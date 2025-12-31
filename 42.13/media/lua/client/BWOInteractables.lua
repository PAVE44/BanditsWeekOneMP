BWOInteractables = BWOInteractables or {}

BWOInteractables.map = {}
BWOInteractables.map.grill = {}
BWOInteractables.map.sittable = {}

local processSquare = function(square)
    local map = BWOInteractables.map
    local sx, sy, sz = square:getX(), square:getY(), square:getZ()
    local id = sx .. "-" .. sy .. "-" .. sz
    local objects = square:getObjects()
    for i=0, objects:size()-1 do
        local object = objects:get(i)
        local sprite = object:getSprite()
        if sprite then
            local props = sprite:getProperties()
            if props then
                if instanceof(object, "IsoBarbecue") then
                    map.grill[id] = {}
                    return
                end

                if props:has("CustomName") then
                    local customName = props:get("CustomName")
                    if customName == "Bench" or customName == "Chair" then
                        map.sittable[id] = {}
                        return
                    end
                end
            end
        end
    end
end

Events.LoadGridsquare.Add(processSquare)