BWOFakeVehicle = BWOFakeVehicle or {}
BWOFakeVehicle.tab = {}

local floor, sin, cos, tan, deg = math.floor, math.sin, math.cos, math.tan, math.deg
local ONE_PI = math.pi
local TWO_PI = math.pi * 2
local LIGHT_COLOR = {r = 1, g = 1, b = 0.8}
local LIGHT_RANGE = 14
local TURN_EARLY_DISTANCE = 3
local BREAK_EARLY_DISTANCE = 10
local ACCELERATION_STEP = 0.25
local BRAKING_STEP = 1.72
local BLOCKED_REMOVE_TICKS = 2000
local PLAYER_CLOSE_DISTANCE = 70
------------------------------------------------
-- Vehicle registration
------------------------------------------------
function BWOFakeVehicle.Add(params)
    local vehicle = {}

    local graph = BWOUtils and BWOUtils.GetDriveGraph and BWOUtils.GetDriveGraph() or nil
    if not graph then return end

    local startNodeId = params.startNodeId and tostring(params.startNodeId) or nil
    local prevNodeId = params.prevNodeId and tostring(params.prevNodeId) or nil
    local startNode = startNodeId and graph[startNodeId] or nil
    local spawnX = params.startX or params.x
    local spawnY = params.startY or params.y

    if (not startNode) and spawnX and spawnY and BWOUtils.GetNearestDriveNodeId then
        startNodeId, startNode = BWOUtils.GetNearestDriveNodeId(spawnX, spawnY, graph)
    end

    if not startNode and (not spawnX or not spawnY) then return end

    vehicle.parts = params.parts
    vehicle.startNodeId = startNodeId
    if prevNodeId and graph[prevNodeId] then
        vehicle.prevNodeId = prevNodeId
    else
        vehicle.prevNodeId = nil
    end
    vehicle.targetNodeId = startNodeId
    vehicle.path = nil
    vehicle.pathIndex = nil
    vehicle.loopPath = (params.loopPath ~= false)
    vehicle.cruiseSpeed = params.cruiseSpeed or params.speed or 15
    vehicle.originalSpeed = vehicle.cruiseSpeed

    vehicle.x = spawnX or (startNode and startNode.x)
    vehicle.y = spawnY or (startNode and startNode.y)
    vehicle.z = 0
    local startRot = (params.startRot or 0) * ONE_PI / 180
    vehicle.rot = startRot % TWO_PI
    vehicle.steer = 0
    vehicle.speed = vehicle.originalSpeed
    vehicle.blockedTicks = 0

    vehicle.emitter = getWorld():getFreeEmitter(vehicle.x, vehicle.y, vehicle.z)
    vehicle.emitter2 = getWorld():getFreeEmitter(vehicle.x, vehicle.y, vehicle.z)

    table.insert(BWOFakeVehicle.tab, vehicle)
end

