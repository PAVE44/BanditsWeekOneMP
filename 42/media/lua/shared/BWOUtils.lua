BWOUtils = BWOUtils or {}

-- Fisher-Yates shuffle
BWOUtils.Shuffle = function(t)
    for i = #t, 2, -1 do
        local j = ZombRand(i) + 1
        t[i], t[j] = t[j], t[i]
    end
end

-- returns a list of all online players
BWOUtils.GetAllPlayers = function()
    local playerList = getOnlinePlayers()
    local allPlayers = {}
    for i = 0, playerList:size() - 1 do
        local player = playerList:get(i)
        if player then
            table.insert(allPlayers, player)
        end
    end
    return allPlayers
end

-- returns a list of players that are at least minDist apart
BWOUtils.GetDistantPlayers = function()
    local allPlayers = BWOUtils.GetAllPlayers()

    local minDist = 200
    local distantPlayers = {}

    BWOUtils.Shuffle(allPlayers)

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
    return distantPlayers
end

-- returns a list of groups of players, where each player in a group is at least
-- minDist apart from at least one other player in the same group
BWOUtils.GetPlayerGroups = function()
    local allPlayers = BWOUtils.GetAllPlayers()
    local minDist = 200

    local groups = {}

    for i = 1, #allPlayers do
        local player = allPlayers[i]
        local placed = false

        -- try to place player into an existing group
        for g = 1, #groups do
            local group = groups[g]

            for k = 1, #group do
                local other = group[k]
                local dist = BanditUtils.DistTo(
                    player:getX(), player:getY(),
                    other:getX(), other:getY()
                )

                if dist < minDist then
                    table.insert(group, player)
                    placed = true
                    break
                end
            end

            if placed then break end
        end

        -- if no group was close enough, create a new one
        if not placed then
            table.insert(groups, { player })
        end
    end

    return groups
end

BWOUtils.GetWorldAge = function()

    local function daysInMonth(month)
        local daysPerMonth = {31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31}
        return daysPerMonth[month]
    end

    local gametime = getGameTime()
    local startYear = gametime:getStartYear()
    local startMonth = gametime:getStartMonth()
    local startDay = gametime:getStartDay()
    local startHour = gametime:getStartTimeOfDay()
    local year = gametime:getYear()
    local month = gametime:getMonth()
    local day = gametime:getDay()
    local hour = gametime:getHour()
    local minute = gametime:getMinutes()

    local startTotalHours = startHour + (startDay - 1) * 24
    for m = 1, startMonth - 1 do
        startTotalHours = startTotalHours + daysInMonth(m) * 24
    end
    startTotalHours = startTotalHours + (startYear * 365 * 24) 

    local totalHours = hour + (day - 1) * 24
    for m = 1, month - 1 do
        totalHours = totalHours + daysInMonth(m) * 24
    end
    totalHours = totalHours + (year * 365 * 24) 

    return totalHours - startTotalHours
end