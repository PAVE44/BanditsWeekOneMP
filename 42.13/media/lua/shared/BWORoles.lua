BWORoles = {}

BWORoles.player = {
    janitor = {
        area = nil,
        requirements = {
            perks = {},
            clothing = {
                ["Vest"] = "Base.Vest_HighViz",
                ["Body"] = "Base.Boilersuit_BlueRed",
                ["Hands"] = "Base.Gloves_Dish",
            }
        },
        hours = {start = 6, finish = 14}
    },
    postman = {
        areaId = {
            x1 = nil,
            y1 = nil,
            x2 = nil,
            y2 = nil,
        },
        requirements = {
            perks = {
                {perk = "Sprinting", levelMin = 2}
            },
            clothing = {
                ["ShortSleeveShirt"] = "Base.Shirt_FormalWhite_ShortSleeve",
                ["Neck"] = "Base.Tie_Full",
                ["ShortsShort"] = "Base.Shorts_ShortFormal",
                ["Bag"] = "Base.Bag_Satchel_Mail",
            }
        },
        hours = {start = 7, finish = 15}
    },
    priest = {
        maleOnly = true,
    },
    roadTechnicial = {
        requirements = {
            perks = {
                {perk = "Maintenance", levelMin = 2}
            }
        },
        hours = {start = 7, finish = 15}
    },
    baker = {
        requirements = {
            perks = {
                {perk = "Cooking", levelMin = 2}
            }
        },
        hours = {start = 4, finish = 12}
    },
    cook = {
        requirements = {
            perks = {
                {perk = "Cooking", levelMin = 3}
            }
        },
        hours = {start = 14, finish = 22}
    },
    waiter = {

    },
    hairdresser = {
        hours = {start = 10, finish = 18}
    },
    stripDancer = {
    },
    securityGuard = {
    },
    teacher = {
    },
    butcher = {
        requirements = {
            perks = {
                {perk = "Butchering", levelMin = 1}
            }
        },
        hours = {start = 7, finish = 15}
    },
    furnitureSales = {
        requirements = {
            perks = {
                {perk = "Woodwork", levelMin = 2}
            }
        },
        hours = {start = 9, finish = 17}
    },
    electronicsSales = {
        requirements = {
            perks = {
                {perk = "Electricity", levelMin = 2}
            }
        },
        hours = {start = 9, finish = 17}
    },
    clothingSales = {
        requirements = {
            perks = {
                {perk = "Tailoring", levelMin = 2}
            }
        },
        hours = {start = 9, finish = 17}
    },
    pharmacist = {
        requirements = {
            perks = {
                {perk = "Doctor", levelMin = 2}
            }
        },
        hours = {start = 9, finish = 17}
    },
    policeman = {
        requirements = {
            perks = {
                {perk = "Fitness", levelMin = 7},
                {perk = "Aiming", levelMin = 4},
                {perk = "Reloading", levelMin = 3},
            }
        },
        hours = {start = 9, finish = 17}
    },
    constructionWorker = {
        hours = {start = 7, finish = 15},
    }
}

BWORoles.player.butcher.logic = {}

BWORoles.player.butcher.logic.transferToContainer = function(player, item, destContainer)
    local payItemTypes = {
        ["Base.Beef"] = 5,
        ["Base.Steak"] = 6,
    }

    local payContainerTypes = {
        ["restaurantdisplay"] = true,
        ["freezer"] = true,
        ["fridge"] = true
    }

    if not item:isFood() then return end
    if not item:isFresh() then return end
    if not item:isUncooked() then return end

    local destContainerType = destContainer:getType()
    if not payContainerTypes[destContainerType] then return end

    local md = item:getModData()
    md.BWO = md.BWO or {}
    if md.BWO.sold then return end

    local weight = item:getActualWeight()
    local own
    for itemType, value in pairs(payItemTypes) do
        if item:getFullType() == itemType then
            own = math.floor(weight * value)
            break
        end
    end

    if own and own > 0 then
        BWOItemTransfer.Earn(player, own)
        md.BWO.sold = true
    end
end

BWORoles.player.postman.logic = {}

BWORoles.player.postman.logic.transferToContainer = function(player, item, destContainer)
    local destContainerType = destContainer:getType()
    local destContainerParent = destContainer:getParent()

    local md = item:getModData()
    md.BWO = md.BWO or {}
    if md.BWO.delivered then return end

    if destContainerType == "postbox" then
        local boxId = string.format("%d-%d", destContainerParent:getX(), destContainerParent:getY())
        local boxData = BWOPostData.GetBox(boxId)
        if boxData then
            local md = item:getModData()
            if md.BWO.box and md.BWO.box.id and md.BWO.box.id == boxData.id and not md.BWO.delivered then
                BWOItemTransfer.Earn(player, 5)
                md.BWO.delivered = true
            end
        end
    end
end

BWORoles.checkRequirements = function(player, role)
    if true then return true end
    local roleData = BWORoles.player[role]
    if not roleData then return false end

    local requirements = roleData.requirements
    if not requirements then return true end

    local perks = requirements.perks
    if not perks then return true end

    for _, perkReq in ipairs(perks) do
        local perk = perkReq.perk
        if Perks[perk] then
            local levelMin = perkReq.levelMin
            if player:getPerkLevel(Perks[perk]) < levelMin then
                return false
            end
        end
    end

    local wornItems = player:getWornItems()
    local clothing = requirements.clothing
    if clothing then
        local req = 0
        local found = 0
        for slot, itemType in pairs(clothing) do
            req = req + 1
            for i = 0, wornItems:size() -1 do
                local item = wornItems:get(i):getItem()
                if item:getFullType() == itemType then
                    found = found + 1
                end
            end
        end
        if found < req then
            return false
        end
    end

    local hours = roleData.hours
    if hours then
        local start = hours.start
        local finish = hours.finish
        local currentHour = getGameTime():getHour()
        if currentHour < start or currentHour >= finish then
            return false
        end
    end
    return true
end

