require "BWOUtils"
require "BWOServerEvents"

BWOEventGenerator = BWOEventGenerator or {}

-- the main architecture of week one multiplayer events

-- schedule stores sequences of events
local schedule = {
    [0] = {
        [1] = {
            {{"StartDay", {day="friday"}}, 1},
        },
        [2] = {
            {{"Siren", {}}, 1},
        },
        [3] = {
            {{"SpawnGroupVehicle", {desc = "Cops", cid = Bandit.clanMap.PoliceBlue, vtype = "Base.CarLightsPolice", lightbar = 2, siren = 2, size = 2, dmin = 20, dmax = 50, program = "Bandit", hostile = false}}, 1},
        },
        [4] = {
            {{"ChopperAlert", {name="heli", sound="BWOChopperPolice1", dir = 90, speed=1.8}}, 1},
        },
        [10] = {
            {{"SpawnGroupVehicle", {desc = "Cops", cid = Bandit.clanMap.PoliceBlue, vtype = "Base.CarLightsPolice", lightbar = 1, siren = 1, size = 2, dmin = 30, dmax = 60, program = "Bandit", hostile = false}}, 1},
        },
        [14] = {
            {{"ChopperAlert", {name="heli", sound="BWOChopperPolice1", dir = -90, speed=1.8}}, 1},
        },
        [20] = {
            {{"SpawnGroupVehicle", {desc = "Cops", cid = Bandit.clanMap.PoliceBlue, vtype = "Base.CarLightsPolice", lightbar = 1, siren = 1, size = 2, dmin = 40, dmax = 70, program = "Bandit", hostile = false}}, 1},
        },
        [25] = {
            {{"Arson", {dmin = 25, dmax = 40}}, 1},
        },
        [30] = {
            {{"SpawnGroupVehicle", {desc = "SWAT", cid = Bandit.clanMap.SWAT, vtype = "Base.StepVan_LouisvilleSWAT", lightbar = 3, siren = 2, size = 5, dmin = 40, dmax = 80, program = "Bandit", hostile = false}}, 1},
        },
        [31] = {
            {{"ChopperAlert", {name="heli2", sound="BWOChopperGeneric", dir = 0, speed=2.4}}, 1},
        },
        [52] = {
            {{"Arson", {dmin = 35, dmax = 55}}, 1},
            {{"Arson", {dmin = 56, dmax = 80}}, 200},
        },
        
    }
}

-- a queue of single events to be fired
local events = {}

-- adds a set of individual events to the queue from the sequence
local function addSequence(sequence)
    dprint("[EVENT_MANAGER][INFO] ADDING SEQUENCE, EVENT NUMBER: " .. #sequence, 3)
    for _, eventConf in ipairs(sequence) do
        local event = eventConf[1]
        local eventDelay = eventConf[2]

        local eventTimed = {
            event,
            BWOUtils.GetTime() + eventDelay
        }
        dprint("[EVENT_MANAGER][INFO] ADDING EVENT: " .. event[1], 3)
        table.insert(events, eventTimed)
    end
end

-- reads the schedule to see if it's the right moment to manage a sequence
local function sequenceProcessor()
    if not isServer() then return end

    local gametime = getGameTime()
    local minute = gametime:getMinutes()
    local worldAge = BWOUtils.GetWorldAge()
    dprint("[EVENT GENERATOR][INFO] SCHEDULE LOOKUP FOR: [" .. worldAge .. "][" .. minute .. "]", 3)

    if schedule[worldAge] and schedule[worldAge][minute] then
        local sequence = schedule[worldAge][minute]
        addSequence(sequence)
    end

    BWOServerEvents.MetaSound()
end

-- fires single event server-side
-- server-side event will call client logic shortafter
local function eventProcessor()
    if not isServer() then return end

    for i, eventTimed in ipairs(events) do
        local currentTime = BWOUtils.GetTime()
        local event = eventTimed[1]
        local eventTime = eventTimed[2]

        if eventTime < currentTime then
            local eventFunction = event[1]
            local eventParams = event[2]
            if eventFunction and eventParams then
                dprint("[EVENT_MANAGER][INFO] EVENT FUNCTION: " .. eventFunction, 3)
                if BWOServerEvents[eventFunction] then
                    dprint("[EVENT_MANAGER][INFO] EXECUTING EVENT", 3)
                    BWOServerEvents[eventFunction](eventParams)
                else
                    dprint("[EVENT_MANAGER][ERR] NO SUCH EVENT!", 1)
                end
            end
            table.remove(events, i)
            break -- deliberately consuming only one event at a time to avoid spikes
        end
    end

end

--[[
local function addToSchedule(args)
    local worldAge = BWOUtils.GetWorldAge()
    local gametime = getGameTime()
    local minute = gametime:getMinutes()

    minute = minute + 1
    if minute == 60 then
        minute = 0
        worldAge = worldAge + 1
    end
    print("[EVENT GENERATOR] ADDING EVENT " .. args[1] .. " [" .. worldAge .. "][" .. minute .. "]")

    for k, v in pairs(args[2]) do
        print("    " .. tostring(k) .. "=" .. tostring(v))
    end

    if not schedule[worldAge] then
        schedule[worldAge] = {}
    end
    schedule[worldAge][minute] = {args[1], args[2]} -- eventName, eventParams
end
]]

-- direct API to allow chaining events from other events
BWOEventGenerator.AddSequence = function(sequence)
    addSequence(sequence)
end

local onClientCommand = function(module, command, player, args)
    if module == "EventManager" then
        if command == "AddSequence" then
            addSequence(args)
        elseif command == "AddEvent" then
            addSequence({{args, 1}})
        end
    end
end


Events.EveryOneMinute.Remove(sequenceProcessor)
Events.EveryOneMinute.Add(sequenceProcessor)

Events.OnTick.Remove(eventProcessor)
Events.OnTick.Add(eventProcessor)

Events.OnClientCommand.Remove(onClientCommand)
Events.OnClientCommand.Add(onClientCommand)