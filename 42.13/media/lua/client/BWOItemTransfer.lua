BWOItemTransfer = BWOItemTransfer or {}

BWOItemTransfer.Earn = function(player, cnt)
    local inventory = player:getInventory()
    for i=1, cnt do
        local item = BanditCompatibility.InstanceItem("Base.Money")
        inventory:AddItem(item)
    end
    player:addLineChatElement("Earn: +$" .. cnt .. ".00", 0, 1, 0)
end

BWOItemTransfer.Pay = function(player, cnt)
    local inventory = player:getInventory()

    local items = ArrayList.new()
    local remaining = cnt
    inventory:getAllEvalRecurse(BWOUtils.predicateMoney, items)
    for i=items:size()-1, 0, -1 do
        local item = items:get(i)
        inventory:Remove(item)
        if remaining <= 0 then break end
        remaining = remaining - 1
    end

    player:addLineChatElement("Pay: -$" .. cnt .. ".00", 1, 0, 0)
end

BWOItemTransfer.GetCash = function(player)
    local inventory = player:getInventory()
    local cash = inventory:getCountTypeRecurse("Base.Money")
    return cash
end

BWOItemTransfer.GetShoppingCartValue = function(player)
    local inventory = player:getInventory()

    local value = 0
    local items = ArrayList.new()
    inventory:getAllEvalRecurse(BWOUtils.predicateShopping, items)
    for i=items:size()-1, 0, -1 do
        local item = items:get(i)
        value = value + (BWOItemTransfer.GetPrice(item) or 0)
    end
    return value
end

BWOItemTransfer.PayShoppingCart = function(player)
    local inventory = player:getInventory()

    local value = 0
    local items = ArrayList.new()
    inventory:getAllEvalRecurse(BWOUtils.predicateShopping, items)
    for i=items:size()-1, 0, -1 do
        local item = items:get(i)
        local md = item:getModData()
        if md.BWO and md.BWO.shopping then
            md.BWO.shopping = false
            md.BWO.bought = true
        end
    end
    return value
end


BWOItemTransfer.SetPurchasable = function(item, price)
    local name = item:getName()
    local newName = name:gsub("^%$[%d%.]+%s*", "")
    newName = newName:gsub("%s*%([^)]*%)", "")
    item:setName("$" .. string.format("%.2f", price) .. " " .. newName)
    local md = item:getModData()
    md.BWO = md.BWO or {}
    md.BWO.shopping = true
end

BWOItemTransfer.UnsetPurchasable = function(item)
    local name = item:getName()
    local newName = name:gsub("^%$[%d%.]+%s*", "")
    newName = newName:gsub("%s*%([^)]*%)", "")
    item:setName(newName)
    local md = item:getModData()
    md.BWO = md.BWO or {}
    md.BWO.shopping = false
end

