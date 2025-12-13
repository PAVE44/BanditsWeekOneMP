BWOServerEvents = BWOServerEvents or {}

BWOServerEvents.ChopperAlert = function(params)
    print("[SERVER_EVENT] [ChopperAlert] Init")
    local players = BWOUtils.GetDistantPlayers()
    for i = 1, #players do
        local player = players[i]
        
        local paramsClient = {}
        
        -- always required
        paramsClient.pid = player:getOnlineID()

        -- server to decide
        paramsClient.cx = player:getX() - 3 + ZombRand(4)
        paramsClient.cy = player:getY() - 3 + ZombRand(4)

        print("[SERVER_EVENT] [ChopperAlert] cx: " .. paramsClient.cx .. " cy: " .. paramsClient.cy)
        -- event to decide
        paramsClient.speed = params.speed
        paramsClient.name = params.name
        paramsClient.dir = params.dir
        paramsClient.sound = params.sound

        sendServerCommand("Events", "ChopperAlert", paramsClient)
    end
end
