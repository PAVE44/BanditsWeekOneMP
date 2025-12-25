require "BWODebug"
require "BWOUtils"

--[[ 

    SERVER EVENTS:
    This code is called from Event Manager by the server. Everything here runs 
    serverside. 
    
    The first type of server events are events where server executes
    its logic, and then makes a call to all or selected clients so they
    can continue with their client-side logic in neccessary. Fo example
    the server spawns NPCs and the client adds the spawn marker.

    Second type are the aggregate events. Their purpose is to prepare a sequence
    of events of the first type and throw it back to the Event Manager.
    The example here is a JetfighterSequence event which builds a sequence
    with plane flyby event, and weapon strike events as consecutive events.

    IMPORTANT:
    If a function fails, its excecution will get retried and repeated inifitely
    by the Event manager. For this reason it is crucial to properly handle all 
    possible errors.
    So each function:
        1. Must check for required params and return if anything is missing
        2. Must sanitize the params so their types will not invoke errors
        3. May introduce local constants
        4. And only then execute the logic
        5. Alao must adhere to the logging standard.

]]

BWOServerEvents = BWOServerEvents or {}

-- params: none
BWOServerEvents.Arson = function(params)
    dprint("[SERVER_EVENT][INFO][Arson] INIT", 3)

    -- sanitize
    local distMin = params.dmin and params.dmin or 45
    local distMax = params.dmax and params.dmax or 85

    -- const
    local densityMin = 0.5

    local groups = BWOUtils.GetPlayerGroups()
    for i = 1, #groups do
        -- pick a random player from the group
        local players = groups[i]
        local playerSelected = BanditUtils.Choice(players)
        local px, py, pz = playerSelected:getX(), playerSelected:getY(), playerSelected:getZ()

        local density = BWOUtils.GetDensityScore(px, py)
        if density > densityMin then
            local room = BWOUtils.FindRoomDist(px, py, distMin, distMax)

            if room then
                local square = BWOUtils.GetRandomRoomSquare(room)
                if square then
                    local cx = square:getX()
                    local cy = square:getY()
                    local cz = square:getZ()

                    -- initiate explosion
                    BWOUtils.Explode(cx, cy, 0)

                    -- execute client logic for event
                    for j = 1, #players do
                        local player = players[j]
                        local paramsClient = {
                            pid = player:getOnlineID(),
                            cx = cx,
                            cy = cy,
                            cz = cz,
                        }
                        dprint("[SERVER_EVENT][INFO][Arson] REQUEST CLIENT LOGIC FOR: " .. tostring(paramsClient.pid), 3)
                        sendServerCommand("Events", "Arson", paramsClient)
                    end
                else
                    dprint("[SERVER_EVENT][INFO][Arson] SQUARE UNAVAILABLE", 3)
                end
            else
                dprint("[SERVER_EVENT][INFO][Arson] NO ROOM FOUND", 3)
            end
        else
            dprint("[SERVER_EVENT][INFO][Arson] SKIPPING DUE TO LOW DENSITY " .. density .. " < " .. densityMin, 3)
        end
    end
end

-- params: speed, name, dir, sound
BWOServerEvents.ChopperAlert = function(params)
    dprint("[SERVER_EVENT][INFO][ChopperAlert] INIT", 3)

    -- sanitize
    local speed = params.speed and params.speed or 1.8
    local name = params.name and params.name or "heli"
    local dir = params.dir and params.dir or 0
    local sound = params.sound and params.sound or "BWOChopperGeneric"

    -- const
    local width = 1243
    local height = 760
    local rotors = true
    local lights = true

    local groups = BWOUtils.GetPlayerGroups()
    for i = 1, #groups do
        -- pick a random player from the group
        local players = groups[i]
        local playerSelected = BanditUtils.Choice(players)

        local cx = playerSelected:getX() - 3 + ZombRand(4)
        local cy = playerSelected:getY() - 3 + ZombRand(4)

        dprint("[SERVER_EVENT][INFO][ChopperAlert] cx: " .. cx .. " cy: " .. cy, 3)

        -- execute client logic for event
        for j = 1, #players do
            local player = players[j]

            local paramsClient = {
                pid = player:getOnlineID(),
                cx = cx,
                cy = cy,
                speed = speed,
                name = name,
                dir = dir,
                sound = sound,
                width = width,
                height = height,
                rotors = rotors,
                lights = lights,
            }
            dprint("[SERVER_EVENT][INFO][ChopperAlert] REQUEST CLIENT LOGIC FOR: " .. tostring(paramsClient.pid), 3)
            sendServerCommand("Events", "FlyingObject", paramsClient)
        end
    end
