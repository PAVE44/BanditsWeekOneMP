require "BWOUtils"

BWOClientEvents = BWOClientEvents or {}

BWOClientEvents.Arson = function(params)
    BWOUtils.Explode(params.cx, params.cy, params.cz)
    BWOUtils.VehiclesAlarm(params.cx, params.cy, 0, 60)
end

-- params: cx, cy, spped, name, dir, sound
BWOClientEvents.ChopperAlert = function(params)
    getCore():setOptionUIRenderFPS(60)

    local effect = {}
    effect.cx = params.cx
    effect.cy = params.cy
    effect.initDist = 200
    effect.width = 1243
    effect.height = 760
    effect.alpha = 1
    effect.speed = params.speed
    effect.name = params.name
    effect.dir = params.dir
    effect.sound = params.sound
    effect.rotors = true
    effect.lights = true
    effect.frameCnt = 3
    effect.cycles = 400
    table.insert(BWOFlyingObject.tab, effect)
end

-- params: cid, x, y, hostile
BWOClientEvents.SpawnGroup = function(params)
    local time = 3600
    if SandboxVars.Bandits.General_ArrivalIcon then
        local icon = Bandit.cidNotification[params.cid]
        if not icon then
            icon = "media/ui/raid.png"
        end

        local color = {r=0, g=1, b=0} -- green
        if params.hostile then
            color = {r=1, g=0, b=0} -- red
        end

        BanditEventMarkerHandler.set(getRandomUUID(), icon, time, params.x, params.y, color, params.desc)
    end
end

-- params: day
BWOClientEvents.StartDay = function(params)
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