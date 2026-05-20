BWOMap = BWOMap or {}

-- table for objects to be added to the map
BWOMap.map = {}

-- populating tables
local addBarricadeNorth = function(x1, x2, y)
    for x=x1, x2 do
        local z = 0
        local id 
        local sprite1
        local sprite2
        
        id = x .. "-" .. y .. "-" .. z
        if x % 2 == 0 then
            sprite1 = "fencing_01_88"
        else
            sprite1 = "fencing_01_89"
        end
        BWOMap.map[id] = {}
        table.insert(BWOMap.map[id], sprite1)

        id = x .. "-" .. (y - 1) .. "-" .. z
        if x % 3 == 0 then
            sprite2 = "fencing_01_96"
        else
            sprite2 = "carpentry_02_13"
        end
        BWOMap.map[id] = {}
        table.insert(BWOMap.map[id], sprite2)
    end
end

local addBarricadeSouth = function(x1, x2, y)
    for x=x1, x2 do
        local z = 0
        local id 
        local sprite1
        local sprite2
    
        id = x .. "-" .. y .. "-" .. z
        if x % 2 == 0 then
            sprite1 = "fencing_01_88"
        else
            sprite1 = "fencing_01_89"
        end
    
        if x % 3 == 0 then
            sprite2 = "fencing_01_96"
        else
            sprite2 = "carpentry_02_13"
        end
        BWOMap.map[id] = {}
        table.insert(BWOMap.map[id], sprite1)
        table.insert(BWOMap.map[id], sprite2)
    end
end

local addBarricadeWest = function(y1, y2, x)
    for y=y1, y2 do
        local z = 0
        local id 
        local sprite
        
        id = x .. "-" .. y .. "-" .. z
        if y % 2 == 0 then
            sprite = "fencing_01_90"
        else
            sprite = "fencing_01_91"
        end
        BWOMap.map[id] = {}
        table.insert(BWOMap.map[id], sprite)
    
        id = (x - 1) .. "-" .. y .. "-" .. z
        if y % 3 == 0 then
            sprite = "fencing_01_96"
        else
            sprite = "carpentry_02_12"
        end
        BWOMap.map[id] = {}
        table.insert(BWOMap.map[id], sprite)
    end
end

local addBarricadeEast = function(y1, y2, x)
    for y=y1, y2 do
        local z = 0
        local id 
        local sprite1
        local sprite2
    
        id = x .. "-" .. y .. "-" .. z
        if y % 2 == 0 then
            sprite1 = "fencing_01_90"
        else
            sprite1 = "fencing_01_91"
        end

        if y % 3 == 0 then
            sprite2 = "fencing_01_96"
        else
            sprite2 = "carpentry_02_12"
        end
        BWOMap.map[id] = {}
        table.insert(BWOMap.map[id], sprite1)
        table.insert(BWOMap.map[id], sprite2)
    end
end

local clearObjects = function(square)
    local objects = square:getObjects()
    local destroyList = {}
    local legalSprites = {}
    table.insert(legalSprites, "fencing_01_88")
    table.insert(legalSprites, "fencing_01_90")
    table.insert(legalSprites, "fencing_01_90")
    table.insert(legalSprites, "fencing_01_91")
    table.insert(legalSprites, "carpentry_02_13")
    table.insert(legalSprites, "carpentry_02_12")
    table.insert(legalSprites, "fencing_01_96")

    for i=0, objects:size()-1 do
        local object = objects:get(i)
        if object then
            local sprite = object:getSprite()
            if sprite then 
                local spriteName = sprite:getName()
                local spriteProps = sprite:getProperties()

                local isSolidFloor = spriteProps:has(IsoFlagType.solidfloor)
                local isAttachedFloor = spriteProps:has(IsoFlagType.attachedFloor)

                isLegalSprite = false
                --[[
                for _, sp in pairs(legalSprites) do
                    if sp == spriteName then
                        isLegalSprite = true
                        break
                    end
                end
                ]]

                if not isSolidFloor and not isLegalSprite then
                    table.insert(destroyList, object)
                end
            end
        end
    end

    for k, obj in pairs(destroyList) do
        if isClient() then
            sledgeDestroy(obj);
        else
            square:transmitRemoveItemFromSquare(obj)
        end
        square:RecalcProperties()
        square:RecalcAllWithNeighbours(true)
        square:setSquareChanged()
    end
end

local addObject = function(square, objectList)
    for _, sprite in pairs(objectList) do
        local obj = IsoObject.new(square, sprite, "")
        square:AddSpecialObject(obj)
        obj:transmitCompleteItemToServer()
        print ("added")
    end
end

addBarricadeEast(6718, 7171, 12175)
addBarricadeSouth(10872, 12174, 7172)
addBarricadeWest(6591, 7171, 10872)

local processSquare = function(square)
    local map = BWOMap.map

    local x, y, z, md = square:getX(), square:getY(), square:getZ(), square:getModData()
    if not md.BWO then md.BWO = {} end

    local id = x .. "-" .. y .. "-" .. z

    if not md.BWO.omod then
         -- spawn map objects
        if map[id] then
            clearObjects(square)
            addObject(square, map[id])
            BWOMap.map[id] = nil
        end
    end
end

Events.LoadGridsquare.Add(processSquare)
