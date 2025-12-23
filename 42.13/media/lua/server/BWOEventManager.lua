require "BWOUtils"
require "BWOServerEvents"
require "Scenarios/SDayOne"

BWOEventGenerator = BWOEventGenerator or {}

-- the main architecture of week one multiplayer events

-- hardcoded for now
local scenarioName = "DayOne"

local scenario = BWOScenarios[scenarioName]:new()

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
    local gametime = getGameTime()
    local minute = gametime:getMinutes()
    local worldAge = BWOUtils.GetWorldAge()
    local schedule = scenario:getSchedule()
    dprint("[EVENT_MANAGER][INFO] SCHEDULE LOOKUP FOR: [" .. worldAge .. "][" .. minute .. "]", 3)

    if schedule[worldAge] and schedule[worldAge][minute] then
        local sequence = schedule[worldAge][minute]
        addSequence(sequence)
    end
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

-- extra spawn for specific room types
local function roomSpawner()
    local roomSpawns = scenario:getRoomSpawns()

    local worldAge = BWOUtils.GetWorldAge()

    local cache = BWORooms.cache
    if #cache == 0 then
        dprint("[EVENT_MANAGER][INFO] REBUILDING ROOM CACHE", 3)
        BWORooms.UpdateCache()
    end

    dprint("[EVENT_MANAGER][INFO] ROOM CACHE IS: " .. #cache, 3)

    local players = BWOUtils.GetAllPlayers()

    for _, rdata in ipairs(cache) do
        if roomSpawns[rdata.name] then
            for i = 1, #players do
                local player = players[i]
                local px, py = player:getX(), player:getY()
                local distSq = ((px - rdata.x) * (px - rdata.x)) + ((py - rdata.y) * (py - rdata.y))
                if distSq > 900 and distSq < 3600 then -- > 30 and < 60
                    for _, sdata in ipairs(roomSpawns[rdata.name]) do
                        if not rdata.spawned and worldAge >= sdata.waMin and worldAge < sdata.waMax then
                            dprint("[EVENT_MANAGER][INFO] ROOM SPAWN: " .. rdata.name, 3)
                            local args = {
                                cid = sdata.cid,
                                program = "Bandit",
                                hostile = sdata.hostile,
                                size = sdata.size,
                                x = rdata.x,
                                y = rdata.y,
                                z = rdata.z,
                            }
                            BanditServer.Spawner.Clan(player, args)

                            rdata.spawned = true
                        end
                    end
                end
            end
        end
    end
end

-- main processor
local function mainProcessor()
    if not isServer() then return end

    sequenceProcessor()

    roomSpawner()

    -- BWOServerEvents.MetaSound()
end

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


Events.EveryOneMinute.Remove(mainProcessor)
Events.EveryOneMinute.Add(mainProcessor)

Events.OnTick.Remove(eventProcessor)
Events.OnTick.Add(eventProcessor)

Events.OnClientCommand.Remove(onClientCommand)
Events.OnClientCommand.Add(onClientCommand)