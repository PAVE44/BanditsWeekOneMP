ZombieActions = ZombieActions or {}

ZombieActions.Transform = {}
ZombieActions.Transform.onStart = function(zombie, task)
    
    zombie:setBumpType("Transform")
    return true
end

ZombieActions.Transform.onWorking = function(zombie, task)
  
    if task.time <= 0 then
       return true
    end
    return false

end

ZombieActions.Transform.onComplete = function(zombie, task)
    local brain = BanditBrain.Get(zombie)
    Bandit.ApplyClothing(zombie, brain)
    Bandit.ApplyAttachments(zombie, brain)

    local syncData = {}
    syncData.id = brain.id
    syncData.clothing = brain.clothing
    syncData.weapons = brain.weapons
    Bandit.ForceSyncPart(zombie, syncData)

    return true
end