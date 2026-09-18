BWOMenu = BWOMenu or {}

local function getRandomWorkAreaId()
    if not BWOAreas or not BWOAreas.areas then
        return nil
    end

    local choices = {}
    for id, area in pairs(BWOAreas.areas) do
        if area.exits and #area.exits > 0 then
            table.insert(choices, id)
        end
    end

    if #choices == 0 then
        return nil
    end

    return BanditUtils.Choice(choices)
end


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

BWOMenu.SpawnCiv = function(player, square)

    for i = 1, 1 do 
        local wid = "11902-6859"

        local occupation = {
            role = "cook",
            hid = "10982-6642",
            wid = wid,
        }

        local args = {
            size = 1,
            cid = Bandit.clanMap.Walker,
            program = "Resident",
            x = square:getX() + ZombRand(4),
            y = square:getY() + ZombRand(4),
            z = square:getZ(),
            occupation = occupation
        }
        sendClientCommand(player, 'Spawner', 'Clan', args)
    end
end

BWOMenu.SpawnHomeless = function(player, square)
    local args = {
        size = 1,
        cid = Bandit.clanMap.Homeless,
        program = "Homeless",
        x = square:getX(),
        y = square:getY(),
        z = square:getZ(),
    }
    sendClientCommand(player, 'Spawner', 'Clan', args)
end

BWOMenu.SpawnRappers = function(player, square)
    local args = {
        size = 1,
        cid = Bandit.clanMap.HipHop,
        program = "HipHop",
        x = square:getX(),
        y = square:getY(),
        z = square:getZ(),
    }
    sendClientCommand(player, 'Spawner', 'Clan', args)
end

BWOMenu.SpawnResident = function(player, square)
    local sx, sy, sz

    --BWOAreas.ExtendData()
    BWOAreas.PrintResidentialPopulationStats()

    local area = BWOAreas.Find(square)
    if not area then return end

    for _, npc in ipairs(area.pop) do
        local occupation = {
            role = npc.role,
            hid = area.id,
            wid = npc.data.workAreaId,
        }

        local args = {
            size = 1,
            cid = Bandit.clanMap.Walker,
            program = "Resident",
            x = square:getX(),
            y = square:getY(),
            z = square:getZ(),
            occupation = occupation
        }

        sendClientCommand(player, 'Spawner', 'Clan', args)
            
    end

end



BWOMenu.SpawnFakeVehicle = function(player, square)


    local options = {
        {templateFunc = BWOFakeVehicleParts.CarLightsTemplate, bodyItemType = "Base.CarLightsPolice"},
        {templateFunc = BWOFakeVehicleParts.CarLightsTemplate, bodyItemType = "Base.CarLightsKST"},
        {templateFunc = BWOFakeVehicleParts.CarLightsTemplate, bodyItemType = "Base.CarNormalBlack"},
        {templateFunc = BWOFakeVehicleParts.CarLightsTemplate, bodyItemType = "Base.CarNormalBlue"},
        {templateFunc = BWOFakeVehicleParts.CarLightsTemplate, bodyItemType = "Base.CarNormalTaxi"},
        {templateFunc = BWOFakeVehicleParts.ModernCarLightsTemplate, bodyItemType = "Base.ModernCarLightsWestpoint"},
        {templateFunc = BWOFakeVehicleParts.ModernCarLightsTemplate, bodyItemType = "Base.ModernCar02Beige"},
        {templateFunc = BWOFakeVehicleParts.ModernCarLightsTemplate, bodyItemType = "Base.ModernCar02Black"},
        {templateFunc = BWOFakeVehicleParts.ModernCarLightsTemplate, bodyItemType = "Base.ModernCar02Blue"},
        {templateFunc = BWOFakeVehicleParts.ModernCarLightsTemplate, bodyItemType = "Base.ModernCar02Green"},
        {templateFunc = BWOFakeVehicleParts.ModernCarLightsTemplate, bodyItemType = "Base.ModernCar02Gray"},
        {templateFunc = BWOFakeVehicleParts.ModernCarLightsTemplate, bodyItemType = "Base.ModernCar02Red"},
        {templateFunc = BWOFakeVehicleParts.ModernCarLightsTemplate, bodyItemType = "Base.ModernCar02White"},
    }

    local option = BanditUtils.Choice(options)

    local vehicle = {
        debug = false,
        startX = square and square:getX() or nil,
        startY = square and square:getY() or nil,
        
        --startNodeId = "11614-6898", -- to west
        --prevNodeId = "11690-6898",

        --startNodeId = "11614-6902", -- to east
        --prevNodeId  = "11561-6902",

        --startNodeId = "11795-6962", -- curve test
        --prevNodeId  = "11837-6962",
        cruiseSpeed = 40,
        startRot = -90,
        parts = BWOFakeVehicleParts.InstanceParts(option.templateFunc, option.bodyItemType),
    }

    BWOFakeVehicle.Add(vehicle)
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
    local args = {"PlaneCrashSequence", params}

    sendClientCommand(player, "EventManager", "AddEvent", args)
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

