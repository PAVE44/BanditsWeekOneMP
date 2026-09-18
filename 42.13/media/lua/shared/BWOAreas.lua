BWOAreas = BWOAreas or {}

-- NPCs role depends on the areaType it is in
BWOAreas.areaTypes = {
    aesthetic = {},
    bakery = {},
    bank = {},
    bar = {},
    bookstore = {},
    church = {},
    clothingstore = {},
    daycare = {},
    electronicstore = {},
    fishing = {},
    furniturestore = {},
    garage = {},
    gunstore = {},
    mechanic = {},
    medical = {},
    movierental = {},
    office = {},
    pharmacy = {},
    police = {},
    post = {},
    restaurant = {},
    school = {},
    stage = {},
    residential = {},
    toolstore = {},
}
-- these define what objects will be registered as useful interactables for the npc programs
BWOAreas.areaTypes.aesthetic = {
    interactables = {"Chair", "Hair Dryer", "Register"}
}
BWOAreas.areaTypes.bakery = {
    interactables = {"Register", "Stand", "Chair", "Table", "Fridge", "Counter", "Oven", "Phone"}
}
BWOAreas.areaTypes.bank = {
    interactables = {"Vault", "Chair", "Counter", "Couch"}
}
BWOAreas.areaTypes.bar = {
    interactables = {"Register", "Antique", "Chair", "Counter", "Table", "Bar Stool", "Seating", "Bar", "Fridge", "Fireplace"}
}
BWOAreas.areaTypes.church = {
    interactables = {"Altar", "Stand", "Pew", "Organ", "Stool"}
}
BWOAreas.areaTypes.clothingstore = {
    interactables = {"Register", "Rack", "Shelves", "Wardrobe", "Phone"}
}
BWOAreas.areaTypes.grocery = {
    interactables = {"Register", "Shelves", "Counter", "Fridge", "Magazine Stand", "Phone"}
}
BWOAreas.areaTypes.gunstore = {
    interactables = {"Register", "Counter", "Shelves", "Locker", "Magazine Stand", "Phone"}
}
BWOAreas.areaTypes.movierental = {
    interactables = {"Register", "Shelves", "Magazine Stand", "Television", "Phone"}
}
BWOAreas.areaTypes.pharmacy = {
    interactables = {"Register", "Shelves", "Cabinet", "Counter", "Fridge", "Magazine Stand", "Phone"}
}
BWOAreas.areaTypes.office = {
    interactables = {"Chair", "Computer"}
}
BWOAreas.areaTypes.police = {
    interactables = {"Desk", "Chair"}
}
BWOAreas.areaTypes.residential = {
    interactables = {"Bed", "Couch", "Chair", "Table", "Fridge", "Oven", "Piano", "Stool", "Television", "Radio", "Phone", "Fireplace", "Sink", "Toilet", "Shelves"}
}
BWOAreas.areaTypes.restaurant = {
    interactables = {"Register", "Seat", "Picknic Table", "Chair", "Table", "Blue Bar Stool", "Fridge", "Counter", "Oven", "Industrial 2000", "Phone"}
}
BWOAreas.areaTypes.school = {
    interactables = {"School Bench", "Chair", "Board", "Picknic Table"}
}
BWOAreas.areaTypes.stage = {
    interactables = {"Microphone"}
}

-- which of the interactables are container of items
BWOAreas.interactableContainers = {
    "Desk", "Fridge", "Oven", "Cabinet", "Locker", "Wardrobe", "Shelves", "Counter", "Magazine Stand"
}

-- mapping of in-game room names to area types
BWOAreas.room2AreaType = {
    aesthetic = "aesthetic",
    bakery = "bakery",
    bank = "bank",
    bar = "bar",
    bookstore = "bookstore",
    cafe = "restaurant",
    church = "church",
    clinic = "medical",
    clothesstore = "clothingstore",
    cornerstore = "grocery",
    conviniencestore = "grocery",
    daycare = "daycare",
    dining_crepe = "restaurant",
    electronicstore = "electronicstore",
    elementaryhall = "school",
    fishing = "fishing",
    furniturestore = "furniturestore",
    garage = "garage",
    garagestorage = "garage",
    gasstore = "grocery",
    generalstore = "grocery",
    gigamart = "grocery",
    grocery = "grocery",
    gunstore = "gunstore",
    livingroom = "residential",
    mechanic = "mechanic",
    medical = "medical",
    movierental = "movierental",
    office = "office",
    pharmacy = "pharmacy",
    pizzawhirled = "restaurant",
    policeoffice = "police",
    post = "post",
    restaurant = "restaurant",
    restaurantdining = "restaurant",
    spiffo_dining = "restaurant",
    stage = "stage",
    toolstore = "toolstore",
    zippeestore = "grocery",
}