BWOFakeVehicle.spawnOptions = {
    {
        templateFunc = BWOFakeVehicleParts.CarLightsTemplate, 
        bodyItemType = "Base.CarLightsPolice",
        cruiseSpeed = 45,
        spawnX = 11840,
        spawnY = 6810,
        startRot = 0,
    },
    {
        templateFunc = BWOFakeVehicleParts.CarLightsTemplate, 
        bodyItemType = "Base.CarLightsKST",
        cruiseSpeed = 45,
        spawnX = 11840,
        spawnY = 6810,
        startRot = 0,
    },
    {
        templateFunc = BWOFakeVehicleParts.CarLightsTemplate, 
        bodyItemType = "Base.CarNormalBlack",
        cruiseSpeed = 45,
        spawnX = 11840,
        spawnY = 6810,
        startRot = 0,
    },
    {
        templateFunc = BWOFakeVehicleParts.CarLightsTemplate, 
        bodyItemType = "Base.CarNormalBlue",
        cruiseSpeed = 45,
        spawnX = 11840,
        spawnY = 6810,
        startRot = 0,
    },
    {
        templateFunc = BWOFakeVehicleParts.CarLightsTemplate, 
        bodyItemType = "Base.CarNormalTaxi",
        cruiseSpeed = 45,
        spawnX = 11840,
        spawnY = 6810,
        startRot = 0,
    },
    {
        templateFunc = BWOFakeVehicleParts.ModernCarLightsTemplate, 
        bodyItemType = "Base.ModernCarLightsWestpoint",
        cruiseSpeed = 45,
        spawnX = 11840,
        spawnY = 6810,
        startRot = 0,
    },
    {
        templateFunc = BWOFakeVehicleParts.ModernCarLightsTemplate, 
        bodyItemType = "Base.ModernCar02Beige",
        cruiseSpeed = 45,
        spawnX = 11840,
        spawnY = 6810,
        startRot = 0,
    },
    {
        templateFunc = BWOFakeVehicleParts.ModernCarLightsTemplate, 
        bodyItemType = "Base.ModernCar02Black",
        cruiseSpeed = 45,
        spawnX = 11840,
        spawnY = 6810,
        startRot = 0,
    },
    {
        templateFunc = BWOFakeVehicleParts.ModernCarLightsTemplate, 
        bodyItemType = "Base.ModernCar02Blue",
        cruiseSpeed = 45,
        spawnX = 11840,
        spawnY = 6810,
        startRot = 0,
    },
    {
        templateFunc = BWOFakeVehicleParts.ModernCarLightsTemplate, 
        bodyItemType = "Base.ModernCar02Green",
        cruiseSpeed = 45,
        spawnX = 11840,
        spawnY = 6810,
        startRot = 0,
    },
    {
        templateFunc = BWOFakeVehicleParts.ModernCarLightsTemplate, 
        bodyItemType = "Base.ModernCar02Gray",
        cruiseSpeed = 45,
        spawnX = 11840,
        spawnY = 6810,
        startRot = 0,
    },
    {
        templateFunc = BWOFakeVehicleParts.ModernCarLightsTemplate, 
        bodyItemType = "Base.ModernCar02Red",
        cruiseSpeed = 45,
        spawnX = 11840,
        spawnY = 6810,
        startRot = 0,
    },
    {
        templateFunc = BWOFakeVehicleParts.ModernCarLightsTemplate, 
        bodyItemType = "Base.ModernCar02White",
        cruiseSpeed = 45,
        spawnX = 11840,
        spawnY = 6810,
        startRot = 0,
    },
}

local function round(num, decimals)
    local mult = 10 ^ decimals
    return floor(num * mult + 0.5) / mult
end

local function clamp(v, minV, maxV)
    if v < minV then return minV end
    if v > maxV then return maxV end
    return v
end

local function moveTowards(current, target, maxStep)
    if current < target then
        return math.min(current + maxStep, target)
    elseif current > target then
        return math.max(current - maxStep, target)
    end
    return current
end

local function normalizeAngle(a)
    a = (a + ONE_PI) % (2 * ONE_PI)   -- this ensures 0..2π
    if a < 0 then a = a + 2 * ONE_PI end
    return a - ONE_PI
end

--[[
local function normalizeAngle(a)
    return ((a + ONE_PI) % (2 * ONE_PI)) - ONE_PI
end
]]

local function playSoundVehicle(vehicle, soundName)
    vehicle.emitter:setPos(vehicle.x, vehicle.y, vehicle.z)
    if not vehicle.emitter:isPlaying(soundName) then
        vehicle.emitter:playSound(soundName)
    end
end

local function playSoundVehicle2(vehicle, soundName)
    vehicle.emitter2:setPos(vehicle.x, vehicle.y, vehicle.z)
    if not vehicle.emitter2:isPlaying(soundName) then
        vehicle.emitter2:playSound(soundName)
    end
end

local function playSoundVehicleEngine(vehicle, soundName)
    if not vehicle.emitter then return end

    local soundIdle = "BWOBMWIdle"
    local soundRunning = "BWOBMWRunning"
    if vehicle.speed > 0 then
        vehicle.emitter:stopSoundByName(soundIdle)
        if not vehicle.emitter:isPlaying(soundRunning) then
            vehicle.emitter:playSound(soundRunning)
        end
    else
        vehicle.emitter:stopSoundByName(soundRunning)
        if not vehicle.emitter:isPlaying(soundIdle) then
            vehicle.emitter:playSound(soundIdle)
        end
    end
    vehicle.emitter:setPos(vehicle.x, vehicle.y, 0)
end

