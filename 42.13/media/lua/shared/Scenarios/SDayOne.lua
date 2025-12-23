require "Scenarios/SAbstract"

BWOScenarios.DayOne = {}

BWOScenarios.DayOne = BWOScenarios.Abstract:derive("BWOScenarios.Abstract")

-- schedule stores sequences of events
BWOScenarios.DayOne.schedule = {
    [0] = {
        [1] = {
            {{"StartDay", {day="friday"}}, 1},
        },
        [2] = {
            {{"Siren", {}}, 1},
        },
        [3] = {
            {{"SpawnGroupVehicle", {desc = "Police Patrol", cid = Bandit.clanMap.PoliceBlue, vtype = "Base.CarLightsPolice", lightbar = 2, siren = 2, size = 2, dmin = 20, dmax = 50, program = "Bandit", hostile = false}}, 1},
        },
        [4] = {
            {{"ChopperAlert", {name="heli", sound="BWOChopperPolice1", dir = 90, speed=1.8}}, 1},
        },
        [10] = {
            {{"SpawnGroupVehicle", {desc = "Police Patrol", cid = Bandit.clanMap.PoliceBlue, vtype = "Base.CarLightsPolice", lightbar = 1, siren = 1, size = 2, dmin = 30, dmax = 60, program = "Bandit", hostile = false}}, 1},
        },
        [15] = {
            {{"ChopperAlert", {name="heli", sound="BWOChopperPolice1", dir = -90, speed=1.8}}, 1},
        },
        [20] = {
            {{"SpawnGroupVehicle", {desc = "Police Patrol", cid = Bandit.clanMap.PoliceBlue, vtype = "Base.CarLightsPolice", lightbar = 1, siren = 1, size = 2, dmin = 40, dmax = 70, program = "Bandit", hostile = false}}, 1},
        },
        [25] = {
            {{"Arson", {dmin = 25, dmax = 40}}, 1},
        },
        [30] = {
            {{"SpawnGroup", {desc = "Neighborhood Watch", cid = Bandit.clanMap.KentuckianFinest, dist = 33, size = 7, program = "Bandit", hostile = false}}, 1},
        },
        [32] = {
            {{"Siren", {}}, 1},
        },
        [35] = {
            {{"ChopperAlert", {name="heli2", sound="BWOChopperGeneric", dir = 0, speed=3.1}}, 1},
        },
        [40] = {
            {{"Arson", {dmin = 35, dmax = 55}}, 1},
            {{"Arson", {dmin = 56, dmax = 80}}, 200},
        },
        [50] = {
            {{"SpawnGroup", {desc = "Neighborhood Watch", cid = Bandit.clanMap.KentuckianFinest, dist = 33, size = 7, program = "Bandit", hostile = false}}, 1},
        },
    },
    [1] = {
        [2] = {
            {{"Siren", {}}, 1},
        },
        [10] = {
            {{"SpawnGroup", {desc = "Police", cid = Bandit.clanMap.PoliceGray, dist = 33, size = 6, program = "Bandit", hostile = false}}, 1},
        },
        [20] = {
            {{"ChopperAlert", {name="heli", sound="BWOChopperPolice2", dir = 180, speed=1.8}}, 1},
        },
        [25] = {
            {{"Arson", {dmin = 40, dmax = 60}}, 1},
        },
        [30] = {
            {{"SpawnGroup", {desc = "Police", cid = Bandit.clanMap.PoliceGray, dist = 33, size = 6, program = "Bandit", hostile = false}}, 1},
        },
        [32] = {
            {{"Siren", {}}, 1},
        },
        [40] = {
            {{"ChopperAlert", {name="heli", sound="BWOChopperPolice2", dir = 0, speed=1.8}}, 1},
        },
        [50] = {
            {{"SpawnGroupVehicle", {desc = "Police Patrol", cid = Bandit.clanMap.PoliceBlue, vtype = "Base.CarLightsPolice", lightbar = 1, siren = 1, size = 2, dmin = 30, dmax = 60, program = "Bandit", hostile = false}}, 1},
        },
    },
    [2] = {
        [2] = {
            {{"Siren", {}}, 1},
        },
        [20] = {
            {{"ChopperAlert", {name="heli2", sound="BWOChopperCDC1", dir = -90, speed=1.7}}, 1},
        },
        [40] = {
            {{"ChopperAlert", {name="heli2", sound="BWOChopperCDC1", dir = 90, speed=1.7}}, 1},
        },
        [50] = {
            {{"SpawnGroupVehicle", {desc = "SWAT", cid = Bandit.clanMap.SWAT, vtype = "Base.StepVan_LouisvilleSWAT", lightbar = 3, siren = 2, size = 5, dmin = 40, dmax = 80, program = "Bandit", hostile = false}}, 1},
        },
    }
}

