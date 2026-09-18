ZombieActions = ZombieActions or {}

local function predicateAll(item)
    -- item:getType()
	return true
end

ZombieActions.Collect = {}
ZombieActions.Collect.onStart = function(zombie, task)
    
    task.surface = BWOUtils.GetSurfaceOffset(task.item.x, task.item.y, task.item.z)

    local anim
    if task.item.ground and task.surface < 0.2 then
        anim = "LootLow"
    else
        anim = "Loot"
    end

    task.anim = anim
    zombie:setBumpType(task.anim)

    local square = zombie:getCell():getGridSquare(task.item.x, task.item.y, task.item.z)
    if not square then return true end

    if not task.item.ground then
        local objects = square:getObjects()
        local cnt = 0
        for i=0, objects:size() - 1 do
            local object = objects:get(i)
            local container = object:getContainer()
            if container then
                local sound = container:getOpenSound()
                if sound then
                    zombie:playSound(sound)
                end
                break
            end
        end
    end

    return true
end

ZombieActions.Collect.onWorking = function(zombie, task)
    zombie:faceLocationF(task.item.x, task.item.y)
    if zombie:getBumpType() ~= task.anim then return true end
    return false
end

ZombieActions.Collect.onComplete = function(zombie, task)
    local square = zombie:getCell():getGridSquare(task.item.x, task.item.y, task.item.z)
    if not square then return true end

    local area = BWOAreas.Find(square)

    if task.item.ground then
        local wobs = square:getWorldObjects()
        local cnt = 0
        for i=0, wobs:size()-1 do
            local object = wobs:get(i)
            local item = object:getItem()
            local itemType = item:getFullType()
            if itemType == task.item.ftype then
                BWOPermaInv.Add(zombie, item)

                square:removeWorldObject(object)
                square:transmitRemoveItemFromSquare(object)
                square:RecalcProperties()
                square:RecalcAllWithNeighbours(true)

                object:removeFromWorld()
                object:removeFromSquare()
                object:setSquare(nil)

                local item = object:getItem()
                item:setWorldItem(nil)

                if area then
                    BWOItems.ShouldRescan(area.id, task.item.x, task.item.y, task.item.z)
                end
                return true
            end
        end
    else
        local objects = square:getObjects()
        local cnt = 0
        for i=0, objects:size() - 1 do
            local object = objects:get(i)
            local container = object:getContainer()
            if container then
                local items = ArrayList.new()
                container:getAllEvalRecurse(predicateAll, items)
                for i=0, items:size()-1 do
                    local item = items:get(i)
                    if item:getFullType() == task.item.ftype then
                        BWOPermaInv.Add(zombie, item)

                        container:Remove(item)
                        if BanditUtils.IsController(zombie) then
                            container:removeItemOnServer(item)
                        end

                        if not isClient() then
                            if container:getParent() and container:getParent():getOverlaySprite() then
                                ItemPicker.updateOverlaySprite(container:getParent())
                            end
                        end

                        local sound = container:getTakeSound()
                        if sound then
                            zombie:playSound(sound)
                        end

                        if area then
                            BWOItems.ShouldRescan(area.id, task.item.x, task.item.y, task.item.z)
                        end
                        return true
                    end
                end
            end
        end
    end

    if area then
        BWOItems.ShouldRescan(area.id, task.item.x, task.item.y, task.item.z)
    end    

    return true
end

