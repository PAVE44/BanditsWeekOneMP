require "BWOAreas"

local function getRandomWorkAreaId()
    local choices = {}
    local areas = BWOAreas.areas
    for id, area in pairs(areas) do
        if area.exits and #area.exits > 0 then
            table.insert(choices, id)
        end
    end

    if #choices == 0 then
        return nil
    end

    return BanditUtils.Choice(choices)
end

local function processSquare(square)
    if isClient() then return end

    local test = BWOAreas.areas

    local area = BWOAreas.Find(square)
    if not area then return end

    if not area.pop then return end
    local popCount = #area.pop
    if popCount == 0 then return end

    local gmd = BWOGMD.GetServer()
    local popSpawned = gmd.areaData.popSpawned
    if not popSpawned[area.id] then
        popSpawned[area.id] = {}
    end

    local selectedNpc = nil
    local selectedNpcIdx = nil
    for i, npc in ipairs(area.pop) do
        if not popSpawned[area.id][i] then
            selectedNpc = npc
            selectedNpcIdx = i
            break
        end
    end

    local selectedSpawnSlot = nil
    if selectedNpc then
        local x, y, z = square:getX(), square:getY(), square:getZ()
        for _, spawnSlot in ipairs(area.spawnSlots) do
            if spawnSlot.x == x and spawnSlot.y == y and spawnSlot.z == z then
                selectedSpawnSlot = spawnSlot
                break
            end
        end
    end

    if selectedSpawnSlot then
        local player = BWOUtils.GetClosestPlayer(selectedSpawnSlot.x, selectedSpawnSlot.y)
        if not player then return end

        local occupation = {
            role = selectedNpc.role,
            hid = area.id,
            wid = selectedNpc.data.workAreaId, -- getRandomWorkAreaId(),
        }

        local args = {
            cid = Bandit.clanMap.Resident,
            program = "Resident",
            hostile = false,
            x = selectedSpawnSlot.x,
            y = selectedSpawnSlot.y,
            z = selectedSpawnSlot.z,
            size = 1,
            occupation = occupation,
        }
        BanditServer.Spawner.Clan(player, args)

        popSpawned[area.id][selectedNpcIdx] = true
    end
end

Events.LoadGridsquare.Remove(processSquare)
Events.LoadGridsquare.Add(processSquare)