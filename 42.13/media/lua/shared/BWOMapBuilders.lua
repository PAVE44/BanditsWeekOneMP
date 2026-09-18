BWOMap = BWOMap or {}

BWOMap.interactables = {}
BWOMap.map = {}
BWOMap.att = {}
BWOMap.fire = {}

BWOMap.trafficLights = {
    ["lighting_outdoor_01_12"] = "bwo_lighting_outdoor_01_12",
    ["lighting_outdoor_01_13"] = "bwo_lighting_outdoor_01_13",
    ["lighting_outdoor_01_14"] = "bwo_lighting_outdoor_01_14",
    ["lighting_outdoor_01_15"] = "bwo_lighting_outdoor_01_15",
    ["lighting_outdoor_01_20"] = "bwo_lighting_outdoor_01_20",
    ["lighting_outdoor_01_21"] = "bwo_lighting_outdoor_01_21",
    ["lighting_outdoor_01_22"] = "bwo_lighting_outdoor_01_22",
    ["lighting_outdoor_01_23"] = "bwo_lighting_outdoor_01_23",
    ["lighting_outdoor_01_59"] = "bwo_lighting_outdoor_01_59",
    ["lighting_outdoor_01_61"] = "bwo_lighting_outdoor_01_61",
    ["lighting_outdoor_01_66"] = "bwo_lighting_outdoor_01_66",
    ["lighting_outdoor_01_68"] = "bwo_lighting_outdoor_01_68",
    ["lighting_outdoor_01_74"] = "bwo_lighting_outdoor_01_74",
    ["lighting_outdoor_01_76"] = "bwo_lighting_outdoor_01_76",
    ["lighting_outdoor_01_83"] = "bwo_lighting_outdoor_01_83",
    ["lighting_outdoor_01_85"] = "bwo_lighting_outdoor_01_85",
}

BWOMap.builders = {}

BWOMap.builders.addBarricadeNorth = function(x1, x2, y)
    for x=x1, x2 do
        local z = 0
        local id 
        local sprite1
        local sprite2
        
        id = x .. "-" .. y .. "-" .. z
        if x % 2 == 0 then
            sprite1 = "fencing_01_88"
        else
            sprite1 = "fencing_01_89"
        end
        BWOMap.map[id] = {}
        table.insert(BWOMap.map[id], sprite1)

        id = x .. "-" .. (y - 1) .. "-" .. z
        if x % 3 == 0 then
            sprite2 = "fencing_01_96"
        else
            sprite2 = "carpentry_02_13"
        end
        BWOMap.map[id] = {}
        table.insert(BWOMap.map[id], sprite2)
    end
end

BWOMap.builders.addBarricadeSouth = function(x1, x2, y)
    for x=x1, x2 do
        local z = 0
        local id 
        local sprite1
        local sprite2
    
        id = x .. "-" .. y .. "-" .. z
        if x % 2 == 0 then
            sprite1 = "fencing_01_88"
        else
            sprite1 = "fencing_01_89"
        end
    
        if x % 3 == 0 then
            sprite2 = "fencing_01_96"
        else
            sprite2 = "carpentry_02_13"
        end
        BWOMap.map[id] = {}
        table.insert(BWOMap.map[id], sprite1)
        table.insert(BWOMap.map[id], sprite2)
    end
end

BWOMap.builders.addBarricadeWest = function(y1, y2, x)
    for y=y1, y2 do
        local z = 0
        local id 
        local sprite
        
        id = x .. "-" .. y .. "-" .. z
        if y % 2 == 0 then
            sprite = "fencing_01_90"
        else
            sprite = "fencing_01_91"
        end
        BWOMap.map[id] = {}
        table.insert(BWOMap.map[id], sprite)
    
        id = (x - 1) .. "-" .. y .. "-" .. z
        if y % 3 == 0 then
            sprite = "fencing_01_96"
        else
            sprite = "carpentry_02_12"
        end
        BWOMap.map[id] = {}
        table.insert(BWOMap.map[id], sprite)
    end
end

