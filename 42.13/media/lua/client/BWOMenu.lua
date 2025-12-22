BWOMenu = BWOMenu or {}

BWOMenu.PlayMusic = function(player, square)
    local objects = square:getObjects()
    for i=0, objects:size()-1 do
        local object = objects:get(i)
        if instanceof(object, "IsoTelevision") or instanceof(object, "IsoRadio") then
            local dd = object:getDeviceData()

            dd:setIsTurnedOn(true)

            local isPlaying = BWORadio.IsPlaying(object)

            if not isPlaying then

                local music = BanditUtils.Choice({"3fee99ec-c8b6-4ebc-9f2f-116043153195", 
                                                "0bc71c8a-f954-4dbf-aa09-ff09b015d6e2", 
                                                "a08b44db-b3cb-46a1-b04c-633e8e5b2a37", 
                                                "38fe9b5a-e932-477c-a6b5-96b9e7ea84da", 
                                                "2a379a08-4428-42b0-ae3d-0fb41c34f74c", 
                                                "2cc1e0e2-75ab-4ac3-9238-635813babc18", 
                                                "c688d4c8-dd7b-4d93-8e0f-c6cb5f488db2", 
                                                "22b4a025-6455-4c8d-b341-fd4f0f18836a"})

                BWORadio.PlaySound(object, music)
            end
        end
    end
end

BWOMenu.SpawnWave = function(player, square, prgName)
    local args = {
        size = 1,
        program = prgName,
        x = square:getX(),
        y = square:getY(),
        z = square:getZ()
    }

    if prgName == "Babe" then
        args.permanent = true
        args.loyal = true
    end

    if prgName == "Walker" then
        args.cid = Bandit.clanMap.Walker
    elseif prgName == "Fireman" then
        args.cid = Bandit.clanMap.Fireman
    elseif prgName == "Gardener" then
        args.cid = Bandit.clanMap.Gardener
    elseif prgName == "Janitor" then
        args.cid = Bandit.clanMap.Janitor
    elseif prgName == "Medic" then
        args.cid = Bandit.clanMap.Medic
    elseif prgName == "Postal" then
        args.cid = Bandit.clanMap.Postal
    elseif prgName == "Runner" then
        args.cid = Bandit.clanMap.Runner
    elseif prgName == "Vandal" then
        args.cid = Bandit.clanMap.Vandal
    elseif prgName == "Shahid" then
        args.cid = Bandit.clanMap.SuicideBomber
    elseif prgName == "Babe" then
        if player:isFemale() then
            args.cid = Bandit.clanMap.BabeMale
        else
            args.cid = Bandit.clanMap.BabeFemale
        end
    end

    local gmd = GetBWOModData()
    local variant = gmd.Variant
    if BWOVariants[variant].playerIsHostile then args.hostileP = true end

    sendClientCommand(player, 'Spawner', 'Clan', args)
end

BWOMenu.FlushDeadbodies = function(player)
    local args = {a=1}
    sendClientCommand(getSpecificPlayer(0), 'Commands', 'DeadBodyFlush', args)
end

BWOMenu.Ambience = function(player, status)
    if status then
        BWOAmbience.Enable("radiation")
    else
        BWOAmbience.Disable("radiation")
    end
end

BWOMenu.AddEffect = function(player, square)

    local effect = {}
    effect.x = square:getX()
    effect.y = square:getY()
    effect.z = square:getZ()
    effect.size = 10000
    effect.name = "clouds"
    effect.frameCnt = 1
    effect.repCnt = 400
    effect.movx = 0.2
    effect.oscilateAlpha = true
    effect.infinite = true
    effect.colors = {r=0.9, g=0.9, b=1.0, a=0.2}

    table.insert(BWOEffects2.tab, effect)
end

BWOMenu.EventArmy = function(player)
    local params = {
        desc = "Army",
        cid = Bandit.clanMap.ArmyGreen,
        size = 4,
        dist = 30,
        program = "Bandit",
        hostile = false
    }
    local args = {"SpawnGroup", params}

    sendClientCommand(player, "EventManager", "AddEvent", args)
end

BWOMenu.EventPoliceVehicle = function(player)
    local params = {
        desc = "Cops",
        cid = Bandit.clanMap.PoliceBlue,
        vtype = "Base.CarLightsPolice",
        lightbar = 2,
        siren = 2,
        size = 2,
        dmin = 35,
        dmax = 80,
        program = "Bandit",
        hostile = false
    }
    local args = {"SpawnGroupVehicle", params}

    sendClientCommand(player, "EventManager", "AddEvent", args)
