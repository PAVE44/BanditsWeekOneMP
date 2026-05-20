ZombieActions = ZombieActions or {}

ZombieActions.Talk = {}
ZombieActions.Talk.onStart = function(zombie, task)
    zombie:setBumpType(task.anim)
    zombie:addLineChatElement(task.line, 0.2, 0.8, 0.1)
    return true
end

ZombieActions.Talk.onWorking = function(zombie, task)
    zombie:faceLocationF(task.x, task.y)
    if zombie:getBumpType() ~= task.anim then return true end
    return false
end

ZombieActions.Talk.onComplete = function(zombie, task)
    return true
end