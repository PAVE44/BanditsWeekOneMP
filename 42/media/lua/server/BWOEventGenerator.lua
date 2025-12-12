BWOEventGenerator = BWOEventGenerator or {}

-- table for enqueued events
BWOEventGenerator.Events = {}

local schedule = {}

-- Fisher-Yates shuffle
local function shuffle(t)
    for i = #t, 2, -1 do
        local j = math.random(i)
        t[i], t[j] = t[j], t[i]
    end
end

-- triggering scheduled events 
local function everyOneMinute()

    if not isServer() then return end

    -- time events
    local gt = getGameTime()
    local hours = math.floor(gt:getWorldAgeHours()) - 10
    local minutes = gt:getMinutes()

    -- build allPlayers as you already do
    local playerList = getOnlinePlayers()
    local allPlayers = {}
    for i = 0, playerList:size() - 1 do
        local player = playerList:get(i)
        if player then
            table.insert(allPlayers, player)
        end
    end

    -- shuffle so selection among close players is random
    shuffle(allPlayers)

    -- keep only players that are not within minDist of any already-kept player
    local minDist = 200
    local distantPlayers = {}

    for i = 1, #allPlayers do
        local p1 = allPlayers[i]
        local keep = true
        for k = 1, #distantPlayers do
            local p2 = distantPlayers[k]
            local dist = BanditUtils.DistTo(p1:getX(), p1:getY(), p2:getX(), p2:getY())
            if dist < minDist then
                keep = false
                break
            end
        end
        if keep then
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