end

BWOMenu.EventArson = function(player)
    local player = getPlayer()
    if not player then return end

    local params = {}
    local args = {"Arson", params}

    sendClientCommand(player, "EventManager", "AddEvent", args)
end

BWOMenu.EventChopperAlert = function(player)
    local player = getPlayer()
    if not player then return end

    local args = {
        {{"ChopperAlert", {name="heli2", sound="BWOChopperGeneric", dir = 90, speed=1.8}}, 1},
        {{"ChopperAlert", {name="heli", sound="BWOChopperGeneric", dir = 0, speed=1.8}}, 500},
    }

    sendClientCommand(player, "EventManager", "AddSequence", args)
end

BWOMenu.EventNuke = function(player)
    local params = {}
    params.x = player:getX()
    params.y = player:getY()
    params.r = 80
    BWOScheduler.Add("Nuke", params, 100)
end

BWOMenu.EventFinalSolution = function(player)
    local params = {}
    BWOScheduler.Add("FinalSolution", params, 100)
end

BWOMenu.EventFliers = function(player)
    local params = {}
    params.x = player:getX()
    params.y = player:getY()
    params.z = player:getZ()
    BWOScheduler.Add("ChopperFliers", params, 100)
end

BWOMenu.EventEntertainer = function(player, eid)
    local params ={}
    params.x = player:getX()
    params.y = player:getY()
    params.z = player:getZ()
    params.eid = eid
    BWOScheduler.Add("Entertainer", params, 100)
end

BWOMenu.EventHome = function (player)
    local params = {}
    params.addRadio = true
    BWOScheduler.Add("BuildingHome", params, 100)
end

BWOMenu.EventHeliCrash = function (player)
    local params = {}
    params.x = -20
    params.y = 0
    params.vtype = "pzkHeli350PoliceWreck"
    BWOScheduler.Add("VehicleCrash", params, 100)
end

BWOMenu.EventHorde = function (player)
    local params = {}
    params.cnt = 100
    params.x = 45
    params.y = 45
    BWOScheduler.Add("Horde", params, 100)
end

BWOMenu.EventParty = function (player)
    local params = {}
    params.roomName = "bedroom"
    params.intensity = 8
    BWOScheduler.Add("BuildingParty", params, 100)
end

BWOMenu.EventJetEngine = function (player)
    local params = {}
    params.x = player:getX()
    params.y = player:getY()
    params.z = player:getZ()
    params.dir = -90
    BWOScheduler.Add("JetEngine", params, 100)
end

BWOMenu.EventJetFighterRun = function (player)
    local params = {weapon = "mg"}
    local args = {"JetfighterSequence", params}

    sendClientCommand(player, "EventManager", "AddEvent", args)
end

BWOMenu.EventGasRun = function(player)
    local params = {weapon = "gas"}
    local args = {"JetfighterSequence", params}

    sendClientCommand(player, "EventManager", "AddEvent", args)
end

BWOMenu.EventBombRun = function(player)
    local params = {weapon = "bomb"}
    local args = {"JetfighterSequence", params}

    sendClientCommand(player, "EventManager", "AddEvent", args)
end

BWOMenu.EventProtest = function(player)
    local params = {}
    params.x = player:getX()
    params.y = player:getY()
    params.z = player:getZ()
    BWOScheduler.Add("Protest", params, 100)
end

BWOMenu.EventReanimate = function(player)
    local params = {}
    params.x = player:getX()
    params.y = player:getY()
    params.z = player:getZ()
    params.r = 50
    params.chance = 100
    BWOScheduler.Add("Reanimate", params, 100)
end

BWOMenu.EventStart = function(player)
    local params = {}
    BWOScheduler.Add("Start", params, 100)
end

BWOMenu.EventStartDay = function(player)

    local params = {day="wednesday"}
    local args = {"StartDay", params}

    sendClientCommand(player, "EventManager", "AddEvent", args)
end

BWOMenu.EventPoliceRiot = function(player)
    local params = {}
    params.intensity = 10
    params.hostile = true
    BWOScheduler.Add("PoliceRiot", params, 100)
end

BWOMenu.EventOpenDoors = function(player)
    local params = {x1=7684, y1=11818, z1=0, x2=7693, y2=11857, z2=1}
    BWOScheduler.Add("OpenDoors", params, 100)
end

