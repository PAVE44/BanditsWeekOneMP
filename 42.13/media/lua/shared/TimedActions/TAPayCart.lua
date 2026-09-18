require "TimedActions/ISBaseTimedAction"

TAPayCart = ISBaseTimedAction:derive("TAPayCart")

function TAPayCart:isValid()
    local money = BWOItemTransfer.GetCash(self.character)
    local due = math.ceil(BWOItemTransfer.GetShoppingCartValue(self.character))
    return money >= due
end

function TAPayCart:start()
    self:setActionAnim("Craft")
    self.character:playSound("CashRegisterOpen")
end

function TAPayCart:stop()
    ISBaseTimedAction.stop(self)
end

function TAPayCart:perform()

    local money = BWOItemTransfer.GetCash(self.character)
    local due = math.ceil(BWOItemTransfer.GetShoppingCartValue(self.character))

    if money >= due then
        BWOItemTransfer.Pay(self.character, due)
        BWOItemTransfer.PayShoppingCart(self.character)
    end
    self.character:playSound("CashRegisterClose")
    
    -- needed to remove from queue / start next.
    ISBaseTimedAction.perform(self)
end

function TAPayCart:complete()
    return true
end

function TAPayCart:getDuration()
    if self.character:isTimedActionInstant() then
        return 1
    end
    return 65
end

function TAPayCart:new(character, square)
    local o = ISBaseTimedAction.new(self, character)
    o.square = square
    o.maxTime = o:getDuration()
    o.caloriesModifier = 5
    return o
end