------------------------------------------------
-- Part creation / lookup
------------------------------------------------
local function getOrCreatePart(part, vehicle, square)
    local obj, item
    local wobs = square:getWorldObjects()
    for i = 0, wobs:size() - 1 do
        local wobj = wobs:get(i)
        local it = wobj:getItem()
        if it:getFullType() == part.itemType then
            obj, item = wobj, it
            break
        end
    end

    if not obj then
        local it = BanditCompatibility.InstanceItem(part.itemType)
        square:AddWorldInventoryItem(it, 0, 0, 0)
        wobs = square:getWorldObjects()
        for i = 0, wobs:size() - 1 do
            local wobj = wobs:get(i)
            local it2 = wobj:getItem()
            if it2:getFullType() == part.itemType then
                obj, item = wobj, it2
                break
            end
        end
    end

    return obj, item
end

------------------------------------------------
-- Transform local offsets into world coordinates
------------------------------------------------
local function transformPart(part, vehicle)
    local rot = vehicle.rot or 0
    local s, c = cos(rot), sin(rot)
    local lx, ly = part.xoffset or 0, part.yoffset or 0
    local wx = vehicle.x + (lx * c) + (ly * s)
    local wy = vehicle.y - (lx * s) + (ly * c)
    local wz = vehicle.z + (part.zoffset or 0)
    return wx, wy, wz
end

local function removePart(part, vehicle)
    if part._obj then
        local oldSquare = getCell():getGridSquare(part._gx, part._gy, part._gz)
        if oldSquare then
            oldSquare:removeWorldObject(part._obj)
            part._obj = nil
            part._item = nil
        end
    end
end

------------------------------------------------
-- Update a single part (spawn/move/rotate)
------------------------------------------------
local function updatePart(part, vehicle)
    local wx_raw, wy_raw, wz_raw = transformPart(part, vehicle)

    -- integer square pos (stable carry method)
    local gx = floor(wx_raw)
    local gy = floor(wy_raw)
    local gz = floor(wz_raw)

    local square = getCell():getGridSquare(gx, gy, gz)
    if not square then 
        return 
    end

    local offX = round(wx_raw - gx, 2)
    local offY = round(wy_raw - gy, 2)
    local offZ = round(wz_raw - gz, 2)

    local offX = wx_raw - gx
    local offY = wy_raw - gy
    local offZ = wz_raw - gz

    -- force into [0,1)
    if offX < 0 then gx, offX = gx - 1, offX + 1 end
    if offY < 0 then gy, offY = gy - 1, offY + 1 end
    if offZ < 0 then gz, offZ = gz - 1, offZ + 1 end
    if offX > 1 then gx, offX = gx + 1, offX - 1 end
    if offY > 1 then gy, offY = gy + 1, offY - 1 end
    if offZ > 1 then gz, offZ = gz + 1, offZ - 1 end

    -- detect square change
    if part._gx ~= gx or part._gy ~= gy or part._gz ~= gz then
        if part._obj then
            local oldSquare = getCell():getGridSquare(part._gx, part._gy, part._gz)
            if oldSquare then
                oldSquare:removeWorldObject(part._obj)
                part._obj = nil
                part._item = nil
            end
        end
    end

    if not part._obj or not part._item then
        part._obj, part._item = getOrCreatePart(part, vehicle, square)
        part._gx, part._gy, part._gz = gx, gy, gz
    end

    local obj, item = part._obj, part._item
    if not (obj and item) then 
        return 
    end

    -- Apply offsets (no quantize, just stable carry)
    obj:setOffX(offX)
    obj:setOffY(offY)
    obj:setOffZ(offZ)

    -- Rotations
    item:setWorldXRotation(part.xrot or 0)
    item:setWorldYRotation(part.yrot or 0)

    local visualRot = vehicle.rot 
    local visualSteer = part.steerRot and vehicle.steer or 0

    local angleDeg = deg(visualRot + visualSteer)
    if part.zrot then
        angleDeg = angleDeg + part.zrot
    end
    angleDeg = round(angleDeg, 0)

    local gameRot = (90 + angleDeg) % 360
    if gameRot == 360 then gameRot = 0 end
    item:setWorldZRotation(gameRot)
    -- item:setWorldZRotation(gameRot)

    obj:update()

end

