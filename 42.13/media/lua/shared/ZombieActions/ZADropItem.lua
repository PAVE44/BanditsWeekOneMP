ZombieActions = ZombieActions or {}

ZombieActions.DropItem = {}
ZombieActions.DropItem.onStart = function(zombie, task)
    
    local hasItem = BWOPermaInv.HasType(zombie, task.item.fullType)
    if not hasItem then return true end

    task.surface = BWOUtils.GetSurfaceOffset(task.x, task.y, task.z)

    local anim
    if task.surface > 0.3 then
        anim = "Give"
    else
        anim = "LootLow"
    end

    task.anim = anim
    zombie:setBumpType(task.anim)

    return true
end

ZombieActions.DropItem.onWorking = function(zombie, task)
    zombie:faceLocationF(task.x, task.y)
    if zombie:getBumpType() ~= task.anim then return true end
    return false
end

ZombieActions.DropItem.onComplete = function(zombie, task)
    local square = zombie:getCell():getGridSquare(task.x, task.y, task.z)
    if not square then return true end

    local hasItem = BWOPermaInv.HasType(zombie, task.item.fullType)
    if not hasItem then return true end

    local item = BanditCompatibility.InstanceItem(task.item.fullType)
    if task.item.weight then
        item:setActualWeight(task.item.weight)
    end
    if task.item.calories then
        item:setCalories(task.item.calories)
    end
    if task.item.lipids then
        item:setLipids(task.item.lipids)
    end
    if task.item.proteins then
        item:setProteins(task.item.proteins)
    end
    if task.item.carbohydrates then
        item:setCarbohydrates(task.item.carbohydrates)
    end
    if task.item.hungerChange then
        item:setHungChange(task.item.hungerChange)
    end
    if task.item.baseHunger then
        item:setBaseHunger(task.item.baseHunger)
    end
    if task.item.thirstChange then
        item:setThirstChange(task.item.thirstChange)
    end
    if task.item.unhappyChange then
        item:setUnhappyChange(task.item.unhappyChange)
    end
    if task.item.boredomChange then
        item:setBoredomChange(task.item.boredomChange)
    end
    if task.item.extraItems then
        for i, extraItem in ipairs(task.item.extraItems) do
            item:addExtraItem(extraItem)
        end
        item:setIsCookable(true)
    end
    if task.item.cooked then
        item:setCooked(true)
        item:setHeat(2.5)
    end
    if task.item.dirty then
        item:setDirtiness(task.item.dirty)
    end
    if task.item.blood then
        item:setBloodLevel(task.item.blood)
    end
    if task.item.wet then
        item:setWetness(task.item.wet)
    end

    square:AddWorldInventoryItem(item, ZombRandFloat(task.xmin, task.xmax), ZombRandFloat(task.ymin, task.ymax), task.surface)
    BWOItems.ShouldRescan(task.areaid, task.x, task.y, task.z)
    BWOPermaInv.RemoveOneOfType(zombie, task.item.fullType)

    local sound = item:getDropSound()
    if sound then
        zombie:playSound(sound)
    end
    return true
end

