ZombieActions = ZombieActions or {}

local prepareActions = {
    ["OpenCannedFood"] = {
        anim = "OpenCanWithKnife",
        sound = "OpenCannedFoodWithKnife",
        prop1 = "Base.KitchenKnife",
        replace = {
            ["Base.TinnedBeans"] = {fullType = "Base.OpenBeans", cnt = 1},
            ["Base.TinnedSoup"] = {fullType = "Base.TinnedSoupOpen", cnt = 1},
            ["Base.CannedBolognese"] = {fullType = "Base.CannedBologneseOpen", cnt = 1},
            ["Base.CannedCarrots2"] = {fullType = "Base.CannedCarrotsOpen", cnt = 1},
            ["Base.CannedChili"] = {fullType = "Base.CannedChiliOpen", cnt = 1},
            ["Base.CannedCorn"] = {fullType = "Base.CannedCornOpen", cnt = 1},
            ["Base.CannedFruitCocktail"] = {fullType = "Base.CannedFruitCocktailOpen", cnt = 1},
            ["Base.CannedFruitBeverage"] = {fullType = "Base.CannedFruitBeverageOpen", cnt = 1},
            ["Base.CannedMilk"] = {fullType = "Base.CannedMilkOpen", cnt = 1},
            ["Base.CannedMushroomSoup"] = {fullType = "Base.CannedMushroomSoupOpen", cnt = 1},
            ["Base.CannedPeaches"] = {fullType = "Base.CannedPeachesOpen", cnt = 1},
            ["Base.CannedPeas"] = {fullType = "Base.CannedPeasOpen", cnt = 1},
            ["Base.CannedPineapple"] = {fullType = "Base.CannedPineappleOpen", cnt = 1},
            ["Base.CannedPotato"] = {fullType = "Base.CannedPotatoOpen", cnt = 1},
            ["Base.TinnedSoup"] = {fullType = "Base.TinnedSoupOpen", cnt = 1},
            ["Base.CannedTomato"] = {fullType = "Base.CannedTomatoOpen", cnt = 1},
            ["Base.TunaTin"] = {fullType = "Base.TunaTinOpen", cnt = 1},
            ["Base.Dogfood"] = {fullType = "Base.DogfoodOpen", cnt = 1},
        }
    },
    ["OpenCannedFood2"] = {
        anim = "OpenCanWithKnife",
        sound = "OpenCannedFoodWithKnife",
        prop1 = "Base.KitchenKnife",
        replace = {
            ["Base.CannedCornedBeef"] = {fullType = "Base.CannedCornedBeefOpen", cnt = 1},
            ["Base.CannedSardines"] = {fullType = "Base.CannedSardinesOpen", cnt = 1},
        }
    },
    ["OpenBottleOfBeer"] = {
        anim = "OpenBeerBottle",
        sound = "OpenBeerBottle",
        replace = {
            ["Base.BeerBottle"] = {fullType = "Base.BeerBottleOpen", cnt = 1},
            ["Base.BeerImported"] = {fullType = "Base.BeerImportedOpen", cnt = 1},
        }
    },
    --[[
    ["OpenPopCan"] = {
        anim = "OpenPopCan",
        sound = "OpenCan",
        replace = {
            ["Base.BeerBottle"] = {fullType = "Base.BeerBottleOpen", cnt = 1},
            ["Base.BeerImported"] = {fullType = "Base.BeerImportedOpen", cnt = 1},
        }
    },]]
    ["OpenPackOfBeer"] = {
        anim = "Making",
        replace = {
            ["Base.BeerPack"] = {fullType = "Base.BeerBottle", cnt = 6},
            ["Base.BeerCanPack"] = {fullType = "Base.BeerCan", cnt = 6},
        }
    },
    ["OpenBoxOfWine"] = {
        anim = "UnPackBox",
        replace = {
            ["Base.WineWhite_Boxed"] = {fullType = "Base.Wine", cnt = 6},
            ["Base.WineRed_Boxed"] = {fullType = "Base.Wine2", cnt = 6},
        }
    },
    ["OpenBottleOfWine"] = {
        anim = "OpenWineBottle",
        sound = "CorkPopWine",
        replace = {
            ["Base.Wine"] = {fullType = "Base.WineOpen", cnt = 1},
            ["Base.Wine2"] = {fullType = "Base.Wine2Open", cnt = 1},
        }
    },
    ["OpenBoxOfCannedFood"] = {
        anim = "UnPackBox",
        replace = {
            ["Base.TinnedBeans_Box"] = {fullType = "Base.TinnedBeans", cnt = 6},
            ["Base.CannedBolognese_Box"] = {fullType = "Base.CannedBolognese", cnt = 6},
            ["Base.CannedCarrots_Box"] = {fullType = "Base.CannedCarrots2", cnt = 6},
            ["Base.CannedChili_Box"] = {fullType = "Base.CannedChili", cnt = 6},
            ["Base.CannedCornedBeef_Box"] = {fullType = "Base.CannedCornedBeef", cnt = 6},
            ["Base.CannedCorn_Box"] = {fullType = "Base.CannedCorn", cnt = 6},
            ["Base.CannedFruitCocktail_Box"] = {fullType = "Base.CannedFruitCocktail", cnt = 6},
            ["Base.CannedFruitBeverage_Box"] = {fullType = "Base.CannedFruitBeverage", cnt = 6},
            ["Base.CannedMilk_Box"] = {fullType = "Base.CannedMilk", cnt = 6},
            ["Base.CannedMushroomSoup_Box"] = {fullType = "Base.CannedMushroomSoup", cnt = 6},
            ["Base.CannedPeaches_Box"] = {fullType = "Base.CannedPeaches", cnt = 6},
            ["Base.CannedPeas_Box"] = {fullType = "Base.CannedPeas", cnt = 6},
            ["Base.CannedPineapple_Box"] = {fullType = "Base.CannedPineapple", cnt = 6},
            ["Base.CannedPotato_Box"] = {fullType = "Base.CannedPotato2", cnt = 6},
            ["Base.CannedSardines_Box"] = {fullType = "Base.CannedSardines", cnt = 6},
            ["Base.TinnedSoup_Box"] = {fullType = "Base.TinnedSoup", cnt = 6},
            ["Base.CannedTomato_Box"] = {fullType = "Base.CannedTomato2", cnt = 6},
            ["Base.TunaTin_Box"] = {fullType = "Base.TunaTin", cnt = 6},
            ["Base.Dogfood_Box"] = {fullType = "Base.Dogfood", cnt = 6},
            ["Base.MysteryCan_Box"] = {fullType = "Base.MysteryCan", cnt = 6},
            ["Base.DentedCan_Box"] = {fullType = "Base.DentedCan", cnt = 6},
            ["Base.WaterRationCan_Box"] = {fullType = "Base.WaterRationCan", cnt = 6},
            ["Base.Macandcheese_Box"] = {fullType = "Base.Macandcheese", cnt = 6},
        }
    },
    ["OpenJarOfFood"] = {
        anim = "Making",
        replace = {
            ["Base.CannedBellPepper"] = {fullType = "Base.CannedBellPepper_Open", cnt = 1},
            ["Base.CannedBroccoli"] = {fullType = "Base.CannedBroccoli_Open", cnt = 1},
            ["Base.CannedCabbage"] = {fullType = "Base.CannedCabbage_Open", cnt = 1},
            ["Base.CannedCarrots"] = {fullType = "Base.CannedCarrots_Open", cnt = 1},
            ["Base.CannedEggplant"] = {fullType = "Base.CannedEggplant_Open", cnt = 1},
            ["Base.CannedLeek"] = {fullType = "Base.CannedLeek_Open", cnt = 1},
            ["Base.CannedPotato"] = {fullType = "Base.CannedPotato_Open", cnt = 1},
            ["Base.CannedRedRadish"] = {fullType = "Base.CannedRedRadish_Open", cnt = 1},
            ["Base.CannedTomato"] = {fullType = "Base.CannedTomato_Open", cnt = 1},
            ["Base.CannedRoe"] = {fullType = "Base.CannedRoe_Open", cnt = 1},
        }
    },
    ["OpenCandyPackage"] = {
        anim = "UnPackBagSmall",
        sound = "PutItemInBag",
        replace = {
            ["Base.CandyPackage"] = {fullType = "Base.Lollipop", cnt = 5},
        }
    }
}

