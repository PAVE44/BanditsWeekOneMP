BWODevTools = BWODevTools or {}

-- building / room scanner

--[[
-- test
BWODevTools.scanArea = {
    x1 = 11800,
    y1 = 6800,
    x2 = 12000,
    y2 = 7000,
}
]]

-- westpoint
BWODevTools.scanArea = {
    x1 = 10871,
    y1 = 6600,
    x2 = 12175,
    y2 = 7170,
}

BWODevTools.cursor = {
    x = BWODevTools.scanArea.x1,
    y = BWODevTools.scanArea.y1,
    dir = 1
}

BWODevTools.step = 20

local known = {}

local saveRoom = function(area)
    local fileWriter = getFileWriter("area-" .. area.type .. "-" .. area.id .. ".txt", true, true)

    local lines = {}
    table.insert(lines, "BWOAreas = BWOAreas or {}\n")
    table.insert(lines, "BWOAreas.areas = BWOAreas.areas or {}\n")
    table.insert(lines, "BWOAreas.areas[\"" .. area.id .. "\"] = {\n")
    
    for k, v in pairs(area) do
        if type(v) == "string" then
            table.insert(lines, "    " .. k .. " = \"" .. v .. "\",\n")
        elseif type(v) == "number" then
            table.insert(lines, "    " .. k .. " = " .. v .. ",\n")
        elseif type(v) == "table" then
            table.insert(lines, "    " .. k .. " = {\n")
            for _, t in ipairs(v) do
                table.insert(lines, "        {")
                for tk, tv in pairs(t) do
                    if type(tv) == "string" then
                        table.insert(lines, tk .. "=\"" .. tv .. "\", ")
                    elseif type(tv) == "number" then
                        table.insert(lines, tk .. "=" .. tv .. ", ")
                    end
                end
                table.insert(lines, "},\n")
            end
            table.insert(lines, "    },\n")
        end
    end

    table.insert(lines, "}\n")
    for _, line in ipairs(lines) do
        fileWriter:write(line)
    end
    fileWriter:close()
end

