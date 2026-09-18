BWODevTools = BWODevTools or {}

-- nav dump
BWODevTools.DumpNav = function(player)
    local gmd = BWOGMD.Get()
    local nav = gmd.nav


    local fileWriter = getFileWriter("nav-walk.txt", true, true)

    local lines = {}
    table.insert(lines, "BWONavigation = BWONavigation or {}\n")
    table.insert(lines, "BWONavigation.walk = BWONavigation.walk or {}\n")

    for k, v in pairs(nav) do
        if v.x and v.y and v.links and not v.v then
            table.insert(lines, "BWONavigation.walk[\"" .. k .. "\"] = {\n")
            table.insert(lines, "    x = " .. v.x .. ",\n")
            table.insert(lines, "    y = " .. v.y .. ",\n")
            table.insert(lines, "    links = {\n")
            for nodeId, cost in pairs(v.links) do
                table.insert(lines, "        [\"" .. nodeId .. "\"] = " .. cost .. ",\n")
            end
            table.insert(lines, "    },\n")
            table.insert(lines, "}\n")
        end
    end

    for _, line in ipairs(lines) do
        fileWriter:write(line)
    end
    fileWriter:close()

    local fileWriter = getFileWriter("nav-drive.txt", true, true)

    local lines = {}
    table.insert(lines, "BWONavigation = BWONavigation or {}\n")
    table.insert(lines, "BWONavigation.drive = BWONavigation.drive or {}\n")

    for k, v in pairs(nav) do
        if v.x and v.y and v.links and v.v then
            table.insert(lines, "BWONavigation.drive[\"" .. k .. "\"] = {\n")
            table.insert(lines, "    x = " .. v.x .. ",\n")
            table.insert(lines, "    y = " .. v.y .. ",\n")
            table.insert(lines, "    links = {\n")
            for nodeId, cost in pairs(v.links) do
                table.insert(lines, "        [\"" .. nodeId .. "\"] = " .. cost .. ",\n")
            end
            table.insert(lines, "    },\n")
            table.insert(lines, "}\n")
        end
    end

    for _, line in ipairs(lines) do
        fileWriter:write(line)
    end
    fileWriter:close()
end

BWODevTools.LoadNav = function(player)
    local gmd = BWOGMD.Get()
    local walk = BWONavigation.walk
    gmd.nav = {}
    for k, v in pairs(walk) do
        gmd.nav[k] = v
    end

    local drive = BWONavigation.drive
    for k, v in pairs(drive) do
        gmd.nav[k] = v
        gmd.nav[k].v = true
    end
end

