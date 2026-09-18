local function adjustSandboxVar(k, v)
    getSandboxOptions():set(k, v)
    SandboxVars[k] = v
end

local function onGameStart()
    BWOAreas.ExtendData()

    adjustSandboxVar("WaterShutModifier", 8)
    adjustSandboxVar("ElecShutModifier", 7)
    adjustSandboxVar("Alarm", 1)
    adjustSandboxVar("ZombieLore.TriggerHouseAlarm", false)


    adjustSandboxVar("VehicleStoryChance", 1)
    adjustSandboxVar("ZoneStoryChance", 1)
    adjustSandboxVar("SurvivorHouseChance", 1)

    adjustSandboxVar("MaximumLootedBuildingRooms", 0)
    adjustSandboxVar("MaximumRatIndex", 0)
    adjustSandboxVar("RuralLooted", 0)

    
    
end

Events.OnGameStart.Remove(onGameStart)
Events.OnGameStart.Add(onGameStart)