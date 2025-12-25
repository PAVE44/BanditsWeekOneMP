BWOPlayer = BWOPlayer or {}

local function everyOneMinute(player)
    local gmd = BWOGMD.Get()

    if gmd.general.gameStarted then
        if BWOPlayer.waitingRoomModal then
            BWOPlayer.waitingRoomModal:removeFromUIManager()
            BWOPlayer.waitingRoomModal:close()
            BWOPlayer.waitingRoomModal = nil
        end
        return
    end

    if not BWOPlayer.waitingRoomModal then
        local screenWidth, screenHeight = getCore():getScreenWidth(), getCore():getScreenHeight()
        local modalWidth, modalHeight = 600, 80
        local modalX = 0
        local modalY = screenHeight - modalHeight
        BWOPlayer.waitingRoomModal = UIWaitingRoom:new(100, 50, 300, screenHeight - 100)
        BWOPlayer.waitingRoomModal:initialise()
        BWOPlayer.waitingRoomModal:addToUIManager()
    end
end

Events.EveryOneMinute.Remove(everyOneMinute)
Events.EveryOneMinute.Add(everyOneMinute)