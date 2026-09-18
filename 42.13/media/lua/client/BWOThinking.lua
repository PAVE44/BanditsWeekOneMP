BWOThinking = BWOThinking or {}

local texturePin = getTexture("media/textures/Foraging/pinIconBlank.png")
local texturePinW = 24
local texturePinH = 36

BWOThinking.thinkData = {}

BWOThinking.AddThinking = function (bandit, tex, action)
    local id = BanditUtils.GetCharacterID(bandit)
    if id then
        BWOThinking.thinkData[id] = {}
        BWOThinking.thinkData[id].tex = tex
        BWOThinking.thinkData[id].action = action
        BWOThinking.thinkData[id].alpha = 2
    end
end

BWOThinking.ResetThinking = function(id)
    BWOThinking.thinkData[id] = {}
end

local function thinking()
    if not isIngameState() then return end
    if isServer() then return end

    local player = getSpecificPlayer(0)
    if player == nil then return end
    local playerNum = player:getPlayerNum()
    local zoom = getCore():getZoom(playerNum)

    local banditList = BanditZombie.CacheLightB
    for id, bandit in pairs(banditList) do
        local thinkData = BWOThinking.thinkData[id]
        if thinkData and thinkData.tex then
            local action = thinkData.action
            local tex = thinkData.tex
            local texW
            local texH
            if tex:getWidth() > tex:getHeight() then
                texW = 16
                texH = 16 * (tex:getHeight() / tex:getWidth())
            else
                texH = 16
                texW = 16 * (tex:getWidth() / tex:getHeight())
            end
            texW = texW / zoom
            texH = texH / zoom

            if tex then
                local bx, by, bz = bandit.x, bandit.y, bandit.z
                thinkData.alpha = thinkData.alpha or 2

                -- pin 
                local px = isoToScreenX(playerNum, bx, by, bz) - (texW / 2)
                local py = isoToScreenY(playerNum, bx, by, bz) - (150 / zoom)
                UIManager.DrawTexture(texturePin, px, py, texturePinW / zoom, texturePinH / zoom, thinkData.alpha)
                
                -- icon tex
                local tx = isoToScreenX(playerNum, bx, by, bz) - (texW / 2) + (4 / zoom)
                local ty = isoToScreenY(playerNum, bx, by, bz) - (150 / zoom) + (4 / zoom)
                
                UIManager.DrawTexture(tex, tx, ty, texW, texH, thinkData.alpha)
                thinkData.alpha = thinkData.alpha - 0.005
                if thinkData.alpha < 0 then
                    BWOThinking.ResetThinking(id)
                end
            else
                BWOThinking.ResetThinking(id)
            end
        end
    end
end

Events.OnPreUIDraw.Add(thinking)
Events.OnBanditDoorToggled.Add(closeDoor)