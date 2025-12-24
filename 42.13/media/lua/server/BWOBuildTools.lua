BWOBuildTools = BWOBuildTools or {}

local function GetOrCreateSquare(x, y, z)
    local cell = getCell()
    local square = cell:getGridSquare(x, y, z)
    if square == nil and getWorld():isValidSquare(x, y, z) then
        square = cell:createNewGridSquare(x, y, z, true)
    end
    return square
end

function BWOBuildTools.IsoObject (sprite, x, y, z)
    local square = GetOrCreateSquare(x, y, z)
    if not square then return end
    -- if not square:isFree(false) then return end
    local obj = IsoObject.new(square, sprite, "")
    square:AddSpecialObject(obj)
    obj:transmitCompleteItemToClients()
end

function BWOBuildTools.IsoDoor (sprite, x, y, z, north)
    local cell = getCell()
    local square = GetOrCreateSquare(x, y, z)
    if not square then return end
    
    for s, number in string.gmatch(sprite, "(.+)_(%d+)") do

        if not north then
            north = true
            if (number % 2 == 0) then
                north = false
            end
        end

        obj = IsoDoor.new(cell, square, sprite, north)
        square:AddSpecialObject(obj)
        obj:transmitCompleteItemToClients()
    end
end

function BWOBuildTools.IsoWindow (sprite, x, y, z)
    local cell = getCell()
    local square = GetOrCreateSquare(x, y, z)
    if not square then return end

    for s, number in string.gmatch(sprite, "(.+)_(%d+)") do
        local north = true
        if (number % 2 == 0) then
            north = false
        end

        obj = IsoWindow.new(cell, square, getSprite(sprite), north)
        obj:setIsLocked(true)
        square:AddSpecialObject(obj)
        obj:transmitCompleteItemToClients()

        local b = 1 + ZombRand(4)
        local barricade = IsoBarricade.AddBarricadeToObject(obj, true)
        if barricade then
            if b == 1 then
                local metal = BanditCompatibility.InstanceItem("Base.SheetMetal")
                metal:setCondition(100)
                barricade:addMetal(nil, metal)
                barricade:transmitCompleteItemToClients()
            elseif b == 2 then
                local metal = BanditCompatibility.InstanceItem("Base.MetalBar")
                metal:setCondition(100)
                barricade:addMetalBar(nil, metal)
                barricade:transmitCompleteItemToClients()
            elseif b == 3 then
                local plank = BanditCompatibility.InstanceItem("Base.Plank")
                plank:setCondition(100)
                barricade:addPlank(nil, plank)
                if barricade:getNumPlanks() == 1 then
                    barricade:transmitCompleteItemToClients()
                else
                    barricade:sendObjectChange('state')
                end
            end
        end
    end
end