end

-- params: speed, name, sound, weapon
BWOServerEvents.JetfighterSequence = function(params)
    dprint("[SERVER_EVENT][INFO][JetfighterSequence] INIT", 3)

    -- sanitize
    local speed = params.speed and params.speed or 4.8
    local name = params.name and params.name or "a10"
    local weapon = params.weapon and params.weapon or nil
    local sound = params.sound and params.sound or BanditUtils.Choice({"JetFlyby_1", "JetFlyby_2"})

    -- const
    local jetDelay = 1500
    local halfLength = 80
    local halfWidth = 5
    local flybySound
    local projectiles = false

    local armaments = {
        ["mg"] = {
            boxSize = 5,
            delayInital = 550,
            delayStep = 1,
        },
        ["bomb"] = {
            boxSize = 8,
            delayInital = 1000,
            delayStep = 110,
        },
        ["gas"] = {
            boxSize = 10,
            delayInital = 1000,
            delayStep = 110,
        },
    }

    local zombieList = getCell():getZombieList()
    local zombieListSize = zombieList:size()
    dprint("[SERVER_EVENT][INFO][JetfighterSequence] ZOMBIES:" .. zombieListSize, 3)

    local groups = BWOUtils.GetPlayerGroups()
    for i = 1, #groups do
        -- pick a random player from the group
        local players = groups[i]
        local playerSelected = BanditUtils.Choice(players)

        local px = math.floor(playerSelected:getX() + 0.5)
        local py = math.floor(playerSelected:getY() + 0.5)

        -- find optimal strafing rectangle 160x10
        local best = 0
        local cx, cy, dir

        -- NS rectangles
        for bx=-4, 4 do
            local y1 = py - halfLength
            local y2 = py + halfLength
            local x1 = px + bx * (halfWidth * 2) - halfWidth
            local x2 = px + bx * (halfWidth * 2) + halfWidth

            local cnt = 0
            for i = 0, zombieListSize - 1 do
                local zombie = zombieList:get(i)
                if zombie then
                    local zx, zy = zombie:getX(), zombie:getY()
                    if zx >= x1 and zx < x2 and zy >= y1 and zy < y2 then
                        cnt = cnt + 1
                        -- dprint("[SERVER_EVENT][INFO][JetfighterSequence] FOUND ZOMBIE NS RECT: X: " .. zx .. " Y: " .. zy, 3)
                    end
                end
            end

            if cnt > best then
                dir = BanditUtils.Choice({-90, 90})
                cx = (x1 + x2) / 2
                cy = py
                best = cnt
                -- dprint("[SERVER_EVENT][INFO][JetfighterSequence] BEST IS: X: " .. cx .. " Y: " .. cy .. " DIR: " .. dir .. " CNT: " .. cnt, 3)
            end
        end

        -- EW rectangles
        for by=-4, 4 do
            local y1 = py + by * (halfWidth * 2) - halfWidth
            local y2 = py + by * (halfWidth * 2) + halfWidth
            local x1 = px - halfLength
            local x2 = px + halfLength

            local cnt = 0
            for i = 0, zombieListSize - 1 do
                local zombie = zombieList:get(i)
                if zombie then
                    local zx, zy = zombie:getX(), zombie:getY()
                    if zx >= x1 and zx < x2 and zy >= y1 and zy < y2 then
                        cnt = cnt + 1
                        -- dprint("[SERVER_EVENT][INFO][JetfighterSequence] FOUND ZOMBIE EW RECT: X: " .. zx .. " Y: " .. zy, 3)
                    end
                end
            end

            if cnt > best then
                dir = BanditUtils.Choice({0, 180})
                cx = px
                cy = (y1 + y2) / 2
                best = cnt
                -- dprint("[SERVER_EVENT][INFO][JetfighterSequence] BEST IS: X: " .. cx .. " Y: " .. cy .. " DIR: " .. dir .. " CNT: " .. cnt, 3)
            end
        end

        -- build sequence
        if cx and cy and dir then
            dprint("[SERVER_EVENT][INFO][JetfighterSequence] COORDS LOCKED: X:" .. cx .. " Y:" .. cy .. " DIR: " .. dir, 3)
            

            -- prepare aggregate event
            local sequence = {}

            if weapon and weapon == "mg" then
                sound = BanditUtils.Choice({"JetFlybyMG_1", "JetFlybyMG_2"})
                projectiles = true
            end

            local delay = jetDelay
            local flybyEvent = {"JetfighterFlyby", {cx = cx, cy = cy, name = name, sound = sound, projectiles = projectiles, dir = dir, speed = speed}}
            table.insert(sequence, {flybyEvent, delay})

            if weapon then
                if weapon == "random" then
                    weapon = BanditUtils.Choice({"mg", "bomb", "gas"})
                end

                if armaments[weapon] then
                    dprint("[SERVER_EVENT][INFO][JetfighterSequence] BUILDING WEAPON SEQUENCE FOR: " .. weapon, 3)
                    local armament = armaments[weapon]

                    delay = delay + armament.delayInital
                    if dir == 0 then
                        for x = cx - halfLength, cx + halfLength, armament.boxSize do
                            local event = {"JetfighterWeapon", {cx = x, cy = cy, dir = dir, weapon = weapon, boxSize = armament.boxSize}}
                            table.insert(sequence, {event, delay})
                            delay = delay + armament.delayStep
                        end
                    elseif dir == 180 then
                        for x = cx + halfLength, cx - halfLength, -armament.boxSize do
                            local event = {"JetfighterWeapon", {cx = x, cy = cy, dir = dir, weapon = weapon, boxSize = armament.boxSize}}
                            table.insert(sequence, {event, delay})
                            delay = delay + armament.delayStep
                        end
                    elseif dir == 90 then
                        for y = cy - halfLength, cy + halfLength, armament.boxSize do
                            local event = {"JetfighterWeapon", {cx = cx, cy = y, dir = dir, weapon = weapon, boxSize = armament.boxSize}}
                            table.insert(sequence, {event, delay})
                            delay = delay + armament.delayStep
                        end
                    elseif dir == -90 then
                        for y = cy + halfLength, cy - halfLength, -armament.boxSize do
                            local event = {"JetfighterWeapon", {cx = cx, cy = y, dir = dir, weapon = weapon, boxSize = armament.boxSize}}
                            table.insert(sequence, {event, delay})
                            delay = delay + armament.delayStep
                        end
                    end
                else
                    dprint("[SERVER_EVENT][ERR][JetfighterSequence] UNKNOWN WEAPON: " .. weapon, 1)
                end
            end

            dprint("[SERVER_EVENT][INFO][JetfighterSequence] SEQUENCE READY, STEPS: " .. #sequence, 3)
            BWOEventGenerator.AddSequence(sequence)
        else
            dprint("[SERVER_EVENT][WARN][JetfighterSequence] NO COORD FOUND", 2)
        end
    end
end

-- params: cx, cy, speed, name, dir, sound, projectiles
BWOServerEvents.JetfighterFlyby = function(params)
    dprint("[SERVER_EVENT][INFO][JetfighterFlyby] INIT", 3)

    -- check
    if not params.cx then return end
    if not params.cy then return end

    -- sanitize
    local cx = params.cx
    local cy = params.cy
    local speed = params.speed and params.speed or 4.8
    local name = params.name and params.name or "a10"
    local dir = params.dir and params.dir or 0
    local sound = params.sound and params.sound or BanditUtils.Choice({"JetFlyby_1", "JetFlyby_2"})
    local projectiles = params.projectiles and params.projectiles or false
    local soundMode = "binary"

    -- const
    local width = 1024
    local height = 586
    local rotors = false
    local lights = true -- not sure if jets have them but its cool

    local groups = BWOUtils.GetPlayerGroups()
    for i = 1, #groups do
        -- pick a random player from the group
        local players = groups[i]

        dprint("[SERVER_EVENT][INFO][JetfighterFlyby] cx: " .. cx .. " cy: " .. cy, 3)

        -- execute client logic for event
        for j = 1, #players do
            local player = players[j]

            local paramsClient = {
                pid = player:getOnlineID(),
                cx = cx,
                cy = cy,
                speed = speed,
                name = name,
                dir = dir,
                sound = sound,
                soundMode = soundMode,
                rotors = rotors,
                lights = lights,
                projectiles = projectiles,
                width = width,
                height = height,
            }
            dprint("[SERVER_EVENT][INFO][JetfighterFlyby] REQUEST CLIENT LOGIC FOR: " .. tostring(paramsClient.pid), 3)
            sendServerCommand("Events", "FlyingObject", paramsClient)
        end
    end
end

-- params: cx, cy, dir, weapon, boxSize
BWOServerEvents.JetfighterWeapon = function(params)
    dprint("[SERVER_EVENT][INFO][JetfighterWeapon] INIT", 3)

    -- check
    if not params.cx then return end
    if not params.cy then return end
    if not params.dir then return end

    -- sanitize
    local cx = params.cx
    local cy = params.cy
    local dir = params.dir
    local weapon = params.weapon and params.weapon or "mg"
    local boxSize = params.boxSize and params.boxSize or 5

    local armaments = {
        ["mg"] = function(x, y, boxSize)
            return true
        end,
        ["bomb"] = function(x, y, boxSize)
            BWOUtils.Explode(x, y, 0)
            return true
        end,
        ["gas"] = function(x, y, boxSize)
            return true
        end
    }

    if armaments[weapon] then
        local armament = armaments[weapon]
        if armament(cx, cy, boxSize) then
            dprint("[SERVER_EVENT][INFO][JetfighterWeapon] ATTACK X: " .. cx .. " Y: " .. cy .. " BOX: " .. boxSize .. " WEAPON: " .. weapon , 3)
            local players = BWOUtils.GetAllPlayers()
            for i = 1, #players do
                local player = players[i]
                local paramsClient = {
                    pid = player:getOnlineID(),
                    cx = cx,
                    cy = cy,
                    dir = dir,
                    weapon = weapon,
                    boxSize = boxSize,
                }
                dprint("[SERVER_EVENT][INFO][JetfighterWeapon] REQUEST CLIENT LOGIC FOR: " .. tostring(paramsClient.pid), 3)
                sendServerCommand("Events", "JetfighterWeapon", paramsClient)
            end
        end
    else
        dprint("[SERVER_EVENT][ERR][JetfighterWeapon] UNKNOWN WEAPON: " .. weapon, 1)
    end
end

-- params: cid, program, hostile, name]
BWOServerEvents.SpawnGroup = function(params)
    dprint("[SERVER_EVENT][INFO][SpawnGroup] INIT", 3)

    -- sanitize
    local cid = params.cid and params.cid or Bandit.clanMap.PoliceBlue
    local program = params.program and params.program or "Bandit"
    local hostile = params.hostile and params.hostile or false
    local size = params.size and params.size or 2
    local dist = params.dist and params.dist or 40
    local desc = params.desc and params.desc or "Unknown"

    -- const
    local multiplierMin = 0.5
    local multiplierMax = 2

    local groups = BWOUtils.GetPlayerGroups()
    for i = 1, #groups do
        -- pick a random player from the group
        local players = groups[i]
        local playerSelected = BanditUtils.Choice(players)
        local px, py, pz = playerSelected:getX(), playerSelected:getY(), playerSelected:getZ()

        -- spawn point selection
        local distance = params.dist + ZombRand(10)
        local spawnPoints = BWOUtils.GenerateSpawnPoints(px, py, pz, distance, 1)
        if #spawnPoints == 1 then
            local spawn = spawnPoints[1]

            -- group size calculation
            local density = BWOUtils.GetDensityScore(px, py)
            if density > multiplierMax then density = multiplierMax end
            if density < multiplierMin then density = multiplierMin end
            size = math.floor(size * #players * density)
            dprint("[SERVER_EVENT][INFO][SpawnGroup] SIZE: " .. size, 3)

            -- spawn
            if size > 0 then
                local args = {
                    cid = cid,
                    program = program,
                    hostile = hostile,
                    x = spawn.x,
                    y = spawn.y,
                    z = spawn.z,
                    size = size
                }
                BanditServer.Spawner.Clan(playerSelected, args)
                dprint("[SERVER_EVENT][INFO][SpawnGroup] SPAWN SUCCESSFUL", 3)

                -- execute client logic for event
                for j = 1, #players do
                    local player = players[j]

                    local paramsClient = {
                        pid = player:getOnlineID(),
                        desc = desc,
                        cid = params.cid,
                        name = params.name,
                        hostile = params.hostile,
                        cx = spawn.x,
                        cy = spawn.y,
                        cz = spawn.z
                    }
                    dprint("[SERVER_EVENT][INFO][SpawnGroup] REQUEST CLIENT LOGIC FOR: " .. tostring(paramsClient.pid), 3)
                    sendServerCommand("Events", "SpawnGroup", paramsClient)
                end
            else
                dprint("[SERVER_EVENT][INFO][SpawnGroup] SPAWN SKIPPED DUE TO ZERO GROUP SIZE", 3)
            end

        else
            dprint("[SERVER_EVENT][INFO][SpawnGroup] NO SUITABLE SPAWN POINT FOUND", 3)
        end
    end
end

-- params: cid, program, hostile, name, dmin, dmax, vtype, lightbar, siren, headlights
BWOServerEvents.SpawnGroupVehicle = function(params)
    dprint("[SERVER_EVENT][INFO][SpawnGroupVehicle] INIT", 3)

    -- sanitize
    local distMin = params.dmin and params.dmin or 45
    local distMax = params.dmax and params.dmax or 85
    local desc = params.desc and params.desc or "Unknown"
    local vtype = params.vtype and params.vtype or "Base.CarNormal"
    local headlights = params.healights and params.healights or false
    local lightbar = params.lightbar and params.lightbar or nil
    local siren = params.siren and params.siren or nil
    local cid = params.cid and params.cid or Bandit.clanMap.Police
    local program = params.program and params.program or "Bandit"
    local hostile = params.hostile and params.hostile or false
    local size = params.size and params.size or 2

    local groups = BWOUtils.GetPlayerGroups()
    for i = 1, #groups do
        -- pick a random player from the group
        local players = groups[i]
        local playerSelected = BanditUtils.Choice(players)
        local px, py, pz = playerSelected:getX(), playerSelected:getY(), playerSelected:getZ()

        -- spawn point selection
        local res = BWOUtils.FindVehicleSpawnPoint(px, py, distMin, distMax)

        if res.valid then
            dprint("[SERVER_EVENT][INFO][SpawnGroupVehicle] VEHICLE SPOTS SELECTED X: " .. res.x .. " Y:" .. res.y, 3)

            -- vehicle spawn
            -- local vehicle = addVehicle("Base.CarLightsPolice", spawn.x, spawn.y, 0)
            local square = getCell():getGridSquare(res.x, res.y, 0)
            if square then
                local vehicle = addVehicleDebug(vtype, IsoDirections.S, nil, square)
                if vehicle then
                    dprint("[SERVER_EVENT][INFO][SpawnGroupVehicle] VEHICLE SPAWN SUCCESSFUL", 3)
                    vehicle:repair()

                    if headlights then
                        vehicle:setHeadlightsOn(headlights)
                    end

                    if vehicle:hasLightbar() then 
                        if lightbar then
                            vehicle:setLightbarLightsMode(lightbar)
                        end
                        if siren then
                            vehicle:setLightbarSirenMode(siren)
                        end
                    end
                else
                    dprint("[SERVER_EVENT][ERR][SpawnGroupVehicle] VEHICLE SPAWN ERROR!", 1)
                end

                -- npc spawn
                local args = {
                    cid = cid,
                    program = program,
                    hostile = hostile,
                    x = res.x + 2,
                    y = res.y + 2,
                    z = 0,
                    size = size
                }
                BanditServer.Spawner.Clan(playerSelected, args)
                dprint("[SERVER_EVENT][INFO][SpawnGroupVehicle] GROUP SPAWN SUCCESSFUL", 3)

                -- execute client logic for event
                for j = 1, #players do
                    local player = players[j]

                    local paramsClient = {
                        pid = player:getOnlineID(),
                        desc = desc,
                        cid = params.cid,
                        name = params.name,
                        hostile = params.hostile,
                        cx = res.x,
                        cy = res.y,
                        cz = 0
                    }
                    dprint("[SERVER_EVENT][INFO][SpawnGroupVehicle] REQUEST CLIENT LOGIC FOR: " .. tostring(paramsClient.pid), 3)
                    sendServerCommand("Events", "SpawnGroupVehicle", paramsClient)
                end
            else
                dprint("[SERVER_EVENT][WARN][SpawnGroupVehicle] SQUARE UNAVAILABLE", 2)
            end
        end
    end
end

-- params: none
BWOServerEvents.MetaSound = function(params)
    dprint("[SERVER_EVENT][INFO][MetaSound] INIT", 3)

    -- const
    local densityMin = 0.4

    local metaSounds = {
        -- "MetaAssaultRifle1",
        -- "MetaPistol1",
        -- "MetaShotgun1",
        -- "MetaPistol2",
        -- "MetaPistol3",
        -- "MetaShotgun1",
        "MetaScream",
        "BWOMetaScream",
        -- "VoiceFemaleDeathFall",
        -- "VoiceFemaleDeathEaten",
        -- "VoiceFemalePainFromFallHigh",
        -- "VoiceMalePainFromFallHigh",
        -- "VoiceMaleDeathAlone",
        -- "VoiceMaleDeathEaten",
    }

    local gametime = getGameTime()
    local hour = gametime:getHour()
    if hour > 4 then return end

    local cell = getCell()
    local zombieList = cell:getZombieList()
    local zombieListSize = zombieList:size() / 2

    if zombieListSize > 100 then zombieListSize = 100 end
    local rnd = ZombRand(100)
    if rnd > zombieListSize then return end


    local groups = BWOUtils.GetPlayerGroups()
    for i = 1, #groups do
        -- pick a random player from the group
        local players = groups[i]
        local playerSelected = BanditUtils.Choice(players)
        local px, py, pz = playerSelected:getX(), playerSelected:getY(), playerSelected:getZ()

        local density = BWOUtils.GetDensityScore(px, py)
        if density > densityMin then
            local rx, ry = 50, 50
            if ZombRand(2) == 0 then rx = -rx end
            if ZombRand(2) == 0 then ry = -ry end

            -- execute client logic for event
            for j = 1, #players do
                local player = players[j]
                local paramsClient = {
                    pid = player:getOnlineID(),
                    cx = px - rx,
                    cy = py - ry,
                    cz = 0,
                    sound = BanditUtils.Choice(metaSounds),
                    volume = 0.6
                }
                dprint("[SERVER_EVENT][INFO][MetaSound] REQUEST CLIENT LOGIC FOR: " .. tostring(paramsClient.pid), 3)
                sendServerCommand("Events", "WorldSound", paramsClient)
            end
        end
    end
end

-- params: none
BWOServerEvents.PlaneCrashSequence = function(params)
    dprint("[SERVER_EVENT][INFO][PlaneCrashSequence] INIT", 3)

    -- const
    local arrivalSound = "BWOBoeing"
    local planeHitSound = "BWOExploPlane"

    local groups = BWOUtils.GetPlayerGroups()
    for i = 1, #groups do
        local players = groups[i]
        local playerSelected = BanditUtils.Choice(players)
        local px, py, pz = playerSelected:getX(), playerSelected:getY(), playerSelected:getZ()

        -- prepare aggregate event
        local delay = 1
        local sequence = {}
        
        local arrivalSoundEvent = {"PlayerSound", {sound = arrivalSound}}
        table.insert(sequence, {arrivalSoundEvent, delay})

        delay = delay + 12800
        local arrivalSoundEvent = {"PlayerSound", {sound = planeHitSound}}
        table.insert(sequence, {arrivalSoundEvent, delay})

        delay = delay + 300
        local arrivalSoundEvent = {"PlayerSound", {sound = planeHitSound}}
        table.insert(sequence, {arrivalSoundEvent, delay})
        
        local partMap = {
            {
                vtype = "Base.pzkPlaneSection1",
                x = px + 30 - ZombRand(5),
                y = py + 11,
                z = 0,
                delay = delay + 2500,
                civs = 2,
                bags = 0,
                seats = 0
            },
            {
                vtype = "Base.pzkPlaneSection2",
                x = px - 20 + ZombRand(3),
                y = py - 10 + ZombRand(10),
                z = 0,
                delay = delay + 3500,
                civs = 12,
                bags = 2,
                seats = 2
            },
            {
                vtype = "Base.pzkPlaneSection3",
                x = px - 11,
                y = py + 4,
                z = 0,
                delay = delay + 4500,
                civs = 25,
                bags = 22,
                seats = 3
            },
            {
                vtype = "Base.pzkPlaneSection2",
                x = px - 25 + ZombRand(6),
                y = py - 21,
                z = 0,
                delay = delay + 4700,
                civs = 12,
                bags = 2,
                seats = 2
            },
            {
                vtype = "Base.pzkPlaneSection4",
                x = px - 45 + ZombRand(10),
                y = py + 7,
                z = 0,
                delay = delay + 5100,
                civs = 18,
                bags = 12,
                seats = 2
            },
            {
                vtype = "Base.pzkPlaneWingL2",
                x = px + 12 + ZombRand(5),
                y = py + 1,
                z = 0,
                delay = delay + 5900,
                civs = 0,
                bags = 0,
                seats = 0
            },
            {
                vtype = "Base.pzkPlaneWingL1",
                x = px - 12 - ZombRand(7),
                y = py + 11 + ZombRand(4),
                z = 0,
                delay = delay + 6600,
                civs = 0,
                bags = 0,
                seats = 0
            },
            {
                vtype = "Base.pzkPlaneEngine",
                x = px - 8,
                y = py - 23,
                z = 0,
                delay = delay + 7300,
                civs = 1,
                bags = 0,
                seats = 0,
                engine = 1
            },
            {
                vtype = "Base.pzkPlaneWingR2",
                x = px + 12,
                y = py + 32,
                z = 0,
                delay = delay + 7800,
                civs = 0,
                bags = 0,
                seats = 0
            },
            {
                vtype = "Base.pzkPlaneWingR1",
                x = px - 2,
                y = py + 28,
                z = 0,
                delay = delay + 8800,
                civs = 0,
                bags = 0,
                seats = 0
            },
            {
                vtype = "Base.pzkPlaneEngine",
                x = px - 6,
                y = py + 0,
                z = 0,
                delay = delay + 10000,
                civs = 0,
                bags = 0,
                seats = 0,
                engine = 1
            },
            {
                vtype = "Base.pzkPlaneSection2",
                x = px + 6,
                y = py + 11,
                z = 0,
                delay = delay + 10800,
                civs = 12,
                bags = 2,
                seats = 2
            },
        }

        for _, part in pairs(partMap) do
            part.pid = playerSelected:getOnlineID()
            local crashPartEvent = {"PlaneCrashPartSequence", part}
            table.insert(sequence, {crashPartEvent, part.delay})
        end

        BWOEventGenerator.AddSequence(sequence)
    end
end

-- params: vtype, x, y, z, delay, civs, bags, seats
BWOServerEvents.PlaneCrashPartSequence = function(params)
    dprint("[SERVER_EVENT][INFO][PlaneCrashPartSequence] INIT", 3)

    -- check
    if not params.x then return end
    if not params.y then return end
    if not params.z then return end
    if not params.pid then return end

    -- sanitize
    local x = params.x
    local y = params.y
    local z = params.z
    local pid = params.pid
    local vtype = params.vtype and params.vtype or "Base.pzkPlaneSection1"
    local delay = params.delay and params.delay or 0
    local civs = params.civs and params.civs or 0
    local bags = params.bags and params.bags or 0
    local seats = params.seats and params.seats or 0

    -- const
    local steps = 24

    local delay = 1
    local sequence = {}
    
    local px, py
    for i = -steps, 0 do
        px, py = x + (i * 2), y
        local params = {
            x = px,
            y = py,
            z = z,
            bags = bags,
            seats = seats,
            pid = pid
        }
        local partEvent = {"PlaneCrashPart", params}
        table.insert(sequence, {partEvent, delay})
        delay = delay + 70
    end

    local params = {
        x = px,
        y = py,
        z = z,
        vtype = vtype,
        civs = civs,
        pid = pid
    }
    local partEvent = {"PlaneCrashPartEnd", params}
    table.insert(sequence, {partEvent, delay})

    BWOEventGenerator.AddSequence(sequence)
end

-- params: x, y, z, bags, seats
BWOServerEvents.PlaneCrashPart = function(params)
    dprint("[SERVER_EVENT][INFO][PlaneCrashPart] INIT", 3)

    -- check
    if not params.x then return end
    if not params.y then return end
    if not params.z then return end

    -- sanitize
    local x = params.x
    local y = params.y
    local z = params.z
    local bags = params.bags and params.bags or 0
    local seats = params.seats and params.seats or 0

    -- const
    local bagTab = {"Base.Suitcase", "Base.Suitcase", "Base.Suitcase", "Base.Suitcase", "Base.Suitcase", "Base.Briefcase", 
                    "Base.Bag_DuffelBag", "Base.Purse", "Base.RippedSheets", "Base.RippedSheetsDirty", 
                    "Base.SheetMetal", "Base.SmallSheetMetal", "Base.ScrapMetal", "Base.MetalPipe"}

    local seatsTab = {"Base.NormalCarSeat2"}

    local insideItemsTab = {
        "Base.Toothbrush", "Base.Toothpaste", "Base.Socks_Ankle", "Base.Socks_Ankle", "Base.Socks_Long",
        "Base.Briefs", "Base.Shirt_Denim", "Base.Tshirt_WhiteTINT", "Base.Tshirt_WhiteTINT", "Base.Underpants_White",
        "Base.Trousers", "Base.Trousers", "Base.Dress_Short", "Base.Dress_Long", "Base.Dress_Normal",
        "Base.Tshirt_WhiteLongSleeveTINT", "Base.Shirt_HawaiianTINT", "Base.Shirt_HawaiianTINT", "Base.Shirt_HawaiianTINT", "Base.Hat_SummerHat",
        "Base.Brandy", "Base.CigarBox", "Base.Boxers_White", "Base.AntibioticsBox", "Base.Book",
    }

    local function addItems(cnt, x, y, itemTab)
        local cell = getCell()
        for i = 1, cnt do
            local ix, iy = x, y - 20 + ZombRand(41)
            local square = cell:getGridSquare(ix, iy, 0)
            if square then
                local itemType = BanditUtils.Choice(itemTab)
                local item = BanditCompatibility.InstanceItem(itemType)
                if item then
                    if instanceof(item, "InventoryContainer") then
                        local container = item:getItemContainer()
                        if container then
                            for i=1, 5 + ZombRand(10) do
                                local itemInside = BanditCompatibility.InstanceItem(BanditUtils.Choice(insideItemsTab))
                                if itemInside then
                                    container:AddItem(itemInside)
                                end
                            end
                        end
                    end
                    item:setWorldZRotation(ZombRand(360))
                    square:AddWorldInventoryItem(item, ZombRandFloat(0.1, 0.9), ZombRandFloat(0.1, 0.9), 0)
                end
            end    
        end
    end

    BWOUtils.ClearSpace(x - 2, y - 2, z, 5, 5)
    BWOUtils.Explode(x, y, z)
    addItems(bags, x, y, bagTab)
    addItems(seats, x, y, seatsTab)

    -- execute client logic for event
    local players = BWOUtils.GetAllPlayers()
    for i = 1, #players do
        local player = players[i]
        local paramsClient = {
            pid = player:getOnlineID(),
            cx = x,
            cy = y,
            cz = z,
        }
        dprint("[SERVER_EVENT][INFO][PlaneCrashPart] REQUEST CLIENT LOGIC FOR: " .. tostring(paramsClient.pid), 3)
        sendServerCommand("Events", "PlaneCrashPart", paramsClient)
    end

end

-- params: x, y, z, vtype, civs
BWOServerEvents.PlaneCrashPartEnd = function(params)
    dprint("[SERVER_EVENT][INFO][PlaneCrashPartEnd] INIT", 3)

    -- check
    if not params.x then return end
    if not params.y then return end
    if not params.z then return end
    if not params.pid then return end

    -- sanitize
    local x = params.x
    local y = params.y
    local z = params.z
    local pid = params.pid
    local vtype = params.vtype and params.vtype or "Base.pzkPlaneSection1"
    local civs = params.civs and params.civs or 0

    local square = getCell():getGridSquare(x, y, z)
    if square then
        local vehicle = addVehicleDebug(vtype, IsoDirections.E, nil, square)
    end

    local players = BWOUtils.GetAllPlayers()
    local player = players[1]
    if player then
        for i=1, civs do
            local args = {}
            args.cid = Bandit.clanMap.Resident
            args.program = "Civilian"
            args.size = 1
            args.x = x + ZombRandFloat(-5, 5)
            args.y = y + ZombRandFloat(-5, 5)
            args.z = z
            args.crawler = true
            BanditServer.Spawner.Clan(player, args)
        end
    end

    -- execute client logic for event
    for i = 1, #players do
        local player = players[i]
        local paramsClient = {
            pid = player:getOnlineID(),
            cx = x,
            cy = y,
            cz = z,
        }
        dprint("[SERVER_EVENT][INFO][PlaneCrashPartEnd] REQUEST CLIENT LOGIC FOR: " .. tostring(paramsClient.pid), 3)
        sendServerCommand("Events", "PlaneCrashPartEnd", paramsClient)
    end
end

-- params: sound
BWOServerEvents.PlayerSound = function(params)
    dprint("[SERVER_EVENT][INFO][PlayerSound] INIT", 3)

    -- check
    if not params.sound then return end

    -- sanitize
    local sound = params.sound

    local players = BWOUtils.GetAllPlayers()
    for i = 1, #players do
        local player = players[i]
        local paramsClient = {
            pid = player:getOnlineID(),
            sound = sound,
        }
        dprint("[SERVER_EVENT][INFO][PlayerSound] REQUEST CLIENT LOGIC FOR: " .. tostring(paramsClient.pid), 3)
        sendServerCommand("Events", "PlayerSound", paramsClient)
    end
end

-- params: none
BWOServerEvents.Siren = function(params)
    dprint("[SERVER_EVENT][INFO][Siren] INIT", 3)

    local players = BWOUtils.GetAllPlayers()
    for i = 1, #players do
        local player = players[i]
        local paramsClient = {
            pid = player:getOnlineID(),
            cx = player:getX() + 10,
            cy = player:getY() - 20,
            cz = player:getZ(),
            sound = "DOSiren2",
        }
        dprint("[SERVER_EVENT][INFO][Siren] REQUEST CLIENT LOGIC FOR: " .. tostring(paramsClient.pid), 3)
        sendServerCommand("Events", "WorldSound", paramsClient)
    end
end

-- params: day
BWOServerEvents.StartDay = function(params)
    dprint("[SERVER_EVENT][INFO][StartDay] INIT", 3)

    -- sanitize
    local day = params.day and params.day or "monday"

    local players = BWOUtils.GetAllPlayers()
    for i = 1, #players do
        local player = players[i]
        local paramsClient = {
            pid = player:getOnlineID(),
            day = day,
        }
        dprint("[SERVER_EVENT][INFO][StartDay] REQUEST CLIENT LOGIC FOR: " .. tostring(paramsClient.pid), 3)
        sendServerCommand("Events", "StartDay", paramsClient)
    end
end
