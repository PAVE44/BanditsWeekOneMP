BWORemote = {}

local isRemote = function(id)
    local cache = BanditZombie.CacheLightB
    for cachedId, cachedData in pairs(cache) do
        if cachedId == id then
            return false
        end
    end
    return true
end

local manageRemotePopulation = function()
    local cell = getCell()

    local countRemote = 0
    local countRemoved = 0
    local countRespawned = 0
    for i = 0, BanditClusterCount - 1 do
        local globalData = BanditClusters[i]
        local toRemove = {}
        for id, data in pairs(globalData) do
            if isRemote(id) then
                if data.lastSeen and not data.recycle then
                    local square = cell:getGridSquare(data.lastSeen.x, data.lastSeen.y, data.lastSeen.z)
                    if data.remote and square then -- phase 3
                        data.remote = nil
                        data.recycle = true
                        data.bornCoords = {x = data.lastSeen.x, y = data.lastSeen.y, z = data.lastSeen.z}
                        local player = BWOUtils.GetClosestPlayer(data.lastSeen.x, data.lastSeen.y)
                        BanditServer.Spawner.Restore(player, data)
                        countRespawned = countRespawned + 1
                    else -- phase 1
                        data.remote = true
                        local program = data.program
                        local programName = program.name
                        local programStage = program.stage
                        if program and RemotePrograms[programName] and RemotePrograms[programName][programStage] then
                            RemotePrograms[programName][programStage](data)
                        end
                        countRemote = countRemote + 1
                    end
                end
            else
                local bandit = BanditZombie.GetInstanceById(id)
                if data.recycle then -- phase 4
                    table.insert(toRemove, id)
                    bandit:removeFromWorld()
                    bandit:removeFromSquare()
                    countRemoved = countRemoved + 1
                else -- phase 0
                    data.lastSeen = {x = bandit:getX(), y = bandit:getY(), z = bandit:getZ()}
                    data.remote = nil
                    data.recycle = nil
                end
            end
        end
        for _, id in ipairs(toRemove) do
            globalData[id] = nil
        end
    end
end

Events.EveryOneMinute.Remove(manageRemotePopulation)
Events.EveryOneMinute.Add(manageRemotePopulation)