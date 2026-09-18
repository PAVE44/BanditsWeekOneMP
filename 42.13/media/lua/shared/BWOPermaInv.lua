BWOPermaInv = BWOPermaInv or {}

local function sync(bandit, permaInv)
    local syncData = {}
    local brain = BanditBrain.Get(bandit)
    syncData.id = brain.id
    syncData.permaInv = permaInv
    Bandit.ForceSyncPart(bandit, syncData)
end

local function add(brain, item, cnt)
    brain.permaInv = brain.permaInv or {}

    local itemConf = {}
    itemConf.fullType = item:getFullType()
    itemConf.size = 1
    itemConf.cooked = item:isCooked()
    itemConf.weight = item:getActualWeight()
    itemConf.class = BWOUtils.GetItemClass(item)

    if itemConf.class == "food" then
        itemConf.hc = math.floor(item:getHungerChange() * 100)
        itemConf.calories = item:getCalories()
        itemConf.lipids = item:getLipids()
        itemConf.proteins = item:getProteins()
        itemConf.carbohydrates = item:getCarbohydrates()
        itemConf.hungerChange = item:getHungChange()
        itemConf.baseHunger = item:getBaseHunger()
        itemConf.thirstChange = item:getThirstChange()
        itemConf.unhappyChange = item:getUnhappyChange()
        itemConf.boredomChange = item:getBoredomChange()
        local extraItems = item:getExtraItems()
        itemConf.extraItems = {}
        for i=0, extraItems:size()-1 do
            local extraItem = extraItems:get(i)
            table.insert(itemConf.extraItems, extraItem)
        end

    elseif itemConf.class == "drink" then
        itemConf.tc = 100
    elseif itemConf.class == "media" then
        itemConf.mid = item:getMediaData():getId()
    elseif itemConf.class == "clothing" then
        itemConf.dirty = item:getDirtiness()
        itemConf.blood = item:getBloodLevel()
        itemConf.wet = item:getWetness()
    end

    for i = 1, cnt do
        table.insert(brain.permaInv, itemConf)
    end
end

local function removeOneOfType(brain, itemFullType)
    for i, itemConf in pairs(brain.permaInv) do
        if itemConf.fullType == itemFullType then
            table.remove(brain.permaInv, i)
            return
        end
    end
end

local function use(brain, itemFullType, use)
    for i, itemConf in pairs(brain.permaInv) do
        if itemConf.fullType == itemFullType then
            if not itemConf.size then itemConf.size = 1 end
            itemConf.size = itemConf.size - use
            if itemConf.size <= 0 then
                table.remove(brain.permaInv, i)
                sync(bandit, brain.permaInv)
                return
            else
                if itemConf.hc then itemConf.hc = math.floor(itemConf.hc * itemConf.size) end
                if itemConf.weight then itemConf.weight = math.floor(itemConf.weight * itemConf.size) end
                if itemConf.calories then itemConf.calories = math.floor(itemConf.calories * itemConf.size) end
                if itemConf.lipids then itemConf.lipids = math.floor(itemConf.lipids * itemConf.size) end
                if itemConf.proteins then itemConf.proteins = math.floor(itemConf.proteins * itemConf.size) end
                if itemConf.carbohydrates then itemConf.carbohydrates = math.floor(itemConf.carbohydrates * itemConf.size) end
                if itemConf.hungerChange then itemConf.hungerChange = math.floor(itemConf.hungerChange * itemConf.size) end
                if itemConf.baseHunger then itemConf.baseHunger = math.floor(itemConf.baseHunger * itemConf.size) end
                if itemConf.thirstChange then itemConf.thirstChange = math.floor(itemConf.thirstChange * itemConf.size) end
                if itemConf.unhappyChange then itemConf.unhappyChange = math.floor(itemConf.unhappyChange * itemConf.size) end
                if itemConf.boredomChange then itemConf.boredomChange = math.floor(itemConf.boredomChange * itemConf.size) end
                sync(bandit, brain.permaInv)
                return
            end
        end
    end
