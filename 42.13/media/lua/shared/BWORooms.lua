BWORooms = {}

BWORooms.cache = {}

BWORooms.UpdateCache = function()
    local cache = {}
    local i = 0
    local defs = getWorld():getMetaGrid():getBuildings()
    for i=0, defs:size()-1 do
        local def = defs:get(i)
        local roomDefs = def:getRooms()
        for i=0, roomDefs:size()-1 do
            local roomDef = roomDefs:get(i)
            local x = (roomDef:getX() + roomDef:getX2()) / 2
            local y = (roomDef:getY() + roomDef:getY2()) / 2
            local z = roomDef:getZ()
            local name = roomDef:getName()
            table.insert(cache, {x=x, y=y, z=z, name=name})
            i = i + 1
        end
    end
    BWORooms.cache = cache
    return i
end

local function onGameStart()
    BWORooms.UpdateCache()
end

Events.OnGameStart.Remove(onGameStart)
Events.OnGameStart.Add(onGameStart)