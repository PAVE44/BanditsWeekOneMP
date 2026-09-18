ZombiePrograms = ZombiePrograms or {}

ZombiePrograms.Homeless = {}

ZombiePrograms.Homeless.Prepare = function(bandit)
    local tasks = {}
    Bandit.ForceStationary(bandit, false)
    return {status=true, next="Main", tasks=tasks}
end

ZombiePrograms.Homeless.Main = function(bandit)
    local tasks = {}
    local bx, by, bz = math.floor(bandit:getX()), math.floor(bandit:getY()), math.floor(bandit:getZ())
    local brain = BanditBrain.Get(bandit)

    if not brain.homeless then
        BanditUtils.MakeHomeless(bandit)
        brain.homeless = true
    end

    local subTasks = BanditPrograms.MetalDrum(bandit)
    if #subTasks > 0 then return {status=true, next="Main", tasks=subTasks} end

    local task = {action="Time", anim="Shrug", time=200}
    table.insert(tasks, task)

    return {status=true, next="Main", tasks=tasks}
end
