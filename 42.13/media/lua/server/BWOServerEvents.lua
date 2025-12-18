require "BWOUtils"

BWOServerEvents = BWOServerEvents or {}

BWOServerEvents.ChopperAlert = function(params)
    print("[SERVER_EVENT] [ChopperAlert] Init")

    local groups = BWOUtils.GetPlayerGroups()
    for i = 1, #groups do
        -- pick a random player from the group
        local players = groups[i]
        local playerSelected = BanditUtils.Choice(players)

        local cx = playerSelected:getX() - 3 + ZombRand(4)
        local cy = playerSelected:getY() - 3 + ZombRand(4)

        print("[SERVER_EVENT] [ChopperAlert] cx: " .. cx .. " cy: " .. cy)

        -- execute client logic for event
        for j = 1, #players do
            local player = players[j]

            local paramsClient = {
                pid = player:getOnlineID(),
                cx = cx,
                cy = cy,
                speed = params.speed,
                name = params.name,
                dir = params.dir,
                sound = params.sound
            }
            print("[SERVER_EVENT] [ChopperAlert] Requesting client logic " .. tostring(paramsClient.pid))
            sendServerCommand("Events", "ChopperAlert", paramsClient)
        end
    end
end

-- params: cid, program, hostile, name]
BWOEvents.SpawnGroup = function(params)
    print("[SERVER_EVENT] [SpawnGroup] Init")

    local groups = BWOUtils.GetPlayerGroups()
    for i = 1, #groups do
        -- pick a random player from the group
        local players = groups[i]
        local playerSelected = BanditUtils.Choice(players)
        local px, py, pz = playerSelected:getX(), playerSelected:getY(), playerSelected:getZ()

        -- spawn point selection
        local distance = params.d + ZombRand(10)
        local spawnPoints = BWOUtils.GenerateSpawnPoints(px, py, pz, distance, 1)
        if #spawnPoints == 1 then
            local sp = spawnPoints[1]

            -- group size calculation
            local density = BWOBuildings.GetDensityScore(player) / 6000
            if density > 2 then density = 2 end
            if density < 0.5 then density = 0.5 end
            local size = params.size
            size = math.floor(size * #players * density)
            print("[SERVER_EVENT] [SpawnGroup] size: " .. size .. " = " .. params.size .. " * " .. #players .. " * " .. density)

            -- spawn
            if size > 0 then
                local args = {
                    cid = params.cid,
                    program = params.program,
                    voice = params.voice,
                    hostile = params.hostile,
                    x = sp.x,
                    y = sp.y,
                    z = sp.z,
                    size = size
                }
                BanditServer.Spawner.Clan(playerSelected, args)

                -- execute client logic for event
                for j = 1, #players do
                    local player = players[j]

                    local paramsClient = {
                        pid = player:getOnlineID(),
                        cid = params.cid,
                        name = params.name,
                        hostile = params.hostile,
                        x = sp.x,
                        y = sp.y,
                        z = sp.z
                    }
                    print("[SERVER_EVENT] [ChopperAlert] Requesting client logic " .. tostring(paramsClient.pid))
                    sendServerCommand("Events", "SpawnGroup", paramsClient)
                end
            else
                print("[SERVER_EVENT] [SpawnGroup] Spawn skipped due to zero group size")
            end

        else
            print("[SERVER_EVENT] [SpawnGroup] No suitable spawn point found")
        end

    end

end

BWOServerEvents.StartDay = function(params)
    print("[SERVER_EVENT] [StartDay] Init")

    local players = BWOUtils.GetAllPlayers()
    for i = 1, #players do
        local player = players[i]
        local paramsClient = {
            pid = player:getOnlineID(),
            day = params.day,
        }
        print("[SERVER_EVENT] [StartDay] Requesting client logic " .. tostring(paramsClient.pid))
        sendServerCommand("Events", "StartDay", paramsClient)
    end
end