------------------------------------------------
-- Collision check for body only
------------------------------------------------
local function inBoundary(body, vehicle, px, py)
    local halfW = body.width / 2
    local wheelbase = body.wheelbase or 4.0
    local frontOverhang = body.frontOverhang or 0.5
    local rearOverhang  = body.rearOverhang  or 0.5
    local rot = vehicle.rot or 0

    local s, c = cos(rot), sin(rot)
    local localCorners = {
        {-halfW, -rearOverhang},                -- rear-left
        { halfW, -rearOverhang},                -- rear-right
        { halfW, wheelbase + frontOverhang},    -- front-right
        {-halfW, wheelbase + frontOverhang},    -- front-left
    }

    local corners = {}
    for i = 1, 4 do
        local lx, ly = localCorners[i][1], localCorners[i][2]
        local wx = vehicle.x + (lx * c) + (ly * s)
        local wy = vehicle.y - (lx * s) + (ly * c)
        corners[i] = {wx, wy}
    end

    for i = 1, 4 do
        local j = (i % 4) + 1
        local x1, y1 = corners[i][1], corners[i][2]
        local x2, y2 = corners[j][1], corners[j][2]

        local ex, ey = x2 - x1, y2 - y1
        local pxv, pyv = px - x1, py - y1
        if (ex * pyv - ey * pxv) < 0 then
            return false
        end
    end

    return true
end

local function isBlockedAhead(vehicle, d, spread)
    local body = vehicle.parts.body
    if not body then return false end

    local vt = BWOFakeVehicle.tab
    local margin = 0.2
    local halfW = body.width / 2 + margin
    local rot = vehicle.rot
    local dirX, dirY = math.cos(rot), math.sin(rot)
    local sideX, sideY = -dirY, dirX
    local pz = vehicle.z or 0

    -- step forward up to distance d
    for step = 1, math.floor(d) do
        local cx = vehicle.x + dirX * step
        local cy = vehicle.y + dirY * step

        -- span across vehicle width
        for offset = -halfW, halfW, 0.5 do
            local px = cx + sideX * offset
            local py = cy + sideY * offset
            local gx, gy = math.floor(px), math.floor(py)

            local square = getCell():getGridSquare(gx, gy, pz)
            if square then
                local zombie = square:getZombie()
                -- solid obstacle
                --[[
                if not square:isFree(false) then
                    return true
                end
                ]]
                -- zombie
                if zombie and zombie:isAlive() then
                    if zombie:getVariableBoolean("Bandit") then
                        if Bandit.IsHostile(zombie) then
                            return false -- bandit
                        else
                            return true -- friendly
                        end
                    end
                    return false -- zombie
                end
                -- player
                if square:getPlayer() then
                    return true
                end
                -- vehicle
                if square:getVehicleContainer() then
                    return true
                end
            else
                return false
            end

            -- check against FakeVehicles
            for _, other in ipairs(vt) do
                if other ~= vehicle then
                    local dx, dy = other.x - px, other.y - py
                    if dx * dx + dy * dy < 1.0 then -- within 1 tile radius
                        return true
                    end
                end
            end
        end
    end

    return false 
end

function getPitch(speed)
    -- Max speed per gear thresholds (end of gear speed)
    local maxSpeeds = {8, 16, 28, 44, 64}

    -- Base pitch at start of each gear
    local basePitches = {0.7, 1.4, 1.6, 1.85, 1.95}

    -- Max pitch at end of each gear
    local maxPitches = {2.0, 2.1, 2.15, 2.18, 3.2}

    -- Determine current gear based on speed
    local gear = #maxSpeeds  -- default gear (last)
    for i, maxSpeed in ipairs(maxSpeeds) do
        if speed <= maxSpeed then
            gear = i
            break
        end
    end

    -- Calculate gear start speed
    local gearStartSpeed = 0
    if gear > 1 then
        gearStartSpeed = maxSpeeds[gear - 1]
    end
    local gearEndSpeed = maxSpeeds[gear]

    -- Normalize speed within current gear [0..1]
    local normSpeed = (speed - gearStartSpeed) / (gearEndSpeed - gearStartSpeed)
    if normSpeed < 0 then normSpeed = 0 end
    if normSpeed > 1 then normSpeed = 1 end

    -- Interpolate pitch within gear
    local pitch = basePitches[gear] + normSpeed * (maxPitches[gear] - basePitches[gear])

    return pitch
end

local function getFrontPosition(vehicle, offset)
    local body = vehicle.parts.body
    local rot = vehicle.rot
    local dirX, dirY = math.cos(rot), math.sin(rot)

    -- distance from ref point to the front bumper
    local dist = (body.wheelbase or 3) + (body.frontOverhang or 0.5) + offset

    -- world coords of front center
    local fx = math.floor(vehicle.x + dirX * dist)
    local fy = math.floor(vehicle.y + dirY * dist)
    local fz = math.floor(vehicle.z + (body.zoffset or 0))

    return fx, fy, fz
