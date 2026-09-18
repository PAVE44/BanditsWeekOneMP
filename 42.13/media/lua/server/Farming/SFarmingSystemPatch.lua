require "Farming/SFarmingSystem"

SFarmingSystem.destroyPlant = function(square)
    if not square then return end
    local zombie = square:getZombie()
    if zombie then
        local bandit = zombie:getVariableBoolean("Bandit")
        if not bandit then 
            args = {}
            args.x = square:getX()
            args.y = square:getY()
            args.z = square:getZ()
            SFarmingSystemCommands.destroy(nil, args)
        end
    end
end