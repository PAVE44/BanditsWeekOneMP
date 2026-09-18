RemotePrograms = RemotePrograms or {}

RemotePrograms.Resident = {}

RemotePrograms.Resident.Main = function(brain)
    local bx, by = brain.lastSeen.x, brain.lastSeen.y

    local occupation = brain.occupation
    
    if occupation and occupation.wid then
        local wid = occupation.wid
        local workArea = BWOAreas.Get(wid)
        if workArea then
            if workArea.exits then
                local target = {}
                local bestDist = math.huge
                for _, exit in ipairs(workArea.exits) do
                    local dist = BanditUtils.DistTo(bx, by, exit.x, exit.y)
                    if dist < bestDist then
                        bestDist = dist
                        target = exit
                    end
                end

                local s = 5
                if target.x and target.y then
                    local dx = target.x - bx
                    local dy = target.y - by
                    local dist = math.sqrt(dx * dx + dy * dy)

                    if dist > 0 then
                        local step = math.min(s, dist)
                        bx = bx + dx / dist * step
                        by = by + dy / dist * step
                        brain.lastSeen.x = bx
                        brain.lastSeen.y = by
                    end
                end
            end
        end
    end
end
