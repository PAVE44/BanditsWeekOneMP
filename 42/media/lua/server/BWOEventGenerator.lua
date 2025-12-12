BWOEventGenerator = BWOEventGenerator or {}

-- table for enqueued events
BWOEventGenerator.Events = {}

local schedule = {}

-- triggering scheduled events 
local function everyOneMinute()

    if not isServer() then return end

    -- time events
    local gt = getGameTime()
    local hours = math.floor(gt:getWorldAgeHours()) - 10
    local minutes = gt:getMinutes()

    local playerList = getOnlinePlayers()

    local allPlayers = {}
    for i=0, playerList:size()-1 do
        local player = playerList:get(i)
        if player then
            table.insert(allPlayers, player)
        end
    end

    local distantPlayers = {}
    for i = 1, #allPlayers do
        local p1 = allPlayers[i]
        local isDistant = true
        for j = 1, #allPlayers do
            local p2 = allPlayers[j]
            if i ~= j then 
                local dist = BanditUtils.DistTo(p1:getX(), p1:getY(), p2:getX(), p2:getY())
                if dist < 200 then
                    isDistant = false
                    break
                end
            end
        end
        if isDistant then
            table.insert(distantPlayers, p1)
        end
    end

    print ("H: " .. hours .. " M: " .. minutes)
    print ("PLAYERS: " .. #allPlayers .. " PLAYER GROUPS: " .. #distantPlayers)

    if schedule[hours] and schedule[hours][minutes] then
        local event = schedule[hours][minutes]
        if event and event[1] and event[2] then
            local eventName = event[1]
            local eventParams = event[2]
            if BWOASequence[eventName] then
                BWOASequence[eventName](eventParams)
            else
                BWOEventGenerator.Add(eventName, eventParams, 1)
            end
        end
    end

end

Events.EveryOneMinute.Remove(everyOneMinute)
Events.EveryOneMinute.Add(everyOneMinute)
