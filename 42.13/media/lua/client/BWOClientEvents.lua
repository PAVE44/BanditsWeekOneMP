require "BWOUtils"

BWOClientEvents = BWOClientEvents or {}

-- Each function:
-- 1. must check for required params
-- 2. must sanitize the params
-- 3. may introduce local constants
-- 4. and only then execute the logic

BWOClientEvents.Arson = function(params)

    -- check
    if not params.cx then return end
    if not params.cy then return end
    if not params.cz then return end

    -- sanitize
    local cx = params.cx
    local cy = params.cy
    local cz = params.cz

    -- const
    local time = 3600
    local icon = "media/ui/arson.png"
    local desc = "Arson"
    local color = {r=1, g=0, b=0} -- red

    BWOUtils.Explode(cx, cy, cz)
    BWOUtils.VehiclesAlarm(cx, cy, 0, 60)

    if SandboxVars.Bandits.General_ArrivalIcon then
        BanditEventMarkerHandler.set(getRandomUUID(), icon, time, cx, cy, color, desc)
    end
end

-- params: cx, cy, spped, name, dir, sound
BWOClientEvents.FlyingObject = function(params)

    -- check
    if not params.cx then return end
    if not params.cy then return end

    -- const
    local initDist = 350
    local frameCnt = 3
    local cycles = 400
    local alpha = 1

    -- sanitize
    local cx = params.cx
    local cy = params.cy
    local width = params.width and params.width or 1243
    local height = params.height and params.height or 760
    local speed = params.speed and params.speed or 1.8
    local name = params.name and params.name or "heli"
    local dir = params.dir and params.dir or 0
    local sound = params.sound and params.sound or nil
    local soundMode = params.soundMode and params.soundMode or "exact"
    local rotors = params.rotors and params.rotors or true
    local lights = params.lights and params.lights or true
    local projectiles = params.projectiles and params.projectiles or false

    getCore():setOptionUIRenderFPS(60)

    local effect = {}
    effect.cx = cx
    effect.cy = cy
    effect.initDist = initDist
    effect.width = width
    effect.height = height
    effect.alpha = alpha
    effect.speed = speed
    effect.name = name
    effect.dir = dir
    effect.sound = sound
    effect.soundMode = soundMode
    effect.rotors = rotors
    effect.lights = lights
    effect.projectiles = projectiles
    effect.frameCnt = frameCnt
    effect.cycles = cycles
    table.insert(BWOFlyingObject.tab, effect)
end

-- params, cx, cy, weapon, boxSize
BWOClientEvents.JetfighterWeapon = function(params)
    -- check
    if not params.cx then return end
    if not params.cy then return end
    if not params.dir then return end

    -- sanitize
    local cx = params.cx
    local cy = params.cy
    local dir = params.dir
    local weapon = params.weapon and params.weapon or "mg"
    local boxSize = params.boxSize and params.boxSize or 5

    local armaments = {
        ["mg"] = function(x, y, boxSize, dir)
            local x1, y1, x2, y2, z = x - 1, y - 1, x + boxSize + 1, y + boxSize + 1, 0
            BWOUtils.Strafe(x1, y1, x2, y2, z, dir)
            return true
        end,
        ["bomb"] = function(x, y, boxSize, dir)
            BWOUtils.Explode(x, y, 0)
            return true
        end,
        ["gas"] = function(x, y, boxSize, dir)
            BWOUtils.DeployGas(x, y, 0)
            return true
        end
    }

    if armaments[weapon] then
        local armament = armaments[weapon]
        armament(cx, cy, boxSize, dir)
    end
end

-- params: sound
BWOClientEvents.PlayerSound = function(params)

    -- check
    if not params.sound then return end
    
    local player = getSpecificPlayer(0)
    if not player then return end

    -- sanitize
    local sound = params.sound
    local volume = params.volume and params.volume or 1

    local emitter = player:getEmitter()
    if emitter then
        local volumeSystem = getSoundManager():getSoundVolume()
        local id = emitter:playSound(sound, true)
        emitter:setVolume(id, volume * volumeSystem)
    end
