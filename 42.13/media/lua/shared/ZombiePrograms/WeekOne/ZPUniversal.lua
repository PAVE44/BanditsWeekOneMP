ZombiePrograms = ZombiePrograms or {}

ZombiePrograms.Universal = {}


ZombiePrograms.Universal.Prepare = function(bandit)
    local tasks = {}

    Bandit.ForceStationary(bandit, false)

    return {status=true, next="Main", tasks=tasks}
end

ZombiePrograms.Universal.Main = function(bandit)
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

    local walkType = "Walk"
    local endurance = 0
    local min6 = math.floor(minute / 6)

    brain.blockPathToPlayer = true

    local neighbor = BanditUtils.GetClosestCivilian(bandit)

    -- first distinction is clan based
    if brain.cid == Bandit.clanMap.Runner then

        walkType = "Run"

        -- follow the street / road
        local subTasks = BanditPrograms.FollowRoad(bandit, walkType)
        if #subTasks > 0 then
            for _, subTask in pairs(subTasks) do
                table.insert(tasks, subTask)
            end
            return {status=true, next="Main", tasks=tasks}
        end

        -- fallback if no road is found
        local subTasks = BanditPrograms.GoSomewhere(bandit, walkType)
        if #subTasks > 0 then
            for _, subTask in pairs(subTasks) do
                table.insert(tasks, subTask)
            end
            return {status=true, next="Main", tasks=tasks}
        end
    end
   
    -- go home
    if brain.residenceId then
        local rid = brain.residenceId
        if BWOBuildings.cache[rid] then
            bandit:addLineChatElement("HOME ", 0.8, 0.8, 0.1)
            local home = BWOBuildings.cache[rid]
            table.insert(tasks, BanditUtils.GetMoveTask(0, home.x, home.y, 0, "Run", 100, false))
            return {status=true, next="Main", tasks=tasks}
        end
    end

    -- second distinction level for generic outfits
    local rnd = brain.rnd[3] + min6

    if rnd > 65 then
        bandit:addLineChatElement("SHOP " .. rnd, 0.8, 0.8, 0.1)
        local shopshelf = BWOInteractables.Find(bandit, "shopshelf", 400, true)
        if shopshelf then
            local square = getCell():getGridSquare(shopshelf.x, shopshelf.y, shopshelf.z)
            if square then
                local asquare = AdjacentFreeTileFinder.Find(square, bandit)
                if asquare then
                    local dist = math.sqrt(shopshelf.dsq)
                    if dist > 1.8 then
                        table.insert(tasks, BanditUtils.GetMoveTask(0, asquare:getX(), asquare:getY(), asquare:getZ(), "Run", dist, false))
                        return {status=true, next="Main", tasks=tasks}
                    else
                        local anim
                        local task = {action="LootItems", anim="Loot", x=shopshelf.x, y=shopshelf.y, z=shopshelf.z,  time=200}
                        table.insert(tasks, task)
                    end
                end
            end
        end

    elseif rnd > 50 then
        bandit:addLineChatElement("TRASH " .. rnd, 0.8, 0.8, 0.1)
        local trashcan = BWOInteractables.Find(bandit, "trashcan", 400, true)
        if trashcan then
            local square = getCell():getGridSquare(trashcan.x, trashcan.y, trashcan.z)
            if square then
                local asquare = AdjacentFreeTileFinder.Find(square, bandit)
                if asquare then
                    local dist = math.sqrt(trashcan.dsq)
                    if dist > 1.8 then
                        table.insert(tasks, BanditUtils.GetMoveTask(0, asquare:getX(), asquare:getY(), asquare:getZ(), "Walk", dist, false))
                        return {status=true, next="Main", tasks=tasks}
                    else
                        local anim
                        local task = {action="LootItems", anim="Loot", x=trashcan.x, y=trashcan.y, z=trashcan.z,  time=200}
                        table.insert(tasks, task)
                    end
                end
            end
        end

    elseif rnd > 30 then
        bandit:addLineChatElement("SITTABLE " .. rnd, 0.8, 0.8, 0.1)
        local sittable = BWOInteractables.Find(bandit, "sittable", 400, false)
        if sittable then
            local square = getCell():getGridSquare(sittable.x, sittable.y, sittable.z)
            if square then
                local asquare = AdjacentFreeTileFinder.Find(square, bandit)
                if asquare then
                    local dist = math.sqrt(sittable.dsq)
                    if dist > 1.8 then
                        table.insert(tasks, BanditUtils.GetMoveTask(0, asquare:getX(), asquare:getY(), asquare:getZ(), "Walk", dist, false))
                        return {status=true, next="Main", tasks=tasks}
                    else
                        local anim
                        local sound
                        local item
                        local smoke = false
                        local time = 200
                        local right = false
                        local left = false
                        local r = ZombRand(7)
                        if r == 0 then
                            anim = "SitInChair1"
                        elseif r == 1 then
                            anim = "SitInChair2"
                        elseif r == 2 then
                            anim = "SitInChairTalk"
                        elseif r == 3 then
                            anim = "SitInChairDrink"
                            item = "Bandits.BeerBottle"
                            sound = "DrinkingFromBottle"
                            right = true
                        elseif r == 4 then
                            anim = "SitInChairEat"
                            right = true
                        elseif r == 5 then
                            anim = "SitInChairSmoke"
                            sound = "Smoke"
                            smoke = true
                            time = 400
                        elseif r == 6 then
                            anim = "SitInChairRead"
                            sound = "PageFlipBook"
                            item = "Bandits.Book"
                            left = true
                            time = 600
                        end

                        local facing = sittable.f

                        local task = {action="SitInChair", anim=anim, left=left, right=right, sound=sound, item=item, x=sittable.x, y=sittable.y, z=sittable.z, facing=facing, time=200}
                        table.insert(tasks, task)
                        return {status=true, next="Main", tasks=tasks}
                    end
                end
            end
        end
    elseif rnd > 15 then
        -- idle
        bandit:addLineChatElement("IDLE " .. rnd, 0.8, 0.8, 0.1)
        local subTasks = BanditPrograms.FallbackAction(bandit)
        if #subTasks > 0 then
            for _, subTask in pairs(subTasks) do
                table.insert(tasks, subTask)
            end
        end
    end

    if (rnd + minute) % 2 == 0 and neighbor then
        local task = {action="Talk", line="Whatever", anim="Gest1", x=neighbor:getX(), y=neighbor:getY(), time = 200}
        table.insert(tasks, task)
        return {status=true, next="Main", tasks=tasks}
    end

    bandit:addLineChatElement("WALK " .. rnd, 0.8, 0.8, 0.1)
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

    

    return {status=true, next="Main", tasks=tasks}
end
