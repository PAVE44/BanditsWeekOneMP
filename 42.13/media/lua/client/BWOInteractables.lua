BWOInteractables = BWOInteractables or {}

BWOInteractables.map = {}
BWOInteractables.map.grill = {}
BWOInteractables.map.sittable = {}
BWOInteractables.map.trashcan = {}
BWOInteractables.map.shopshelf = {}


local isTaken = function(bandit, x, y, z)
    -- skip objects that are already occupied by other character
    local taken = false
    local bid = BanditUtils.GetZombieID(bandit)
    local taken = false
    local square = getCell():getGridSquare(x, y, z)
    if square then
        local chrs = square:getMovingObjects()
        for i=0, chrs:size()-1 do
            local chr = chrs:get(i)
            if instanceof(chr, "IsoZombie") and BanditUtils.GetZombieID(chr) == bid then
                taken = false
            else
                taken = true
                break
            end
        end
    end
    return taken
end

--[[
local isShopShelf = function(groupName, customName)
    local defs = {
        ["Shelves"] = {"Large Shop", "Trapzoid Shop", "Generic Cooled", "Beige Rack Shop"},
        ["Counter"] = {"Shop Display", "Zippee", "Fossoil", "Fossoil Corner", "Gas2Go", "Gas2Go Corner"},
        ["Rack"] = {"Zippee Shelves"},
        ["Fridge"] = {"Large"},
        ["Freezer"] = {"Popsicle"},
    }
    for cn, groups in pairs(defs) do
        if cn == customName then
            for _, gn in ipairs(groups) do
                if gn == groupName then
                    return true
                end
            end
        end
    end
    return false
end
]]

local isSeatable = function(groupName, customName)
    local defs = {
        "Bench", "Seat", "Chair", "Toilet"
    }

    for _, cn in ipairs(defs) do
        if cn == customName then
            return true
        end
    end
    return false
end

local isTrashcan = function(groupName, customName)
    local defs = {
        "Dumpster", "Recycle Bin", "Fossoil Garbage", "Grey Garbage"
    }

    for _, cn in ipairs(defs) do
        if cn == customName then
            return true
        end
    end
    return false
end

local isShop = function(square)
    local room = square:getRoom()
    if room then
        return BWORooms.IsShop(room)
    end
    return false
end

local isShopShelf = function(groupName, customName)
    local defs = {
        "Shelves", "Counter", "Rack", "Fridge", "Freezer", "Bar", "Crate", "Cartbox"
    }

    for _, cn in ipairs(defs) do
        if cn == customName then
            return true
        end
    end
    return false
end

BWOInteractables.Remove = function(x, y, z)
    local map = BWOInteractables.map

    for itype, tab in pairs(map) do
        for id, data in pairs(tab) do
            if data.x == x and data.y == y and data.z == z then
                map[itype][id] = nil
                return
            end
        end
    end
end

BWOInteractables.Find = function(bandit, itype, dsq, multi)
    local map = BWOInteractables.map[itype]
    if not map then return end

    local bx, by, bz = bandit:getX(), bandit:getY(), bandit:getZ()
    local distBest = math.huge
    local ret = false

    for id, data in pairs(map) do
        if data.z == bz then
            local distSq = ((bx - data.x) * (bx - data.x)) + ((by - data.y) * (by - data.y))
            if distSq < dsq and distSq < distBest and (multi or not isTaken(bandit, data.x, data.y, data.z)) then
                ret = data
                ret.dsq = distSq
                distBest = distSq
            end
        end
    end
    return ret
end

local processSquare = function(square)
    local map = BWOInteractables.map
    local sx, sy, sz = square:getX(), square:getY(), square:getZ()
    local id = sx .. "-" .. sy .. "-" .. sz
    local data = {x = sx, y = sy, z = sz}
    local objects = square:getObjects()
    for i=0, objects:size()-1 do
        local object = objects:get(i)
        local container = object:getContainer()

        local sprite = object:getSprite()
        if sprite then
            local props = sprite:getProperties()
            if props then
                if instanceof(object, "IsoBarbecue") then
                    map.grill[id] = data
                    return
                end

                if props:has("GroupName") and props:has("CustomName") then
                    local groupName = props:get("GroupName")
                    local customName = props:get("CustomName")
                    if isSeatable(groupName, customName)  then
                        if props:has("Facing") then
                            data.f = props:get("Facing")
                            data.cn = customName
                            map.sittable[id] = data
                            return
                        end
                    elseif isTrashcan(groupName, customName)  then
                        if container and not container:isEmpty() then
                            data.cn = customName
                            map.trashcan[id] = data
                        end
                    elseif isShop(square) and isShopShelf(groupName, customName) then
                        if container and not container:isEmpty() then
                            data.cn = customName
                            map.shopshelf[id] = data
                        end
                    end
                end
            end
        end
    end
end

Events.LoadGridsquare.Add(processSquare)