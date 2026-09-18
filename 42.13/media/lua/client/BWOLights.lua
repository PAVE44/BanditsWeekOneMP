BWOLights = BWOLights or {}

BWOLights.tab = {}

BWOLights.Add = function(x, y, z, params)
    local data = {
        x = x, 
        y = y, 
        z = z, 
        params = params,
        upd = getTimestampMs()
    }
    table.insert(BWOLights.tab, data)
end

local getPower = function(x, y, z)
    local square = getCell():getGridSquare(x, y, -2)
    if square then
        local generator = square:getGenerator()
        if generator then
            return generator
        end
    end
    return nil
end

local manageLights = function()
    local gameTime = getGameTime()
    local worldAgeHours = gameTime:getWorldAgeHours()
    local dayLengthMinutes = getSandboxOptions():getDayLengthMinutes()
    local worldAgeSeconds = math.floor(worldAgeHours * 3600 * dayLengthMinutes / 120)

    for _, light in ipairs(BWOLights.tab) do
        if not light.state then
            light.state = false
        end
        if light.params.oscillator then
            local phase = light.params.oscillator
            local desiredState
            if worldAgeSeconds % phase == 0 then
                desiredState = true
            end
            if worldAgeSeconds % phase == phase / 2 then
                desiredState = false
            end
            if desiredState ~= nil and light.state ~= desiredState then
                light.state = desiredState
                -- print ("Light state changed: " .. tostring(desiredState))

                local gen = getPower(light.x, light.y, light.z)
                if gen then
                    gen:setActivated(desiredState)

                    --[[
                    local cell = getCell()
                    if desiredState == false then
                        local ls = cell:getLightSourceAt(light.x, light.y, 0)
                        if ls then
                            getCell():removeLamppost(ls)
                        end
                    elseif desiredState == true then
                        local ls = IsoLightSource.new(light.x, light.y, 0, 1, 0.35, 0.08, 2, 15)
                        getCell():addLamppost(ls)
                    end
                    ]]
                end
            end
        end
    end
end

Events.OnTick.Add(manageLights)