end

-- params: cid, x, y, hostile, desc
BWOClientEvents.SpawnGroup = function(params)

    -- check
    if not params.cx then return end
    if not params.cy then return end
    if not params.cz then return end
    if not params.cid then return end

    -- sanitize
    local cx = params.cx
    local cy = params.cy
    local cz = params.cz
    local desc = params.desc and params.desc or "Unknown"
    local icon = Bandit.cidNotification[cid] and Bandit.cidNotification[cid] or "media/ui/raid.png"
    local hostile = params.hostile and params.hostile or false

    -- const
    local time = 3600

    if SandboxVars.Bandits.General_ArrivalIcon then
        local color = {r=0, g=1, b=0} -- green
        if hostile then
            color = {r=1, g=0, b=0} -- red
        end

        BanditEventMarkerHandler.set(getRandomUUID(), icon, time, cx, cy, color, desc)
    end
end

-- params: cid, x, y, hostile, desc
BWOClientEvents.SpawnGroupVehicle = function(params)

    -- check
    if not params.cx then return end
    if not params.cy then return end
    if not params.cz then return end
    if not params.cid then return end

    -- sanitize
    local cx = params.cx
    local cy = params.cy
    local cz = params.cz
    local cid = params.cid
    local desc = params.desc and params.desc or "Unknown"
    local icon = Bandit.cidNotification[cid] and Bandit.cidNotification[cid] or "media/ui/raid.png"
    local hostile = params.hostile and params.hostile or false

    -- const
    local time = 3600

    if SandboxVars.Bandits.General_ArrivalIcon then
        local color = {r=0, g=1, b=0} -- green
        if hostile then
            color = {r=1, g=0, b=0} -- red
        end

        BanditEventMarkerHandler.set(getRandomUUID(), icon, time, cx, cy, color, desc)
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
    local cx = params.cx
    local cy = params.cy
    local cz = params.cz
    local sound = params.sound
    local volume = params.volume and params.volume or 1

    local emitter = getWorld():getFreeEmitter(cx, cy, cz)
    if emitter then
        local volumeSystem = getSoundManager():getSoundVolume()
        local id = emitter:playSound(sound, true)
        
        emitter:setVolume(id, volume * volumeSystem)
    end
end

-- params: cx, cy, cz
BWOClientEvents.PlaneCrashPart = function(params)

    -- check
    if not params.cx then return end
    if not params.cy then return end
    if not params.cz then return end

    -- sanitize
    local cx = params.cx
    local cy = params.cy
    local cz = params.cz

    BWOUtils.Explode(cx, cy, cz)
    --BWOUtils.VehiclesAlarm(cx, cy, 0, 60)

end

BWOClientEvents.PlaneCrashPartEnd = function(params)

    -- check
    if not params.cx then return end
    if not params.cy then return end
    if not params.cz then return end

    -- sanitize
    local cx = params.cx
    local cy = params.cy
    local cz = params.cz

    BWOUtils.VehiclesAlarm(cx, cy, 0, 60)

end

-- params: day
BWOClientEvents.StartDay = function(params)

    -- check
    if not params.day then return end

    -- sanitize
    local day = params.day

    local player = getSpecificPlayer(0)
    if player then
        player:playSound("ZSDayStart")
    end

    BWOTex.tex = getTexture("media/textures/day_" .. day .. ".png")
    BWOTex.speed = 0.011
    BWOTex.mode = "center"
    BWOTex.alpha = 2.4
end

BWOClientEvents.Teleport = function(params)
    local player = getSpecificPlayer(0)
    if not player then return end
    player:setX(params.x)
    player:setY(params.y)
    player:setZ(params.z)
    player:setLastX(params.x)
    player:setLastY(params.y)
    player:setLastZ(params.z)
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