-- which area types are considered shopping areas
BWOAreas.shoppingAreaTypes = {
    grocery = true,
    clothingstore = true,
    furniturestore = true,
    electronicstore = true,
    pharmacy = true,
    toolstore = true,
    bookstore = true
}

local getRandomResidentialArea = function(mx, my, dist)
    local candidates = {}
    for id, area in pairs(BWOAreas.areas) do
        if area.type == "residential" then
            local ax = (area.x + area.x2) / 2
            local ay = (area.y + area.y2) / 2
            if BanditUtils.DistTo(ax, ay, mx, my) <= dist then
                if area.pop and #area.pop > 0 then
                    for i=1, #area.pop do
                        if area.pop[i].role == "unemployed" then
                            table.insert(candidates, area)
                            break
                        end
                    end
                end
            end
        end
    end

    if #candidates > 0 then
        local idx = 1 + ZombRand(#candidates)
        return candidates[idx].id
    end

    return nil
end

-- mapping of area types to the roles that typically inhabit them, the amount of roles
-- is counted by the number of interactables multiplied by proportion
BWOAreas.area2role = {
    aesthetic = {
        [1] = {
            interactables = {"Hair Dryer"},
            role = "hairdresser",
            proportion = 2.0,
        },
        [1] = {
            interactables = {"Register"},
            role = "cashier",
            proportion = 1.0,
        }
    },
    bakery = {
        [1] = {
            interactables = {"Oven"},
            role = "cook",
            proportion = 1.0,
        },
        [2] = {
            interactables = {"Register"},
            role = "cashier",
            proportion = 1.0,
        }
    },
    bank = {
        [1] = {
            interactables = {"Vault"},
            role = "security",
            proportion = 0.5,
        },
        [2] = {
            interactables = {"Vault"},
            role = "banker",
            proportion = 0.5,
        },
    },
    bar = {
        [1] = {
            interactables = {"Antique"}, -- that antique tap
            role = "barman",
            proportion = 1.0,
        },
    },
    bookstore = {
        [1] = {
            interactables = {"Register"},
            role = "cashier",
            proportion = 1.0,
        },
    },
    clothingstore = {
        [1] = {
            interactables = {"Register"},
            role = "cashier",
            proportion = 1.0,
        },
    },
    church = {
        [1] = {
            interactables = {"Altar"},
            role = "priest",
            proportion = 1.0,
        },
    },
    grocery = {
        [1] = {
            interactables = {"Register"},
            role = "cashier",
            proportion = 1.0,
        },
    },
    gunstore = {
        [1] = {
            interactables = {"Register"},
            role = "cashier",
            proportion = 1.0,
        },
    },
    medical = {
        [1] = {
            interactables = {"Workstation"},
            role = "doctor",
            proportion = 1.0,
        },
    },
    office = {
        [1] = {
            interactables = {"Computer"},
            role = "office",
            proportion = 1.0,
        },
    },
    pharmacy = {
        [1] = {
            interactables = {"Register"},
            role = "cashier",
            proportion = 1.0,
        },
    },
    police = {
        [1] = {
            interactables = {"Desk"},
            role = "police",
            proportion = 0.5,
        },
    },
    post = {
        [1] = {
            interactables = {"Cartbox"},
            role = "postman",
            proportion = 1.0,
        }
    },
    restaurant = {
        [1] = {
            interactables = {"Oven"},
            role = "cook",
            proportion = 1.0,
        },
        [2] = {
            interactables = {"Table"},
            role = "waiter",
            proportion = 0.2,
        },
        [3] = {
            interactables = {"Register"},
            role = "cashier",
            proportion = 1,
        },
    },
    school = {
        [1] = {
            interactables = {"Board"},
            role = "teacher",
            proportion = 0.1,
        },
        [2] = {
            interactables = {"School Bench"},
            role = "student",
            proportion = 0.5,
        },
    },
}

BWOAreas.independentRoles = {
    janitor = 5,
}

-- extends area data with precomputed data for easier access
-- serverside!
BWOAreas.ExtendData = function()

    -- extend with the NPC population data
    for id, area in pairs(BWOAreas.areas) do
        if area.interactables then
            if area.type == "residential" then
                area.pop = {}
                local beds = 0
                for _, interactable in ipairs(area.interactables) do
                    if interactable.type == "Bed" then
                        beds = beds + 1
                    end
                end
                beds = math.ceil(beds / 2) -- 1 bed occupies 2 squares
                for i=1, beds do
                    table.insert(area.pop, {role = "unemployed", data = {}})
                end
            end
        end
    end

    -- assign npcs to jobs
    for id, area in pairs(BWOAreas.areas) do
        if area.interactables and area.type ~= "residential" then
            local roleSpecs = BWOAreas.area2role[area.type]
            if roleSpecs then
                local mx = (area.x + area.x2) / 2
                local my = (area.y + area.y2) / 2
                for _, roleSpec in ipairs(roleSpecs) do
                    local interactableCount = 0
                    for _, interactable in ipairs(area.interactables) do
                        for _, interactableType in ipairs(roleSpec.interactables or {}) do
                            if interactable.type == interactableType then
                                interactableCount = interactableCount + 1
                                break
                            end
                        end
                    end

                    local proportion = roleSpec.proportion or 0
                    local workSlot = math.ceil(interactableCount * proportion)
                    for i=1, workSlot do
                        local assignedAreaId = getRandomResidentialArea(mx, my, 300)
                        if assignedAreaId then
                            local assignedArea = BWOAreas.areas[assignedAreaId]
                            if assignedArea and assignedArea.pop then
                                for _, npc in ipairs(assignedArea.pop) do
                                    if npc.role == "unemployed" then
                                        npc.role = roleSpec.role
                                        npc.data.workAreaId = id
                                        print ("[BWOAreas][INFO] Assigned NPC from area " .. assignedAreaId .. " to work in area " .. id .. " as " .. roleSpec.role)
                                        break
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end

        -- assign npcs to non-area dependent jobs
    for role, cnt in pairs(BWOAreas.independentRoles) do
        for i=1, cnt do
            local cityCenter = {
                x = 11920,
                y = 6900
            }
            local assignedAreaId = getRandomResidentialArea(cityCenter.x, cityCenter.y, 300)
            if assignedAreaId then
                local assignedArea = BWOAreas.areas[assignedAreaId]
                if assignedArea and assignedArea.pop then
                    for _, npc in ipairs(assignedArea.pop) do
                        if npc.role == "unemployed" then
                            npc.role = role
                            print ("[BWOAreas][INFO] Assigned NPC from area " .. assignedAreaId .. " to work as " .. role)
                            break
                        end
                    end
                end
            end
        end
    end
end

BWOAreas.PrintResidentialPopulationStats = function()
    local totalResidentialAreas = 0
    local totalPopulation = 0
    local totalUnemployed = 0
    local totalEmployed = 0
    local totalEmployedByRole = {}

    for id, area in pairs(BWOAreas.areas) do
        if area.type == "residential" then
            totalResidentialAreas = totalResidentialAreas + 1
            local areaPopulation = 0
            local areaUnemployed = 0
            local areaEmployed = 0
            local areaEmployedByRole = {}

            if area.pop then
                for _, npc in ipairs(area.pop) do
                    areaPopulation = areaPopulation + 1
                    if npc.role == "unemployed" then
                        areaUnemployed = areaUnemployed + 1
                    else
                        areaEmployed = areaEmployed + 1
                        areaEmployedByRole[npc.role] = (areaEmployedByRole[npc.role] or 0) + 1
                        totalEmployedByRole[npc.role] = (totalEmployedByRole[npc.role] or 0) + 1
                    end
                end
            end

            totalPopulation = totalPopulation + areaPopulation
            totalUnemployed = totalUnemployed + areaUnemployed
            totalEmployed = totalEmployed + areaEmployed

            print("[BWOAreas][STATS] Residential area " .. tostring(id) .. ": pop=" .. areaPopulation .. ", unemployed=" .. areaUnemployed .. ", employed=" .. areaEmployed)
            for role, count in pairs(areaEmployedByRole) do
                print("[BWOAreas][STATS] Residential area " .. tostring(id) .. ": employed as " .. role .. "=" .. count)
            end
        end
    end

    print("[BWOAreas][STATS] Residential summary: areas=" .. totalResidentialAreas .. ", pop=" .. totalPopulation .. ", unemployed=" .. totalUnemployed .. ", employed=" .. totalEmployed)
    for role, count in pairs(totalEmployedByRole) do
        print("[BWOAreas][STATS] Residential summary: employed as " .. role .. "=" .. count)
    end
end

BWOAreas.Get = function(id)
    return BWOAreas.areas[id]
end

BWOAreas.Find = function(square)
    if not square then return nil end
    if square:isOutside() then return nil end
    local sx, sy, sz = square:getX(), square:getY(), square:getZ()

    local areaData = BWOAreas.areas
    for _, area in pairs(areaData) do
        if sx >= area.x and sx <= area.x2 and
           sy >= area.y and sy <= area.y2 then
            return area
        end
    end
    return nil
end

BWOAreas.IsShopping = function(area)
    return BWOAreas.shoppingAreaTypes[area.type] == true
end

BWOAreas.FindInteractable = function(name, area, x, y, z)
    if not area or not area.interactables then return nil end

    local bestDist2 = math.huge
    local bestInteractable = nil
    for _, interactable in ipairs(area.interactables) do
        if interactable.type == name then
            local dist2 = ((interactable.x - x) * (interactable.x - x)) + ((interactable.y - y) * (interactable.y - y))
            if dist2 < bestDist2 then
                bestDist2 = dist2
                bestInteractable = interactable
            end
        end
    end
    return bestInteractable, math.sqrt(bestDist2)
end