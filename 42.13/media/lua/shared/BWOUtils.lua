BWOUtils = BWOUtils or {}

BWOUtils.predicateAll = function(item)
	return true
end

BWOUtils.predicateNotBroken = function(item)
	return not item:isBroken()
end

BWOUtils.predicateShopping = function(item)
    local md = item:getModData()
    md.BWO = md.BWO or {}
    return md.BWO.shopping and not md.BWO.bought or false
end

BWOUtils.predicateMoney = function(item)
    return item:getFullType() == "Base.Money"
end

-- Fisher-Yates shuffle
BWOUtils.Shuffle = function(t)
    for i = #t, 2, -1 do
        local j = ZombRand(i) + 1
        t[i], t[j] = t[j], t[i]
    end
end

BWOUtils.IsInCircle = function(x, y, cx, cy, r)
    local d2 = (x - cx) ^ 2 + (y - cy) ^ 2
    return d2 <= r ^ 2
end

BWOUtils.CoordId = function(x, y)
    return x .. "-" .. y
end

local function distSq(x1, y1, x2, y2)
    local dx = x2 - x1
    local dy = y2 - y1
    return dx * dx + dy * dy
end

local function getWalkGraph()
    if not BWONavigation or not BWONavigation.walk then
        return nil
    end
    return BWONavigation.walk
end

local function getDriveGraph()
    if not BWONavigation or not BWONavigation.drive then
        return nil
    end
    return BWONavigation.drive
end

local function getNearestGraphNode(graph, x, y)
    if not graph then
        return nil
    end

    local bestId, bestNode, bestDsq = nil, nil, math.huge

    for id, node in pairs(graph) do
        if node and node.x and node.y then
            local dsq = distSq(x, y, node.x, node.y)
            if dsq < bestDsq then
                bestDsq = dsq
                bestId = id
                bestNode = node
            end
        end
    end

    if not bestId then
        return nil
    end

    return bestId, bestNode, math.sqrt(bestDsq)
end

local function heuristic(graph, fromId, toId)
    local from = graph[fromId]
    local to = graph[toId]
    if not from or not to then
        return math.huge
    end
    return math.sqrt(distSq(from.x, from.y, to.x, to.y))
end

local function reconstructPath(cameFrom, current)
    local path = {current}
    while cameFrom[current] do
        current = cameFrom[current]
        table.insert(path, 1, current)
    end
    return path
end

local function findPathAStar(graph, startId, goalId, maxIterations)
    if not graph or not startId or not goalId then
        return nil
    end
    if not graph[startId] or not graph[goalId] then
        return nil
    end

    local limit = maxIterations or 5000
    local openSet = {}
    local closedSet = {}
    local cameFrom = {}
    local gScore = {}
    local fScore = {}

    openSet[startId] = true
    gScore[startId] = 0
    fScore[startId] = heuristic(graph, startId, goalId)

    local iterations = 0
    while true do
        iterations = iterations + 1
        if iterations > limit then
            return nil
        end

        local current
        local bestF = math.huge
        for nodeId, _ in pairs(openSet) do
            local f = fScore[nodeId] or math.huge
            if f < bestF then
                bestF = f
                current = nodeId
            end
        end

        if not current then
            return nil
        end

        if current == goalId then
            return reconstructPath(cameFrom, current)
        end

        openSet[current] = nil
        closedSet[current] = true

        local currentNode = graph[current]
        if currentNode and currentNode.links then
            for neighborId, cost in pairs(currentNode.links) do
                if graph[neighborId] then
                    local stepCost = tonumber(cost) or heuristic(graph, current, neighborId)
                    local tentative = (gScore[current] or math.huge) + stepCost
                    if tentative < (gScore[neighborId] or math.huge) then
                        cameFrom[neighborId] = current
                        gScore[neighborId] = tentative
                        fScore[neighborId] = tentative + heuristic(graph, neighborId, goalId)
                        openSet[neighborId] = true
                        closedSet[neighborId] = nil
                    elseif not closedSet[neighborId] then
                        openSet[neighborId] = true
                    end
                end
            end
        end
    end
end

