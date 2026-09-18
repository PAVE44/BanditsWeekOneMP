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

-- Events.EveryOneMinute.Remove(everyOneMinute)
-- Events.EveryOneMinute.Add(everyOneMinute)

local UITextHandle

local playerTick = 0

local function playerProximity(player)

    if playerTick % 16 == 0 then
        local post = BWOPostData.box
        local playerNum = player:getPlayerNum()
        local sqs = {
            {x = 0, y = 0},
            {x = 1, y = 0},
            {x = 1, y = 1},
            {x = 0, y = 1},
            {x = -1, y = 1},
            {x = -1, y = 0},
            {x = -1, y = -1},
            {x = 0, y = -1},
            {x = 1, y = 1},
        }

        local px, py = math.floor(player:getX()), math.floor(player:getY())
        local fid
        for _, sq in ipairs(sqs) do
            local sx, sy = px + sq.x, py + sq.y
            local id = sx .. "-" .. sy
            if post[id] then
                fid = id
                fx = sx
                fy = sy
                break
            end
        end

        if fid then
            local fpost = BWOPostData.GetBox(fid)
            if not UITextHandle then
                UITextHandle = UIText:new(playerNum, fpost.x, fpost.y, 0, fpost.address)
                UITextHandle:initialise()
                UITextHandle:addToUIManager()
            else
                UITextHandle:setData(fpost.x, fpost.y, 0, fpost.address)
            end
        else
            if UITextHandle then
                UITextHandle:removeFromUIManager()
                UITextHandle:close()
                UITextHandle = nil
            end
        end
    end

    playerTick = playerTick + 1
    if playerTick >= 256 then playerTick = 0 end
end

Events.OnPlayerUpdate.Remove(playerProximity)
Events.OnPlayerUpdate.Add(playerProximity)