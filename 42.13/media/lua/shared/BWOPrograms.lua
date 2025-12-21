BanditPrograms = BanditPrograms or {}

-- this is a collection of universal subprograms that are shared by main npc programs.

BanditPrograms.Symptoms = function(bandit)
    local tasks = {}

    local id = BanditUtils.GetCharacterID(bandit)
    local gameTime = getGameTime()
    local hour = gameTime:getHour()
    local minute = gameTime:getMinutes()

    local rn = ZombRand(20)
    if rn < 14 then
        local sound 
        if bandit:isFemale() then
            sound = "ZSCoughF" .. (1 + ZombRand(4))
        else
            sound = "ZSCoughM" .. (1 + ZombRand(4))
        end
        local task = {action="Time", anim="Cough", sound=sound, time=100}
        table.insert(tasks, task)
        return tasks
    elseif rn == 14 then
        local task = {action="Time", anim="PainTorso", time=100}
        table.insert(tasks, task)
        return tasks
    elseif rn == 15 then
        local task = {action="Time", anim="PainStomach1", time=100}
        table.insert(tasks, task)
        return tasks
    elseif rn == 16 then
        local task = {action="Time", anim="PainStomach2", time=100}
        table.insert(tasks, task)
        return tasks
    elseif rn == 17 then
        local task = {action="Time", anim="FeelFeint", time=100}
        table.insert(tasks, task)
        return tasks
    else
        local sound = "ZSVomit" .. (1 + ZombRand(4))
        local task = {action="Vomit", anim="Vomit", sound=sound, time=100}
        table.insert(tasks, task)

        return tasks
    end

    return tasks
end

BanditPrograms.FallbackAction = function(bandit)
    local tasks = {}
    local action = ZombRand(10)

    if action == 0 then
        local task = {action="Time", anim="ShiftWeight", time=200}
        table.insert(tasks, task)
    elseif action == 1 then
        local task = {action="Time", anim="ChewNails", time=200}
        table.insert(tasks, task)
    elseif action == 2 then
        local task = {action="Time", anim="Smoke", time=200}
        table.insert(tasks, task)
        table.insert(tasks, task)
        table.insert(tasks, task)
    elseif action == 3 then
        local task = {action="Time", anim="PullAtCollar", time=200}
        table.insert(tasks, task)
    elseif action == 4 then
        local task = {action="Time", anim="Sneeze", time=200}
        table.insert(tasks, task)
        addSound(getPlayer(), bandit:getX(), bandit:getY(), bandit:getZ(), 7, 60)
    elseif action == 5 then
        local task = {action="Time", anim="WipeBrow", time=200}
        table.insert(tasks, task)
    elseif action == 6 then
        local task = {action="Time", anim="WipeHead", time=200}
        table.insert(tasks, task)
    else
        local task = {action="Time", anim="ChewNails", time=200}
        table.insert(tasks, task)
    end

    return tasks
end