local function getWalkPath(startX, startY, goalX, goalY, graph, maxIterations)
    local navGraph = graph or getWalkGraph()
    if not navGraph then
        return nil
    end

    local startId = getNearestGraphNode(navGraph, startX, startY)
    local goalId = getNearestGraphNode(navGraph, goalX, goalY)
    if not startId or not goalId then
        return nil
    end

    local path = findPathAStar(navGraph, startId, goalId, maxIterations)
    if not path then
        return nil
    end

    return path, startId, goalId
end

BWOUtils.GetWalkGraph = function()
    return getWalkGraph()
end

BWOUtils.GetNearestWalkNodeId = function(x, y, graph)
    local navGraph = graph or getWalkGraph()
    if not navGraph then
        return nil
    end
    return getNearestGraphNode(navGraph, x, y)
end

BWOUtils.GetWalkPathToNodeId = function(startX, startY, goalId, graph, maxIterations)
    local navGraph = graph or getWalkGraph()
    if not navGraph or not goalId then
        return nil
    end

    local targetId = tostring(goalId)
    if not navGraph[targetId] then
        return nil
    end

    local startId = getNearestGraphNode(navGraph, startX, startY)
    if not startId then
        return nil
    end

    local path = findPathAStar(navGraph, startId, targetId, maxIterations)
    if not path then
        return nil
    end

    return path, startId, targetId
end

BWOUtils.GetDriveGraph = function()
    return getDriveGraph()
end

BWOUtils.GetNearestDriveNodeId = function(x, y, graph)
    local navGraph = graph or getDriveGraph()
    if not navGraph then
        return nil
    end
    return getNearestGraphNode(navGraph, x, y)
end

BWOUtils.GetDrivePathToNodeId = function(startX, startY, goalId, graph, maxIterations)
    local navGraph = graph or getDriveGraph()
    if not navGraph or not goalId then
        return nil
    end

    local targetId = tostring(goalId)
    if not navGraph[targetId] then
        return nil
    end

    local startId = getNearestGraphNode(navGraph, startX, startY)
    if not startId then
        return nil
    end

    local path = findPathAStar(navGraph, startId, targetId, maxIterations)
    if not path then
        return nil
    end

    return path, startId, targetId
end

local function clearGraphNavState(brain)
    brain.navPath = nil
    brain.navPathIndex = nil
    brain.navGoalId = nil
end

local function clearNavPathState(brain)
    clearGraphNavState(brain)
    brain.navDirectTargetId = nil
end

BWOUtils.GetTransformTask = function(bandit, outfit, weapons)
    local brain = BanditBrain.Get(bandit)
    
    local changed = false
    for bodyPart, items in pairs(outfit) do
        local rnd = brain.id % #items
        local chosenItem = items[rnd + 1]

        if brain.clothing[bodyPart] ~= chosenItem then
            brain.clothing[bodyPart] = chosenItem
            changed = true
        end
    end

    for bodyPart, items in pairs(brain.clothing) do
        if not outfit[bodyPart] then
            brain.clothing[bodyPart] = nil
            changed = true
        end
    end

    if weapons.melee then
        if brain.weapons.melee ~= weapons.melee then
            brain.weapons.melee = weapons.melee
            changed = true
        end
    end
    if weapons.primary then
        if not brain.weapons.primary.name or brain.weapons.primary.name ~= weapons.primary.name then
            brain.weapons.primary = weapons.primary
            changed = true
        end
    end
    if weapons.secondary then
        if not brain.weapons.secondary.name or brain.weapons.secondary.name ~= weapons.secondary.name then
            brain.weapons.secondary = weapons.secondary
            changed = true
        end
    end

    if changed then
        local task = {action="Transform", time=100}
        return task
    end
    return nil
end