local eatType2Anim = {
    ["Plate"] = "EatFromPlateHand",
    ["Pot"] = "EatFromPot",
    ["EatSmall"] = "EatSmall",
    ["EatOffStick"] = "EatOffStick",
    ["2handforced"] = "Eat2Hands",
    ["EatBox"] = "EatFromPacket",
    ["Bourbon"] = "DrinkFromBourbonBottle",
    ["Popcan"] = "DrinkPopCan",
    ["Bottle"] = "DrinkFromBottle",
}

ZombieActions.Eat = {}
ZombieActions.Eat.onStart = function(zombie, task)
    local itemConf = BWOPermaInv.GetClass(zombie, "food")
    if not itemConf then return false end

    -- to make the npc have the item visibly in hand, we need to use a "weapon" substitute of that item
    -- as weaponsprite is actually used to read the static model 

    local itemFood = BanditCompatibility.InstanceItem(itemConf.fullType)
    if not itemFood then return false end

    local item = itemFood:getScriptItem()
    task.openingRecipe = item:getOpeningRecipe() or item:getDoubleClickRecipe()

    task.fullType = itemConf.fullType
    task.hc = itemConf.hc

    if task.openingRecipe then

        task.prop2 = itemConf.fullType

        local prepareAction = prepareActions[task.openingRecipe]
        if prepareAction then
            task.anim = prepareAction.anim
            task.sound = prepareAction.sound
            task.prop1 = prepareAction.prop1
            task.prop2 = itemConf.fullType
            task.replace = "Base.Apple"
            if prepareAction.replace[itemConf.fullType] then
                task.replace = prepareAction.replace[itemConf.fullType]
            end
            zombie:addLineChatElement("Preparing " .. task.prop2, 0, 0, 1)
        end
    else
        task.prop2 = itemConf.fullType

        zombie:addLineChatElement("Consuming " .. task.prop2, 0, 0, 1)

        local eatType = itemFood:getEatType()
        local anim = "Eat1Hand"
        if eatType2Anim[eatType] then
            anim = eatType2Anim[eatType]
        end
        task.anim = anim

        -- local sound = "Eating"
        --[[
        if instanceof(itemFood, "Food") then
            sound = itemFood:getCustomEatSound()
        elseif instanceof(itemFood, "ComboItem") then
            local fc = itemFood:getFluidContainer()
            if fc then
                sound = fc:getCustomDrinkSound()
            end
        end
        ]]

        task.sound = itemFood:getCustomEatSound()
        
    end

    if task.prop1 then
        local itemHeld = BanditCompatibility.InstanceItem(task.prop1)
        if itemHeld then
            zombie:setPrimaryHandItem(itemHeld)
        end
    else
        zombie:setPrimaryHandItem(nil)
    end

    if task.prop2 then
        local subFullType = string.gsub(task.prop2, "^[^%.]+", "Bandits")
        local itemHeld = BanditCompatibility.InstanceItem(subFullType)
        if itemHeld then
            zombie:setSecondaryHandItem(itemHeld)
        end
    else
        zombie:setSecondaryHandItem(nil)
    end

    zombie:setBumpType(task.anim)

    if task.sound then
        local emitter = zombie:getEmitter()
        if not emitter:isPlaying(task.sound) then
            emitter:playSound(task.sound)
        end
    end

    return true
end

ZombieActions.Eat.onWorking = function(zombie, task)
    if zombie:getBumpType() ~= task.anim then return true end
    return false
end

ZombieActions.Eat.onComplete = function(zombie, task)
    if task.sound then
        local emitter = zombie:getEmitter()
        emitter:stopSoundByName(task.sound)
    end

    if task.openingRecipe then
        if task.replace then
            for i = 1, task.replace.cnt do
                local itemFood = BanditCompatibility.InstanceItem(task.replace.fullType)
                BWOPermaInv.Add(zombie, itemFood)
            end
            BWOPermaInv.RemoveOneOfType(zombie, task.fullType)
        end
    else
        zombie:setSecondaryHandItem(nil)
        BWOPermaInv.RemoveOneOfType(zombie, task.fullType)

        local brain = BanditBrain.Get(zombie)
        if brain then
            if task.hc and task.hc < 0 then
                brain.hunger = brain.hunger + task.hc
                if brain.hunger < 0 then
                    brain.hunger = 0
                end
                zombie:addLineChatElement(task.hc .. " " .. getText("IGUI_Halo_Hunger") .. " ", 0, 1, 0, UIFont.Small, 30.0, "default")
            end
        end
    end
    return true
end
