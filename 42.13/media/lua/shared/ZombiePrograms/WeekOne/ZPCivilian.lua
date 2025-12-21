ZombiePrograms = ZombiePrograms or {}

ZombiePrograms.Civilian = {}


ZombiePrograms.Civilian.Prepare = function(bandit)
    local tasks = {}

    Bandit.ForceStationary(bandit, false)

    return {status=true, next="Main", tasks=tasks}
end

ZombiePrograms.Civilian.Main = function(bandit)
    local tasks = {}
    local cell = bandit:getCell()
    local brain = BanditBrain.Get(bandit)
    local id = brain.id
    local bx = bandit:getX()
    local by = bandit:getY()
    local bz = bandit:getZ()
    local gameTime = getGameTime()
    local hour = gameTime:getHour()
    local minute = gameTime:getMinutes()

    local walkType = "Run"
    local endurance = 0
    
    local health = bandit:getHealth()
    if health < 0.8 then
        walkType = "Limp"
        endurance = 0
    end 

    if brain.rnd[1] == 1 then
        local n = math.abs(id) + hour + minute 
        if n % 3 == 0 then
            local subTasks = BanditPrograms.Symptoms(bandit)
            if #subTasks > 0 then
                for _, subTask in pairs(subTasks) do
                    table.insert(tasks, subTask)
                end

                return {status=true, next="Main", tasks=tasks}
            end
        end
    end


    if brain.rnd[2] == 1 or brain.rnd[2] == 2 then
        -- panic
        local subTasks = BanditPrograms.FollowRoad(bandit, walkType)
        if #subTasks > 0 then
            for _, subTask in pairs(subTasks) do
                table.insert(tasks, subTask)
            end
            return {status=true, next="Main", tasks=tasks}
        end
        
        -- go somewhere if no road is found
        local subTasks = BanditPrograms.GoSomewhere(bandit, walkType)
        if #subTasks > 0 then
            for _, subTask in pairs(subTasks) do
                table.insert(tasks, subTask)
            end
            return {status=true, next="Main", tasks=tasks}
        end
    elseif brain.rnd[2] == 3 then
        -- despair
        local subTasks = BanditPrograms.Cry(bandit, walkType)
        if #subTasks > 0 then
            for _, subTask in pairs(subTasks) do
                table.insert(tasks, subTask)
            end
            return {status=true, next="Main", tasks=tasks}
        end
    elseif brain.rnd[2] >= 4 then 
        -- courage
        local target, enemy = BanditUtils.GetTarget(bandit, config)

        -- engage with target
        if target.x and target.y and target.z then

            local tx, ty, tz = target.x, target.y, target.z
        
            if enemy then
                if target.fx and target.fy and (enemy:isRunning()  or enemy:isSprinting()) then
                    tx, ty = target.fx, target.fy
                end
            end

            local walkType = Bandit.GetCombatWalktype(bandit, enemy, target.dist)

            table.insert(tasks, BanditUtils.GetMoveTaskTarget(endurance, tx, ty, tz, target.id, target.player, walkType, target.dist))
            return {status=true, next="Main", tasks=tasks}
        end

    end

    -- fallback
    local subTasks = BanditPrograms.FallbackAction(bandit)
    if #subTasks > 0 then
        for _, subTask in pairs(subTasks) do
            table.insert(tasks, subTask)
        end
    end

    return {status=true, next="Main", tasks=tasks}
end
