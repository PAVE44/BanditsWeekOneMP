ZombiePrograms = ZombiePrograms or {}

ZombiePrograms.Resident = {}

local NODE_REACHED_DISTANCE = 1.4

ZombiePrograms.Resident.Prepare = function(bandit)
    local tasks = {}
    Bandit.ForceStationary(bandit, false)
    return {status=true, next="Main", tasks=tasks}
end

ZombiePrograms.Resident.Main = function(bandit)
    local tasks = {}
    local bx, by, bz = math.floor(bandit:getX()), math.floor(bandit:getY()), math.floor(bandit:getZ())
    local brain = BanditBrain.Get(bandit)
    local occupation = brain.occupation

    
    bandit:setVariable("WalkSpeed", 0.71)

    -- WORK ACTIVITIES
    if occupation and occupation.wid then

        local wid = occupation.wid
        local workArea = BWOAreas.Get(wid)
        if workArea then

            local areaMargin = 3 
            if bx >= workArea.x - areaMargin and bx <= workArea.x2 + areaMargin and
               by >= workArea.y - areaMargin and by <= workArea.y2 + areaMargin then
                 -- work
                bandit:addLineChatElement(occupation.role .. " " .. "working", 0.2, 0.8, 0.1)
                
                if occupation.role == "cashier" then
                    local subTasks = BanditPrograms.WorkArea.Cashier(bandit, workArea)
                    if #subTasks > 0 then return {status=true, next="Main", tasks=subTasks} end
                elseif occupation.role == "cook" then
                    local subTasks = BanditPrograms.WorkArea.Cook(bandit, workArea)
                    if #subTasks > 0 then return {status=true, next="Main", tasks=subTasks} end
                elseif occupation.role == "police" then
                    local subTasks = BanditPrograms.WorkArea.Police(bandit, workArea)
                    if #subTasks > 0 then return {status=true, next="Main", tasks=subTasks} end
                end

            else
                -- commute to work
                if workArea.exits then
                    local target = {}
                    local bestDist = math.huge
                    for _, exit in ipairs(workArea.exits) do
                        local dist = BanditUtils.DistTo(bx, by, exit.x, exit.y)
                        if dist < bestDist then
                            bestDist = dist
                            target = exit
                        end
                    end

                    if target.x and target.y then
                        local moveTask = BWOUtils.GetMoveTaskNav(bandit, target.x, target.y, bz, {
                            directDistance = 6,
                            reachedDistance = NODE_REACHED_DISTANCE,
                            stopDistance = 1,
                            moveType = "Walk",
                        })
                        if moveTask then
                            bandit:addLineChatElement(occupation.role .. "->" .. workArea.type, 0.2, 0.8, 0.1)
                            table.insert(tasks, moveTask)
                            return {status=true, next="Main", tasks=tasks}
                        end
                    end
                end
            end
        end
    end

    local task = {action="Time", anim="Shrug", time=200}
    table.insert(tasks, task)

    return {status=true, next="Main", tasks=tasks}
end
