require "TimedActions/ISBaseTimedAction"

TAJukebox = ISBaseTimedAction:derive("TAJukebox");

function TAJukebox:isValid()
    return true
end

function TAJukebox:update()
    
end

function TAJukebox:start()
    self.character:faceLocationF(self.square:getX() + 0.5, self.square:getY() + 0.5)
    self:setActionAnim("Loot")
end

function TAJukebox:stop()
    ISBaseTimedAction.stop(self)
end

function TAJukebox:perform()
    local x, y, z = self.square:getX(), self.square:getY(), self.square:getZ()
    local option = self.option
    local jukebox = BWOJukebox.Get(x, y, z)
    if jukebox then
        if option == "on" then
            BWOJukebox.TurnOn(x, y, z)
        elseif option == "off" then
            BWOJukebox.TurnOff(x, y, z)
        end
    end

    ISBaseTimedAction.perform(self)
end

function TAJukebox:new(character, square, option)
    local o = {}
    setmetatable(o, self)
    self.__index = self
    
    o.character = character
    o.square = square
    o.stopOnWalk = false
    -- o.stopOnRun = false
    o.maxTime = 40

    -- custom fields
    o.option = option
    return o
end

return TAJukebox;
