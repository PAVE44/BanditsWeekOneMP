BWOServerEvents = BWOServerEvents or {}

BWOServerEvents.ChopperAlert = function(params)
    print("[SERVER_EVENT] [ChopperAlert] Init")

    local paramsClient = {}
    paramsClient.speed = params.speed
    paramsClient.name = params.name
    paramsClient.dir = params.dir
    paramsClient.sound = params.sound

    local groups = BWOUtils.GetPlayerGroups()
    for i = 1, #groups do
        -- pick a random player from the group
        local players = groups[i]
        local player = BanditUtils.Choice(players)
        
        paramsClient.cx = player:getX() - 3 + ZombRand(4)
        paramsClient.cy = player:getY() - 3 + ZombRand(4)

        print("[SERVER_EVENT] [ChopperAlert] cx: " .. paramsClient.cx .. " cy: " .. paramsClient.cy)

        -- all players in the group get the same event
        for j = 1, #groups[i] do
            local player = groups[i][j]

            paramsClient.pid = player:getOnlineID()
            print("[SERVER_EVENT] [ChopperAlert] Sending to player " .. tostring(paramsClient.pid))
            sendServerCommand("Events", "ChopperAlert", paramsClient)
        end
    end
end
