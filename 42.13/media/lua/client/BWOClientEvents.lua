require "BWOUtils"

BWOClientEvents = BWOClientEvents or {}

BWOClientEvents.Arson = function(params)

    -- check
    if not params.cx then return end
    if not params.cy then return end
    if not params.cz then return end

    BWOUtils.Explode(params.cx, params.cy, params.cz)
    BWOUtils.VehiclesAlarm(params.cx, params.cy, 0, 60)
end

-- params: cx, cy, spped, name, dir, sound
BWOClientEvents.ChopperAlert = function(params)

    -- check
    if not params.cx then return end
    if not params.cy then return end

    -- sanitize
    local speed = params.speed and params.speed or 1.8
    local name = params.name and params.name or "heli"
    local dir = params.dir and params.dir or 0
    local sound = params.sound and params.sound or nil

    getCore():setOptionUIRenderFPS(60)

    local effect = {}
    effect.cx = params.cx
    effect.cy = params.cy
    effect.initDist = 200
    effect.width = 1243
    effect.height = 760
    effect.alpha = 1
    effect.speed = speed
    effect.name = name
    effect.dir = dir
    effect.sound = sound
    effect.rotors = true
    effect.lights = true
    effect.frameCnt = 3
    effect.cycles = 400
    table.insert(BWOFlyingObject.tab, effect)
end

-- params: cid, x, y, hostile, desc
BWOClientEvents.SpawnGroup = function(params)

    -- check
    if not params.cx then return end
    if not params.cy then return end
    if not params.cz then return end

    -- sanitize
    local desc = params.desc and params.desc or "Unknown"
    local cid = params.cid and params.cid or Bandit.clanMap.PoliceBlue
    local icon = Bandit.cidNotification[params.cid] and Bandit.cidNotification[params.cid] or "media/ui/raid.png"
    local hostile = params.hostile and params.hostile or false

    -- const
    local time = 3600

    if SandboxVars.Bandits.General_ArrivalIcon then
        local color = {r=0, g=1, b=0} -- green
        if hostile then
            color = {r=1, g=0, b=0} -- red
        end

        BanditEventMarkerHandler.set(getRandomUUID(), icon, time, params.cx, params.cy, color, params.desc)
    end
end

-- params: cid, x, y, hostile, desc
BWOClientEvents.SpawnGroupVehicle = function(params)
    
    -- check
    if not params.cx then return end
    if not params.cy then return end
    if not params.cz then return end

    -- sanitize
    local desc = params.desc and params.desc or "Unknown"
    local cid = params.cid and params.cid or Bandit.clanMap.PoliceBlue
    local icon = Bandit.cidNotification[params.cid] and Bandit.cidNotification[params.cid] or "media/ui/raid.png"
    local hostile = params.hostile and params.hostile or false

    -- const
    local time = 3600

    if SandboxVars.Bandits.General_ArrivalIcon then
        local color = {r=0, g=1, b=0} -- green
        if hostile then
            color = {r=1, g=0, b=0} -- red
        end

        BanditEventMarkerHandler.set(getRandomUUID(), icon, time, params.cx, params.cy, color, desc)
    end
end

-- params: cx, cy, cz, sound
BWOClientEvents.WorldSound = function(params)

    -- check
    if not params.cx then return end
    if not params.cy then return end
    if not params.cz then return end
    if not params.sound then return end

    -- sanitize
    local volume = params.volume and params.volume or 1

    local emitter = getWorld():getFreeEmitter(params.cx, params.cy, params.cz)
    if emitter then
        local volume = getSoundManager():getSoundVolume()
        local id = emitter:playSound(params.sound, true)
        
        emitter:setVolume(id, volume * volume)
    end
end

-- params: day
BWOClientEvents.StartDay = function(params)

    if not params.day then return end

    local player = getSpecificPlayer(0)

    if player then
        player:playSound("ZSDayStart")
    end

    BWOTex.tex = getTexture("media/textures/day_" .. params.day .. ".png")
    BWOTex.speed = 0.011
    BWOTex.mode = "center"
    BWOTex.alpha = 2.4
end


local onServerCommand = function(module, command, args)
    if module == "Events" and BWOClientEvents[command] then
        local player = getPlayer()
        if player then
            local pid = player:getOnlineID()
            if args.pid and args.pid == pid then
                BWOClientEvents[command](args)
            end
        end
    end
end

Events.OnServerCommand.Remove(onServerCommand)
Events.OnServerCommand.Add(onServerCommand)