end

-- setters

BWOPermaInv.Add = function (bandit, item, cnt)
    local brain = BanditBrain.Get(bandit)
    if not brain then return end
    if not cnt then cnt = 1 end
    add(brain, item, cnt)
    sync(bandit, brain.permaInv)
end

BWOPermaInv.RemoveOneOfType = function (bandit, itemFullType)
    local brain = BanditBrain.Get(bandit)
    if not brain or not brain.permaInv then return end

    removeOneOfType(brain, itemFullType)
    sync(bandit, brain.permaInv)
end

BWOPermaInv.Craft = function (bandit, ingredients, output, cnt)
    local brain = BanditBrain.Get(bandit)
    if not brain or not brain.permaInv then return end
    if not cnt then cnt = 1 end

    for _, ingredient in ipairs(ingredients) do
        removeOneOfType(brain, ingredient)
    end
    local item = BanditCompatibility.InstanceItem(output)
    
    add(brain, item, cnt)
    sync(bandit, brain.permaInv)
end

BWOPermaInv.Use = function (bandit, itemFullType, use)
    local brain = BanditBrain.Get(bandit)
    if not brain or not brain.permaInv then return end

    use(brain, itemFullType, use)
    sync(bandit, brain.permaInv)
end

-- getters

BWOPermaInv.GetAll = function (bandit)
    local brain = BanditBrain.Get(bandit)
    if not brain or not brain.permaInv then return {} end

    return brain.permaInv
end

BWOPermaInv.Get = function (bandit, predicate)
    local brain = BanditBrain.Get(bandit)
    if not brain or not brain.permaInv then return nil end

    for i, itemConf in pairs(brain.permaInv) do
        if not predicate or predicate(itemConf) then
            return itemConf
        end
    end

    return nil
end

BWOPermaInv.Has = function (bandit, cntExpected, predicate)
    local brain = BanditBrain.Get(bandit)
    if not brain or not brain.permaInv then return false end
    if not cntExpected then cntExpected = 1 end

    local cnt = 0
    for _, itemConf in pairs(brain.permaInv) do
        if not predicate or predicate(itemConf) then
            cnt = cnt + 1
            if cnt >= cntExpected then
                return true
            end
        end
    end

    return false
end

BWOPermaInv.GetType = function (bandit, itemFullType, predicate)
    local brain = BanditBrain.Get(bandit)
    if not brain or not brain.permaInv then return nil end

    for i, itemConf in pairs(brain.permaInv) do
        if itemConf.fullType == itemFullType and (not predicate or predicate(itemConf)) then
            return itemConf
        end
    end

    return nil
end

BWOPermaInv.HasType = function (bandit, itemFullType, cntExpected, predicate)
    local brain = BanditBrain.Get(bandit)
    if not brain or not brain.permaInv then return false end
    if not cntExpected then cntExpected = 1 end

    local cnt = 0
    for _, itemConf in pairs(brain.permaInv) do
        if itemConf.fullType == itemFullType and (not predicate or predicate(itemConf)) then
            cnt = cnt + 1
            if cnt >= cntExpected then
                return true
            end
        end
    end

    return false
end

BWOPermaInv.GetClass = function (bandit, class)
    local brain = BanditBrain.Get(bandit)
    if not brain or not brain.permaInv then return false end

    for _, itemConf in pairs(brain.permaInv) do
        local item = BanditCompatibility.InstanceItem(itemConf.fullType)
        if item then
            local itemClass = BWOUtils.GetItemClass(item)
            if itemClass == class then
                return itemConf
            end
        end
    end
end

BWOPermaInv.HasClass = function (bandit, class)
    local brain = BanditBrain.Get(bandit)
    if not brain or not brain.permaInv then return false end

    for _, itemConf in pairs(brain.permaInv) do
        local item = BanditCompatibility.InstanceItem(itemConf.fullType)
        if item then
            local itemClass = BWOUtils.GetItemClass(item)
            if itemClass == class then
                return true
            end
        end
    end

    return false
end