BWOMenu.EventPlaneCrash = function(player)
    local params = {}
    params.x = player:getX()
    params.y = player:getY()
    params.z = player:getZ()
    BWOScheduler.Add("PlaneCrashSequence", params, 100)
end

BWOMenu.EventDrawPlane = function(player)
    local params = {}
    params.x = player:getX()
    params.y = player:getY()
    params.z = 1
    BWOScheduler.Add("DrawPlane", params, 100)
end

BWOMenu.EventPower = function(player, on)
    local params = {}
    params.on = on
    BWOScheduler.Add("SetHydroPower", params, 100)
end

BWOMenu.EventBikers = function(player)
    local params = {}
    params.intensity = 5
    BWOScheduler.Add("Bikers", params, 100)
end

BWOMenu.EventCriminals = function(player)
    local params = {}
    params.intensity = 3
    BWOScheduler.Add("Criminals", params, 100)
end

BWOMenu.EventDream = function(player)
    local params = {}
    params.night = 5
    BWOScheduler.Add("Dream", params, 100)
end

BWOMenu.EventBandits = function(player)
    local params = {}
    params.intensity = 7
    BWOScheduler.Add("Bandits", params, 100)
end

BWOMenu.EventThieves = function(player)
    local params = {}
    params.intensity = 2
    BWOScheduler.Add("Thieves", params, 100)
end

BWOMenu.EventShahids = function(player)
    local params = {}
    params.intensity = 1
    BWOScheduler.Add("Shahids", params, 100)
end

BWOMenu.EventHammerBrothers = function(player)
    local params = {}
    params.intensity = 2
    BWOScheduler.Add("HammerBrothers", params, 100)
end

BWOMenu.EventStorm = function(player)
    local params = {}
    params.len = 1440
    BWOScheduler.Add("WeatherStorm", params, 1000)
end

BWOMenu.SpotRooms = function(player)
    local cell = getCell()
    local rooms = cell:getRoomList() 
    for index=0, rooms:size()-1, 1 do
        local room = rooms:get(index)
        if room then
            cell:roomSpotted(room)
        end
    end
end

