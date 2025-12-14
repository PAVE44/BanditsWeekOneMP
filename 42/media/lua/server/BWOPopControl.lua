require "BWOUtils"

BWOPopControl = BWOPopControl or {}

local function zombieController(targetCnt)
    if targetCnt > 400 then return end
    local gmd = GetBanditModData()
    local zombieList = BanditZombie.CacheLightZ

    local cnt = 0
    local toDelete = {}
    for id, z in pairs(zombieList) do
        cnt = cnt + 1
        if cnt > targetCnt then
            local zombie = BanditZombie.GetInstanceById(z.id)
            if zombie and zombie:isAlive() and not zombie:isReanimatedPlayer() and not gmd.Queue[id] then
                zombie:removeFromWorld()
                zombie:removeFromSquare()
                table.insert(toDelete, id)
            end
        end
    end

    for i = 1, #toDelete do
        zombieList[toDelete[i]] = nil
    end

    if cnt >= 0 then
        print ("[POP CONTROL] Zombie Controller: Target Count: " .. targetCnt .. " Removed count: " .. cnt)
    end
end

BWOPopControl.population = {
    zombie = {
        periods = {
            [1] = {start=0, endt=110, cnt=0}, -- 110
            [2] = {start=110, endt=118, cnt=1}, -- 8
            [3] = {start=118, endt=123, cnt=2}, -- 3
            [4] = {start=123, endt=125, cnt=3}, -- 2
            [5] = {start=125, endt=126, cnt=5}, -- 1
            [6] = {start=126, endt=127, cnt=8},
            [7] = {start=127, endt=128, cnt=13},
            [8] = {start=128, endt=100000, cnt=1000},
        },
        control = zombieController
    },
    inhabitant = {
        cnt = 0,
        max = 0
    },
    street = {
        cnt = 0,
        max = 0
    },
    survivor = {
        cnt = 0,
        max = 0
    }
}

local function getGroupCount(group, worldAge)
    local periods = BWOPopControl.population[group].periods
    for i = 1, #periods do
        local period = periods[i]
        if worldAge >= period.start and worldAge < period.endt then
            return period.cnt
        end
    end
    return nil
end

local onTick = function(numTicks)
    if numTicks % 4 > 0 then return end
    if not isServer() then return end

    local worldAge = BWOUtils.GetWorldAge() 
    local population = BWOPopControl.population
    for group, data in pairs(population) do
        if data.periods and data.control then
            local targetCnt = getGroupCount(group, worldAge)
            if targetCnt then
                data.control(targetCnt)
            end
        end
    end
end

local function loadBanditOptions()
    local options = {}

    local clans = {
        resident = {
            cid = Bandit.clanMap.Resident,
            program = "Walker",
        },
        office = {
            cid = Bandit.clanMap.Office,
            program = "Walker",
        },
        postal = {
            cid = Bandit.clanMap.Postal,
            program = "Walker",
        },
        gardener = {
            cid = Bandit.clanMap.Gardener,
            program = "Walker",
        },
        janitor = {
            cid = Bandit.clanMap.Janitor,
            program = "Walker",
        },
        walker = {
            cid = Bandit.clanMap.Walker,
            program = "Walker",
        },
        runner = {
            cid = Bandit.clanMap.Runner,
            program = "Walker",
        },
    }

    for name, data in pairs(clans) do
        options[name] = {}
        local subOptions = BanditCustom.GetFromClan(data.cid)
        for bid, subOption in pairs(subOptions) do
            -- enrich
            subOption.bid = bid
            subOption.program = data.program
            table.insert(options[name], subOption)
        end
    end
    return options
end

