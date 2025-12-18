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

    local dayDict = {7, 9, 12, 14, 17, 21, 2, 5}

    local startYear = 1992 + SandboxVars.StartYear
    local startMonth = SandboxVars.StartMonth
    local startDay = SandboxVars.StartDay
    local startHour = dayDict[SandboxVars.StartTime]

    local gametime = getGameTime()
    local year = gametime:getYear()
    local month = gametime:getMonth() + 1
    if month > 12 then month = 1 end

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

BWOUtils.GenerateSpawnPoints = function(px, py, pz, d, count)

    local cell = getCell()

    local validSpawnPoints = {}
    for i=d, d+6 do
        local spawnPoints = {}
        table.insert(spawnPoints, {x=px+i, y=py+i, z=pz})
        table.insert(spawnPoints, {x=px+i, y=py-i, z=pz})
        table.insert(spawnPoints, {x=px-i, y=py+i, z=pz})
        table.insert(spawnPoints, {x=px-i, y=py-i, z=pz})
        table.insert(spawnPoints, {x=px+i, y=py, z=pz})
        table.insert(spawnPoints, {x=px-i, y=py, z=pz})
        table.insert(spawnPoints, {x=px, y=py+i, z=pz})
        table.insert(spawnPoints, {x=px, y=py-i, z=pz})

        for i, sp in pairs(spawnPoints) do
            local square = cell:getGridSquare(sp.x, sp.y, sp.z)
            if square then
                if square:isFree(false) then
                    table.insert(validSpawnPoints, sp)
                end
            end
        end
    end

    if #validSpawnPoints >= 1 then
        local p = 1 + ZombRand(#validSpawnPoints)
        local spawnPoint = validSpawnPoints[p]
        local ret = {}
        for i=1, count do
            table.insert(ret, spawnPoint)
        end
        return ret
    end

    return {}
end

BWOUtils.densityScoreCache = {}

BWOUtils.GetDensityScore = function(px, py)
    local radius = 120
    local normalizer = 6000
    local sx = math.floor(px / 25)
    local sy = math.floor(py / 25)
    local id = sx .. "-" .. sy
    local cache = BWOBuildings.densityScoreCache
    if cache[id] then return cache[id] end

    local cell = getCell()
    local rooms = cell:getRoomList()
    local total = 0

    for i = 0, rooms:size() - 1 do
        local room = rooms:get(i)
        if room then
            local roomDef = room:getRoomDef()
            if roomDef then
                local x1, y1, x2, y2 = roomDef:getX(), roomDef:getY(), roomDef:getX2(), roomDef:getY2()

                local cx = (x1 + x2) / 2
                local cy = (y1 + y2) / 2

                if math.abs(px - cx) + math.abs(py - cy) <= radius then
                    local size = (x2 - x1) * (y2 - y1)
                    total = total + size
                end
            end
        end
    end

    local density = total / normalizer
    BWOBuildings.densityScoreCache[id] = density
    return density
end