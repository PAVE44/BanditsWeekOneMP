ZombieActions = ZombieActions or {}

ZombieActions.Cry = {}
ZombieActions.Cry.onStart = function(zombie, task)
    task.anim = "Cry" .. tostring(1 + ZombRand(3))
    zombie:setBumpType(task.anim)
    local emitter = zombie:getEmitter()
    if zombie:isFemale() then
        if not emitter:isPlaying("FemaleDespair") then
            emitter:playSound("FemaleDespair")
        end
    else
        if not emitter:isPlaying("MaleDespair") then
            emitter:playSound("MaleDespair")
        end
    end

    local lines = {
        "No!",
        "This can't be true!",
        "I can't take it anymore!",
        "We are doomed!",
        "Please, I want this over!",
        "God! Help me please!",
    }

    -- i almost cried myself when i coded this...
    local line = BanditUtils.Choice(lines)
    zombie:addLineChatElement(line, 0.2, 0.8, 0.1)

    return true
end

ZombieActions.Cry.onWorking = function(zombie, task)
    if zombie:getBumpType() ~= task.anim then return true end
    return false
end

ZombieActions.Cry.onComplete = function(zombie, task)
    -- local emitter = zombie:getEmitter()
    -- emitter:stopSoundByName("EmmaCry")
    return true
end