BWOItemTransfer.GetPrice = function(item)

    local foodTypeMultiplier = {
        -- General
        NoExplicit  = 1.00,

        -- Fruits & vegetables
        Fruits      = 0.85,
        Berry       = 1.20,
        Citrus      = 1.00,
        Vegetables  = 0.75,
        Vegetable   = 0.75,
        Greens      = 0.80,
        Herb        = 1.30,
        Mushroom    = 1.20,
        HotPepper   = 1.10,

        -- Grains / staples
        Bread       = 1.00,
        Rice        = 0.70,
        Pasta       = 0.75,
        Bean        = 0.70,
        Seed        = 1.20,
        Sugar       = 0.65,
        Thickener   = 0.70,

        -- Meat
        Meat        = 2.90,
        Beef        = 3.20,
        Poultry     = 2.20,
        Game        = 1.60,
        Venison     = 3.30,
        Sausage     = 1.90,
        Bacon       = 1.90,

        -- Fish / seafood
        Fish        = 2.90,
        Seafood     = 3.10,
        Roe         = 2.00,

        -- Dairy / eggs
        Milk        = 1.00,
        Cheese      = 1.50,
        Egg         = 1.10,

        -- Prepared / drink
        Juice       = 1.20,
        Coffee      = 1.30,
        Tea         = 1.20,
        Stock       = 0.80,
        Oil         = 0.70,

        -- Sweets
        Candy       = 1.50,
        Chocolate   = 1.70,
        Cocoa       = 1.40,

        -- Nuts
        Nut         = 1.70,

        -- Other
        Insect      = 0.30,

        -- Pet food
        DogFood     = 0.60,
        CatFood     = 0.70,
    }

    local weight = item:getActualWeight()
    local category = item:getCategory()
    local multiplier = 8

    if item:isItemType(ItemType.FOOD) then

        local calories = item:getCalories()
        local carbs    = item:getCarbohydrates()
        local protein  = item:getProteins()
        local fat      = item:getLipids()

        local nutrition =
            1.0
            + 0.10 * math.log(1 + calories / 100)
            + 0.25 * math.log(1 + protein / 10)
            + 0.05 * math.log(1 + fat / 10)
            + 0.02 * math.log(1 + carbs / 10)
        
        local packaging = item:isPackaged() and 1.10 or 1.0

        local foodType = item:getFoodType()
        local category = foodTypeMultiplier[foodType] or 1.0
        
        multiplier = 2.0 * category * nutrition * packaging
    elseif item:isItemType(ItemType.LITERATURE) then
        multiplier = 5
    elseif item:isItemType(ItemType.CLOTHING) then
        local fabricMultiplier = {
            Cotton = 1.00,
            Denim  = 1.15,
            Leather = 1.35,
        }
        local fabric = item:getFabricType()
        fabricMultiplier = fabricMultiplier[fabric] or 1.0

        local scratchDefense = item:getScratchDefense()
        local biteDefense   = item:getBiteDefense()
        local bulletDefense = item:getBulletDefense()
        local protectionMultiplier =
            1
            + scratchDefense * 0.01
            + biteDefense   * 0.02
            + bulletDefense * 0.05

        local insulation = item:getInsulation()
        local insulationMultiplier = 1 + insulation * 0.5

        local waterResistance = item:getWaterResistance()
        local waterMultiplier = 1 + waterResistance * 0.25

        local windResistance = item:getWindresistance()
        local windMultiplier = 1 + windResistance * 0.25

        multiplier = multiplier * fabricMultiplier * protectionMultiplier * insulationMultiplier * waterMultiplier * windMultiplier

    elseif item:isItemType(ItemType.WEAPON_PART) then
        multiplier = 130

    elseif item:isItemType(ItemType.WEAPON) and item:IsWeapon() then
        local itemType = WeaponType.getWeaponType(item)
        if itemType == WeaponType.FIREARM then
            multiplier = 226
        elseif itemType == WeaponType.HANDGUN then
            multiplier = 166
        elseif itemType == WeaponType.HEAVY then
            multiplier = 12
        elseif itemType == WeaponType.ONE_HANDED then
            multiplier = 8
        elseif itemType == WeaponType.SPEAR then
            multiplier = 8
        elseif itemType == WeaponType.TWO_HANDED then
            multiplier = 9
        elseif itemType == WeaponType.THROWING then
            multiplier = 14
        elseif itemType == WeaponType.CHAINSAW then
            multiplier = 15
        end

    elseif item:getDisplayCategory() == "Ammo" then
        multiplier = 15
    elseif item:isItemType(ItemType.RADIO) then
        multiplier = 35
        if item:getName():embodies("Premium") then
            multiplier = 56
        elseif item:getName():embodies("Antique") then
            multiplier = 4
        end

    end

    local price = weight * multiplier
    return price
end

local onTransferItem = function(data, item)
    local item = data.item
    local destContainer = data.destContainer
    local destContainerType = data.destContainer:getType()
    local destContainerParent = destContainer:getParent()
    local containerCharacter = destContainer:getCharacter()
    local player = data.character
    local cx, cy, cz = player:getX(), player:getY(), player:getZ()
    local square = player:getCurrentSquare()
    local isShopping = false

    local area = BWOAreas.Find(square)
    if area then
        isShopping = BWOAreas.IsShopping(area)
    end

    if instanceof(destContainerParent, "IsoPlayer") or instanceof(containerCharacter, "IsoPlayer") then 
        -- that means taking things

        -- shopping
        if isShopping then
            local price = BWOItemTransfer.GetPrice(item)
            BWOItemTransfer.SetPurchasable(item, price)
        end
    
    else 
        if BWORoles.checkRequirements(player, "postman") then
            BWORoles.player.postman.logic.transferToContainer(player, item, destContainer)
        elseif BWORoles.checkRequirements(player, "butcher") then
            BWORoles.player.butcher.logic.transferToContainer(player, item, destContainer)
        end

        if not isShopping then
            BWOItemTransfer.UnsetPurchasable(item)
        end

        for x = -1, 1 do
            for y = -1, 1 do
                BWOItems.ShouldRescan(area.id, cx + x, cy + y, cz)
            end
        end
    end
end

Events.OnTransferItem.Remove(onTransferItem)
Events.OnTransferItem.Add(onTransferItem)
