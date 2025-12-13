require "BWOUtils"
require "BWOServerEvents"

BWOEventGenerator = BWOEventGenerator or {}

-- table for enqueued events
BWOEventGenerator.Events = {}

local schedule = {}

-- server is the orchestrator of all events
local function everyOneMinute()
    if not isServer() then return end

    local gametime = getGameTime()
    local minute = gametime:getMinutes()
    local worldAge = BWOUtils.GetWorldAge()
    print("[EVENT GENERATOR] CHECK FOR EVENTS [" .. worldAge .. "][" .. minute .. "]")

    if schedule[worldAge] and schedule[worldAge][minute] then
        print("[EVENT GENERATOR] FOUND EVENT TO TRIGGER")
        local event = schedule[worldAge][minute]
        if event and event[1] and event[2] then
            print("[EVENT GENERATOR] EVENT NAME: " .. event[1])
            if BWOServerEvents and BWOServerEvents[event[1]] then
                print("[EVENT GENERATOR] EXECUTING EVENT")
                BWOServerEvents[event[1]](event[2])
            end
        end
    end

end

local function addEventDebug(args)
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

local onClientCommand = function(module, command, player, args)
    if module == "EventGenerator" then
        if command == "AddEventDebug" then
            --[[
            local argStr = ""
            for k, v in pairs(args) do
                argStr = argStr .. " " .. k .. "=" .. tostring(v)
            end
            print ("[EVENT GENERATOR] " .. module .. "." .. command .. " "  .. argStr)
            ]]
            addEventDebug(args)
        end
    end
end


Events.EveryOneMinute.Remove(everyOneMinute)
Events.EveryOneMinute.Add(everyOneMinute)

Events.OnClientCommand.Remove(onClientCommand)
Events.OnClientCommand.Add(onClientCommand)