ZombieActions = ZombieActions or {}

local function predicateAll(item)
    -- item:getType()
	return true
end

ZombieActions.Craft = {}
ZombieActions.Craft.onStart = function(zombie, task)
    if task.craftData.anim then
        zombie:setBumpType(task.craftData.anim)
    end
    return true
end

ZombieActions.Craft.onWorking = function(zombie, task)
    if task.surface then
        zombie:faceLocationF(task.surface.x, task.surface.y)
    end

    local bumpType = zombie:getBumpType()
    if bumpType ~= task.craftData.anim then
        zombie:setBumpType(task.craftData.anim)
    end

    return false
end

ZombieActions.Craft.onComplete = function(zombie, task)
    if task.craftData then
        local ingredients = task.craftData.ingredients
        local output = task.craftData.output
        local cnt = task.craftData.count
        local inv = BWOPermaInv.GetAll(zombie)
        BWOPermaInv.Craft(zombie, ingredients, output, cnt)
        local inv2 = BWOPermaInv.GetAll(zombie)
    end

    return true
end

