BWOMap = BWOMap or {}

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
    table.insert(legalSprites, "location_community_park_01_44")

    for i=0, objects:size()-1 do
        local object = objects:get(i)
        if object then
            local sprite = object:getSprite()
            if sprite then 
                local spriteName = sprite:getName()
                local spriteProps = sprite:getProperties()

                local isSolidFloor = spriteProps:has(IsoFlagType.solidfloor)
                local isAttachedFloor = spriteProps:has(IsoFlagType.attachedFloor)
                local isWall = object:isWall()

                isLegalSprite = false
                --[[
                for _, sp in pairs(legalSprites) do
                    if sp == spriteName then
                        isLegalSprite = true
                        break
                    end
                end
                ]]

                if not isSolidFloor and not isLegalSprite and not isWall then
                    table.insert(destroyList, object)
                end
            end
        end
    end

    for k, obj in pairs(destroyList) do
        square:transmitRemoveItemFromSquare(obj)
        square:RecalcProperties()
        square:RecalcAllWithNeighbours(true)
        square:setSquareChanged()
    end
end

local addObject = function(square, objectList)
    for _, sprite in pairs(objectList) do
        local obj = IsoObject.new(square, sprite, "")
        square:AddSpecialObject(obj)
        obj:transmitCompleteItemToClients()
    end
    -- print ("[BWO] Added " .. #objectList .. " objects to square " .. square:getX() .. ", " .. square:getY() .. ", " .. square:getZ())
end

local addFire = function(square, objectList)
    for _, sprite in pairs(objectList) do
        local obj = IsoFireplace.new(getCell(), square, getSprite(sprite))
        square:AddSpecialObject(obj)
        obj:addFuel(100)
        obj:setLit(true)
        obj:transmitCompleteItemToClients()
        square:setSquareChanged()
    end
end

local clearAttachments = function(square)
    local objects = square:getObjects()
    for i=0, objects:size()-1 do
        local object = objects:get(i)
        if object then
            object:setAttachedAnimSprite(ArrayList.new())
        end
    end
    square:setSquareChanged()
end

local addAttachment = function(square, attachmentList)
    local floor = square:getFloor()
    for _, sprite in pairs(attachmentList) do
        floor:getAttachedAnimSprite():add(getSprite(sprite):newInstance())
    end
    floor:transmitUpdatedSpriteToClients()
    square:setSquareChanged()
    -- print ("[BWO] Added " .. #attachmentList .. " attachments to square " .. square:getX() .. ", " .. square:getY() .. ", " .. square:getZ())
end

local processSquare = function(square)
    if isClient() then return end

    local map = BWOMap.map
    local att = BWOMap.att
    local fire = BWOMap.fire
    local cell = square:getCell()

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
        if att[id] then
            clearAttachments(square)
            addAttachment(square, att[id])
            BWOMap.att[id] = nil
        end
        if fire[id] then
            clearObjects(square)
            addFire(square, fire[id])
            BWOMap.fire[id] = nil
        end
    end

    local trafficLights = BWOMap.trafficLights
    local objects = square:getObjects()
    for i=0, objects:size()-1 do
        local object = objects:get(i)

        -- traffic lights
        local sprite = object:getSprite()
        if sprite then
            local name = sprite:getName()

            -- replace if needed and register
            for old, new in pairs(trafficLights) do
                local register = false
                if name == old  then
                    if isClient() then
                        sledgeDestroy(object)
                    else
                        square:transmitRemoveItemFromSquare(object)
                    end
                    
                    local sprite = getSprite(new)
                    local ls = IsoClothingDryer.new(cell, square, sprite)
                    square:AddSpecialObject(ls)
                    square:setSquareChanged()

                    local genSquare = cell:getOrCreateGridSquare(x, y, -2)
                    if genSquare and genSquare:getChunk() then
                        local generator = genSquare:getGenerator()
                        if not generator then
                            local genItem = BanditCompatibility.InstanceItem("Base.Generator_Old")
                            local generator = IsoGenerator.new(genItem, cell, genSquare)
                            generator:setCondition(100)
                            generator:setFuel(100)
                            generator:setConnected(true)
                            cell:addToProcessIsoObjectRemove(generator)

                            -- local props = generator:getProperties()
                            -- props:set("GeneratorSound", "silenced")
                        end
                    end

                    register = true
                end

                -- its already replaced, ensure registration
                if name == new then
                    register = true
                end

                if register then
                    BWOLights.Add(x, y, z, {oscillator = 20})
                    break
                end
            end
        end
    end
end

Events.LoadGridsquare.Add(processSquare)
