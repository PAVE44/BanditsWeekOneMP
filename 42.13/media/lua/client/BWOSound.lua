BWOSound = BWOSound or {}

BWOSound.global = {}
BWOSound.objects = {}
BWOSound.maxDist = 12

BWOSound.megaphones = {}
BWOSound.megaphones.global = {
    {x=9966, y=12642, z=-4},
    {x=9966, y=12609, z=-4},
}

local function fixVolume(volume)
    local volumeMain = getSoundManager():getSoundVolume()
    local volumeZoom = 1

    local player = getSpecificPlayer(0)
    if player then
        local playerNum = player:getPlayerNum()
        local zoom = 1 / getCore():getZoom(playerNum)
        volumeZoom = BanditUtils.Lerp(zoom, 0.4, 4, 0.2, 1)
    end

    return volume * volumeMain * volumeZoom
end

BWOSound.PlayPlayer = function(tab)
    local player = getSpecificPlayer(0)
    local volume = tab.volume or 1
    local emitter = player:getEmitter()
    local id = emitter:playSound(tab.sound)
    emitter:setVolume(id, fixVolume(volume))
end

BWOSound.PlayCharacter = function(tab)
    local character = tab.character
    local emitter = character:getEmitter()
    if not emitter:isPlaying(tab.sound) then
        local volume = tab.volume or 1
        local id = emitter:playSound(tab.sound)
        emitter:setVolume(id, fixVolume(volume))
    end
end

BWOSound.PlayDevice = function(tab)
    local dd = tab.dd
    -- local volume = fixVolume(dd:getDeviceVolume())
    dd:playSoundLocal(tab.sound, true)
end

BWOSound.PlayLocation = function(tab)
    local square = getCell():getGridSquare(tab.x, tab.y, tab.z)
    if square then
        local emitter = getWorld():getFreeEmitter(tab.x, tab.y, tab.z)
        local id = emitter:playSound(tab.sound)
        emitter:setVolume(id, fixVolume(1))
    end
end

BWOSound.AddGlobal = function(tab)
    table.insert(BWOSound.global, tab)
end

BWOSound.RemoveGlobal = function(tab)
    for i, effect in ipairs(BWOSound.global) do
        if tab.sound == effect.sound then
            for _, megaphone in ipairs(BWOSound.megaphones.global) do
                megaphone.emitter:stopSoundByName(effect.sound)
                megaphone.emitter = nil
            end
            table.remove(BWOSound.global, i)
            break
        end
    end
end

BWOSound.AddToObject = function(tab)
    if not tab.sound then return end

    local duplicate = false
    for i, effect in ipairs(BWOSound.objects) do
        if effect.x == tab.x and effect.y == tab.y and effect.z == tab.z then
            duplicate = true
            break
        end
    end

    if not duplicate then
        table.insert(BWOSound.objects, tab)
    end
end

BWOSound.RemoveFromObject = function(tab)
    for i, effect in ipairs(BWOSound.objects) do
        if effect.x == tab.x and effect.y == tab.y and effect.z == tab.z then
            if effect.emitter then
                effect.emitter:stopAll()
            end
            table.remove(BWOSound.objects, i)
            break
        end
    end
end

local function onTick()
    if isServer() then return end
    if not isIngameState() then return end

    local world = getWorld()
    local player = getSpecificPlayer(0)
    if not player then return end

    local pemitter = player:getEmitter()
    local px, py, pz = player:getX(), player:getY(), player:getZ()
    
    local volume = fixVolume(1)

    -- global looped emitters
    for _, effect in ipairs(BWOSound.global) do
        for _, megaphone in ipairs(BWOSound.megaphones.global) do
            if not megaphone.emitter then
                megaphone.emitter = world:getFreeEmitter(megaphone.x, megaphone.y, megaphone.z)
            end

            if not megaphone.emitter:isPlaying(effect.sound) then
                megaphone.emitter:playSound(effect.sound)
            end
            megaphone.emitter:setVolumeAll(volume)
        end
    end

    -- object looped emitters
    for _, effect in ipairs(BWOSound.objects) do
        if effect.x and effect.y and effect.z then

            local maxDist = effect.maxDist or BWOSound.maxDist
            if math.abs(effect.x - px) < maxDist and math.abs(effect.y - py) < maxDist and math.abs(effect.z - pz) < 1 then

                if not effect.emitter then
                    effect.emitter = world:getFreeEmitter(effect.x, effect.y, effect.z)
                end

                if effect.emitter then
                    effect.emitter:setPos(effect.x, effect.y, effect.z)
                    if not effect.emitter:isPlaying(effect.sound) then
                        local sid = effect.emitter:playSound(effect.sound)
                        effect.sid = sid
                        -- print (effect.sound .. " x: " .. effect.x .. " y: " .. effect.y .. " z: " .. effect.z)
                    end
                end
            else
                if effect.emitter then
                    effect.emitter:stopAll()
                    effect.emitter:tick()
                    effect.emitter = nil
                end
            end
        end
    end
end

Events.OnTick.Remove(onTick)
Events.OnTick.Add(onTick)