end

local function pickNextLinkedNode(graph, currentId, previousId, vehicle)
    local current = graph[currentId]
    if not (current and current.links) then
        return nil
    end

    local candidates = {}
    for linkedId, _ in pairs(current.links) do
        if linkedId ~= previousId then
            table.insert(candidates, linkedId)
        end
    end

    if vehicle and vehicle.rot and vehicle.x and vehicle.y and #candidates > 0 then
        local headingX = cos(vehicle.rot)
        local headingY = sin(vehicle.rot)
        local forwardCandidates = {}

        for _, linkedId in ipairs(candidates) do
            local node = graph[linkedId]
            if node then
                local vx = node.x - vehicle.x
                local vy = node.y - vehicle.y
                local lenSq = vx * vx + vy * vy
                if lenSq < 0.0001 then
                    table.insert(forwardCandidates, linkedId)
                else
                    local dot = headingX * vx + headingY * vy
                    if dot >= 0 then
                        table.insert(forwardCandidates, linkedId)
                    end
                end
            end
        end

        if #forwardCandidates > 0 then
            candidates = forwardCandidates
        end
    end

    if #candidates > 0 then
        return candidates[ZombRand(#candidates) + 1]
    end

    for linkedId, _ in pairs(current.links) do
        return linkedId
    end

    return nil
end

local function updatePathTarget(vehicle, graph)
    if not graph then
        return nil, nil
    end

    if not vehicle.targetNodeId and BWOUtils.GetNearestDriveNodeId then
        vehicle.targetNodeId = BWOUtils.GetNearestDriveNodeId(vehicle.x, vehicle.y, graph)
        vehicle.prevNodeId = nil
    end

    local target = vehicle.targetNodeId and graph[vehicle.targetNodeId] or nil
    if not target and BWOUtils.GetNearestDriveNodeId then
        vehicle.targetNodeId = BWOUtils.GetNearestDriveNodeId(vehicle.x, vehicle.y, graph)
        vehicle.prevNodeId = nil
        target = vehicle.targetNodeId and graph[vehicle.targetNodeId] or nil
    end

    if not target then
        return nil, nil
    end

    local dx = target.x - vehicle.x
    local dy = target.y - vehicle.y
    local distSq = dx * dx + dy * dy
    local approachDist = math.sqrt(distSq)
    local curveAngle = 0

    local nextId = pickNextLinkedNode(graph, vehicle.targetNodeId, vehicle.prevNodeId, vehicle)
    if nextId then
        local nextNode = graph[nextId]
        if nextNode then
            local nextDx = nextNode.x - target.x
            local nextDy = nextNode.y - target.y
            local approachLen = math.sqrt(dx * dx + dy * dy)
            local exitLen = math.sqrt(nextDx * nextDx + nextDy * nextDy)
            if approachLen > 0.0001 and exitLen > 0.0001 then
                local dot = (dx * nextDx) + (dy * nextDy)
                local ratio = clamp(dot / (approachLen * exitLen), -1, 1)
                curveAngle = math.acos(ratio)
            end
        end
    end

    -- When a waypoint is reached, continue to the next linked waypoint.
    if distSq < (TURN_EARLY_DISTANCE * TURN_EARLY_DISTANCE) then
        local currentId = vehicle.targetNodeId
        vehicle.prevNodeId = currentId
        if nextId then
            vehicle.targetNodeId = nextId
            target = graph[nextId] or target
        end
    end

    return target.x, target.y, approachDist, curveAngle
end

local function isAnyPlayerClose(vehicle, players)
    for _, player in ipairs(players) do
        local dx = player:getX() - vehicle.x
        local dy = player:getY() - vehicle.y
        local distSq = dx * dx + dy * dy
        if distSq < (PLAYER_CLOSE_DISTANCE * PLAYER_CLOSE_DISTANCE) then
            return true
        end
    end

    return false
end
------------------------------------------------
-- Vehicle manager
------------------------------------------------
local function manageVehicles(ticks)
    --- if not isIngameState() or isServer() then return end

    local cell = getCell()
    local volume = getSoundManager():getSoundVolume()
    local fakeItem = BanditCompatibility.InstanceItem("Base.AssaultRifle")
    local fakeZombie = cell:getFakeZombieForHit()
    local fakeVehicle = BaseVehicle.new(cell)
    local zombieList = BanditZombie.CacheLight
    local vehicleList = BWOFakeVehicle.tab
    local players = BWOUtils.GetAllPlayers()
    local graph = BWONavigation and BWONavigation.drive
    local multiplier = getGameTime():getMultiplier() * 0.005
    local removeIndices = {}

    for idx, vehicle in ipairs(vehicleList) do
        local body = vehicle.parts.body
        local isAnyPlayerClose = isAnyPlayerClose(vehicle, players)
        if body then
            ------------------------------------------------
            -- PATH FOLLOWING
            ------------------------------------------------
            local blockedAhead = isBlockedAhead(vehicle, 9, 2)
            if blockedAhead then
                vehicle.blockedTicks = (vehicle.blockedTicks or 0) + 1
            else
                vehicle.blockedTicks = 0
            end

            if vehicle.blockedTicks >= BLOCKED_REMOVE_TICKS then
                table.insert(removeIndices, idx)
            end

            local targetSpeed = vehicle.originalSpeed or vehicle.cruiseSpeed or 15

            local tx, ty, waypointDist, curveAngle = updatePathTarget(vehicle, graph)

            if tx and ty then
                local dx, dy = tx - vehicle.x, ty - vehicle.y

                local targetAngle = normalizeAngle(math.atan2(dy, dx))
                local currentRot = normalizeAngle(vehicle.rot)
                local angleDiff = normalizeAngle(targetAngle - currentRot)

                local maxSteer = 0.6
                local steerGain = 2.8
                local desiredSteer = clamp(angleDiff * steerGain, -maxSteer, maxSteer)
                vehicle.steer = desiredSteer

                if blockedAhead then
                    targetSpeed = 0
                    if vehicle.speed > 3 then
                        playSoundVehicle(vehicle, "VehicleHandBrake") -- VehicleHandBrakeChunky
                    end
                    playSoundVehicle2(vehicle, "BWOCarHorn")
                else
                    local originalSpeed = vehicle.originalSpeed or vehicle.cruiseSpeed or 15
                    local minTurnSpeed = 15
                    local ninety = ONE_PI * 0.5

                    if waypointDist and waypointDist > BREAK_EARLY_DISTANCE then
                        targetSpeed = originalSpeed
                    else
                        local turnAngle = curveAngle or 0
                        if turnAngle >= ninety then
                            targetSpeed = minTurnSpeed
                        else
                            local ratio = turnAngle / ninety
                            targetSpeed = originalSpeed - (originalSpeed - minTurnSpeed) * ratio
                        end
                    end
                end
            else
                vehicle.steer = 0
                if blockedAhead then
                    targetSpeed = 0
                else
                    targetSpeed = vehicle.originalSpeed or vehicle.cruiseSpeed or 15
                end
            end

            local currentSpeed = vehicle.speed or 0
            if currentSpeed < targetSpeed then
                vehicle.speed = math.min(currentSpeed + ACCELERATION_STEP, targetSpeed)
            elseif currentSpeed > targetSpeed then
                vehicle.speed = math.max(currentSpeed - BRAKING_STEP, targetSpeed)
            else
                vehicle.speed = targetSpeed
            end

            ------------------------------------------------
            -- ENGINE SOUND
            ------------------------------------------------

            -- playSoundVehicleEngine(vehicle)

            ------------------------------------------------
            -- LIGHT MANAGEMENT
            ------------------------------------------------
            if isAnyPlayerClose then
                for i = 1, 4 do
                    local lx, ly, lz = getFrontPosition(vehicle, i * i + 2)

                    local lightSource = IsoLightSource.new(lx, ly, lz, LIGHT_COLOR.r, LIGHT_COLOR.g, LIGHT_COLOR.b, i * i, 1)
                    if lightSource then
                        cell:addLamppost(lightSource)
                    end
                end
            end

            ------------------------------------------------
            -- MOVEMENT INTEGRATION
            ------------------------------------------------
            local step = vehicle.speed * multiplier
            local wheelbase = math.max(body.wheelbase or 3, 0.01)
            local steer = clamp(vehicle.steer or 0, -0.75, 0.75)
            vehicle.rot = (vehicle.rot + (step / wheelbase) * math.tan(steer)) % TWO_PI
            --vehicle.rot = round(vehicle.rot, 2)

            vehicle.x = vehicle.x + step * cos(vehicle.rot)
            vehicle.y = vehicle.y + step * sin(vehicle.rot)
            -- vehicle.x = round(vehicle.x, 6)
            -- vehicle.y = round(vehicle.y, 6)

            ------------------------------------------------
            -- UPDATE PARTS
            ------------------------------------------------
            for _, part in pairs(vehicle.parts) do
                if isAnyPlayerClose then
                    updatePart(part, vehicle, isAnyPlayerClose)
                else
                    removePart(part, vehicle)
                end
            end

            ------------------------------------------------
            -- COLLISIONS (BODY ONLY)
            ------------------------------------------------
            if isAnyPlayerClose then
                for id, chr in pairs(zombieList) do
                    if inBoundary(body, vehicle, chr.x, chr.y) then
                        local chr = BanditZombie.GetInstanceById(chr.id)
                        if chr and chr:isAlive() and chr:getActionStateName() ~= "hitreaction" then
                            -- 
                            if vehicle.speed > 6 then
                                local dmg = math.floor(vehicle.speed * 0.1)
                                chr:Hit(fakeItem, fakeZombie, dmg, false, 1, false)
                                vehicle.speed = vehicle.speed * 0.8

                                playSoundVehicle(vehicle, "VehicleHitCharacter")
                            elseif vehicle.speed > 1 then
                                chr:changeState(ZombieOnGroundState.instance())
                                playSoundVehicle(vehicle, "VehicleRunOverBody")
                            end
                            --chr:Hit(fakeVehicle, vehicle.speed, false, -4, -4)
                            


                            --[[
                            local square = chr:getSquare()

                            if square and square:getChunk() then
                                local item = BanditCompatibility.InstanceItem("Base.PipeBomb")
                                item:setExplosionPower(10)
                                item:setTriggerExplosionTimer(0)
                                item:setAttackTargetSquare(square)

                                local trap = IsoTrap.new(nil, item, cell, square)
                                trap:triggerExplosion(false)
                            end]]
                        end
                    end
                end

                for _, player in ipairs(players) do
                    if inBoundary(body, vehicle, player:getX(), player:getY()) then
                        if vehicle.speed > 6 then
                            local dmg = math.floor(vehicle.speed * 0.1)
                            player:Hit(fakeItem, fakeZombie, dmg, false, 1, false)
                            vehicle.speed = vehicle.speed * 0.8
                            player:clearVariable("BumpFallType")
                            player:setBumpType("stagger")
                            player:setBumpFall(true)
                            player:setBumpFallType("pushedBehind")
                        end
                    end
                end
            end
        end
    end

    for i = #removeIndices, 1, -1 do
        local idx = removeIndices[i]
        local vehicle = vehicleList[idx]
        if vehicle then
            if vehicle.parts then
                for _, part in pairs(vehicle.parts) do
                    if part._obj then
                        local oldSquare = getCell():getGridSquare(part._gx, part._gy, part._gz)
                        if oldSquare then
                            oldSquare:removeWorldObject(part._obj)
                            part._obj = nil
                            part._item = nil
                        end
                    end
                end
            end

            if vehicle.ls then
                for _, lightSource in pairs(vehicle.ls) do
                    if lightSource then
                        cell:removeLamppost(lightSource)
                    end
                end
            end
            table.remove(vehicleList, idx)
        end
    end

    fakeItem = nil
    fakeZombie = nil
end

Events.OnTick.Remove(manageVehicles)
Events.OnTick.Add(manageVehicles)

local function manageVehiclePopulation()
    local expectedPopulation = 32
    local spawnOptions = BWOFakeVehicle.spawnOptions
    local vehicleList = BWOFakeVehicle.tab
    local currentPopulation = #vehicleList
    if currentPopulation < expectedPopulation then
        local option = BanditUtils.Choice(spawnOptions)

        local vehicle = {
            startX = option.spawnX,
            startY = option.spawnY,
            cruiseSpeed = option.cruiseSpeed,
            startRot = option.startRot,
            parts = BWOFakeVehicleParts.InstanceParts(option.templateFunc, option.bodyItemType),
        }

        BWOFakeVehicle.Add(vehicle)
    end
end

Events.EveryOneMinute.Remove(manageVehiclePopulation)
Events.EveryOneMinute.Add(manageVehiclePopulation)
