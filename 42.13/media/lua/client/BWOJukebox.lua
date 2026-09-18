BWOJukebox = BWOJukebox or {}

BWOJukebox.jukeboxes = {}

BWOJukebox.playlist = {
    {clip = "JukeboxRaps", title = "Rhythm of 93"},
    {clip = "JukeboxParty2", title = "Neon Rewind"},
    {clip = "JukeboxRaps", title = "Neon Nights"},
}

BWOJukebox.Add = function (x, y, z)
    local id = tostring(x) .. "." .. tostring(y) .. "." .. tostring(z)
    BWOJukebox.jukeboxes[id] = {
        x = x, 
        y = y, 
        z = z,
        sound = nil,
        on = false
    }
    return BWOJukebox.jukeboxes[id]
end

BWOJukebox.FindClosest = function (x, y, z)
    local closest
    local distBest = math.huge
    for id, jukebox in pairs(BWOJukebox.jukeboxes) do
        if jukebox.on then
            local distSq = ((jukebox.x - x) * (jukebox.x - x)) + ((jukebox.y - y) * (jukebox.y - y)) + ((jukebox.z - z) * (jukebox.z - z))
            if distSq < distBest then
                closest = jukebox
                distBest = distSq
            end
        end
    end
    return closest, math.sqrt(distBest)
end

BWOJukebox.Remove = function (x, y, z)
    local id = tostring(x) .. "." .. tostring(y) .. "." .. tostring(z)
    BWOJukebox.jukeboxes[id] = nil
end

BWOJukebox.Get = function (x, y, z)
    local id = tostring(x) .. "." .. tostring(y) .. "." .. tostring(z)
    return BWOJukebox.jukeboxes[id]
end

BWOJukebox.TurnOn = function (x, y, z)
    local jukeboxes = BWOJukebox.jukeboxes
    local id = tostring(x) .. "." .. tostring(y) .. "." .. tostring(z)
    if jukeboxes[id] then
        jukeboxes[id].on = true
    end
end

BWOJukebox.TurnOff = function (x, y, z)
    local jukeboxes = BWOJukebox.jukeboxes
    local id = tostring(x) .. "." .. tostring(y) .. "." .. tostring(z)
    if jukeboxes[id] then
        jukeboxes[id].on = false
    end
end

local function everyOneMinute()
    local jukeboxes = BWOJukebox.jukeboxes
    local playlist = BWOJukebox.playlist
    for id, jukebox in pairs(jukeboxes) do
        -- ensure it exists
        local square = getCell():getGridSquare(jukebox.x, jukebox.y, jukebox.z)
        if square then
            local isoJukebox = BanditUtils.GetIsoObject(jukebox.x, jukebox.y, jukebox.z, "Boombox") or BanditUtils.GetIsoObject(jukebox.x, jukebox.y, jukebox.z, "Jukebox")
            if not isoJukebox then
                BWOSound.RemoveFromObject({x = jukebox.x, y = jukebox.y, z = jukebox.z, sound = jukebox.sound})
                BWOJukebox.Remove(jukebox.x, jukebox.y, jukebox.z)
                return
            end
            if jukebox.on then
                local choice = BanditUtils.Choice(playlist)
                jukebox.sound = choice.clip
                BWOSound.AddToObject({x = jukebox.x, y = jukebox.y, z = jukebox.z, sound = jukebox.sound, maxDist=21, volume = 0.4})
            else
                BWOSound.RemoveFromObject({x = jukebox.x, y = jukebox.y, z = jukebox.z, sound = jukebox.sound})
            end
        end
    end
end

Events.EveryOneMinute.Remove(everyOneMinute)
Events.EveryOneMinute.Add(everyOneMinute)