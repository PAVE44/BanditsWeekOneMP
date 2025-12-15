require "BWOUtils"

BWOClientEvents = BWOClientEvents or {}

BWOClientEvents.ChopperAlert = function(params)
    local player = getSpecificPlayer(0)
    if not player then return end
    
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

BWOClientEvents.StartDay = function(params)
    local player = getSpecificPlayer(0)
    if not player then return end

    player:playSound("ZSDayStart")
    
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