BWOMap.builders.addBarricadeEast = function(y1, y2, x)
    for y=y1, y2 do
        local z = 0
        local id 
        local sprite1
        local sprite2
    
        id = x .. "-" .. y .. "-" .. z
        if y % 2 == 0 then
            sprite1 = "fencing_01_90"
        else
            sprite1 = "fencing_01_91"
        end

        if y % 3 == 0 then
            sprite2 = "fencing_01_96"
        else
            sprite2 = "carpentry_02_12"
        end
        BWOMap.map[id] = {}
        table.insert(BWOMap.map[id], sprite1)
        table.insert(BWOMap.map[id], sprite2)
    end
end

BWOMap.builders.addZebraN = function(x1, y1, length)
    -- zebra
    local shape = {
        {y = 0, sprite = "street_trafficlines_01_6"},
        {y = 1, sprite = "street_trafficlines_01_32"},
        {y = 2, sprite = "street_trafficlines_01_32"},
        {y = 3, sprite = "street_trafficlines_01_2"},
    }
    for l = 1, length do
        for _, s in pairs(shape) do
            local x = x1 + l - 1
            local y = y1 + s.y
            local z = 0
            local id = x .. "-" .. y .. "-" .. z
            BWOMap.att[id] = {}
            table.insert(BWOMap.att[id], s.sprite)

            -- stopline
            if s.y == 0 and l <= length / 2 then
                table.insert(BWOMap.att[id], "street_trafficlines_01_34")
            end

        end
    end
end

BWOMap.builders.addZebraS = function(x1, y1, length)
    -- zebra
    local shape = {
        {y = 0, sprite = "street_trafficlines_01_6"},
        {y = 1, sprite = "street_trafficlines_01_32"},
        {y = 2, sprite = "street_trafficlines_01_32"},
        {y = 3, sprite = "street_trafficlines_01_2"},
    }
    for l = 1, length do
        for _, s in pairs(shape) do
            local x = x1 + l - 1
            local y = y1 + s.y
            local z = 0
            local id = x .. "-" .. y .. "-" .. z
            BWOMap.att[id] = {}
            table.insert(BWOMap.att[id], s.sprite)

            -- stopline
            if s.y == 3 and l > length / 2 then
                table.insert(BWOMap.att[id], "street_trafficlines_01_34")
            end

        end
    end
end

BWOMap.builders.addZebraNS = function(x1, y1, length)
    -- zebra
    local shape = {
        {y = 0, sprite = "street_trafficlines_01_6"},
        {y = 1, sprite = "street_trafficlines_01_32"},
        {y = 2, sprite = "street_trafficlines_01_32"},
        {y = 3, sprite = "street_trafficlines_01_2"},
    }
    for l = 1, length do
        for _, s in pairs(shape) do
            local x = x1 + l - 1
            local y = y1 + s.y
            local z = 0
            local id = x .. "-" .. y .. "-" .. z
            BWOMap.att[id] = {}
            table.insert(BWOMap.att[id], s.sprite)
        end
    end
end

BWOMap.builders.addZebraE = function(x1, y1, length)
    -- zebra
    local shape = {
        {x = 0, sprite = "street_trafficlines_01_4"},
        {x = 1, sprite = "street_trafficlines_01_34"},
        {x = 2, sprite = "street_trafficlines_01_34"},
        {x = 3, sprite = "street_trafficlines_01_0"},
    }
    for l = 1, length do
        for _, s in pairs(shape) do
            local x = x1 + s.x
            local y = y1 + l - 1
            local z = 0
            local id = x .. "-" .. y .. "-" .. z
            BWOMap.att[id] = {}
            table.insert(BWOMap.att[id], s.sprite)

            -- stopline
            if s.x == 3 and l <= length / 2 then
                table.insert(BWOMap.att[id], "street_trafficlines_01_32")
            end

        end
    end
end

