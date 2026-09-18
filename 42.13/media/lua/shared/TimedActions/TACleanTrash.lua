require "TimedActions/ISBaseTimedAction"

TACleanTrash = ISBaseTimedAction:derive("TACleanTrash")

function TACleanTrash:isValid()
    local primaryItem = self.character:getPrimaryHandItem()
    if primaryItem and primaryItem:hasTag(ItemTag.CLEAR_ASHES) and not primaryItem:isBroken() then
        return true
    end
end

function TACleanTrash:waitToStart()
    self.character:faceLocation(self.square:getX(), self.square:getY())
    return self.character:shouldBeTurning()
end

function TACleanTrash:update()
    self.character:faceLocation(self.square:getX(), self.square:getY())
    self.character:setMetabolicTarget(Metabolics.LightWork)
end

function TACleanTrash:start()
    local primaryItem = self.character:getPrimaryHandItem()
    local square = self.square

    self:setActionAnim("ScrubFloor_Mop")
    self:setOverrideHandModels(primaryItem, nil)
    self.sound = self.character:playSound("CleanBloodBleach")
end

function TACleanTrash:stop()
    self.character:stopOrTriggerSound(self.sound)
    ISBaseTimedAction.stop(self)
end

function TACleanTrash:getTrashObject()
    local objects = self.square:getObjects()
    for i=0, objects:size()-1 do
        local object = objects:get(i)
        local sprite = object:getSprite()
        if sprite then
            local props = sprite:getProperties()
            if props then
                if props:has("CustomName") then
                    local customName = props:get("CustomName")
                    if customName == "Trash" then
                        return object
                    end
                end
            end
        end
    end
    return nil
end

function TACleanTrash:perform()
    self.character:stopOrTriggerSound(self.sound)

    local trash = self:getTrashObject()
    if trash then
        BWOItemTransfer.Earn(self.character, 1)
    end
    -- needed to remove from queue / start next.
    ISBaseTimedAction.perform(self)
end

function TACleanTrash:complete()

    local trash = self:getTrashObject()
    if trash then
        self.square:transmitRemoveItemFromSquare(trash)
        self.square:RemoveTileObject(trash)
    end

    return true
end

function TACleanTrash:getDuration()
    if self.character:isTimedActionInstant() then
        return 1
    end
    return 150
end

function TACleanTrash:new(character, square)
    local o = ISBaseTimedAction.new(self, character)
    o.square = square
    o.maxTime = o:getDuration()
    o.caloriesModifier = 5
    return o
end
