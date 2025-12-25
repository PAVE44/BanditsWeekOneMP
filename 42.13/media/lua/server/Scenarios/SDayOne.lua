require "Scenarios/SAbstract"
require "BWOBuildTools"
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
    },
    [3] = {
        [5] = {
            {{"Arson", {dmin = 40, dmax = 60}}, 1},
        },
        [15] = {
            {{"SpawnGroup", {desc = "Criminals", cid = Bandit.clanMap.CriminalBlack, dist = 33, size = 6, program = "Bandit", hostile = true}}, 1},
        },
        [20] = {
            {{"SpawnGroup", {desc = "Police", cid = Bandit.clanMap.PoliceGray, dist = 33, size = 6, program = "Bandit", hostile = false}}, 1},
        },
        [25] = {
            {{"SpawnGroup", {desc = "Criminals", cid = Bandit.clanMap.CriminalBlack, dist = 33, size = 6, program = "Bandit", hostile = true}}, 1},
        },
        [35] = {
            {{"SpawnGroup", {desc = "Criminals", cid = Bandit.clanMap.CriminalBlack, dist = 33, size = 6, program = "Bandit", hostile = true}}, 1},
        },
        [45] = {
            {{"SpawnGroup", {desc = "Criminals", cid = Bandit.clanMap.CriminalWhite, dist = 33, size = 6, program = "Bandit", hostile = true}}, 1},
        },
        [47] = {
            {{"SpawnGroup", {desc = "Criminals", cid = Bandit.clanMap.CriminalWhite, dist = 33, size = 6, program = "Bandit", hostile = true}}, 1},
        },
    },
    [4] = {
        [5] = {
            {{"SpawnGroup", {desc = "Criminals", cid = Bandit.clanMap.CriminalWhite, dist = 33, size = 6, program = "Bandit", hostile = true}}, 1},
        },
        [7] = {
            {{"SpawnGroup", {desc = "Criminals", cid = Bandit.clanMap.CriminalWhite, dist = 33, size = 6, program = "Bandit", hostile = true}}, 1},
        },
        [35] = {
            {{"Arson", {dmin = 40, dmax = 60}}, 1},
        },
        [44] = {
            {{"SpawnGroup", {desc = "Mafia", cid = Bandit.clanMap.CriminalClassy, dist = 33, size = 5, program = "Bandit", hostile = true}}, 1},
        },
        [45] = {
            {{"SpawnGroup", {desc = "Criminals", cid = Bandit.clanMap.CriminalBlack, dist = 33, size = 6, program = "Bandit", hostile = true}}, 1},
        },
        [46] = {
            {{"SpawnGroup", {desc = "Mafia", cid = Bandit.clanMap.CriminalClassy, dist = 33, size = 8, program = "Bandit", hostile = true}}, 1},
        },
        [47] = {
            {{"Arson", {dmin = 60, dmax = 90}}, 1},
        },
        [50] = {
            {{"Arson", {dmin = 60, dmax = 90}}, 1},
        },
        [55] = {
            {{"Arson", {dmin = 60, dmax = 90}}, 1},
        },
    },
    [5] = {
        [5] = {
            {{"Arson", {dmin = 60, dmax = 90}}, 1},
        },
        [10] = {
            {{"Arson", {dmin = 60, dmax = 90}}, 1},
        },
        [15] = {
            {{"Arson", {dmin = 60, dmax = 90}}, 1},
        },
        [20] = {
            {{"SpawnGroup", {desc = "Mafia", cid = Bandit.clanMap.CriminalClassy, dist = 33, size = 8, program = "Bandit", hostile = true}}, 1},
        },
        [25] = {
            {{"SpawnGroup", {desc = "Veterans", cid = Bandit.clanMap.Veteran, dist = 33, size = 8, program = "Bandit", hostile = false}}, 1},
        },
        [28] = {
            {{"SpawnGroup", {desc = "Police", cid = Bandit.clanMap.PoliceRiot, dist = 33, size = 6, program = "Bandit", hostile = false}}, 1},
            {{"SpawnGroup", {desc = "Police", cid = Bandit.clanMap.PoliceRiot, dist = 33, size = 6, program = "Bandit", hostile = false}}, 1},
            {{"SpawnGroup", {desc = "Police", cid = Bandit.clanMap.PoliceRiot, dist = 33, size = 6, program = "Bandit", hostile = false}}, 1},
        },
        [30] = {
            {{"SpawnGroup", {desc = "Biker Gang", cid = Bandit.clanMap.Biker, dist = 33, size = 5, program = "Bandit", hostile = true}}, 1},
            {{"SpawnGroup", {desc = "Biker Gang", cid = Bandit.clanMap.Biker, dist = 33, size = 6, program = "Bandit", hostile = true}}, 1},
            {{"SpawnGroup", {desc = "Biker Gang", cid = Bandit.clanMap.Biker, dist = 33, size = 6, program = "Bandit", hostile = true}}, 1},
        },
    },
    [6] = {
        [5] = {
            {{"SpawnGroup", {desc = "Bandits", cid = Bandit.clanMap.BanditSpike, dist = 33, size = 7, program = "Bandit", hostile = true}}, 1},
        },
        [6] = {
            {{"SpawnGroup", {desc = "Robbers", cid = Bandit.clanMap.Robbers, dist = 33, size = 7, program = "Bandit", hostile = true}}, 1},
        },
        [15] = {
            {{"SpawnGroup", {desc = "Bandits", cid = Bandit.clanMap.BanditSpike, dist = 33, size = 7, program = "Bandit", hostile = true}}, 1},
        },
        [16] = {
            {{"SpawnGroup", {desc = "Robbers", cid = Bandit.clanMap.Robbers, dist = 33, size = 7, program = "Bandit", hostile = true}}, 1},
        },
        [55] = {
            {{"SpawnGroup", {desc = "Asylum Escapees", cid = Bandit.clanMap.Mental, dist = 33, size = 18, program = "Bandit", hostile = true}}, 1},
        },
    },
    [7] = {
        [30] = {
            {{"SpawnGroup", {desc = "Hooligans", cid = Bandit.clanMap.Polish, dist = 33, size = 9, program = "Bandit", hostile = true}}, 1},
        },
    },
    [8] = {
        [45] = {
            {{"SpawnGroup", {desc = "Inmate Escapees", cid = Bandit.clanMap.InmateFree, dist = 33, size = 18, program = "Bandit", hostile = true}}, 1},
        },
    },
    [9] = {
        [45] = {
            {{"SpawnGroup", {desc = "Brotherhood", cid = Bandit.clanMap.HammerBrothers, dist = 33, size = 18, program = "Bandit", hostile = true}}, 1},
        },
    },
    [10] = {
        [30] = {
            {{"SpawnGroup", {desc = "Army", cid = Bandit.clanMap.ArmyGreen, dist = 33, size = 6, program = "Bandit", hostile = false}}, 1},
        },
        [32] = {
            {{"SpawnGroup", {desc = "Bandits", cid = Bandit.clanMap.BanditStrong, dist = 33, size = 7, program = "Bandit", hostile = true}}, 1},
        },
        [35] = {
            {{"SpawnGroup", {desc = "Army", cid = Bandit.clanMap.ArmyGreen, dist = 33, size = 6, program = "Bandit", hostile = false}}, 1},
        },
        [40] = {
            {{"SpawnGroup", {desc = "Army", cid = Bandit.clanMap.ArmyGreen, dist = 33, size = 6, program = "Bandit", hostile = false}}, 1},
        },
        [45] = {
            {{"SpawnGroup", {desc = "Bandits", cid = Bandit.clanMap.BanditStrong, dist = 33, size = 7, program = "Bandit", hostile = true}}, 1},
        },
    },
    [11] = {
        [2] = {
            {{"Siren", {}}, 1},
        },
        [10] = {
            {{"JetfighterSequence", {weapon = "mg"}}, 1},
        },
        [11] = {
            {{"JetfighterSequence", {weapon = "mg"}}, 1},
        },
        [21] = {
            {{"JetfighterSequence", {weapon = "mg"}}, 1},
        },
        [22] = {
            {{"JetfighterSequence", {weapon = "mg"}}, 1},
        },
        [31] = {
            {{"JetfighterSequence", {weapon = "mg"}}, 1},
        },
        [32] = {
            {{"JetfighterSequence", {weapon = "mg"}}, 1},
        },
        [38] = {
            {{"SpawnGroup", {desc = "Army", cid = Bandit.clanMap.ArmyGreen, dist = 33, size = 6, program = "Bandit", hostile = false}}, 1},
        },
        [39] = {
            {{"SpawnGroup", {desc = "Bandits", cid = Bandit.clanMap.BanditStrong, dist = 33, size = 7, program = "Bandit", hostile = true}}, 1},
        },
        [41] = {
            {{"JetfighterSequence", {weapon = "mg"}}, 1},
        },
        [42] = {
            {{"JetfighterSequence", {weapon = "mg"}}, 1},
        },
        [47] = {
            {{"JetfighterSequence", {weapon = "mg"}}, 1},
        },
        [48] = {
            {{"JetfighterSequence", {weapon = "mg"}}, 1},
        },
    },
    [12] = {
        [2] = {
            {{"Siren", {}}, 1},
        },
        [9] = {
            {{"JetfighterSequence", {weapon = "gas"}}, 1},
        },
        [10] = {
            {{"JetfighterSequence", {weapon = "mg"}}, 1},
        },
        [11] = {
            {{"JetfighterSequence", {weapon = "mg"}}, 1},
        },
        [12] = {
            {{"SpawnGroup", {desc = "Army", cid = Bandit.clanMap.ArmyGreenMask, dist = 33, size = 6, program = "Bandit", hostile = false}}, 1},
            {{"SpawnGroup", {desc = "Army", cid = Bandit.clanMap.ArmyGreenMask, dist = 33, size = 6, program = "Bandit", hostile = false}}, 1},
        },
        [20] = {
            {{"JetfighterSequence", {weapon = "gas"}}, 1},
        },
        [21] = {
            {{"JetfighterSequence", {weapon = "mg"}}, 1},
        },
        [22] = {
            {{"JetfighterSequence", {weapon = "mg"}}, 1},
        },
        [30] = {
            {{"JetfighterSequence", {weapon = "gas"}}, 1},
        },
        [31] = {
            {{"JetfighterSequence", {weapon = "mg"}}, 1},
        },
        [32] = {
            {{"JetfighterSequence", {weapon = "mg"}}, 1},
        },
        [40] = {
            {{"JetfighterSequence", {weapon = "gas"}}, 1},
        },
        [41] = {
            {{"JetfighterSequence", {weapon = "mg"}}, 1},
        },
        [42] = {
            {{"JetfighterSequence", {weapon = "mg"}}, 1},
        },
        [43] = {
            {{"SpawnGroup", {desc = "Army", cid = Bandit.clanMap.ArmyGreenMask, dist = 33, size = 6, program = "Bandit", hostile = false}}, 1},
            {{"SpawnGroup", {desc = "Army", cid = Bandit.clanMap.ArmyGreenMask, dist = 33, size = 6, program = "Bandit", hostile = false}}, 1},
        },
    },
    [13] = {
        [5] = {
            {{"SpawnGroup", {desc = "Bandits", cid = Bandit.clanMap.BanditStrong, dist = 33, size = 10, program = "Bandit", hostile = true}}, 1},
        },
        [13] = {
            {{"PlaneCrashSequence", {}}, 1},
        },
        [14] = {
            {{"JetfighterSequence", {weapon = "mg"}}, 1},
        },
    },
	[14] = {
        [2] = {
            {{"Siren", {}}, 1},
        },
        [9] = {
            {{"JetfighterSequence", {weapon = "bomb"}}, 1},
        },
        [10] = {
            {{"JetfighterSequence", {weapon = "mg"}}, 1},
        },
        [11] = {
            {{"JetfighterSequence", {weapon = "mg"}}, 1},
        },
		[21] = {
            {{"JetfighterSequence", {weapon = "bomb"}}, 1},
        },
        [22] = {
            {{"JetfighterSequence", {weapon = "mg"}}, 1},
        },
        [23] = {
            {{"JetfighterSequence", {weapon = "mg"}}, 1},
        },
		[34] = {
            {{"JetfighterSequence", {weapon = "bomb"}}, 1},
        },
        [35] = {
            {{"JetfighterSequence", {weapon = "mg"}}, 1},
        },
        [36] = {
            {{"JetfighterSequence", {weapon = "mg"}}, 1},
        },
		[54] = {
            {{"JetfighterSequence", {weapon = "bomb"}}, 1},
        },
        [55] = {
            {{"JetfighterSequence", {weapon = "mg"}}, 1},
        },
        [56] = {
            {{"JetfighterSequence", {weapon = "mg"}}, 1},
        },
	},
	[15] = {
        [2] = {
            {{"Siren", {}}, 1},
        },
        [10] = {
            {{"JetfighterSequence", {weapon = "bomb"}}, 1},
			{{"JetfighterSequence", {weapon = "gas"}}, 500},
			{{"JetfighterSequence", {weapon = "bomb"}}, 1000},
			{{"JetfighterSequence", {weapon = "gas"}}, 1500},
			{{"JetfighterSequence", {weapon = "bomb"}}, 2000},
			{{"JetfighterSequence", {weapon = "gas"}}, 2500},
        },
        [30] = {
           	{{"JetfighterSequence", {weapon = "bomb"}}, 1},
			{{"JetfighterSequence", {weapon = "bomb"}}, 500},
			{{"JetfighterSequence", {weapon = "bomb"}}, 1000},
			{{"JetfighterSequence", {weapon = "bomb"}}, 1500},
			{{"JetfighterSequence", {weapon = "bomb"}}, 2000},
			{{"JetfighterSequence", {weapon = "bomb"}}, 2500},
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

BWOScenarios.DayOne.playerSpawns = {
    [1] = {x = 11933, y = 6863, z = 0}
}

function BWOScenarios.DayOne:waitingRoom()
    print ("waiting room build executed")
    local sx, sy, sz = 11782, 947, 0

    --[[
    BanditBaseGroupPlacements.ClearSpace (sx, sy, 0, 25, 25)
    BanditBaseGroupPlacements.ClearSpace (sx, sy, 1, 25, 25)
    BanditBaseGroupPlacements.ClearSpace (sx, sy, 2, 25, 25)
    ]]

    -- created procedurally
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 0, sy + 0, sz + 0)
    BWOBuildTools.IsoObject ("walls_interior_house_02_34", sx + 0, sy + 0, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 0, sy + 1, sz + 0)
    BWOBuildTools.IsoObject ("walls_interior_house_02_32", sx + 0, sy + 1, sz + 0)
    BWOBuildTools.IsoObject ("furniture_seating_indoor_02_1", sx + 0, sy + 1, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 0, sy + 2, sz + 0)
    BWOBuildTools.IsoObject ("walls_interior_house_02_32", sx + 0, sy + 2, sz + 0)
    BWOBuildTools.IsoObject ("furniture_seating_indoor_02_1", sx + 0, sy + 2, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 0, sy + 3, sz + 0)
    BWOBuildTools.IsoObject ("walls_interior_house_02_32", sx + 0, sy + 3, sz + 0)
    BWOBuildTools.IsoObject ("furniture_tables_high_01_43", sx + 0, sy + 3, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 0, sy + 4, sz + 0)
    BWOBuildTools.IsoObject ("walls_interior_house_02_32", sx + 0, sy + 4, sz + 0)
    BWOBuildTools.IsoObject ("location_business_office_generic_01_37", sx + 0, sy + 4, sz + 0)
    BWOBuildTools.IsoObject ("furniture_tables_high_01_42", sx + 0, sy + 4, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 0, sy + 5, sz + 0)
    BWOBuildTools.IsoObject ("walls_interior_house_02_32", sx + 0, sy + 5, sz + 0)
    BWOBuildTools.IsoObject ("location_business_office_generic_01_36", sx + 0, sy + 5, sz + 0)
    BWOBuildTools.IsoObject ("furniture_tables_high_01_43", sx + 0, sy + 5, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 0, sy + 6, sz + 0)
    BWOBuildTools.IsoObject ("walls_interior_house_02_32", sx + 0, sy + 6, sz + 0)
    BWOBuildTools.IsoObject ("furniture_tables_high_01_42", sx + 0, sy + 6, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 0, sy + 7, sz + 0)
    BWOBuildTools.IsoObject ("walls_interior_house_02_32", sx + 0, sy + 7, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 0, sy + 8, sz + 0)
    BWOBuildTools.IsoObject ("walls_interior_house_02_32", sx + 0, sy + 8, sz + 0)
    BWOBuildTools.IsoObject ("furniture_seating_indoor_02_1", sx + 0, sy + 8, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 0, sy + 9, sz + 0)
    BWOBuildTools.IsoObject ("walls_interior_house_02_32", sx + 0, sy + 9, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_13", sx + 0, sy + 10, sz + 0)
    BWOBuildTools.IsoObject ("walls_interior_house_04_86", sx + 0, sy + 10, sz + 0)
    BWOBuildTools.IsoObject ("fixtures_counters_01_59", sx + 0, sy + 10, sz + 0)
    BWOBuildTools.IsoObject ("fixtures_sinks_01_21", sx + 0, sy + 10, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_13", sx + 0, sy + 11, sz + 0)
    BWOBuildTools.IsoObject ("walls_interior_house_04_84", sx + 0, sy + 11, sz + 0)
    BWOBuildTools.IsoObject ("fixtures_bathroom_01_5", sx + 0, sy + 11, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 0, sy + 12, sz + 0)
    BWOBuildTools.IsoObject ("walls_interior_house_02_34", sx + 0, sy + 12, sz + 0)
    BWOBuildTools.IsoObject ("vegetation_indoor_01_11", sx + 0, sy + 12, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 0, sy + 13, sz + 0)
    BWOBuildTools.IsoObject ("walls_interior_house_02_32", sx + 0, sy + 13, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 0, sy + 14, sz + 0)
    BWOBuildTools.IsoObject ("walls_interior_house_02_32", sx + 0, sy + 14, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 0, sy + 15, sz + 0)
    BWOBuildTools.IsoObject ("walls_interior_house_02_32", sx + 0, sy + 15, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 0, sy + 16, sz + 0)
    BWOBuildTools.IsoObject ("walls_interior_house_02_32", sx + 0, sy + 16, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 0, sy + 17, sz + 0)
    BWOBuildTools.IsoObject ("walls_interior_house_02_32", sx + 0, sy + 17, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 0, sy + 18, sz + 0)
    BWOBuildTools.IsoObject ("walls_interior_house_02_32", sx + 0, sy + 18, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 0, sy + 19, sz + 0)
    BWOBuildTools.IsoObject ("walls_interior_house_02_32", sx + 0, sy + 19, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 0, sy + 20, sz + 0)
    BWOBuildTools.IsoObject ("walls_interior_house_02_32", sx + 0, sy + 20, sz + 0)
    BWOBuildTools.IsoObject ("location_community_school_01_33", sx + 0, sy + 20, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 0, sy + 21, sz + 0)
    BWOBuildTools.IsoObject ("walls_interior_house_02_32", sx + 0, sy + 21, sz + 0)
    BWOBuildTools.IsoObject ("vegetation_indoor_01_11", sx + 0, sy + 21, sz + 0)
    BWOBuildTools.IsoObject ("walls_exterior_house_02_49", sx + 0, sy + 22, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 1, sy + 0, sz + 0)
    BWOBuildTools.IsoObject ("walls_interior_house_02_43", sx + 1, sy + 0, sz + 0)
    BWOBuildTools.IsoObject ("fixtures_doors_frames_01_3", sx + 1, sy + 0, sz + 0)
    BWOBuildTools.IsoObject ("fixtures_doors_01_57", sx + 1, sy + 0, sz + 0)
    BWOBuildTools.IsoObject ("lighting_indoor_01_25", sx + 1, sy + 0, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 1, sy + 1, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 1, sy + 2, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 1, sy + 3, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 1, sy + 4, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 1, sy + 5, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 1, sy + 6, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 1, sy + 7, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 1, sy + 8, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 1, sy + 9, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_13", sx + 1, sy + 10, sz + 0)
    BWOBuildTools.IsoObject ("walls_interior_house_04_95", sx + 1, sy + 10, sz + 0)
    BWOBuildTools.IsoObject ("fixtures_doors_frames_01_3", sx + 1, sy + 10, sz + 0)
    BWOBuildTools.IsoDoor ("fixtures_doors_01_15", sx + 1, sy + 10, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_13", sx + 1, sy + 11, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 1, sy + 12, sz + 0)
    BWOBuildTools.IsoObject ("walls_interior_house_02_33", sx + 1, sy + 12, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 1, sy + 13, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 1, sy + 14, sz + 0)
    BWOBuildTools.IsoObject ("furniture_seating_indoor_02_1", sx + 1, sy + 14, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 1, sy + 15, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 1, sy + 16, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 1, sy + 17, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 1, sy + 18, sz + 0)
    BWOBuildTools.IsoObject ("furniture_seating_indoor_02_1", sx + 1, sy + 18, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 1, sy + 19, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 1, sy + 20, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 1, sy + 21, sz + 0)
    BWOBuildTools.IsoWindow ("walls_commercial_01_17", sx + 1, sy + 22, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 2, sy + 0, sz + 0)
    BWOBuildTools.IsoObject ("walls_interior_house_02_33", sx + 2, sy + 0, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 2, sy + 1, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 2, sy + 2, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 2, sy + 3, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 2, sy + 4, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 2, sy + 5, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 2, sy + 6, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 2, sy + 7, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 2, sy + 8, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 2, sy + 9, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_13", sx + 2, sy + 10, sz + 0)
    BWOBuildTools.IsoObject ("walls_interior_house_04_85", sx + 2, sy + 10, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_13", sx + 2, sy + 11, sz + 0)
    BWOBuildTools.IsoObject ("fixtures_bathroom_01_15", sx + 2, sy + 11, sz + 0)
    BWOBuildTools.IsoObject ("trashcontainers_01_20", sx + 2, sy + 11, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 2, sy + 12, sz + 0)
    BWOBuildTools.IsoObject ("walls_interior_house_02_33", sx + 2, sy + 12, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 2, sy + 13, sz + 0)
    BWOBuildTools.IsoObject ("furniture_seating_indoor_02_0", sx + 2, sy + 13, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 2, sy + 14, sz + 0)
    BWOBuildTools.IsoObject ("furniture_tables_high_01_23", sx + 2, sy + 14, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 2, sy + 15, sz + 0)
    BWOBuildTools.IsoObject ("furniture_seating_indoor_02_2", sx + 2, sy + 15, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 2, sy + 16, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 2, sy + 17, sz + 0)
    BWOBuildTools.IsoObject ("furniture_seating_indoor_02_0", sx + 2, sy + 17, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 2, sy + 18, sz + 0)
    BWOBuildTools.IsoObject ("furniture_tables_high_01_23", sx + 2, sy + 18, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 2, sy + 19, sz + 0)
    BWOBuildTools.IsoObject ("furniture_seating_indoor_02_2", sx + 2, sy + 19, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 2, sy + 20, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 2, sy + 21, sz + 0)
    BWOBuildTools.IsoWindow ("walls_commercial_01_17", sx + 2, sy + 22, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_21", sx + 3, sy + 0, sz + 0)
    BWOBuildTools.IsoObject ("location_community_church_small_01_5", sx + 3, sy + 0, sz + 0)
    BWOBuildTools.IsoObject ("location_community_church_small_01_14", sx + 3, sy + 0, sz + 0)
    BWOBuildTools.IsoObject ("fixtures_doors_frames_01_2", sx + 3, sy + 0, sz + 0)
    BWOBuildTools.IsoDoor ("fixtures_doors_01_56", sx + 3, sy + 0, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_21", sx + 3, sy + 1, sz + 0)
    BWOBuildTools.IsoObject ("location_community_church_small_01_4", sx + 3, sy + 1, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_21", sx + 3, sy + 2, sz + 0)
    BWOBuildTools.IsoObject ("location_community_church_small_01_4", sx + 3, sy + 2, sz + 0)
    BWOBuildTools.IsoObject ("appliances_cooking_01_20", sx + 3, sy + 2, sz + 0)
    BWOBuildTools.IsoObject ("appliances_cooking_01_68", sx + 3, sy + 2, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_21", sx + 3, sy + 3, sz + 0)
    BWOBuildTools.IsoObject ("location_community_church_small_01_4", sx + 3, sy + 3, sz + 0)
    BWOBuildTools.IsoObject ("appliances_cooking_01_20", sx + 3, sy + 3, sz + 0)
    BWOBuildTools.IsoObject ("appliances_cooking_01_68", sx + 3, sy + 3, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_21", sx + 3, sy + 4, sz + 0)
    BWOBuildTools.IsoObject ("location_community_church_small_01_4", sx + 3, sy + 4, sz + 0)
    BWOBuildTools.IsoObject ("appliances_cooking_01_52", sx + 3, sy + 4, sz + 0)
    BWOBuildTools.IsoObject ("appliances_cooking_01_68", sx + 3, sy + 4, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_21", sx + 3, sy + 5, sz + 0)
    BWOBuildTools.IsoObject ("location_community_church_small_01_4", sx + 3, sy + 5, sz + 0)
    BWOBuildTools.IsoObject ("appliances_cooking_01_41", sx + 3, sy + 5, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_21", sx + 3, sy + 6, sz + 0)
    BWOBuildTools.IsoObject ("location_community_church_small_01_4", sx + 3, sy + 6, sz + 0)
    BWOBuildTools.IsoObject ("appliances_cooking_01_40", sx + 3, sy + 6, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 3, sy + 7, sz + 0)
    BWOBuildTools.IsoObject ("walls_interior_house_02_33", sx + 3, sy + 7, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 3, sy + 8, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 3, sy + 9, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_13", sx + 3, sy + 10, sz + 0)
    BWOBuildTools.IsoObject ("walls_interior_house_04_86", sx + 3, sy + 10, sz + 0)
    BWOBuildTools.IsoObject ("fixtures_counters_01_59", sx + 3, sy + 10, sz + 0)
    BWOBuildTools.IsoObject ("fixtures_sinks_01_21", sx + 3, sy + 10, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_13", sx + 3, sy + 11, sz + 0)
    BWOBuildTools.IsoObject ("walls_interior_house_04_84", sx + 3, sy + 11, sz + 0)
    BWOBuildTools.IsoObject ("fixtures_bathroom_01_5", sx + 3, sy + 11, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 3, sy + 12, sz + 0)
    BWOBuildTools.IsoObject ("walls_interior_house_02_33", sx + 3, sy + 12, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 3, sy + 13, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 3, sy + 14, sz + 0)
    BWOBuildTools.IsoObject ("furniture_seating_indoor_02_3", sx + 3, sy + 14, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 3, sy + 15, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 3, sy + 16, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 3, sy + 17, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 3, sy + 18, sz + 0)
    BWOBuildTools.IsoObject ("furniture_seating_indoor_02_3", sx + 3, sy + 18, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 3, sy + 19, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 3, sy + 20, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 3, sy + 21, sz + 0)
    BWOBuildTools.IsoWindow ("walls_commercial_01_17", sx + 3, sy + 22, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_21", sx + 4, sy + 0, sz + 0)
    BWOBuildTools.IsoObject ("location_community_church_small_01_5", sx + 4, sy + 0, sz + 0)
    BWOBuildTools.IsoObject ("location_community_school_01_32", sx + 4, sy + 0, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_21", sx + 4, sy + 1, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_21", sx + 4, sy + 2, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_21", sx + 4, sy + 3, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_21", sx + 4, sy + 4, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_21", sx + 4, sy + 5, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_21", sx + 4, sy + 6, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 4, sy + 7, sz + 0)
    BWOBuildTools.IsoObject ("walls_interior_house_02_33", sx + 4, sy + 7, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 4, sy + 8, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 4, sy + 9, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_13", sx + 4, sy + 10, sz + 0)
    BWOBuildTools.IsoObject ("walls_interior_house_04_95", sx + 4, sy + 10, sz + 0)
    BWOBuildTools.IsoObject ("fixtures_doors_frames_01_3", sx + 4, sy + 10, sz + 0)
    BWOBuildTools.IsoDoor ("fixtures_doors_01_15", sx + 4, sy + 10, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_13", sx + 4, sy + 11, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 4, sy + 12, sz + 0)
    BWOBuildTools.IsoObject ("walls_interior_house_02_33", sx + 4, sy + 12, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 4, sy + 13, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 4, sy + 14, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 4, sy + 15, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 4, sy + 16, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 4, sy + 17, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 4, sy + 18, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 4, sy + 19, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 4, sy + 20, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 4, sy + 21, sz + 0)
    BWOBuildTools.IsoWindow ("walls_commercial_01_17", sx + 4, sy + 22, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_21", sx + 5, sy + 0, sz + 0)
    BWOBuildTools.IsoObject ("location_community_church_small_01_5", sx + 5, sy + 0, sz + 0)
    BWOBuildTools.IsoObject ("appliances_refrigeration_01_22", sx + 5, sy + 0, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_21", sx + 5, sy + 1, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_21", sx + 5, sy + 2, sz + 0)
    BWOBuildTools.IsoObject ("trashcontainers_01_17", sx + 5, sy + 2, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_21", sx + 5, sy + 3, sz + 0)
    BWOBuildTools.IsoObject ("fixtures_counters_01_39", sx + 5, sy + 3, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_21", sx + 5, sy + 4, sz + 0)
    BWOBuildTools.IsoObject ("fixtures_counters_01_39", sx + 5, sy + 4, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_21", sx + 5, sy + 5, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_21", sx + 5, sy + 6, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 5, sy + 7, sz + 0)
    BWOBuildTools.IsoObject ("walls_interior_house_02_33", sx + 5, sy + 7, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 5, sy + 8, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 5, sy + 9, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_13", sx + 5, sy + 10, sz + 0)
    BWOBuildTools.IsoObject ("walls_interior_house_04_85", sx + 5, sy + 10, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_13", sx + 5, sy + 11, sz + 0)
    BWOBuildTools.IsoObject ("fixtures_bathroom_01_15", sx + 5, sy + 11, sz + 0)
    BWOBuildTools.IsoObject ("trashcontainers_01_20", sx + 5, sy + 11, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 5, sy + 12, sz + 0)
    BWOBuildTools.IsoObject ("walls_interior_house_02_33", sx + 5, sy + 12, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 5, sy + 13, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 5, sy + 14, sz + 0)
    BWOBuildTools.IsoObject ("furniture_seating_indoor_02_1", sx + 5, sy + 14, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 5, sy + 15, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 5, sy + 16, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 5, sy + 17, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 5, sy + 18, sz + 0)
    BWOBuildTools.IsoObject ("furniture_seating_indoor_02_1", sx + 5, sy + 18, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 5, sy + 19, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 5, sy + 20, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 5, sy + 21, sz + 0)
    BWOBuildTools.IsoObject ("walls_exterior_house_02_49", sx + 5, sy + 22, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_21", sx + 6, sy + 0, sz + 0)
    BWOBuildTools.IsoObject ("location_community_church_small_01_5", sx + 6, sy + 0, sz + 0)
    BWOBuildTools.IsoObject ("appliances_refrigeration_01_22", sx + 6, sy + 0, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_21", sx + 6, sy + 1, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_21", sx + 6, sy + 2, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_21", sx + 6, sy + 3, sz + 0)
    BWOBuildTools.IsoObject ("fixtures_counters_01_35", sx + 6, sy + 3, sz + 0)
    BWOBuildTools.IsoObject ("fixtures_sinks_01_16", sx + 6, sy + 3, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_21", sx + 6, sy + 4, sz + 0)
    BWOBuildTools.IsoObject ("fixtures_counters_01_35", sx + 6, sy + 4, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_21", sx + 6, sy + 5, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_21", sx + 6, sy + 6, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_21", sx + 6, sy + 7, sz + 0)
    BWOBuildTools.IsoObject ("location_community_church_small_01_14", sx + 6, sy + 7, sz + 0)
    BWOBuildTools.IsoObject ("fixtures_doors_frames_01_2", sx + 6, sy + 7, sz + 0)
    BWOBuildTools.IsoDoor ("fixtures_doors_02_16", sx + 6, sy + 7, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 6, sy + 8, sz + 0)
    BWOBuildTools.IsoObject ("walls_interior_house_02_33", sx + 6, sy + 8, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 6, sy + 9, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 6, sy + 10, sz + 0)
    BWOBuildTools.IsoObject ("walls_interior_house_02_32", sx + 6, sy + 10, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 6, sy + 11, sz + 0)
    BWOBuildTools.IsoObject ("walls_interior_house_02_32", sx + 6, sy + 11, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 6, sy + 12, sz + 0)
    BWOBuildTools.IsoObject ("walls_interior_house_02_33", sx + 6, sy + 12, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 6, sy + 13, sz + 0)
    BWOBuildTools.IsoObject ("furniture_seating_indoor_02_0", sx + 6, sy + 13, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 6, sy + 14, sz + 0)
    BWOBuildTools.IsoObject ("furniture_tables_high_01_23", sx + 6, sy + 14, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 6, sy + 15, sz + 0)
    BWOBuildTools.IsoObject ("furniture_seating_indoor_02_2", sx + 6, sy + 15, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 6, sy + 16, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 6, sy + 17, sz + 0)
    BWOBuildTools.IsoObject ("furniture_seating_indoor_02_0", sx + 6, sy + 17, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 6, sy + 18, sz + 0)
    BWOBuildTools.IsoObject ("furniture_tables_high_01_23", sx + 6, sy + 18, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 6, sy + 19, sz + 0)
    BWOBuildTools.IsoObject ("furniture_seating_indoor_02_2", sx + 6, sy + 19, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 6, sy + 20, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 6, sy + 21, sz + 0)
    BWOBuildTools.IsoObject ("walls_interior_house_02_34", sx + 6, sy + 21, sz + 0)
    BWOBuildTools.IsoObject ("walls_exterior_house_02_49", sx + 6, sy + 22, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_21", sx + 7, sy + 0, sz + 0)
    BWOBuildTools.IsoObject ("location_community_church_small_01_5", sx + 7, sy + 0, sz + 0)
    BWOBuildTools.IsoObject ("appliances_refrigeration_01_22", sx + 7, sy + 0, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_21", sx + 7, sy + 1, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_21", sx + 7, sy + 2, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_21", sx + 7, sy + 3, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_21", sx + 7, sy + 4, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_21", sx + 7, sy + 5, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_21", sx + 7, sy + 6, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_21", sx + 7, sy + 7, sz + 0)
    BWOBuildTools.IsoObject ("lighting_indoor_01_3", sx + 7, sy + 7, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 7, sy + 8, sz + 0)
    BWOBuildTools.IsoObject ("walls_interior_house_02_33", sx + 7, sy + 8, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 7, sy + 9, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 7, sy + 10, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 7, sy + 11, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 7, sy + 12, sz + 0)
    BWOBuildTools.IsoObject ("walls_interior_house_02_43", sx + 7, sy + 12, sz + 0)
    BWOBuildTools.IsoObject ("fixtures_doors_frames_01_3", sx + 7, sy + 12, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 7, sy + 13, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 7, sy + 14, sz + 0)
    BWOBuildTools.IsoObject ("furniture_seating_indoor_02_3", sx + 7, sy + 14, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 7, sy + 15, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 7, sy + 16, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 7, sy + 17, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 7, sy + 18, sz + 0)
    BWOBuildTools.IsoObject ("furniture_seating_indoor_02_3", sx + 7, sy + 18, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 7, sy + 19, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 7, sy + 20, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 7, sy + 21, sz + 0)
    BWOBuildTools.IsoObject ("walls_interior_house_02_33", sx + 7, sy + 21, sz + 0)
    BWOBuildTools.IsoObject ("blends_street_01_21", sx + 7, sy + 22, sz + 0)
    BWOBuildTools.IsoObject ("walls_exterior_house_02_49", sx + 7, sy + 22, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_21", sx + 8, sy + 0, sz + 0)
    BWOBuildTools.IsoObject ("location_community_church_small_01_5", sx + 8, sy + 0, sz + 0)
    BWOBuildTools.IsoObject ("fixtures_counters_01_38", sx + 8, sy + 0, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_21", sx + 8, sy + 1, sz + 0)
    BWOBuildTools.IsoObject ("fixtures_counters_01_39", sx + 8, sy + 1, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_21", sx + 8, sy + 2, sz + 0)
    BWOBuildTools.IsoObject ("appliances_cooking_01_14", sx + 8, sy + 2, sz + 0)
    BWOBuildTools.IsoObject ("appliances_cooking_01_71", sx + 8, sy + 2, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_21", sx + 8, sy + 3, sz + 0)
    BWOBuildTools.IsoObject ("appliances_cooking_01_14", sx + 8, sy + 3, sz + 0)
    BWOBuildTools.IsoObject ("appliances_cooking_01_71", sx + 8, sy + 3, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_21", sx + 8, sy + 4, sz + 0)
    BWOBuildTools.IsoObject ("fixtures_counters_01_39", sx + 8, sy + 4, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_21", sx + 8, sy + 5, sz + 0)
    BWOBuildTools.IsoObject ("fixtures_counters_01_39", sx + 8, sy + 5, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_21", sx + 8, sy + 6, sz + 0)
    BWOBuildTools.IsoObject ("fixtures_sinks_01_34", sx + 8, sy + 6, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_21", sx + 8, sy + 7, sz + 0)
    BWOBuildTools.IsoObject ("appliances_cooking_01_66", sx + 8, sy + 7, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 8, sy + 8, sz + 0)
    BWOBuildTools.IsoObject ("walls_interior_house_02_33", sx + 8, sy + 8, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 8, sy + 9, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 8, sy + 10, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 8, sy + 11, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 8, sy + 12, sz + 0)
    BWOBuildTools.IsoObject ("walls_interior_house_02_33", sx + 8, sy + 12, sz + 0)
    BWOBuildTools.IsoObject ("vegetation_indoor_01_12", sx + 8, sy + 12, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 8, sy + 13, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 8, sy + 14, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 8, sy + 15, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 8, sy + 16, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 8, sy + 17, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 8, sy + 18, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 8, sy + 19, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 8, sy + 20, sz + 0)
    BWOBuildTools.IsoObject ("lighting_indoor_01_3", sx + 8, sy + 20, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 8, sy + 21, sz + 0)
    BWOBuildTools.IsoObject ("walls_interior_house_02_33", sx + 8, sy + 21, sz + 0)
    BWOBuildTools.IsoObject ("walls_exterior_house_02_49", sx + 8, sy + 22, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 9, sy + 0, sz + 0)
    BWOBuildTools.IsoObject ("walls_interior_house_02_32", sx + 9, sy + 0, sz + 0)
    BWOBuildTools.IsoWindow ("walls_commercial_01_65", sx + 9, sy + 0, sz + 0)
    BWOBuildTools.IsoObject ("vegetation_indoor_01_7", sx + 9, sy + 0, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 9, sy + 1, sz + 0)
    BWOBuildTools.IsoObject ("walls_interior_house_02_32", sx + 9, sy + 1, sz + 0)
    BWOBuildTools.IsoObject ("furniture_seating_indoor_02_0", sx + 9, sy + 1, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 9, sy + 2, sz + 0)
    BWOBuildTools.IsoObject ("walls_interior_house_02_32", sx + 9, sy + 2, sz + 0)
    BWOBuildTools.IsoObject ("furniture_tables_high_01_23", sx + 9, sy + 2, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 9, sy + 3, sz + 0)
    BWOBuildTools.IsoObject ("walls_interior_house_02_32", sx + 9, sy + 3, sz + 0)
    BWOBuildTools.IsoObject ("furniture_seating_indoor_02_2", sx + 9, sy + 3, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 9, sy + 4, sz + 0)
    BWOBuildTools.IsoObject ("walls_interior_house_02_32", sx + 9, sy + 4, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 9, sy + 5, sz + 0)
    BWOBuildTools.IsoObject ("walls_interior_house_02_32", sx + 9, sy + 5, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 9, sy + 6, sz + 0)
    BWOBuildTools.IsoObject ("walls_interior_house_02_32", sx + 9, sy + 6, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 9, sy + 7, sz + 0)
    BWOBuildTools.IsoObject ("walls_interior_house_02_32", sx + 9, sy + 7, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 9, sy + 8, sz + 0)
    BWOBuildTools.IsoObject ("walls_interior_house_02_35", sx + 9, sy + 8, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 9, sy + 9, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 9, sy + 10, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 9, sy + 11, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 9, sy + 12, sz + 0)
    BWOBuildTools.IsoObject ("walls_interior_house_02_32", sx + 9, sy + 12, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 9, sy + 13, sz + 0)
    BWOBuildTools.IsoObject ("walls_interior_house_02_32", sx + 9, sy + 13, sz + 0)
    BWOBuildTools.IsoObject ("location_community_school_01_33", sx + 9, sy + 13, sz + 0)
    BWOBuildTools.IsoObject ("location_restaurant_bar_01_5", sx + 9, sy + 13, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 9, sy + 14, sz + 0)
    BWOBuildTools.IsoObject ("walls_interior_house_02_32", sx + 9, sy + 14, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 9, sy + 15, sz + 0)
    BWOBuildTools.IsoObject ("walls_interior_house_02_32", sx + 9, sy + 15, sz + 0)
    BWOBuildTools.IsoObject ("location_restaurant_bar_01_39", sx + 9, sy + 15, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 9, sy + 16, sz + 0)
    BWOBuildTools.IsoObject ("walls_interior_house_02_32", sx + 9, sy + 16, sz + 0)
    BWOBuildTools.IsoObject ("location_restaurant_bar_01_38", sx + 9, sy + 16, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 9, sy + 17, sz + 0)
    BWOBuildTools.IsoObject ("walls_interior_house_02_32", sx + 9, sy + 17, sz + 0)
    BWOBuildTools.IsoObject ("location_restaurant_bar_01_37", sx + 9, sy + 17, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 9, sy + 18, sz + 0)
    BWOBuildTools.IsoObject ("walls_interior_house_02_32", sx + 9, sy + 18, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 9, sy + 19, sz + 0)
    BWOBuildTools.IsoObject ("walls_interior_house_02_32", sx + 9, sy + 19, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 9, sy + 20, sz + 0)
    BWOBuildTools.IsoObject ("walls_interior_house_02_42", sx + 9, sy + 20, sz + 0)
    BWOBuildTools.IsoObject ("fixtures_doors_frames_01_2", sx + 9, sy + 20, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 9, sy + 21, sz + 0)
    BWOBuildTools.IsoObject ("walls_interior_house_02_35", sx + 9, sy + 21, sz + 0)
    BWOBuildTools.IsoObject ("walls_exterior_house_02_49", sx + 9, sy + 22, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 10, sy + 0, sz + 0)
    BWOBuildTools.IsoWindow ("walls_commercial_01_65", sx + 10, sy + 0, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 10, sy + 1, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 10, sy + 2, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 10, sy + 3, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 10, sy + 4, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 10, sy + 5, sz + 0)
    BWOBuildTools.IsoObject ("furniture_seating_indoor_02_0", sx + 10, sy + 5, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 10, sy + 6, sz + 0)
    BWOBuildTools.IsoObject ("furniture_tables_high_01_23", sx + 10, sy + 6, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 10, sy + 7, sz + 0)
    BWOBuildTools.IsoObject ("furniture_seating_indoor_02_2", sx + 10, sy + 7, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 10, sy + 8, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 10, sy + 9, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 10, sy + 10, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 10, sy + 11, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 10, sy + 12, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 10, sy + 13, sz + 0)
    BWOBuildTools.IsoObject ("location_restaurant_bar_01_5", sx + 10, sy + 13, sz + 0)
    BWOBuildTools.IsoObject ("location_restaurant_bar_01_35", sx + 10, sy + 13, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 10, sy + 14, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 10, sy + 15, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 10, sy + 16, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 10, sy + 17, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 10, sy + 18, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 10, sy + 19, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 10, sy + 20, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 10, sy + 21, sz + 0)
    BWOBuildTools.IsoWindow ("walls_commercial_01_17", sx + 10, sy + 22, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 11, sy + 0, sz + 0)
    BWOBuildTools.IsoObject ("walls_commercial_01_75", sx + 11, sy + 0, sz + 0)
    BWOBuildTools.IsoObject ("fixtures_doors_01_37", sx + 11, sy + 0, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 11, sy + 1, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 11, sy + 2, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 11, sy + 3, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 11, sy + 4, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 11, sy + 5, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 11, sy + 6, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 11, sy + 7, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 11, sy + 8, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 11, sy + 9, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 11, sy + 10, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 11, sy + 11, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 11, sy + 12, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 11, sy + 13, sz + 0)
    BWOBuildTools.IsoObject ("location_restaurant_bar_01_6", sx + 11, sy + 13, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 11, sy + 14, sz + 0)
    BWOBuildTools.IsoObject ("location_restaurant_bar_01_7", sx + 11, sy + 14, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 11, sy + 15, sz + 0)
    BWOBuildTools.IsoObject ("location_restaurant_bar_01_7", sx + 11, sy + 15, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 11, sy + 16, sz + 0)
    BWOBuildTools.IsoObject ("location_restaurant_bar_01_7", sx + 11, sy + 16, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 11, sy + 17, sz + 0)
    BWOBuildTools.IsoObject ("location_restaurant_bar_01_7", sx + 11, sy + 17, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 11, sy + 18, sz + 0)
    BWOBuildTools.IsoObject ("location_restaurant_bar_01_7", sx + 11, sy + 18, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 11, sy + 19, sz + 0)
    BWOBuildTools.IsoObject ("fixtures_counters_01_55", sx + 11, sy + 19, sz + 0)
    BWOBuildTools.IsoObject ("location_shop_accessories_01_23", sx + 11, sy + 19, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 11, sy + 20, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 11, sy + 21, sz + 0)
    BWOBuildTools.IsoObject ("walls_exterior_house_02_49", sx + 11, sy + 22, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 12, sy + 0, sz + 0)
    BWOBuildTools.IsoWindow ("walls_commercial_01_65", sx + 12, sy + 0, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 12, sy + 1, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 12, sy + 2, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 12, sy + 3, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 12, sy + 4, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 12, sy + 5, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 12, sy + 6, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 12, sy + 7, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 12, sy + 8, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 12, sy + 9, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 12, sy + 10, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 12, sy + 11, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 12, sy + 12, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 12, sy + 13, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 12, sy + 14, sz + 0)
    BWOBuildTools.IsoObject ("location_restaurant_bar_01_25", sx + 12, sy + 14, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 12, sy + 15, sz + 0)
    BWOBuildTools.IsoObject ("location_restaurant_bar_01_25", sx + 12, sy + 15, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 12, sy + 16, sz + 0)
    BWOBuildTools.IsoObject ("location_restaurant_bar_01_25", sx + 12, sy + 16, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 12, sy + 17, sz + 0)
    BWOBuildTools.IsoObject ("location_restaurant_bar_01_25", sx + 12, sy + 17, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 12, sy + 18, sz + 0)
    BWOBuildTools.IsoObject ("location_restaurant_bar_01_25", sx + 12, sy + 18, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 12, sy + 19, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 12, sy + 20, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 12, sy + 21, sz + 0)
    BWOBuildTools.IsoObject ("walls_exterior_house_02_49", sx + 12, sy + 22, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 13, sy + 0, sz + 0)
    BWOBuildTools.IsoWindow ("walls_commercial_01_65", sx + 13, sy + 0, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 13, sy + 1, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 13, sy + 2, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 13, sy + 3, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 13, sy + 4, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 13, sy + 5, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 13, sy + 6, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 13, sy + 7, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 13, sy + 8, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 13, sy + 9, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 13, sy + 10, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 13, sy + 11, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 13, sy + 12, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 13, sy + 13, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 13, sy + 14, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 13, sy + 15, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 13, sy + 16, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 13, sy + 17, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 13, sy + 18, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 13, sy + 19, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 13, sy + 20, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 13, sy + 21, sz + 0)
    BWOBuildTools.IsoObject ("walls_exterior_house_02_49", sx + 13, sy + 22, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 14, sy + 0, sz + 0)
    BWOBuildTools.IsoWindow ("walls_commercial_01_65", sx + 14, sy + 0, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 14, sy + 1, sz + 0)
    BWOBuildTools.IsoObject ("floors_rugs_01_28", sx + 14, sy + 1, sz + 0)
    BWOBuildTools.IsoObject ("furniture_seating_indoor_02_0", sx + 14, sy + 1, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 14, sy + 2, sz + 0)
    BWOBuildTools.IsoObject ("floors_rugs_01_36", sx + 14, sy + 2, sz + 0)
    BWOBuildTools.IsoObject ("furniture_tables_high_01_40", sx + 14, sy + 2, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 14, sy + 3, sz + 0)
    BWOBuildTools.IsoObject ("floors_rugs_01_44", sx + 14, sy + 3, sz + 0)
    BWOBuildTools.IsoObject ("furniture_seating_indoor_02_2", sx + 14, sy + 3, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 14, sy + 4, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 14, sy + 5, sz + 0)
    BWOBuildTools.IsoObject ("recreational_01_45", sx + 14, sy + 5, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 14, sy + 6, sz + 0)
    BWOBuildTools.IsoObject ("recreational_01_44", sx + 14, sy + 6, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 14, sy + 7, sz + 0)
    BWOBuildTools.IsoObject ("recreational_01_40", sx + 14, sy + 7, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 14, sy + 8, sz + 0)
    BWOBuildTools.IsoObject ("recreational_01_10", sx + 14, sy + 8, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 14, sy + 9, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 14, sy + 10, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 14, sy + 11, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 14, sy + 12, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 14, sy + 13, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 14, sy + 14, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 14, sy + 15, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 14, sy + 16, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 14, sy + 17, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 14, sy + 18, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 14, sy + 19, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 14, sy + 20, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 14, sy + 21, sz + 0)
    BWOBuildTools.IsoWindow ("walls_commercial_01_17", sx + 14, sy + 22, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 15, sy + 0, sz + 0)
    BWOBuildTools.IsoWindow ("walls_commercial_01_65", sx + 15, sy + 0, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 15, sy + 1, sz + 0)
    BWOBuildTools.IsoObject ("floors_rugs_01_29", sx + 15, sy + 1, sz + 0)
    BWOBuildTools.IsoObject ("furniture_seating_indoor_02_0", sx + 15, sy + 1, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 15, sy + 2, sz + 0)
    BWOBuildTools.IsoObject ("floors_rugs_01_37", sx + 15, sy + 2, sz + 0)
    BWOBuildTools.IsoObject ("furniture_tables_high_01_41", sx + 15, sy + 2, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 15, sy + 3, sz + 0)
    BWOBuildTools.IsoObject ("floors_rugs_01_45", sx + 15, sy + 3, sz + 0)
    BWOBuildTools.IsoObject ("furniture_seating_indoor_02_2", sx + 15, sy + 3, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 15, sy + 4, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 15, sy + 5, sz + 0)
    BWOBuildTools.IsoObject ("recreational_01_43", sx + 15, sy + 5, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 15, sy + 6, sz + 0)
    BWOBuildTools.IsoObject ("recreational_01_42", sx + 15, sy + 6, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 15, sy + 7, sz + 0)
    BWOBuildTools.IsoObject ("recreational_01_41", sx + 15, sy + 7, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 15, sy + 8, sz + 0)
    BWOBuildTools.IsoObject ("recreational_01_11", sx + 15, sy + 8, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 15, sy + 9, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 15, sy + 10, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 15, sy + 11, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 15, sy + 12, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 15, sy + 13, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 15, sy + 14, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 15, sy + 15, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 15, sy + 16, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 15, sy + 17, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 15, sy + 18, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 15, sy + 19, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 15, sy + 20, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 15, sy + 21, sz + 0)
    BWOBuildTools.IsoObject ("walls_exterior_house_02_49", sx + 15, sy + 22, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 16, sy + 0, sz + 0)
    BWOBuildTools.IsoWindow ("walls_commercial_01_65", sx + 16, sy + 0, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 16, sy + 1, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 16, sy + 2, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 16, sy + 3, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 16, sy + 4, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 16, sy + 5, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 16, sy + 6, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 16, sy + 7, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 16, sy + 8, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 16, sy + 9, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 16, sy + 10, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 16, sy + 11, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 16, sy + 12, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 16, sy + 13, sz + 0)
    BWOBuildTools.IsoObject ("fixtures_railings_01_118", sx + 16, sy + 13, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 16, sy + 14, sz + 0)
    BWOBuildTools.IsoObject ("fixtures_railings_01_116", sx + 16, sy + 14, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 16, sy + 15, sz + 0)
    BWOBuildTools.IsoObject ("fixtures_railings_01_116", sx + 16, sy + 15, sz + 0)
    BWOBuildTools.IsoObject ("furniture_seating_indoor_03_65", sx + 16, sy + 15, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 16, sy + 16, sz + 0)
    BWOBuildTools.IsoObject ("fixtures_railings_01_116", sx + 16, sy + 16, sz + 0)
    BWOBuildTools.IsoObject ("furniture_seating_indoor_03_64", sx + 16, sy + 16, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 16, sy + 17, sz + 0)
    BWOBuildTools.IsoObject ("fixtures_railings_01_116", sx + 16, sy + 17, sz + 0)
    BWOBuildTools.IsoObject ("furniture_seating_indoor_03_65", sx + 16, sy + 17, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 16, sy + 18, sz + 0)
    BWOBuildTools.IsoObject ("fixtures_railings_01_116", sx + 16, sy + 18, sz + 0)
    BWOBuildTools.IsoObject ("furniture_seating_indoor_03_64", sx + 16, sy + 18, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 16, sy + 19, sz + 0)
    BWOBuildTools.IsoObject ("fixtures_railings_01_116", sx + 16, sy + 19, sz + 0)
    BWOBuildTools.IsoObject ("vegetation_indoor_01_9", sx + 16, sy + 19, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 16, sy + 20, sz + 0)
    BWOBuildTools.IsoObject ("fixtures_railings_01_119", sx + 16, sy + 20, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 16, sy + 21, sz + 0)
    BWOBuildTools.IsoObject ("walls_exterior_house_02_49", sx + 16, sy + 22, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 17, sy + 0, sz + 0)
    BWOBuildTools.IsoWindow ("walls_commercial_01_65", sx + 17, sy + 0, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 17, sy + 1, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 17, sy + 2, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 17, sy + 3, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 17, sy + 4, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 17, sy + 5, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 17, sy + 6, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 17, sy + 7, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 17, sy + 8, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 17, sy + 9, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 17, sy + 10, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 17, sy + 11, sz + 0)
    BWOBuildTools.IsoObject ("furniture_seating_indoor_02_1", sx + 17, sy + 11, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 17, sy + 12, sz + 0)
    BWOBuildTools.IsoObject ("furniture_seating_indoor_02_1", sx + 17, sy + 12, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 17, sy + 13, sz + 0)
    BWOBuildTools.IsoObject ("fixtures_railings_01_117", sx + 17, sy + 13, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 17, sy + 14, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 17, sy + 15, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 17, sy + 16, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 17, sy + 17, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 17, sy + 18, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 17, sy + 19, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 17, sy + 20, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 17, sy + 21, sz + 0)
    BWOBuildTools.IsoObject ("walls_exterior_house_02_49", sx + 17, sy + 22, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 18, sy + 0, sz + 0)
    BWOBuildTools.IsoObject ("walls_commercial_01_75", sx + 18, sy + 0, sz + 0)
    BWOBuildTools.IsoObject ("fixtures_doors_01_37", sx + 18, sy + 0, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 18, sy + 1, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 18, sy + 2, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 18, sy + 3, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 18, sy + 4, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 18, sy + 5, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 18, sy + 6, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 18, sy + 7, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 18, sy + 8, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 18, sy + 9, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 18, sy + 10, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 18, sy + 11, sz + 0)
    BWOBuildTools.IsoObject ("furniture_tables_high_01_43", sx + 18, sy + 11, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 18, sy + 12, sz + 0)
    BWOBuildTools.IsoObject ("furniture_tables_high_01_42", sx + 18, sy + 12, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 18, sy + 13, sz + 0)
    BWOBuildTools.IsoObject ("fixtures_railings_01_117", sx + 18, sy + 13, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 18, sy + 14, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 18, sy + 15, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 18, sy + 16, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 18, sy + 17, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 18, sy + 18, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 18, sy + 19, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 18, sy + 20, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 18, sy + 21, sz + 0)
    BWOBuildTools.IsoWindow ("walls_commercial_01_17", sx + 18, sy + 22, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 19, sy + 0, sz + 0)
    BWOBuildTools.IsoWindow ("walls_commercial_01_65", sx + 19, sy + 0, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 19, sy + 1, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 19, sy + 2, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 19, sy + 3, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 19, sy + 4, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 19, sy + 5, sz + 0)
    BWOBuildTools.IsoObject ("furniture_seating_indoor_02_0", sx + 19, sy + 5, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 19, sy + 6, sz + 0)
    BWOBuildTools.IsoObject ("furniture_tables_high_01_23", sx + 19, sy + 6, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 19, sy + 7, sz + 0)
    BWOBuildTools.IsoObject ("furniture_seating_indoor_02_2", sx + 19, sy + 7, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 19, sy + 8, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 19, sy + 9, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 19, sy + 10, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 19, sy + 11, sz + 0)
    BWOBuildTools.IsoObject ("furniture_seating_indoor_02_3", sx + 19, sy + 11, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 19, sy + 12, sz + 0)
    BWOBuildTools.IsoObject ("furniture_seating_indoor_02_3", sx + 19, sy + 12, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 19, sy + 13, sz + 0)
    BWOBuildTools.IsoObject ("fixtures_railings_01_117", sx + 19, sy + 13, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 19, sy + 14, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 19, sy + 15, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 19, sy + 16, sz + 0)
    BWOBuildTools.IsoObject ("floors_rugs_01_59", sx + 19, sy + 16, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 19, sy + 17, sz + 0)
    BWOBuildTools.IsoObject ("floors_rugs_01_58", sx + 19, sy + 17, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 19, sy + 18, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 19, sy + 19, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 19, sy + 20, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_carpet_01_13", sx + 19, sy + 21, sz + 0)
    BWOBuildTools.IsoObject ("walls_exterior_house_02_49", sx + 19, sy + 22, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 20, sy + 0, sz + 0)
    BWOBuildTools.IsoWindow ("walls_commercial_01_65", sx + 20, sy + 0, sz + 0)
    BWOBuildTools.IsoObject ("vegetation_indoor_01_7", sx + 20, sy + 0, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 20, sy + 1, sz + 0)
    BWOBuildTools.IsoObject ("furniture_seating_indoor_02_0", sx + 20, sy + 1, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 20, sy + 2, sz + 0)
    BWOBuildTools.IsoObject ("furniture_tables_high_01_23", sx + 20, sy + 2, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 20, sy + 3, sz + 0)
    BWOBuildTools.IsoObject ("furniture_seating_indoor_02_2", sx + 20, sy + 3, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 20, sy + 4, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 20, sy + 5, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 20, sy + 6, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 20, sy + 7, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 20, sy + 8, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 20, sy + 9, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 20, sy + 10, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 20, sy + 11, sz + 0)
    BWOBuildTools.IsoObject ("floors_interior_tilesandwood_01_46", sx + 20, sy + 12, sz + 0)
    BWOBuildTools.IsoObject ("vegetation_indoor_01_7", sx + 20, sy + 12, sz + 0)
    BWOBuildTools.IsoObject ("walls_exterior_house_01_1", sx + 20, sy + 13, sz + 0)
    BWOBuildTools.IsoWindow ("walls_commercial_01_16", sx + 20, sy + 13, sz + 0)
    BWOBuildTools.IsoObject ("lighting_outdoor_01_26", sx + 20, sy + 13, sz + 0)
    BWOBuildTools.IsoWindow ("walls_commercial_01_16", sx + 20, sy + 14, sz + 0)
    BWOBuildTools.IsoWindow ("walls_commercial_01_16", sx + 20, sy + 15, sz + 0)
    BWOBuildTools.IsoObject ("walls_exterior_house_02_51", sx + 20, sy + 16, sz + 0)
    BWOBuildTools.IsoObject ("fixtures_doors_frames_01_25", sx + 20, sy + 16, sz + 0)
    BWOBuildTools.IsoObject ("fixtures_doors_02_40", sx + 20, sy + 16, sz + 0)
    BWOBuildTools.IsoObject ("fixtures_doors_frames_01_24", sx + 20, sy + 17, sz + 0)
    BWOBuildTools.IsoObject ("fixtures_doors_02_44", sx + 20, sy + 17, sz + 0)
    BWOBuildTools.IsoWindow ("walls_commercial_01_16", sx + 20, sy + 18, sz + 0)
    BWOBuildTools.IsoWindow ("walls_commercial_01_16", sx + 20, sy + 19, sz + 0)
    BWOBuildTools.IsoWindow ("walls_commercial_01_16", sx + 20, sy + 20, sz + 0)
    BWOBuildTools.IsoObject ("lighting_outdoor_01_30", sx + 20, sy + 20, sz + 0)
    BWOBuildTools.IsoObject ("floors_exterior_street_01_16", sx + 20, sy + 21, sz + 0)
    BWOBuildTools.IsoObject ("location_community_church_small_01_6", sx + 20, sy + 21, sz + 0)
    BWOBuildTools.IsoObject ("walls_exterior_house_01_1", sx + 20, sy + 22, sz + 0)
end

function BWOScenarios.DayOne:controller()
	local worldAge = BWOUtils.GetWorldAge()
	local zcnt = 55 + (worldAge * 2)
	if zcnt > 100 then zcnt = 100 end
    BWOPopControl.zombiePercent = zcnt
end