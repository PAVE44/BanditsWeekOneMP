BWOGMD = {}
BWOGMD.data = {}

local function initModData(isNewGame)

    -- BWO GLOBAL MODDATA, RETRANSMITTABLE SERVER-CLIENT
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

    -- dev only
    if not globalData.nav then 
        globalData.nav = {}
    end

    BWOGMD.data = globalData

    -- BWO GLOBAL MODDATA, SERVER ONLY, NOT RETRANSMITTABLE SERVER-CLIENT
    if isClient() then return end

    local globalDataServer = ModData.getOrCreate("BWOMP_SERVER")

    -- server-only permanent area data
    if not globalDataServer.areaData then 
        globalDataServer.areaData = {}

        -- the amount of already spawned people in the area
        if not globalDataServer.areaData.popSpawned then
            globalDataServer.areaData.popSpawned = {}
        end
    end

    BWOGMD.dataServer = globalDataServer
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

BWOGMD.GetServer = function()
    return BWOGMD.dataServer
end


Events.OnInitGlobalModData.Add(initModData)
Events.OnReceiveGlobalModData.Add(loadModData)
