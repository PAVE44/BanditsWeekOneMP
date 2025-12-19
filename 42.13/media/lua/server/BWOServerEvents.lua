require "BWODebug"
require "BWOUtils"

BWOServerEvents = BWOServerEvents or {}

BWOServerEvents.Arson = function(params)
    dprint("[SERVER_EVENT][INFO][Arson] INIT", 3)
    local distMin = 45
    local distMax = 85
    local densityMin = 0.5

    local groups = BWOUtils.GetPlayerGroups()
    for i = 1, #groups do
        -- pick a random player from the group
        local players = groups[i]
        local playerSelected = BanditUtils.Choice(players)
        local px, py, pz = playerSelected:getX(), playerSelected:getY(), playerSelected:getZ()

        local density = BWOUtils.GetDensityScore(px, py)
        if density > densityMin then
            local room = BWOUtils.FindRoomDist(px, py, distMin, distMax)

            if room then
                local square = BWOUtils.GetRandomRoomSquare(room)
                if square then
                    local cx = square:getX()
                    local cy = square:getY()
                    local cz = square:getZ()

                    BWOUtils.Explode(cx, cy, 0)

                    for j = 1, #players do
                        local player = players[j]
                        local paramsClient = {
                            pid = player:getOnlineID(),
                            cx = cx,
                            cy = cy,
                            cz = cz
                        }
                        dprint("[SERVER_EVENT][INFO][Arson] REQUEST CLIENT LOGIC FOR: " .. tostring(paramsClient.pid), 3)
                        sendServerCommand("Events", "Arson", paramsClient)
                    end
                else
                    dprint("[SERVER_EVENT][INFO][Arson] SQUARE UNAVAILABLE", 3)
                end
            else
                dprint("[SERVER_EVENT][INFO][Arson] NO ROOM FOUND", 3)
            end
        else
            dprint("[SERVER_EVENT][INFO][Arson] SKIPPING DUE TO LOW DENSITY " .. density .. " < " .. densityMin, 3)
        end
    end
end

BWOServerEvents.ChopperAlert = function(params)
    dprint("[SERVER_EVENT][INFO][ChopperAlert] INIT", 3)

    local groups = BWOUtils.GetPlayerGroups()
    for i = 1, #groups do
        -- pick a random player from the group
        local players = groups[i]
        local playerSelected = BanditUtils.Choice(players)

        local cx = playerSelected:getX() - 3 + ZombRand(4)
        local cy = playerSelected:getY() - 3 + ZombRand(4)

        dprint("[SERVER_EVENT][INFO][ChopperAlert] cx: " .. cx .. " cy: " .. cy, 3)

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
            dprint("[SERVER_EVENT][INFO][ChopperAlert] REQUEST CLIENT LOGIC FOR: " .. tostring(paramsClient.pid), 3)
            sendServerCommand("Events", "ChopperAlert", paramsClient)
        end
    end
end

-- params: cid, program, hostile, name]
BWOServerEvents.SpawnGroup = function(params)
    dprint("[SERVER_EVENT][INFO][SpawnGroup] INIT", 3)

    local multiplierMin = 0.5
    local multiplierMax = 2

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
            local density = BWOUtils.GetDensityScore(px, py)
            if density > multiplierMax then density = multiplierMax end
            if density < multiplierMin then density = multiplierMin end
            local size = params.size
            size = math.floor(size * #players * density)
            dprint("[SERVER_EVENT][INFO][SpawnGroup] SIZE: " .. size .. " = " .. params.size .. " * " .. #players .. " * " .. density, 3)

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
                dprint("[SERVER_EVENT][INFO][SpawnGroup] SPAWN SUCCESSFUL", 3)

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
                    dprint("[SERVER_EVENT][INFO][SpawnGroup] REQUEST CLIENT LOGIC FOR: " .. tostring(paramsClient.pid), 3)
                    sendServerCommand("Events", "SpawnGroup", paramsClient)
                end
            else
                dprint("[SERVER_EVENT][INFO][SpawnGroup] SPAWN SKIPPED DUE TO ZERO GROUP SIZE", 3)
            end

        else
            dprint("[SERVER_EVENT][INFO][SpawnGroup] NO SUITABLE SPAWN POINT FOUND", 3)
        end
    end
end

BWOServerEvents.StartDay = function(params)
    dprint("[SERVER_EVENT][INFO][StartDay] INIT", 3)

    local players = BWOUtils.GetAllPlayers()
    for i = 1, #players do
        local player = players[i]
        local paramsClient = {
            pid = player:getOnlineID(),
            day = params.day,
        }
        dprint("[SERVER_EVENT][INFO][StartDay] REQUEST CLIENT LOGIC FOR: " .. tostring(paramsClient.pid), 3)
        sendServerCommand("Events", "StartDay", paramsClient)
    end
end
