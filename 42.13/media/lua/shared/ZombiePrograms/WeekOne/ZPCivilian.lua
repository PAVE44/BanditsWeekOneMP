ZombiePrograms = ZombiePrograms or {}

ZombiePrograms.Civilian = {}


ZombiePrograms.Civilian.Prepare = function(bandit)
    local tasks = {}

    Bandit.ForceStationary(bandit, false)

    return {status=true, next="Main", tasks=tasks}
end

ZombiePrograms.Civilian.Main = function(bandit)
    local tasks = {}
    local brain = BanditBrain.Get(bandit)
    local id = brain.id
    local bx = bandit:getX()
    local by = bandit:getY()
    local bz = bandit:getZ()
    local cell = bandit:getCell()
    local square = bandit:getSquare()
    local room = square:getRoom()
    local gameTime = getGameTime()
    local hour = gameTime:getHour()
    local minute = gameTime:getMinutes()

    if room then
        local opts = {distLimit=10, charId=id}
        local seat, dist = BWOInteractables.FindClosest({"Chair", "Couch"}, {x=bx, y=by, z=bz}, opts)
        if seat then
            local line = "civ id: " .. id .. " got seat: " .. seat.x .. ", " .. seat.y .. ", " .. seat.z
            bandit:addLineChatElement(line, 0.2, 0.8, 0.1)
            local task = {action="SitInChair", anim="SitInChairTalk", x=seat.x, y=seat.y, z=seat.z, facing=seat.f, time=1000}
            local subTasks = BanditPrograms.GoAndDo(bandit, seat, task)
            if #subTasks > 0 then
                -- BWOANPC.AddThinking(bandit, getTexture(tv:getSprite():getName()):splitIcon(), "WatchTV")
                return {status=true, next="Main", tasks=subTasks}
            end
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

ZombiePrograms.Civilian.Old = function(bandit)
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


    if brain.rnd[2] <= 1 then
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
    elseif brain.rnd[2] <= 2 then
        -- despair
        local subTasks = BanditPrograms.Cry(bandit)
        if #subTasks > 0 then
            for _, subTask in pairs(subTasks) do
                table.insert(tasks, subTask)
            end
            return {status=true, next="Main", tasks=tasks}
        end
    elseif brain.rnd[2] <= 6 then
        -- hide
        local subTasks = BanditPrograms.Hide(bandit)
        if #subTasks > 0 then
            for _, subTask in pairs(subTasks) do
                table.insert(tasks, subTask)
            end
            return {status=true, next="Main", tasks=tasks}
        end
    elseif brain.rnd[2] <= 10 then 
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