function BWOMenu.WorldContextMenuPre(playerID, context, worldobjects, test)

    local player = getSpecificPlayer(playerID)
    if not player then return end

    local square = BanditCompatibility.GetClickedSquare()

    local zombie = square:getZombie()
    if not zombie then
        local squareS = square:getS()
        if squareS then
            zombie = squareS:getZombie()
            if not zombie then
                local squareW = square:getW()
                if squareW then
                    zombie = squareW:getZombie()
                end
            end
        end
    end

    if isDebugEnabled() or isAdmin() then

        local density = BWOUtils.GetDensityScore(player:getX(), player:getY())
        print (density)

        local res = BWOUtils.FindVehicleSpawnPoint(player:getX(), player:getY(), 35, 80)
        if res.valid then
            dprint("[SERVER_EVENT][INFO][SpawnGroupVehicle] VEHICLE SPOTS SELECTED X: " .. res.x .. " Y:" .. res.y, 3)
        end

        local eventsOption = context:addOption("BWO Event")
        local eventsMenu = context:getNew(context)

        context:addSubMenu(eventsOption, eventsMenu)

        eventsMenu:addOption("Army", player, BWOMenu.EventArmy)
        eventsMenu:addOption("Arson", player, BWOMenu.EventArson)
        -- eventsMenu:addOption("Bandits", player, BWOMenu.EventBandits)
        -- eventsMenu:addOption("Bikers", player, BWOMenu.EventBikers)
        eventsMenu:addOption("Chopper Alert", player, BWOMenu.EventChopperAlert)
        -- eventsMenu:addOption("Criminals", player, BWOMenu.EventCriminals)
        -- eventsMenu:addOption("Dream", player, BWOMenu.EventDream)
        eventsMenu:addOption("Police + Car", player, BWOMenu.EventPoliceVehicle)

        --[[
        local entertainerOption = eventsMenu:addOption("Entertainer")
        local entertainerMenu = context:getNew(context)
        eventsMenu:addSubMenu(entertainerOption, entertainerMenu)

        entertainerMenu:addOption("Priest", player, BWOMenu.EventEntertainer, 0)
        entertainerMenu:addOption("Guitarist", player, BWOMenu.EventEntertainer, 1)
        entertainerMenu:addOption("Violinist", player, BWOMenu.EventEntertainer, 2)
        entertainerMenu:addOption("Saxophonist", player, BWOMenu.EventEntertainer, 3)
        entertainerMenu:addOption("Breakdancer", player, BWOMenu.EventEntertainer, 4)
        entertainerMenu:addOption("Clown 1", player, BWOMenu.EventEntertainer, 5)
        entertainerMenu:addOption("Clown 2", player, BWOMenu.EventEntertainer, 6)
        ]]

        -- eventsMenu:addOption("Final Solution", player, BWOMenu.EventFinalSolution)
        -- eventsMenu:addOption("Fliers", player, BWOMenu.EventFliers)
        -- eventsMenu:addOption("Hammer Brothers", player, BWOMenu.EventHammerBrothers)
        -- eventsMenu:addOption("Heli Crash", player, BWOMenu.EventHeliCrash)
        -- eventsMenu:addOption("Horde", player, BWOMenu.EventHorde)
        -- eventsMenu:addOption("House Register", player, BWOMenu.EventHome)
        -- eventsMenu:addOption("House Party", player, BWOMenu.EventParty)
        -- eventsMenu:addOption("Jetengine", player, BWOMenu.EventJetEngine)
        eventsMenu:addOption("Jetfighter + MG", player, BWOMenu.EventJetFighterRun)
        eventsMenu:addOption("Jetfighter + Bomb", player, BWOMenu.EventBombRun)
        eventsMenu:addOption("Jetfighter + Gas", player, BWOMenu.EventGasRun)
        -- eventsMenu:addOption("Nuke", player, BWOMenu.EventNuke)
        -- eventsMenu:addOption("Open Doors", player, BWOMenu.EventOpenDoors)
        -- eventsMenu:addOption("Rolice Riot", player, BWOMenu.EventPoliceRiot)
        -- eventsMenu:addOption("Plane Crash", player, BWOMenu.EventPlaneCrash, true)
        -- eventsMenu:addOption("Plane Draw", player, BWOMenu.EventDrawPlane)
        -- eventsMenu:addOption("Power On", player, BWOMenu.EventPower, true)
        -- eventsMenu:addOption("Power Off", player, BWOMenu.EventPower, false)
        -- eventsMenu:addOption("Protest", player, BWOMenu.EventProtest)
        -- eventsMenu:addOption("Reanimate", player, BWOMenu.EventReanimate)
        -- eventsMenu:addOption("Shahid", player, BWOMenu.EventShahids)
        -- eventsMenu:addOption("Start", player, BWOMenu.EventStart)
        eventsMenu:addOption("Start Day", player, BWOMenu.EventStartDay)
        -- eventsMenu:addOption("Storm", player, BWOMenu.EventStorm)
        -- eventsMenu:addOption("Thieves", player, BWOMenu.EventThieves)
        
        --[[
        local spawnOption = context:addOption("BWO Spawn")
        local spawnMenu = context:getNew(context)
        context:addSubMenu(spawnOption, spawnMenu)
        
        spawnMenu:addOption("Babe", player, BWOMenu.SpawnWave, square, "Babe")
        spawnMenu:addOption("Fireman", player, BWOMenu.SpawnWave, square, "Fireman")
        spawnMenu:addOption("Gardener", player, BWOMenu.SpawnWave, square, "Gardener")
        spawnMenu:addOption("Inhabitant", player, BWOMenu.SpawnRoom, square, "Inhabitant")
        spawnMenu:addOption("Janitor", player, BWOMenu.SpawnWave, square, "Janitor")
        spawnMenu:addOption("Medic", player, BWOMenu.SpawnWave, square, "Medic")
        spawnMenu:addOption("Postal", player, BWOMenu.SpawnWave, square, "Postal")
        spawnMenu:addOption("Runner", player, BWOMenu.SpawnWave, square, "Runner")
        spawnMenu:addOption("Shahid", player, BWOMenu.SpawnWave, square, "Shahid")
        spawnMenu:addOption("Survivor", player, BWOMenu.SpawnWave, square, "Survivor")
        spawnMenu:addOption("Vandal", player, BWOMenu.SpawnWave, square, "Vandal")
        spawnMenu:addOption("Walker", player, BWOMenu.SpawnWave, square, "Walker")
        
        context:addOption("BWO Add Effect", player, BWOMenu.AddEffect, square)
        context:addOption("BWO Spot Rooms", player, BWOMenu.SpotRooms)
        ]]
        
    
    end
end

Events.OnPreFillWorldObjectContextMenu.Add(BWOMenu.WorldContextMenuPre)
