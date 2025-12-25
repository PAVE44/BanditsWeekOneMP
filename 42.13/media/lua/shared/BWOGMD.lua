BWOGMD = {}
BWOGMD.data = {}

local function initModData(isNewGame)

    -- BANDIT GLOBAL MODDATA
    local globalData = ModData.getOrCreate("BWOMP")
    if isClient() then
        ModData.request("BWOMP")
    end
    
    if not globalData.general then 
        globalData.general = {
            gameStarted = false,
            waitingRoomBuilt = false,
        }
    end

    if not globalData.players then 
        globalData.players = {}
    end

    BWOGMD.data = globalData

end

local function loadModData(key, globalData)
    if isClient() then
        if key and globalData then
            if key == "BWOMP" then
                BWOGMD.data = globalData
            end
        end
    end
end

BWOGMD.Get = function()
    return BWOGMD.data
end

BWOGMD.Transmit = function()
    if isServer() then
        ModData.transmit("BWOMP")
    end
end

Events.OnInitGlobalModData.Add(initModData)
Events.OnReceiveGlobalModData.Add(loadModData)
