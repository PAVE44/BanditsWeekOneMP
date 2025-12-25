BWOScenarios = {}

BWOScenarios.Abstract = {}
BWOScenarios.Abstract.__index = BWOScenarios.Abstract

function BWOScenarios.Abstract:getSchedule()
    return self.schedule
end

function BWOScenarios.Abstract:getRoomSpawns()
    return self.roomSpawns
end

function BWOScenarios.Abstract:getWaitingRoom()
    return self.waitingRoom
end

function BWOScenarios.Abstract:getRandomPlayerSpawn()
    return BanditUtils.Choice(self.playerSpawns)
end

function BWOScenarios.Abstract:derive(type)
    local derived = {}
    setmetatable(derived, { __index = self })
    derived.__index = derived
    derived.Type = type
    return derived
end

function BWOScenarios.Abstract:waitingRoom()
end

function BWOScenarios.Abstract:controller()
end

function BWOScenarios.Abstract:new()
    local o = setmetatable({}, self)
    return o
end