BWODevTools.ScanRooms = function(player)

    local function randomSelectTab(t, n)
        local count = #t

        if count <= n then
            return t
        end

        -- Partial Fisher-Yates shuffle
        for i = 1, n do
            local j = i + ZombRand(count - i + 1)
            t[i], t[j] = t[j], t[i]
        end

        -- Remove everything after the first n
        for i = count, n + 1, -1 do
            t[i] = nil
        end

        return t
    end

    local getAreaType = function(square)
        local area

        local room = square:getRoom()
        local z = square:getZ()
        if room then
            for roomName, areaType in pairs(BWOAreas.room2AreaType) do
                if BWOAreas.areaTypes[areaType] and room:getName() == roomName then
                    local roomDef = room:getRoomDef()
                    if roomDef then
                        area = {}
                        area.type = areaType
                        area.x = roomDef:getX()
                        area.y = roomDef:getY()
                        area.x2 = roomDef:getX2()
                        area.y2 = roomDef:getY2()
                        area.id = BWOUtils.CoordId(area.x, area.y)
                        area.exits = {}
                        area.interactables = {}
                        area.spawnSlots = {}
                        for x=area.x, area.x2 + 1 do
                            for y=area.y, area.y2 + 1 do
                                local square = getCell():getGridSquare(x, y, z)
                                if square then
                                    -- exit
                                    local door = square:getIsoDoor()
                                    if door then
                                        local inRoom = square:getRoom() and true or false
                                        local oppositeIsRoom = door:getOppositeSquare() and door:getOppositeSquare():getRoom() and true or false
                                        if inRoom ~= oppositeIsRoom then
                                            table.insert(area.exits, {x=x, y=y, z=z})
                                        end
                                    end

                                    -- spawn slots
                                    if square:isFree(false) then
                                        table.insert(area.spawnSlots, {x=x, y=y, z=z})
                                    end
                                end
                            end
                        end
                        area.spawnSlots = randomSelectTab(area.spawnSlots, 16)

                        local buildingDef = roomDef:getBuilding()
                        if #area.exits > 0 and buildingDef and buildingDef:isFullyStreamedIn() then
                            local bx1 = buildingDef:getX()
                            local by1 = buildingDef:getY()
                            local bx2 = buildingDef:getX2()
                            local by2 = buildingDef:getY2()
                            for x=bx1, bx2 do
                                for y=by1, by2 do
                                    for z = 0, 2 do
                                        local square = getCell():getGridSquare(x, y, z)
                                        if square then
                                            local objects = square:getObjects()
                                            for i=0, objects:size()-1 do
                                                local object = objects:get(i)
                                                if object then
                                                    local sprite = object:getSprite()
                                                    if sprite then
                                                        local props = sprite:getProperties()

                                                        if BWOAreas.areaTypes[areaType].interactables then
                                                            if props:has("CustomName") then
                                                                customName = props:get("CustomName")
                                                                for _, interactable in ipairs(BWOAreas.areaTypes[areaType].interactables) do
                                                                    if customName == interactable then
                                                                        table.insert(area.interactables, {x=x, y=y, z=z,type=customName})
                                                                    end
                                                                end
                                                            end
                                                        end
                                                    end
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                    break
                end
            end
        end
        return area
    end

    local advanceCursorSnake = function()
        local cursor = BWODevTools.cursor
        local area = BWODevTools.scanArea
        local step = BWODevTools.step

        local nextX = cursor.x + (step * cursor.dir)

        if cursor.dir == 1 and nextX > area.x2 then
            cursor.y = cursor.y + step
            if cursor.y > area.y2 then
                return false
            end
            cursor.dir = -1
            cursor.x = area.x2
            return true
        end

        if cursor.dir == -1 and nextX < area.x1 then
            cursor.y = cursor.y + step
            if cursor.y > area.y2 then
                return false
            end
            cursor.dir = 1
            cursor.x = area.x1
            return true
        end

        cursor.x = nextX
        return cursor.y <= area.y2
    end

    local px, py = BWODevTools.cursor.x, BWODevTools.cursor.y
    local step = BWODevTools.step
    local halfStep = step / 2
    for x = px - halfStep, px + halfStep do
        for y = py - halfStep, py + halfStep do
            local square = getCell():getGridSquare(x, y, 0)
            if square then
                local area = getAreaType(square)
                if area and not known[area.id] then
                    known[area.id] = area
                    saveRoom(area)
                end
            end
        end
    end

    if advanceCursorSnake() then

        local args = {
            {{"ScanRooms", {x = BWODevTools.cursor.x, y = BWODevTools.cursor.y}}, 300},
        }

        sendClientCommand(player, "EventManager", "AddSequence", args)

        player:teleportTo(BWODevTools.cursor.x, BWODevTools.cursor.y, 0)
    end
end

BWODevTools.RescanArea = function(player, areaid)
    local area = BWOAreas.Get(areaid)
    if area then
       area.interactables = {}
       for x=area.x, area.x2 do
            for y=area.y, area.y2 do
                for z = 0, 2 do
                    local square = getCell():getGridSquare(x, y, z)
                    if square then
                        local objects = square:getObjects()
                        for i=0, objects:size()-1 do
                            local object = objects:get(i)
                            if object then
                                local sprite = object:getSprite()
                                if sprite then
                                    local props = sprite:getProperties()

                                    if BWOAreas.areaTypes[area.type].interactables then
                                        if props:has("CustomName") then
                                            customName = props:get("CustomName")
                                            for _, interactable in ipairs(BWOAreas.areaTypes[area.type].interactables) do
                                                if customName == interactable then
                                                    table.insert(area.interactables, {x=x, y=y, z=z,type=customName})
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
        saveRoom(area)
    end
end