BWOMenu.ScanAreaRooms = function(player)
    BWODevTools.ScanRooms(player)
end

BWOMenu.RescanArea = function(player, id)
    BWODevTools.RescanArea(player, id)
end

BWOMenu.DumpNav = function(player)
    BWODevTools.DumpNav(player)
end

BWOMenu.LoadNav = function(player)
    BWODevTools.LoadNav(player)
end

BWOMenu.AddTrafficLight = function(player, square)
    local cell = getCell()
    local sprite = getSprite("bwo_lighting_outdoor_01_13")
    local ls = IsoLightSwitch.new(cell, square, sprite, square:getRoomID())

    ls:setCanBeModified(true)
    ls:setPower(1000)
    ls:setHasBattery(true)
    ls:setUseBatteryDirect(true)
    ls:addLightSourceFromSprite()
    ls:setPrimaryR(255 / 255)
    ls:setPrimaryG(90 / 255)
    ls:setPrimaryB(20 / 255)
    square:AddSpecialObject(ls)
    square:setSquareChanged()
end

BWOMenu.ClothingTest = function(player, zombie)
    local brain = BanditBrain.Get(zombie)
    brain.clothing["Hat"] = "Base.Hat_Beany"
    Bandit.ApplyClothing(zombie, brain)
end

BWOMenu.GetMail = function(player)
    local box = BWOPostData.GetRandomBox()
    local mail = BanditCompatibility.InstanceItem("Base.GenericMail")

    mail:setName("JOHN DOE, " .. box.address)
    local md = mail:getModData()
    md.BWO = {}
    md.BWO.box = {}
    md.BWO.box.id = box.id
    player:getInventory():AddItem(mail)
end

-- time actions
BWOMenu.CleanTrash = function(player, square)
    local playerInv = player:getInventory()
    local item = playerInv:getFirstTagEvalRecurse(ItemTag.CLEAR_ASHES, BWOUtils.predicateNotBroken)

    if item then
        local transferAction = ISInventoryTransferUtil.newInventoryTransferAction(player, item, item:getContainer(), playerInv, 100)
        ISTimedActionQueue.add(transferAction)
        ISTimedActionQueue.add(ISEquipWeaponAction:new(player, item, 30, true))
        if luautils.walkAdj(player, square) then
            ISTimedActionQueue.add(TACleanTrash:new(player, square))
        end
    end
end

BWOMenu.JukeboxOptions = function(player, square, option)
    local x, y, z = square:getX(), square:getY(), square:getZ()
    if luautils.walkAdj(player, square) then
        ISTimedActionQueue.add(TAJukebox:new(player, square, option))
    end
end

BWOMenu.PayCart = function(player, square)
    if luautils.walkAdj(player, square) then
        ISTimedActionQueue.add(TAPayCart:new(player))
    end
end


