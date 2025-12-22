require "BWODebug"
require "BWOUtils"

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

BWOServerEvents.ChopperAlert = function(params)
    dprint("[SERVER_EVENT][INFO][ChopperAlert] INIT", 3)

    -- sanitize
    local speed = params.speed and params.speed or 1.8
    local name = params.name and params.name or "heli"
    local dir = params.dir and params.dir or 0
    local sound = params.sound and params.sound or nil

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
                speed = params.speed,
                name = params.name,
                dir = params.dir,
                sound = params.sound
            }
            dprint("[SERVER_EVENT][INFO][ChopperAlert] REQUEST CLIENT LOGIC FOR: " .. tostring(paramsClient.pid), 3)
            sendServerCommand("Events", "ChopperAlert", paramsClient)
        end
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
            local vehicle = addVehicleDebug(vtype, IsoDirections.S, nil, getCell():getGridSquare(res.x, res.y, 0))
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

    local cell = getCell()
    local zombieList = cell:getZombieList()
    local zombieListSize = zombieList:size() / 2

    if zombieListSize > 100 then zombieListSize = 100 end
    local rnd = ZombRand(100)
    if rnd > zombieListSize then return end

    local proportion = 2 * (50 - math.abs(50 - BWOPopControl.zombiePercent))
    local rnd2 = ZombRand(100)
    if rnd2 > proportion then return end
    
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

BWOServerEvents.PlaneCrash = function(params)
    dprint("[SERVER_EVENT][INFO][PlaneCrash] INIT", 3)

    local densityMin = 0.2

    local groups = BWOUtils.GetPlayerGroups()
    for i = 1, #groups do

        local players = groups[i]
        local playerSelected = BanditUtils.Choice(players)
        local px, py, pz = playerSelected:getX(), playerSelected:getY(), playerSelected:getZ()
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