BWOScenarios.DayOne.roomSpawns = {
    ["armysurplus"] = {
        {waMin=0, waMax=2, cid=Bandit.clanMap.Veteran, size = 2, hostile = false},
        {waMin=2, waMax=24, cid=Bandit.clanMap.Militia, size = 6, hostile = true},
    },
    ["artstore"] = {
        {waMin=0, waMax=3, cid=Bandit.clanMap.Security, size = 6, hostile = false},
        {waMin=3, waMax=24, cid=Bandit.clanMap.Robbers, size = 8, hostile = true},
    },
    ["bank"] = {
        {waMin=0, waMax=3, cid=Bandit.clanMap.Security, size = 4, hostile = false},
        {waMin=3, waMax=24, cid=Bandit.clanMap.Robbers, size = 6, hostile = true},
    },
    ["bar"] = {
        {waMin=0, waMax=3, cid=Bandit.clanMap.Biker, size = 5, hostile = false},
        {waMin=3, waMax=24, cid=Bandit.clanMap.Biker, size = 7, hostile = true},
    },
    ["barcountertwiggy"] = {
        {waMin=0, waMax=3, cid=Bandit.clanMap.Biker, size = 3, hostile = false},
        {waMin=3, waMax=24, cid=Bandit.clanMap.Biker, size = 4, hostile = true},
    },
    ["barkitchen"] = {
        {waMin=0, waMax=3, cid=Bandit.clanMap.Biker, size = 3, hostile = false},
        {waMin=3, waMax=24, cid=Bandit.clanMap.Biker, size = 4, hostile = true},
    },
    ["barstorage"] = {
        {waMin=0, waMax=3, cid=Bandit.clanMap.Biker, size = 3, hostile = false},
        {waMin=3, waMax=24, cid=Bandit.clanMap.Biker, size = 4, hostile = true},
    },
    ["bankstorage"] = {
        {waMin=0, waMax=3, cid=Bandit.clanMap.Security, size = 2, hostile = false},
        {waMin=3, waMax=24, cid=Bandit.clanMap.Robbers, size = 3, hostile = true},
    },
    ["clinic"] = {
        {waMin=0, waMax=4, cid=Bandit.clanMap.Medic, size = 3, hostile = false},
        {waMin=4, waMax=24, cid=Bandit.clanMap.BanditStrong, size = 4, hostile = true},
    },
    ["conveniencestore"] = {
        {waMin=0, waMax=3, cid=Bandit.clanMap.Security, size = 2, hostile = false},
        {waMin=3, waMax=24, cid=Bandit.clanMap.CriminalBlack, size = 3, hostile = true},
    },
    ["cornerstore"] = {
        {waMin=0, waMax=3, cid=Bandit.clanMap.Security, size = 4, hostile = false},
        {waMin=3, waMax=24, cid=Bandit.clanMap.CriminalBlack, size = 6, hostile = true},
    },
    ["departmentstore"] = {
        {waMin=0, waMax=3, cid=Bandit.clanMap.Security, size = 4, hostile = false},
        {waMin=3, waMax=24, cid=Bandit.clanMap.CriminalBlack, size = 6, hostile = true},
    },
    ["detectiveoffice"] = {
        {waMin=0, waMax=3, cid=Bandit.clanMap.PoliceBlue, size = 5, hostile = false},
        {waMin=3, waMax=24, cid=Bandit.clanMap.Militia, size = 7, hostile = true},
    },
    ["generalstore"] = {
        {waMin=0, waMax=3, cid=Bandit.clanMap.Security, size = 4, hostile = false},
        {waMin=3, waMax=24, cid=Bandit.clanMap.CriminalBlack, size = 6, hostile = true},
    },
    ["giftstore"] = {
        {waMin=0, waMax=3, cid=Bandit.clanMap.Security, size = 2, hostile = false},
        {waMin=3, waMax=24, cid=Bandit.clanMap.Robbers, size = 2, hostile = true},
    },
    ["gigamart"] = {
        {waMin=0, waMax=3, cid=Bandit.clanMap.Security, size = 5, hostile = false},
        {waMin=3, waMax=24, cid=Bandit.clanMap.CriminalBlack, size = 10, hostile = true},
    },
    ["gunstore"] = {
        {waMin=0, waMax=2, cid=Bandit.clanMap.Veteran, size = 2, hostile = false},
        {waMin=2, waMax=24, cid=Bandit.clanMap.Militia, size = 5, hostile = true},
    },
    ["jewelrystore"] = {
        {waMin=0, waMax=3, cid=Bandit.clanMap.Security, size = 4, hostile = false},
        {waMin=3, waMax=24, cid=Bandit.clanMap.Robbers, size = 6, hostile = true},
    },
    ["leatherclothesstore"] = {
        {waMin=0, waMax=3, cid=Bandit.clanMap.Security, size = 2, hostile = false},
        {waMin=3, waMax=24, cid=Bandit.clanMap.CriminalClassy, size = 3, hostile = true},
    },
    ["liquorstore"] = {
        {waMin=0, waMax=2, cid=Bandit.clanMap.Security, size = 1, hostile = false},
        {waMin=2, waMax=24, cid=Bandit.clanMap.Redneck, size = 8, hostile = true},
    },
    ["medclinic"] = {
        {waMin=0, waMax=4, cid=Bandit.clanMap.Medic, size = 3, hostile = false},
        {waMin=4, waMax=24, cid=Bandit.clanMap.BanditStrong, size = 4, hostile = true},
    },
    ["medical"] = {
        {waMin=0, waMax=4, cid=Bandit.clanMap.Medic, size = 3, hostile = false},
        {waMin=4, waMax=24, cid=Bandit.clanMap.BanditStrong, size = 4, hostile = true},
    },
    ["medicaloffice"] = {
        {waMin=0, waMax=4, cid=Bandit.clanMap.Medic, size = 2, hostile = false},
        {waMin=4, waMax=24, cid=Bandit.clanMap.BanditStrong, size = 3, hostile = true},
    },
    ["medicalclinic"] = {
        {waMin=0, waMax=4, cid=Bandit.clanMap.Medic, size = 3, hostile = false},
        {waMin=4, waMax=24, cid=Bandit.clanMap.BanditStrong, size = 4, hostile = true},
    },
    ["medicalstorage"] = {
        {waMin=0, waMax=4, cid=Bandit.clanMap.Medic, size = 1, hostile = false},
        {waMin=4, waMax=24, cid=Bandit.clanMap.BanditStrong, size = 1, hostile = true},
    },
    ["pawnshop"] = {
        {waMin=0, waMax=3, cid=Bandit.clanMap.Security, size = 1, hostile = false},
        {waMin=3, waMax=24, cid=Bandit.clanMap.CriminalWhite, size = 4, hostile = true},
    },
    ["policearchive"] = {
        {waMin=0, waMax=3, cid=Bandit.clanMap.PoliceBlue, size = 1, hostile = false},
        {waMin=3, waMax=24, cid=Bandit.clanMap.Militia, size = 1, hostile = true},
    },
    ["policegarage"] = {
        {waMin=0, waMax=3, cid=Bandit.clanMap.PoliceBlue, size = 3, hostile = false},
        {waMin=3, waMax=24, cid=Bandit.clanMap.Militia, size = 3, hostile = true},
    },
    ["policegunstorage"] = {
        {waMin=0, waMax=3, cid=Bandit.clanMap.SWAT, size = 2, hostile = false},
        {waMin=3, waMax=24, cid=Bandit.clanMap.Militia, size = 4, hostile = true},
    },
    ["policehall"] = {
        {waMin=0, waMax=3, cid=Bandit.clanMap.SWAT, size = 2, hostile = false},
        {waMin=3, waMax=24, cid=Bandit.clanMap.Militia, size = 2, hostile = true},
    },
    ["policelocker"] = {
        {waMin=0, waMax=3, cid=Bandit.clanMap.SWAT, size = 2, hostile = false},
        {waMin=3, waMax=24, cid=Bandit.clanMap.Militia, size = 2, hostile = true},
    },
    ["policeoffice"] = {
        {waMin=0, waMax=3, cid=Bandit.clanMap.PoliceBlue, size = 2, hostile = false},
        {waMin=3, waMax=24, cid=Bandit.clanMap.Militia, size = 2, hostile = true},
    },
    ["policestorage"] = {
        {waMin=0, waMax=3, cid=Bandit.clanMap.SWAT, size = 2, hostile = false},
        {waMin=3, waMax=24, cid=Bandit.clanMap.Militia, size = 2, hostile = true},
    },
    ["pharmacy"] = {
        {waMin=0, waMax=3, cid=Bandit.clanMap.Medic, size = 2, hostile = false},
        {waMin=3, waMax=24, cid=Bandit.clanMap.BanditStrong, size = 3, hostile = true},
    },
    ["pharmacystorage"] = {
        {waMin=0, waMax=3, cid=Bandit.clanMap.Medic, size = 2, hostile = false},
        {waMin=3, waMax=24, cid=Bandit.clanMap.BanditStrong, size = 3, hostile = true},
    },
    ["security"] = {
        {waMin=0, waMax=4, cid=Bandit.clanMap.Security, size = 2, hostile = false},
    },
    ["zippeestorage"] = {
        {waMin=0, waMax=3, cid=Bandit.clanMap.Security, size = 1, hostile = false},
        {waMin=3, waMax=24, cid=Bandit.clanMap.CriminalBlack, size = 2, hostile = true},
    },
    ["zippeestore"] = {
        {waMin=0, waMax=3, cid=Bandit.clanMap.Security, size = 1, hostile = false},
        {waMin=3, waMax=24, cid=Bandit.clanMap.CriminalBlack, size = 2, hostile = true},
    },
}
