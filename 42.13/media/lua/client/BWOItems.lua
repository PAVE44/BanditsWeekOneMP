BWOItems = BWOItems or {}

BWOItems.dirty = {}

local function getId(object)
    return object:getX() .. ":" .. object:getY() .. ":" .. object:getZ()
end

BWOItems.ShouldRescan = function(areaid, x, y, z)
    local id = x .. ":" .. y .. ":" .. z
    BWOItems.dirty[id] = {areaid = areaid, x = x, y = y, z = z}
end

BWOItems.Find = function(workArea, ingredient)
    if not workArea.items then
        return nil
    end
    for gridid, itemStack in pairs(workArea.items) do
        for itemType, itemData in pairs(itemStack) do
            if itemType == ingredient then
                return itemData
            end
        end
    end
    return nil
end



local function analyze(square)

    local found = {}

    local hasAccessSquare = BanditUtils.HasAccessSquare(square)
    if not hasAccessSquare then 
        return
    end

    local predicateAll = BWOUtils.predicateAll
    local x, y, z = square:getX(), square:getY(), square:getZ()

    local objects = square:getObjects()
    for i=0, objects:size()-1 do
        local object = objects:get(i)
        local container = object:getContainer()
        if container and not container:isEmpty() then
            local items = ArrayList.new()
            container:getAllEval(predicateAll, items)
            for i=0, items:size()-1 do
                local item = items:get(i)
                local ftype = item:getFullType()
                local bag = item:IsInventoryContainer() 
                local class = BWOUtils.GetItemClass(item)
                
                local cooked, hot
                local blood, dirty, wet, holes
                if item:isFood() then
                    cooked = item:isCooked()
                    hot = item:getInvHeat() > 0.5
                elseif item:IsClothing() then
                    blood = item:getBloodLevel()
                    dirty = item:getDirtiness()
                    wet = item:getWetness()
                    holes = item:getHolesNumber()
                end

                if found[ftype] then
                    found[ftype].cnt = found[ftype].cnt + 1
                else
                    found[ftype] = {
                        x = x,
                        y = y,
                        z = z,
                        class = class,
                        ftype = ftype,
                        cooked = cooked,
                        hot = hot,
                        blood = blood,
                        dirty = dirty,
                        wet = wet,
                        holes = holes,
                        bag = bag,
                        cnt = 1,
                        cont = customName
                    }
                end
            end
        end
    end

    local wobs = square:getWorldObjects()
    for i = 0, wobs:size()-1 do
        local o = wobs:get(i)
        local item = o:getItem()
        local ftype = item:getFullType()
        local bag = item:IsInventoryContainer() 
        local class = BWOUtils.GetItemClass(item)

        local cooked, hot
        local blood, dirty, wet, holes
        if item:isFood() then
            cooked = item:isCooked()
            hot = item:getInvHeat() > 0.5
        elseif item:IsClothing() then
            blood = item:getBloodLevel()
            dirty = item:getDirtiness()
            wet = item:getWetness()
            holes = item:getHolesNumber()
        end

        if found[ftype] then
            found[ftype].cnt = found[ftype].cnt + 1
        else
            found[ftype] = {
                x = x,
                y = y,
                z = z,
                class = class,
                ftype = ftype,
                ground = true,
                cooked = cooked,
                hot = hot,
                blood = blood,
                dirty = dirty,
                holes = holes,
                wet = wet,
                bag = bag,
                cnt = 1
            }
        end
    end
    return found
end

local function onTick()
    local i = 0
    local dirty = BWOItems.dirty

    local i=0
    for id, coords in pairs(BWOItems.dirty) do
        i = i + 1
    end
    -- print("Total dirty items: " .. i)

    i = 0
    local done = {}
    for id, coords in pairs(BWOItems.dirty) do
        if coords then
            local square = getCell():getGridSquare(coords.x, coords.y, coords.z)
            if square then
                local area = BWOAreas.Get(coords.areaid)
                if area then
                    -- Handle the area-specific logic for the dirty item here
                    local items = analyze(square)
                    if items then
                        if not area.items then 
                            area.items = {}
                        end
                        
                        local oid = getId(square)
                        area.items[oid] = nil
                        for k, v in pairs(items) do
                            if not area.items[oid] then
                                area.items[oid] = {}
                            end
                            area.items[oid][k] = v
                        end
                    end
                end
            end
            table.insert(done, id)
        end
        if i>10 then break end
    end
    for _, id in ipairs(done) do
        BWOItems.dirty[id] = nil
    end
    -- print("Processed " .. #done .. " dirty items")
end


Events.OnTick.Remove(onTick)
Events.OnTick.Add(onTick)