BWOMap.builders.addZebraW = function(x1, y1, length)
    -- zebra
    local shape = {
        {x = 0, sprite = "street_trafficlines_01_4"},
        {x = 1, sprite = "street_trafficlines_01_34"},
        {x = 2, sprite = "street_trafficlines_01_34"},
        {x = 3, sprite = "street_trafficlines_01_0"},
    }
    for l = 1, length do
        for _, s in pairs(shape) do
            local x = x1 + s.x
            local y = y1 + l - 1
            local z = 0
            local id = x .. "-" .. y .. "-" .. z
            BWOMap.att[id] = {}
            table.insert(BWOMap.att[id], s.sprite)

            -- stopline
            if s.x == 0 and l > length / 2 then
                table.insert(BWOMap.att[id], "street_trafficlines_01_32")
            end

        end
    end
end

BWOMap.builders.addZebraEW = function(x1, y1, length)
    -- zebra
    local shape = {
        {x = 0, sprite = "street_trafficlines_01_4"},
        {x = 1, sprite = "street_trafficlines_01_34"},
        {x = 2, sprite = "street_trafficlines_01_34"},
        {x = 3, sprite = "street_trafficlines_01_0"},
    }
    for l = 1, length do
        for _, s in pairs(shape) do
            local x = x1 + s.x
            local y = y1 + l - 1
            local z = 0
            local id = x .. "-" .. y .. "-" .. z
            BWOMap.att[id] = {}
            table.insert(BWOMap.att[id], s.sprite)
        end
    end
end

BWOMap.builders.pavement = function(x, y)
    local z = 0
    local id = x .. "-" .. y .. "-" .. z
    BWOMap.map[id] = {}
    table.insert(BWOMap.map[id], "floors_exterior_tilesandstone_01_3")
end

BWOMap.builders.pavementS = function(x, y)
    local z = 0
    local id = x .. "-" .. y .. "-" .. z
    BWOMap.map[id] = {}
    table.insert(BWOMap.map[id], "floors_exterior_tilesandstone_01_3")

    BWOMap.att[id] = {}
    table.insert(BWOMap.att[id], "blends_natural_01_47")
end

BWOMap.builders.pavementN = function(x, y)
    local z = 0
    local id = x .. "-" .. y .. "-" .. z
    BWOMap.map[id] = {}
    table.insert(BWOMap.map[id], "floors_exterior_tilesandstone_01_3")

    BWOMap.att[id] = {}
    table.insert(BWOMap.att[id], "blends_natural_01_44")
end

BWOMap.builders.mailboxN = function(x, y)
    local z = 0
    local id = x .. "-" .. y .. "-" .. z
    BWOMap.map[id] = {}
    table.insert(BWOMap.map[id], "street_decoration_01_21")
end

BWOMap.builders.mailboxS = function(x, y)
    local z = 0
    local id = x .. "-" .. y .. "-" .. z
    BWOMap.map[id] = {}
    table.insert(BWOMap.map[id], "street_decoration_01_19")
end

BWOMap.builders.metaldrum = function(x, y)
    local z = 0
    local id = x .. "-" .. y .. "-" .. z
    BWOMap.fire[id] = {}
    table.insert(BWOMap.fire[id], "crafted_01_30")
end


BWOMap.builders.generic = function(x, y, sprite)
    local z = 0
    local id = x .. "-" .. y .. "-" .. z
    BWOMap.map[id] = BWOMap.map[id] or {}
    table.insert(BWOMap.map[id], sprite)
end

BWOMap.Register = function(builder, params)
    local builders = BWOMap.builders
    if builders[builder] then
        builders[builder](params[1], params[2], params[3], params[4], params[5], params[6])
    end
end

BWOMap.InteractableAdd = function(name, x, y, z)
    local interactables = BWOMap.interactables
    interactables[name] = interactables[name] or {}
    local id = x .. "-" .. y .. "-" .. z
    interactables[name][id] = {
        x = x,
        y = y,
        z = z,
    }
end

BWOMap.InteractableFind = function(name, x, y, z)
    local interactables = BWOMap.interactables
    if not interactables[name] then return nil end
    
    local distBest2 = math.huge
    local result = nil
    for id, data in pairs(interactables[name]) do
        local dist2 = ((data.x - x) * (data.x - x)) + ((data.y - y) * (data.y - y))
        if dist2 < distBest2 then
            distBest2 = dist2
            result = data
        end
    end
    return result, math.sqrt(distBest2)
end