BWOUtils.GetMoveTaskNav = function(bandit, targetX, targetY, targetZ, opts)
    if not bandit or not targetX or not targetY then
        return nil
    end

    local brain = BanditBrain.Get(bandit)
    if not brain then
        return nil
    end

    local options = opts or {}
    local directDistance = options.directDistance or 6
    local reachedDistance = options.reachedDistance or 1.4
    local stopDistance = options.stopDistance or 1
    local moveType = options.moveType or "Walk"

    local bxf = bandit:getX()
    local byf = bandit:getY()
    local bx = math.floor(bxf)
    local by = math.floor(byf)
    local bz = targetZ or math.floor(bandit:getZ())
    local directTargetId = tostring(targetX) .. ":" .. tostring(targetY) .. ":" .. tostring(bz)

    local targetDist = BanditUtils.DistTo(bxf, byf, targetX, targetY)
    if brain.navDirectTargetId and brain.navDirectTargetId ~= directTargetId then
        brain.navDirectTargetId = nil
    end

    if targetDist < directDistance then
        brain.navDirectTargetId = directTargetId
    end

    if brain.navDirectTargetId == directTargetId then
        -- bandit:addLineChatElement(("direct: " .. targetX .. "," .. targetY), 1, 1, 1)
        clearGraphNavState(brain)
        brain.navDirectTargetId = directTargetId
        if targetDist > stopDistance then
            return BanditUtils.GetMoveTask(0, targetX, targetY, bz, moveType, targetDist, false)
        end
        brain.navDirectTargetId = nil
        return nil
    end

    local graph = getWalkGraph()
    if graph then
        local goalId = getNearestGraphNode(graph, targetX, targetY)
        if goalId then
            local needsNewPath = (not brain.navPath) or (brain.navGoalId ~= goalId) or (not brain.navPathIndex)
            if needsNewPath then
                local path, _, pathGoalId = getWalkPath(bx, by, targetX, targetY, graph)
                if path and #path > 0 then
                    brain.navPath = path
                    brain.navGoalId = pathGoalId
                    brain.navPathIndex = (#path > 1) and 2 or 1
                else
                    clearGraphNavState(brain)
                    brain.navDirectTargetId = directTargetId
                end
            end

            local currentPath = brain.navPath
            local currentIndex = brain.navPathIndex
            if currentPath and currentIndex then
                local nextId = currentPath[currentIndex]
                local nextNode = graph[nextId]

                if nextNode then
                    local guard = 0
                    while nextNode and guard < 8 do
                        local waypointDist = BanditUtils.DistTo(bxf, byf, nextNode.x, nextNode.y)
                        if waypointDist > reachedDistance then
                            break
                        end

                        currentIndex = currentIndex + 1
                        brain.navPathIndex = currentIndex
                        nextId = currentPath[currentIndex]
                        nextNode = graph[nextId]
                        guard = guard + 1
                    end

                    if not nextNode then
                        clearGraphNavState(brain)
                        brain.navDirectTargetId = directTargetId
                    end

                    if nextNode then
                        local stepDist = BanditUtils.DistTo(bxf, byf, nextNode.x, nextNode.y)
                        if stepDist > stopDistance then
                            return BanditUtils.GetMoveTask(0, nextNode.x, nextNode.y, bz, moveType, stepDist, false)
                        end
                    end
                end
            end
        end
    end

    if targetDist > stopDistance then
        return BanditUtils.GetMoveTask(0, targetX, targetY, bz, moveType, targetDist, false)
    end

    return nil
end

-- returns a list of all online players
BWOUtils.GetAllPlayers = function()
    local allPlayers = {}

    local gamemode = getWorld():getGameMode()

    local playerList
    if gamemode == "Multiplayer" then
        playerList = getOnlinePlayers()
    else
        playerList = IsoPlayer.getPlayers()
    end
    for i = 0, playerList:size() - 1 do
        local player = playerList:get(i)
        if player then
            table.insert(allPlayers, player)
        end
    end

    return allPlayers
end

BWOUtils.SquareHasOtherCharacters = function(id, square)
    local chrs = square:getMovingObjects()
    for i=0, chrs:size()-1 do
        local chr = chrs:get(i)
        if instanceof(chr, "IsoZombie") then
            if BanditUtils.GetCharacterID(chr) ~= id then
                return true
            end
        else
            if instanceof(chr, "IsoPlayer") then
                return true
            end
        end
    end
end

BWOUtils.GetRandomPlayer = function()
    local allPlayers = BWOUtils.GetAllPlayers()
    if #allPlayers == 0 then
        return nil
    end
    return allPlayers[ZombRand(#allPlayers) + 1]
end

-- returns a list of all online players
BWOUtils.GetPlayerById = function(id)
    local playerList = getOnlinePlayers()
    for i = 0, playerList:size() - 1 do
        local player = playerList:get(i)
        if player then
            if player:getOnlineID() == id then
                return player
            end
        end
    end
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

-- returns a list of players that are at least minDist apart
BWOUtils.GetClosestPlayer = function(x, y)
    local allPlayers = BWOUtils.GetAllPlayers()

    local maxDist = math.huge

    local closestPlayer = nil
    for i = 1, #allPlayers do
        local player = allPlayers[i]
        local dist = BanditUtils.DistTo(x, y, player:getX(), player:getY())
        if dist < maxDist then
            maxDist = dist
            closestPlayer = player
        end
    end
    return closestPlayer
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

BWOUtils.GetBiggestPlayerGroup = function()
    local groups = BWOUtils.GetPlayerGroups()

    if #groups == 0 then
        return nil
    end

    local biggestSize = 0
    local biggestGroups = {}

    for i = 1, #groups do
        local size = #groups[i]

        if size > biggestSize then
            biggestSize = size
            biggestGroups = {groups[i]}
        elseif size == biggestSize then
            table.insert(biggestGroups, groups[i])
        end
    end

    return BanditUtils.Choice(biggestGroups)
end

BWOUtils.GetTime = function()
    -- local m = getSandboxOptions():getDayLengthMinutes()
    -- local coeff = 60 / m

    return math.floor(getGameTime():getWorldAgeHours() * 100000) -- multiply to increase resolution
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

BWOUtils.GetWorldAgeClient = function()

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
    local cache = BWOUtils.densityScoreCache
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
    BWOUtils.densityScoreCache[id] = density
    return density
end

BWOUtils.Explode = function(x, y, z)

    local cell = getCell()
    if not z then z = 0 end

    local square = cell:getGridSquare(x, y, z)
    if not square then return end

    for dx = -7, 7 do
        for dy = -7, 7 do
            if BWOUtils.IsInCircle(x + dx, y + dy, x, y, 6) then
                local squareF = cell:getGridSquare(x + dx, y + dy, z)
                if squareF then
                    square:BurnWalls(false)
                end
            end
        end
    end

    local squareF = cell:getGridSquare(x, y, z)
    IsoFireManager.StartFire(cell, squareF, true, 1000, 100)
    
    if not isServer() then

        local player = getSpecificPlayer(0)
        if not player then return end

        -- junk placement
        BanditBaseGroupPlacements.Junk (x-4, y-4, 0, 6, 8, 3)

        -- explosion initiating ragdoll eeffect
        local item = BanditCompatibility.InstanceItem("Base.PipeBomb")
        item:setExplosionPower(10)
        item:setTriggerExplosionTimer(0)
        item:setAttackTargetSquare(square)

        if square:getChunk() then
            -- local player = getSpecificPlayer(0)
            local trap = IsoTrap.new(nil, item, cell, square)
            trap:triggerExplosion(false)
        end

        -- explosion effect
        local effect = {}
        effect.x = square:getX()
        effect.y = square:getY()
        effect.z = square:getZ()
        effect.size = 1000
        effect.name = "explobig"
        effect.frameCnt = 17
        table.insert(BWOEffects2.tab, effect)

        -- smoke effect
        for _ = 1, 2 do
            local effect2 = {}
            effect2.x = square:getX() + ZombRandFloat(-4.5, 4.5)
            effect2.y = square:getY() + ZombRandFloat(-4.5, 4.5)
            effect2.z = square:getZ()
            effect2.size = 1200
            effect2.poison = false
            effect2.name = "smoke"
            effect2.frameCnt = 60
            effect2.frameRnd = true
            effect2.repCnt = 17 + ZombRand(3)
            table.insert(BWOEffects2.tab, effect2)
        end

        -- light blast
        local colors = {r=1.0, g=0.5, b=0.5}
        local lightSource = IsoLightSource.new(x, y, 0, colors.r, colors.g, colors.b, 60, 10)
        getCell():addLamppost(lightSource)

        -- flash
        local lightLevel = square:getLightLevel(0)
        if lightLevel < 0.95 and player:isOutside() then
            local px = player:getX()
            local py = player:getY()
            local sx = square:getX()
            local sy = square:getY()

            local dx = math.abs(px - sx)
            local dy = math.abs(py - sy)

            local tex
            local dist = math.sqrt(math.pow(sx - px, 2) + math.pow(sy - py, 2))
            if dist > 40 then dist = 40 end

            if dx > dy then
                if sx > px then
                    tex = "e"
                else
                    tex = "w"
                end
            else
                if sy > py then
                    tex = "s"
                else
                    tex = "n"
                end
            end

            BWOTex.tex = getTexture("media/textures/blast_" .. tex .. ".png")
            BWOTex.speed = 0.05
            BWOTex.mode = "full"
            local alpha = 1.2 - (dist / 40)
            if alpha > 1 then alpha = 1 end
            BWOTex.alpha = alpha
        end

        -- sound
        local sounds = {
            "BurnedObjectExploded", "FlameTrapExplode", "SmokeBombExplode", "PipeBombExplode", 
            "DOExploClose1", "DOExploClose2", "DOExploClose3", "DOExploClose4", "DOExploClose5", 
            "DOExploClose6", "DOExploClose7", "DOExploClose8"
        }

        local function getSound()
            return sounds[1 + ZombRand(#sounds)]
        end

        local sound = getSound()
        local emitter = getWorld():getFreeEmitter(x, y, 0)
        emitter:playSound(sound)
        emitter:setVolumeAll(0.9)

        addSound(player, math.floor(x), math.floor(y), 0, 100, 100)

        -- wake up players
        -- BanditPlayer.WakeEveryone()
    end
end

BWOUtils.ClearSpace = function(x, y, z, w, h)
    local cell = getCell()

    for cz=0, 2 do
        for cx=x, x+w do
            for cy=y, y+h do
                local square = cell:getGridSquare(cx, cy, cz)
                if square then
                    local objects = square:getObjects()
                    local destroyList = {}

                    for i=0, objects:size()-1 do
                        local object = objects:get(i)
                        if object then
                            local sprite = object:getSprite()
                            if sprite then 
                                local spriteName = sprite:getName()
                                local spriteProps = sprite:getProperties()

                                local isSolidFloor = spriteProps:has(IsoFlagType.solidfloor)
                                local isAttachedFloor = spriteProps:has(IsoFlagType.attachedFloor)

                                if not isSolidFloor or cz > 0 then
                                    table.insert(destroyList, object)
                                end

                                if isSolidFloor and spriteName:embodies("natural") then
                                    object:clearAttachedAnimSprite()
                                end
                            end
                        end
                    end

                    for k, obj in pairs(destroyList) do
                        if isClient() then
                            sledgeDestroy(obj);
                        else
                            square:transmitRemoveItemFromSquare(obj)
                        end
                    end
                end
            end
        end
    end
end

BWOUtils.DeployGas = function(x, y, z)
    local effect = {}
    effect.x = x
    effect.y = y
    effect.z = z
    effect.size = 1800 + ZombRand(200)
    effect.poison = true
    effect.colors = {r=0.1, g=0.7, b=0.2, a=0.2}
    effect.name = "gas"
    effect.frameCnt = 60
    effect.frameRnd = true
    effect.repCnt = 24
    table.insert(BWOEffects2.tab, effect)
end

BWOUtils.Strafe = function(x1, y1, x2, y2, z, dir)
    local fakeItem = BanditCompatibility.InstanceItem("Base.AssaultRifle")
    local fakeZombie = getCell():getFakeZombieForHit()
    local player = getSpecificPlayer(0)
    local volumeSystem = getSoundManager():getSoundVolume()

    --[[
    local sound = "JetMG"

    local emitter = getWorld():getFreeEmitter((x1 + x2) / 2, (y1 + y2) / 2, z)
    local id = emitter:playSound(sound, true)
    emitter:setVolume(id, volumeSystem)]]

    local zombieList = BanditZombie.CacheLight
    for id, zombie in pairs(zombieList) do
        if zombie.x >= x1 and zombie.x < x2 and zombie.y >= y1 and zombie.y < y2 then
            local character = BanditZombie.GetInstanceById(id)
            if character and character:isOutside() then
                character:Hit(fakeItem, fakeZombie, 20, false, 1, false)
            end
        end
    end

    if player then
        local px, py = player:getX(), player:getY()
        if px >= x1 and px < x2 and py >= y1 and py < y2 and player:isOutside() then
            player:Hit(fakeItem, fakeZombie, 0.8, false, 1, false)
        end
    end

    -- smoke effect
    for i = 1, 2 do
        local effect2 = {}
        effect2.x = ZombRandFloat(x1, x2)
        effect2.y = ZombRandFloat(y1, y2)
        effect2.z = 0
        effect2.size = 300
        effect2.poison = false
        effect2.name = "smoke"
        effect2.frameCnt = 60
        effect2.frameRnd = true
        effect2.repCnt = 2
        table.insert(BWOEffects2.tab, effect2)
    end
end

BWOUtils.FindBuildingDist = function(px, py, min, max)
    local cell = getCell()
    local rooms = cell:getRoomList()
    local buildings = {}
    local buildingList = {}
    for i = 0, rooms:size() - 1 do
        local room = rooms:get(i)

        local building = room:getBuilding()
        if building then
            local def = building:getDef()
            local key = def:getKeyId()

            if not buildings[key] then
                buildings[key] = true
                table.insert(buildingList, building)
            end
        end
    end

    BWOUtils.Shuffle(buildingList)

    for _, building in ipairs(buildingList) do
        local def = building:getDef()
        local mx = (def:getX() + def:getX2()) / 2
        local my = (def:getY() + def:getY2()) / 2
        local dist = BanditUtils.DistTo(px, py, mx, my)

        if dist > min and dist < max then
            return building
        end
    end
end

BWOUtils.FindRoomDist = function(px, py, min, max)
    local cell = getCell()
    local rooms = cell:getRoomList()
    local roomList = {}
    for i = 0, rooms:size() - 1 do
        local room = rooms:get(i)
        table.insert(roomList, room)
    end

    BWOUtils.Shuffle(roomList)

    for _, room in ipairs(roomList) do
        local def = room:getRoomDef()
        if def then
            local mx = (def:getX() + def:getX2()) / 2
            local my = (def:getY() + def:getY2()) / 2
            local dist = BanditUtils.DistTo(px, py, mx, my)

            if dist > min and dist < max then
                return room
            end
        end
    end
end

BWOUtils.GetRandomRoomSquare = function(room)
    local def = room:getRoomDef()
    local x1, y1, x2, y2, z = def:getX(), def:getY(), def:getX2(), def:getY2(), def:getZ()
    local rx = x1 + ZombRand(x2-x1)
    local ry = y1 + ZombRand(y2-y1)
    local square = getCell():getGridSquare(rx, ry, z)
    return square
end

BWOUtils.HasZoneType = function(x, y, z, zoneType)
    local zones = getZones(x, y, z)
    if zones then
        for i=0, zones:size()-1 do
            local zone = zones:get(i)
            if zone:getType() == zoneType then
                return true
            end
        end
    end
    return false
end

BWOUtils.FindVehicleSpawnPoint = function(px, py, dmin, dmax)
    
    -- detects orientation and width of the road
    local getInfo = function(x, y)
        local res = {}
        res.valid = false
  
        -- check in x
        local xlen = 0
        local xmin = math.huge
        local xmax = 0
        for i = -8, 8 do
            local dx = x + i
            if BWOUtils.HasZoneType(dx, y, 0, "Nav") then 
                xlen = xlen + 1 
                if dx < xmin then
                    xmin = dx
                end
                if dx > xmax then
                    xmax = dx
                end
            end
        end

        --check in y
        local ylen = 0
        local ymin = math.huge
        local ymax = 0
        for i = -8, 8 do
            local dy = y + i
            if BWOUtils.HasZoneType(x, dy, 0, "Nav") then 
                ylen = ylen + 1
                if dy < ymin then
                    ymin = dy
                end
                if dy > ymax then
                    ymax = dy
                end
            end
        end

        if xlen >= 6 and ylen >= 6 then
            res.valid = true
            res.x = (xmin + xmax) / 2
            res.y = (ymax + ymax) / 2
        end

        return res
    end

    -- find all possible spawn points
    local slist = {}
    for i=-dmax, -dmin, 5 do
        table.insert(slist, i)
    end
    for i=dmin, dmax, 5 do
        table.insert(slist, i)
    end

    local list = {}
    for _, dx in ipairs(slist) do
        for _, dy in ipairs(slist) do
            local x = px + dx
            local y = py + dy
            local res = getInfo(x, y)
            if res.valid then 
                table.insert(list, res)
            end
        end
    end

    if #list == 0 then return {valid=false} end

    BWOUtils.Shuffle(list)

    local res = list[1]
    return res
end

BWOUtils.VehiclesAlarm = function(px, py, min, max)
    local vehicleList = getCell():getVehicles()
    for i=0, vehicleList:size()-1 do
        local vehicle = vehicleList:get(i)
        if vehicle and not vehicle:getDriver() and vehicle:hasAlarm() then
            local vx, vy = vehicle:getX(), vehicle:getY()
            local dist = BanditUtils.DistTo(px, py, vx, vy)
            if dist > min and dist < max then
                vehicle:setAlarmed(true)
                vehicle:triggerAlarm()
            end
        end
    end
end

BWOUtils.IsUsefulItem = function(item)
    local cat = item:getDisplayCategory()
    if instanceof(item, "Food") then
        if item:getCalories() > 100 then
            return true
        end
    elseif instanceof(item, "HandWeapon") then
        if item:getMinDamage() >= 0.5 then
            return true
        end
    elseif cat == "Ammo" then
        return true
    end
    return false
end

function BanditUtils.GetClosestCivilian(bandit)
    local bx, by, bz = bandit:getX(), bandit:getY(), bandit:getZ()
    local result
    local distBest = math.huge
    local bid = BanditUtils.GetZombieID(bandit)
    local zombieList = BanditZombie.GetAllB()
    for id, zombie in pairs(zombieList) do
        if id ~= bid and zombie.brain and zombie.brain.program and zombie.brain.program.name == "Universal" then 
            local distSq = ((bx - zombie.x) * (bx - zombie.x)) + ((by - zombie.y) * (by - zombie.y))
            if zombie.z == bz and distSq < 9 and distSq < distBest then
                local bandit2 = BanditZombie.GetInstanceById(id)
                if bandit:CanSee(bandit2) then
                    result = bandit2
                end
            end
        end
    end

    return result
end

function BanditUtils.MakeHomeless(bandit)
    local banditVisuals = bandit:getHumanVisual()

    local maxIndex = BloodBodyPartType.MAX:index()
    for i = 0, maxIndex - 1 do
        local part = BloodBodyPartType.FromIndex(i)
        banditVisuals:setDirt(part, 1)
    end

    local itemVisuals = bandit:getItemVisuals()
    for i = 0, itemVisuals:size() - 1 do
        local item = itemVisuals:get(i)
        if item then
            local itemType = item:getItemType()
            if itemType then
                local itemTemp = BanditCompatibility.InstanceItem(itemType)
                 if itemTemp and itemTemp:IsClothing() then
                    local coveredPartList = itemTemp:getCoveredParts()
                    for i=0, coveredPartList:size()-1 do
                        local coveredPart = coveredPartList:get(i)
                        item:setHole(coveredPart)
                    end
                end
            end
        end
    end
    bandit:resetModel()
end

function BanditUtils.GetIsoObject(x, y, z, customName)
    local cell = getCell()
    local square = cell:getGridSquare(x, y, z)
    if not square then return nil end

    local objects = square:getObjects()
    for i=0, objects:size()-1 do
        local object = objects:get(i)
        local sprite = object:getSprite()
        if sprite then
            local props = sprite:getProperties()
            if props and props:has("CustomName") and  props:get("CustomName") == customName then
                return object
            end
        end
    end
end

BWOUtils.GetItemClass = function(item)
    local class = "normal"

    if item:isRecordedMedia() then
        class = "media"
    elseif (item:isFood() and not item:isPoison()) then
        if item:getOpeningRecipe() or item:getDoubleClickRecipe() then
            class = "food_packaged"
        else
            class = "food"
        end
    elseif instanceof(item, "ComboItem") then
        local fluidContainer = item:getFluidContainer()
        if fluidContainer and not fluidContainer:isPoisonous() and not fluidContainer:isEmpty() and not fluidContainer:isTainted() then
            class = "drink"
        end
    elseif item:IsClothing() then
        class = "clothing"
    end
    return class
end

BWOUtils.GetSurfaceOffset = function(x, y, z)

    local cell = getCell()
    local square = cell:getGridSquare(x, y, z)
    local tileObjects = square:getLuaTileObjectList()
    local squareSurfaceOffset = 0

    -- get the object with the highest offset
    for k, object in pairs(tileObjects) do
        local surfaceOffsetNoTable = object:getSurfaceOffsetNoTable()
        if surfaceOffsetNoTable > squareSurfaceOffset then
            squareSurfaceOffset = surfaceOffsetNoTable
        end

        local surfaceOffset = object:getSurfaceOffset()
        if surfaceOffset > squareSurfaceOffset then
            squareSurfaceOffset = surfaceOffset
        end
    end

    return squareSurfaceOffset / 96
end

