ZombiePrograms = ZombiePrograms or {}

ZombiePrograms.HipHop = {}

ZombiePrograms.HipHop.Prepare = function(bandit)
    local tasks = {}
    Bandit.ForceStationary(bandit, false)
    return {status=true, next="Main", tasks=tasks}
end

ZombiePrograms.HipHop.Main = function(bandit)
    local tasks = {}
    local bx, by, bz = math.floor(bandit:getX()), math.floor(bandit:getY()), math.floor(bandit:getZ())
    local brain = BanditBrain.Get(bandit)

    local subTasks = BanditPrograms.Boombox(bandit)
    if #subTasks > 0 then return {status=true, next="Main", tasks=subTasks} end

    local task = {action="Time", anim="Shrug", time=200}
    table.insert(tasks, task)

    return {status=true, next="Main", tasks=tasks}
end