function BWOMenu.WorldContextMenuPre(playerID, context, worldobjects, test)

    local player = getSpecificPlayer(playerID)
    if not player then return end

    local playerInv = player:getInventory()
    local square = BanditCompatibility.GetClickedSquare()
    local sx, sy, sz = square:getX(), square:getY(), square:getZ()
    --BWOAreas.ExtendData()
    BWOAreas.PrintResidentialPopulationStats()

    if square:getRoom() then
        print ("room: " .. square:getRoom():getName())
    end

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

    local players = BWOUtils.GetAllPlayers()
    for j = 1, #players do
        local player = players[j]
        local name = player:getUsername()
        print (name)
    end

    local trash = nil
    local register = nil
    local jukebox = nil
    local objects = square:getObjects()
    for i=0, objects:size()-1 do
        local object = objects:get(i)
        local sprite = object:getSprite()
        if sprite then
            local props = sprite:getProperties()
            if props then
                if props:has("CustomName") then
                    local customName = props:get("CustomName")
                    if customName == "Trash" then
                        print("Found Trash object")
                        trash = object
                        break
                    elseif customName == "Register" then
                        register = object
                    elseif customName == "Jukebox" or customName == "Boombox" then
                        jukebox = object
                    end
                end
            end
        end
    end

    if trash then
        local item = playerInv:getFirstTagEvalRecurse(ItemTag.CLEAR_ASHES, BWOUtils.predicateNotBroken)
        local option = context:addOption("Clean Trash", player, BWOMenu.CleanTrash, square)
        if not item then
            local tooltip = ISToolTip:new()
            option.notAvailable = true
            tooltip.description = "You need a a tool to clean the trash."
            option.toolTip = tooltip
        end
    elseif register then
        local money = BWOItemTransfer.GetCash(player)
        local due = math.ceil(BWOItemTransfer.GetShoppingCartValue(player))
        if due > 0 then
            local option = context:addOption("Pay $" .. string.format("%.2f", due), player, BWOMenu.PayCart, square)
            if money < due then
                local tooltip = ISToolTip:new()
                option.notAvailable = true
                tooltip.description = "You do not have enough money to pay for your shopping cart."
                option.toolTip = tooltip
            end
        end
    elseif jukebox then
        local jukebox = BWOJukebox.Get(sx, sy, sz)
        if not jukebox then
            jukebox = BWOJukebox.Add(sx, sy, sz)
        end
        if jukebox.on then
            context:addOption(getText("ContextMenu_StopMusic"), player, BWOMenu.JukeboxOptions, square, "off")
        else
            context:addOption(getText("ContextMenu_PlayMusic"), player, BWOMenu.JukeboxOptions, square, "on")
        end
    end

    if isDebugEnabled() then

        BWORoles.checkRequirements(player, "postman")
        print ("daylength: " .. getSandboxOptions():getDayLengthMinutes())
        local eventsOption = context:addOption("BWO Dev Tools")
        local eventsMenu = context:getNew(context)

        context:addSubMenu(eventsOption, eventsMenu)

        local area = BWOAreas.Find(square)
        if area then
            BWOItems.ShouldRescan(area.id, sx, sy, sz)
            eventsMenu:addOption("Rescan Area " .. area.id .. " as " .. area.type, player, BWOMenu.RescanArea, area.id)
        end

        eventsMenu:addOption("Scan Rooms to File", player, BWOMenu.ScanAreaRooms)
        eventsMenu:addOption("Dump Nav to File", player, BWOMenu.DumpNav)
        eventsMenu:addOption("Load Nav from File", player, BWOMenu.LoadNav)
        -- eventsMenu:addOption("Add Traffic Light", player, BWOMenu.AddTrafficLight, square)
        
        if zombie then
            -- eventsMenu:addOption("Clothing Test", player, BWOMenu.ClothingTest, zombie)
        end
        eventsMenu:addOption("Get Mail", player, BWOMenu.GetMail)

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
        eventsMenu:addOption("Plane Crash", player, BWOMenu.EventPlaneCrash)
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
        
        
        local spawnOption = context:addOption("BWO Spawn")
        local spawnMenu = context:getNew(context)
        context:addSubMenu(spawnOption, spawnMenu)
        
        spawnMenu:addOption("Resident", player, BWOMenu.SpawnResident, square)
        spawnMenu:addOption("Civ", player, BWOMenu.SpawnCiv, square)
        spawnMenu:addOption("Homeless", player, BWOMenu.SpawnHomeless, square)
        spawnMenu:addOption("Rappers", player, BWOMenu.SpawnRappers, square)
        spawnMenu:addOption("Fake Vehicle", player, BWOMenu.SpawnFakeVehicle, square)
        --[[
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
        
        ]]
        
    
    end
end

Events.OnPreFillWorldObjectContextMenu.Add(BWOMenu.WorldContextMenuPre)