local function everyOneMinute()
    
    if not isServer() then return end
    -- print ("[POP CONTROL] Init ")

    local worldAge = BWOUtils.GetWorldAge() 
    local cell = getCell()
    local zombieList = cell:getZombieList()
    local zombieListSize = zombieList:size()
    local options = loadBanditOptions()
    local clusters = {}

    print ("[POP CONTROL] Zombie Count: " .. zombieListSize)
    for i = 0, zombieListSize - 1 do
        local zombie = zombieList:get(i)
        -- local id = zombie:getPersistentOutfitID()
        local id = BanditUtils.GetCharacterID(zombie)
        local gmd = GetBanditClusterData(id)
        local c = GetBanditCluster(id)
        if not gmd[id] then
            
            local bandit = BanditUtils.Choice(options.walker)
            local brain = {}

            -- auto-generated properties 
            brain.id = id
            brain.inVehicle = false
            brain.fullname = BanditNames.GenerateName(zombie:isFemale())

            brain.born = getGameTime():getWorldAgeHours()
            brain.bornCoords = {}
            brain.bornCoords.x = zombie:getX()
            brain.bornCoords.y = zombie:getY()
            brain.bornCoords.z = zombie:getZ()

            brain.stationary = false
            brain.sleeping = false
            brain.aiming = false
            brain.moving = false
            brain.endurance = 1.00
            brain.speech = 0.00
            brain.sound = 0.00
            brain.infection = 0

            -- properties taken from bandit custom profile
            local general = bandit.general
            brain.clan = general.cid
            brain.cid = general.cid
            brain.bid = general.bid
            brain.female = general.female or false
            brain.skin = general.skin or 1
            brain.hairType = general.hairType or 1
            brain.hairColor = general.hairColor or 1
            brain.beardType = general.beardType or 1
            brain.eatBody = false

            local health = general.health or 5
            brain.health = BanditUtils.Lerp(health, 1, 9, 1, 2.6)

            local accuracyBoost = general.sight or 5
            brain.accuracyBoost = BanditUtils.Lerp(accuracyBoost, 1, 9, -8, 8)

            local enduranceBoost = general.endurance or 5
            brain.enduranceBoost = BanditUtils.Lerp(enduranceBoost, 1, 9, 0.25, 1.75)

            local strengthBoost = general.strength or 5
            brain.strengthBoost = BanditUtils.Lerp(strengthBoost, 1, 9, 0.25, 1.75)

            brain.exp = {0, 0, 0}
            if general.exp1 and general.exp2 and general.exp3 then
                brain.exp = {general.exp1, general.exp2, general.exp3}
            end

            brain.weapons = {}
            brain.weapons.melee = "Base.BareHands"
            brain.weapons.primary = {["bulletsLeft"] = 0, ["magCount"] = 0}
            brain.weapons.secondary = {["bulletsLeft"] = 0, ["magCount"] = 0}

            if bandit.weapons then
                if bandit.weapons.melee then
                    brain.weapons.melee = BanditCompatibility.GetLegacyItem(bandit.weapons.melee)
                end
                for _, slot in pairs({"primary", "secondary"}) do
                    brain.weapons[slot].bulletsLeft = 0
                    brain.weapons[slot].magCount = 0
                    if bandit.weapons[slot] and bandit.ammo[slot] then
                        brain.weapons[slot] = BanditWeapons.Make(bandit.weapons[slot], bandit.ammo[slot])
                    end
                end
            end

            brain.clothing = bandit.clothing or {}
            brain.tint = bandit.tint or {}
            brain.bag = bandit.bag

            brain.loot = {}
            brain.inventory = {}
            brain.tasks = {}

            -- bandit differentiators
            brain.rnd = {ZombRand(2), ZombRand(10), ZombRand(100), ZombRand(1000), ZombRand(10000)}

            brain.personality = {}

            -- addiction and sickness
            brain.personality.alcoholic = (ZombRand(50) == 0)
            brain.personality.smoker = (ZombRand(4) == 0)
            brain.personality.compulsiveCleaner = (ZombRand(90) == 0)

            -- collectors
            brain.personality.comicsCollector = (ZombRand(80) == 0)
            brain.personality.gameCollector = (ZombRand(220) == 0)
            brain.personality.hottieCollector = (ZombRand(100) == 0)
            brain.personality.toyCollector = (ZombRand(220) == 0)
            brain.personality.videoCollector = (ZombRand(220) == 0)
            brain.personality.underwearCollector = (ZombRand(150) == 0)

            -- heritage
            brain.personality.fromPoland = (ZombRand(120) == 0) -- ku chwale ojczyzny!

            brain.hostile = false
            brain.hostileP = false

            brain.program = {}
            brain.program.name = bandit.program
            brain.program.stage = "Prepare"
            brain.programFallback = brain.program

            -- bwo uses it
            brain.occupation = ""
            brain.loyal = false

            brain.master = 0
            brain.permanent = false
            brain.key = nil

            brain.voice = Bandit.PickVoice(zombie)

            -- ready!
            gmd[id] = brain
            clusters[c] = true
            
            -- print ("[POP CONTROL] Zombie " .. id .. " banditized.")
        else
            -- print ("[POP CONTROL] Zombie " .. id .. " is already a bandit.")
        end
    end


    for c, _ in pairs(clusters) do
        -- print ("[POP CONTROL] Transmitting cluser " .. c)
        TransmitBanditClusterExpicit(c)
    end
end

-- Events.OnTick.Remove(onTick)
-- Events.OnTick.Add(onTick)

Events.EveryOneMinute.Remove(everyOneMinute)
Events.EveryOneMinute.Add(everyOneMinute)