BanditPrograms.FollowRoad = function(bandit, walkType)

    local function getGroundQuality(square)
        local quality
        local objects = square:getObjects()
        for i=0, objects:size()-1 do
            local object = objects:get(i)
            if object then
                local sprite = object:getSprite()
                if sprite then
                    local spriteName = sprite:getName()
                    if spriteName then
                        
                        if spriteName:embodies("tilesandstone") then
                            -- best quality pedestrian pavements
                            quality = 1
                            break
                        elseif spriteName:embodies("street") then
                            local spriteProps = sprite:getProperties()
                            if spriteProps:has(IsoFlagType.attachedFloor) then
                                local material = spriteProps:get("FootstepMaterial")
                                if material == "Gravel" then
                                    -- gravel path
                                    quality = 1 -- 2
                                else
                                    -- probably main road
                                    quality = 4
                                end
                            else
                                -- probably parking
                                quality = 1 -- 3
                            end

                            break
                        end
                    end
                end
            end
        end
        return quality
    end

    local tasks = {}

    local player = getSpecificPlayer(0)
    if not player then return end

    local cell = bandit:getCell()
    local bx = bandit:getX()
    local by = bandit:getY()
    local bz = bandit:getZ()

    -- react to cars

    local vehicleList = {}
    --[[
    local npcVehicles = BWOVehicles.tab
    for k, v in pairs(npcVehicles) do
        if v:getController() and not v:isStopped() then
            vehicleList[k] = v
        end
    end]]

    local playerVehicle = player:getVehicle()
    if playerVehicle and not playerVehicle:isStopped() then
        vehicleList[playerVehicle:getId()] = playerVehicle
    end

    for id, vehicle in pairs(vehicleList) do
        local vx = vehicle:getX()
        local vy = vehicle:getY()
        local dist = BanditUtils.DistTo(bx, by, vx, vy)
        if dist < 10 then
            local vay = vehicle:getAngleY()
            local ba = bandit:getDirectionAngle()

            -- angles of cars are 90 degrees rotated compared to character angles
            -- normalize this
            vay = vay - 90
            if vay < -180 then vay = vay + 360 end

            local escapeAngle = vay - 90
            if escapeAngle < 180 then escapeAngle = escapeAngle + 360 end 

            local theta = escapeAngle * math.pi * 0.00555555--/ 180
            local lx = math.floor(10 * math.cos(theta) + 0.5)
            if bx > vx then 
                lx = math.abs(lx) 
            else
                lx = -math.abs(lx) 
            end

            local ly = math.floor(10 * math.sin(theta) + 0.5)
            if by > vy then 
                ly = math.abs(ly) 
            else
                ly = -math.abs(ly) 
            end
            
            -- print ("should escape to lx: " .. lx .. " ly: " .. ly)
            table.insert(tasks, BanditUtils.GetMoveTask(0, bx + lx, by + ly, 0, "Run", 10, false))
            return tasks
            
        end
    end

    local direction = bandit:getForwardDirection()
    local angle = direction:getDirection()
    direction:setLength(8)

    local options = {}
    options[1] = {} -- pavements
    options[2] = {} -- gravel roads
    options[3] = {} -- parkings
    options[4] = {} -- main roads
    options[5] = {} -- unused

    local step = 0.785398163 / 2 -- 22.5 deg
    for i = 0, 14 do
        for j=-1, 1, 2 do
            local newangle = angle + (i * j * step)
            if newangle > 6.283185304 then newangle = newangle - 6.283185304 end
            direction:setDirection(newangle)

            local vx = bx + direction:getX()
            local vy = by + direction:getY()
            local vz = bz
            local square = cell:getGridSquare(vx, vy, vz)
            if square and square:isOutside() then
                local groundQuality = getGroundQuality(square)
                if groundQuality then
                    table.insert(options[groundQuality], {x=vx, y=vy, z=vz})
                end
            end
        end
    end

    for _, opts in pairs(options) do
        for _, opt in pairs(opts) do
            table.insert(tasks, BanditUtils.GetMoveTask(0, opt.x, opt.y, opt.z, walkType, 2, false))
            return tasks
        end
    end
    
    return tasks
end

BanditPrograms.GoSomewhere = function(bandit, walkType)
    local tasks = {}
    local bx = bandit:getX()
    local by = bandit:getY()
    local bz = bandit:getZ()
    local id = BanditUtils.GetCharacterID(bandit)

    local rnd = math.abs(id) % 4
    local dx = 0
    local dy = 0
    if rnd == 0 then
        dx = 8
    elseif rnd == 1 then
        dy = 8
    elseif rnd == 2 then
        dx = -8
    elseif rnd == 3 then
        dy = -8
    end

    local gameTime = getGameTime()
    local hour = gameTime:getHour()
    if hour % 2 == 0 then
        dx = -dx
        dy = -dy
    end

    table.insert(tasks, BanditUtils.GetMoveTask(0, bx + dx, by + dy, 0, walkType, 10, false))
    return tasks
end

BanditPrograms.Cry = function(bandit)
    local tasks = {}

    local task = {action="Cry", time=200}
    table.insert(tasks, task)

    return tasks
end

BanditPrograms.Fallback = function(bandit)
    local tasks = {}

    local anim = BanditUtils.Choice({"WipeBrow", "WipeHead"})
    local task = {action="Time", anim=anim, time=100}
    table.insert(tasks, task)

    return tasks
end