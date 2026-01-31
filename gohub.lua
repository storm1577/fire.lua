-- Keep going, don't just change the name. 😼👍🔥

local Settings = {
    WeaponType = "Melee"
}

local cachedEnemies = {}
local lastScan = 0
_G.NoClip = true
_G.NotAutoEquip = false
_G.CurrentTarget = nil
_G.SelectWeapon = nil
_G.StartFarm = false
local visitedChests = {}
local lastChestCount = 0
local chestsCollected = 0
local checkInterval = 0
local isServerHopping = false
local _B = false
local PosMon = nil
local flyPlatform = nil
local autoFishLoop = false
local autoSellFishLoop = false
local autoBuyBaitLoop = false
local autoDarkbeardActive = false
local darkbeardConnection = nil
local chipBuyAttemptTime = 0
local hasBoughtChip = false
local raidLastMobTime = tick()
local raidCurrentIslandIndex = 1

local autoChestConnection
local floatConnection
local noclipConnection

Settings.AutoChest = false
Settings.AutoChestHop = false
Settings.ChestHopAmount = 5
Settings.AutoMelee = false
Settings.AutoDefense = false
Settings.AutoSword = false
Settings.AutoGun = false
Settings.AutoFruit = false
Settings.PointsValue = 10
Settings.BringEnemy = false
Settings.FarmHeight = 15
Settings.FlySpeed = 300
Settings.AutoFarm = false
Settings.TravelDress = false
Settings.AutoZou = false
Settings.AutoFactory = false
Settings.AutoRaidCastle = false
Settings.AutoRandomFruit = false
Settings.AutoStoreFruit = false
Settings.AutoCollectFruit = false
Settings.BartiloQuest = false
Settings.CitizenQuest = false
Settings.AutoDonAccess = false
Settings.AutoBisento = false
Settings.AutoRengoku = false
Settings.AutoBlackLeg = false
Settings.AutoElectro = false
Settings.AutoFishmanKarate = false
Settings.AutoDragonClaw = false
Settings.AutoSuperhuman = false
Settings.AutoDeathStep = false
Settings.AutoSharkmanKarate = false
Settings.AutoElectricClaw = false
Settings.AutoDragonTalon = false
Settings.AutoGodhuman = false
Settings.AutoSanguineArt = false
Settings.SelectMaterial = Settings.SelectMaterial or "Radioactive Material"
Settings.AutoFarmMaterial = false
Settings.AcceptQuestForMaterial = false
Settings.AutoRaid = false
Settings.AutoCakePrince = false
Settings.TakeMissionOnCakePrince = false
Settings.SelectedBosses = Settings.SelectedBosses or {}
Settings.KillSelectedBoss = false
Settings.GetQuestBosses = false
Settings.KillAllBoss = false
Settings.FarmBossesSelectedHop = false
Settings.FarmAllBossesHop = false

local autoCakePrinceConnection = nil
local cakePrinceCheckTime = 0
local lastCakePrinceRemoteTime = 0
local autoDeathStepConnection = nil
local autoElectricClawConnection = nil
local autoSharkmanKarateConnection = nil
local autoDragonTalonConnection = nil
local autoGodhumanConnection = nil
local autoSanguineArtConnection = nil

local raidLastMobTime = tick()
local raidCurrentIslandIndex = 1

local storedFruits = {}

local FishingSettings = {
    CustomPosition = nil,
    DefaultNPCPosition = nil,
    DefaultFishingPosition = nil,
    AutoFish = false,
    AutoSellFish = false,
    AutoBuyBait = false
}

local MaterialsList = {
    "Radioactive Material",
    "Mystic Droplet",
    "Magma Ore",
    "Angel Wings",
    "Leather",
    "Scrap Metal",
    "Fish Tail",
    "Demonic Wisp",
    "Vampire Fang",
    "Conjured Cocoa",
    "Dragon Scale",
    "Gunpowder",
    "Mini Tusk"
}

local ChipsList = {
    "Flame",
    "Ice",
    "Quake",
    "Light",
    "Dark",
    "String",
    "Rumble",
    "Magma",
    "Human: Buddha",
    "Sand",
    "Bird: Phoenix",
    "Dough"
}

Settings.SelectedChip = Settings.SelectedChip or "Flame"
Settings.AutoSelectDungeon = false
Settings.AutoBuyChip = false
Settings.AutoStartRaid = false
Settings.AutoCompleteRaid = false

local MaterialData = {
    ["Radioactive Material"] = {
        Mon = "Factory Staff",
        Qdata = 2,
        Qname = "Area2Quest",
        PosQ = CFrame.new(632.698608, 73.1055908, 918.666321),
        PosM = CFrame.new(73.078674316406, 81.863441467285, -27.470672607422),
        World = 2
    },
    ["Mystic Droplet"] = {
        Mon = "Water Fighter",
        Qdata = 2,
        Qname = "ForgottenQuest",
        PosQ = CFrame.new(-3054.44458, 235.544281, -10142.8193),
        PosM = CFrame.new(-3352.9013671875, 285.01556396484, -10534.841796875),
        World = 2
    },
    ["Magma Ore"] = {
        Mon = World1 and "Military Spy" or "Magma Ninja",
        Qdata = World1 and 2 or 1,
        Qname = World1 and "MagmaQuest" or "FireSideQuest",
        PosQ = World1 and CFrame.new(-5313.37012, 10.9500084, 8515.29395) or CFrame.new(-5428.03174, 15.0622921, -5299.43457),
        PosM = World1 and CFrame.new(-5802.8681640625, 86.262413024902, 8828.859375) or CFrame.new(-5449.6728515625, 76.658744812012, -5808.2006835938),
        World = World1 and 1 or 2
    },
    ["Angel Wings"] = {
        Mon = "God's Guard",
        Qdata = 1,
        Qname = "SkyExp1Quest",
        PosQ = CFrame.new(-4721.88867, 843.874695, -1949.96643),
        PosM = CFrame.new(-4710.04296875, 845.27697753906, -1927.3079833984),
        World = 1,
        RequireEntrance = Vector3.new(-7859.09814, 5544.19043, -381.476196)
    },
    ["Leather"] = {
        Mon = World1 and "Brute" or (World2 and "Marine Captain" or "Jungle Pirate"),
        Qdata = World1 and 2 or (World2 and 2 or 1),
        Qname = World1 and "BuggyQuest1" or (World2 and "MarineQuest3" or "DeepForestIsland2"),
        PosQ = World1 and CFrame.new(-1141.07483, 4.10001802, 3831.5498) or (World2 and CFrame.new(-2440.79639, 71.7140732, -3216.06812) or CFrame.new(-12680.3818, 389.971039, -9902.01953)),
        PosM = World1 and CFrame.new(-1140.0837402344, 14.809885025024, 4322.9213867188) or (World2 and CFrame.new(-1861.2310791016, 80.176582336426, -3254.6975097656) or CFrame.new(-12256.16015625, 331.73828125, -10485.8369140625)),
        World = World1 and 1 or (World2 and 2 or 3)
    },
    ["Scrap Metal"] = {
        Mon = World1 and "Brute" or (World2 and "Swan Pirate" or "Jungle Pirate"),
        Qdata = World1 and 2 or (World2 and 1 or 1),
        Qname = World1 and "BuggyQuest1" or (World2 and "Area2Quest" or "DeepForestIsland2"),
        PosQ = World1 and CFrame.new(-1141.07483, 4.10001802, 3831.5498) or (World2 and CFrame.new(638.43811, 71.769989, 918.282898) or CFrame.new(-12680.3818, 389.971039, -9902.01953)),
        PosM = World1 and CFrame.new(-1140.0837402344, 14.809885025024, 4322.9213867188) or (World2 and CFrame.new(1068.6643066406, 137.61428833008, 1322.1060791016) or CFrame.new(-12107, 332, -10549)),
        World = World1 and 1 or (World2 and 2 or 3)
    },
    ["Fish Tail"] = {
        Mon = World3 and "Fishman Raider" or "Fishman Warrior",
        Qdata = 1,
        Qname = World3 and "DeepForestIsland3" or "FishmanQuest",
        PosQ = World3 and CFrame.new(-10581.6563, 330.872955, -8761.18652) or CFrame.new(61122.65234375, 18.497442245483, 1569.3997802734),
        PosM = World3 and CFrame.new(-10407.5263671875, 331.76263427734375, -8368.5166015625) or CFrame.new(60878.30078125, 18.482830047607, 1543.7574462891),
        World = World3 and 3 or 1,
        RequireEntrance = not World3 and Vector3.new(61163.8515625, 11.6796875, 1819.7841796875) or nil
    },
    ["Demonic Wisp"] = {
        Mon = "Demonic Soul",
        Qdata = 1,
        Qname = "HauntedQuest2",
        PosQ = CFrame.new(-9516.99316, 172.017181, 6078.46533),
        PosM = CFrame.new(-9505.8720703125, 172.10482788085938, 6158.9931640625),
        World = 3
    },
    ["Vampire Fang"] = {
        Mon = "Vampire",
        Qdata = 2,
        Qname = "ZombieQuest",
        PosQ = CFrame.new(-5497.06152, 47.5923004, -795.237061),
        PosM = CFrame.new(-6037.66796875, 32.184638977051, -1340.6597900391),
        World = 2
    },
    ["Conjured Cocoa"] = {
        Mon = "Chocolate Bar Battler",
        Qdata = 2,
        Qname = "ChocQuest1",
        PosQ = CFrame.new(233.22836303710938, 29.876001358032227, -12201.2333984375),
        PosM = CFrame.new(582.590576171875, 77.18809509277344, -12463.162109375),
        World = 3
    },
    ["Dragon Scale"] = {
        Mon = "Dragon Crew Archer",
        Qdata = 2,
        Qname = "DragonCrewQuest",
        PosQ = CFrame.new(6737.06055, 127.417763, -712.300659),
        PosM = CFrame.new(6668.76172, 481.376923, 329.12207),
        World = 3
    },
    ["Gunpowder"] = {
        Mon = "Pistol Billionaire",
        Qdata = 2,
        Qname = "PiratePortQuest",
        PosQ = CFrame.new(-290.07, 42.90, 5581.59),
        PosM = CFrame.new(-187.33, 86.24, 6013.51),
        World = 3
    },
    ["Mini Tusk"] = {
        Mon = "Mythological Pirate",
        Qdata = 2,
        Qname = "DeepForestIsland",
        PosQ = CFrame.new(-13234.04, 331.488495, -7625.40137),
        PosM = CFrame.new(-13680.607421875, 501.08154296875, -6991.189453125),
        World = 3
    }
}

local BossData = {
    World1 = {
        ["The Gorilla King"] = {
            Mon = "The Gorilla King",
            Qname = "JungleQuest",
            Qdata = 3,
            PosQBoss = CFrame.new(-1601.6553955078, 36.85213470459, 153.38809204102),
            PosB = CFrame.new(-1088.75977, 8.13463783, -488.559906, -0.707134247, 0, 0.707079291, 0, 1, 0, -0.707079291, 0, -0.707134247),
            HasQuest = true
        },
        ["Chef"] = {
            Mon = "Chef",
            Qname = "BuggyQuest1",
            Qdata = 3,
            PosQBoss = CFrame.new(-1140.1761474609, 4.752049446106, 3827.4057617188),
            PosB = CFrame.new(-1087.3760986328, 46.949409484863, 4040.1462402344),
            HasQuest = true
        },
        ["The Saw"] = {
            Mon = "The Saw",
            PosB = CFrame.new(-784.89715576172, 72.427383422852, 1603.5822753906),
            HasQuest = false
        },
        ["Yeti"] = {
            Mon = "Yeti",
            Qname = "SnowQuest",
            Qdata = 3,
            PosQBoss = CFrame.new(1386.8073730469, 87.272789001465, -1298.3576660156),
            PosB = CFrame.new(1218.7956542969, 138.01184082031, -1488.0262451172),
            HasQuest = true
        },
        ["Mob Leader"] = {
            Mon = "Mob Leader",
            PosB = CFrame.new(-2844.7307128906, 7.4180502891541, 5356.6723632813),
            HasQuest = false
        },
        ["Vice Admiral"] = {
            Mon = "Vice Admiral",
            Qname = "MarineQuest2",
            Qdata = 2,
            PosQBoss = CFrame.new(-5036.2465820313, 28.677835464478, 4324.56640625),
            PosB = CFrame.new(-5006.5454101563, 88.032081604004, 4353.162109375),
            HasQuest = true
        },
        ["Saber Expert"] = {
            Mon = "Saber Expert",
            PosB = CFrame.new(-1458.89502, 29.8870335, -50.633564),
            HasQuest = false
        },
        ["Warden"] = {
            Mon = "Warden",
            Qname = "ImpelQuest",
            Qdata = 1,
            PosB = CFrame.new(5278.04932, 2.15167475, 944.101929, 0.220546961, -4.49946401e-06, 0.975376427, -1.95412576e-05, 1, 9.03162072e-06, -0.975376427, -2.10519756e-05, 0.220546961),
            PosQBoss = CFrame.new(5191.86133, 2.84020686, 686.438721, -0.731384635, 0, 0.681965172, 0, 1, 0, -0.681965172, 0, -0.731384635),
            HasQuest = true
        },
        ["Chief Warden"] = {
            Mon = "Chief Warden",
            Qname = "ImpelQuest",
            Qdata = 2,
            PosB = CFrame.new(5206.92578, 0.997753382, 814.976746, 0.342041343, -0.00062915677, 0.939684749, 0.00191645394, 0.999998152, -2.80422337e-05, -0.939682961, 0.00181045406, 0.342041939),
            PosQBoss = CFrame.new(5191.86133, 2.84020686, 686.438721, -0.731384635, 0, 0.681965172, 0, 1, 0, -0.681965172, 0, -0.731384635),
            HasQuest = true
        },
        ["Swan"] = {
            Mon = "Swan",
            Qname = "ImpelQuest",
            Qdata = 3,
            PosB = CFrame.new(5325.09619, 7.03906584, 719.570679, -0.309060812, 0, 0.951042235, 0, 1, 0, -0.951042235, 0, -0.309060812),
            PosQBoss = CFrame.new(5191.86133, 2.84020686, 686.438721, -0.731384635, 0, 0.681965172, 0, 1, 0, -0.681965172, 0, -0.731384635),
            HasQuest = true
        },
        ["Magma Admiral"] = {
            Mon = "Magma Admiral",
            Qname = "MagmaQuest",
            Qdata = 3,
            PosQBoss = CFrame.new(-5314.6220703125, 12.262420654297, 8517.279296875),
            PosB = CFrame.new(-5765.8969726563, 82.92064666748, 8718.3046875),
            HasQuest = true
        },
        ["Fishman Lord"] = {
            Mon = "Fishman Lord",
            Qname = "FishmanQuest",
            Qdata = 3,
            PosQBoss = CFrame.new(61122.65234375, 18.497442245483, 1569.3997802734),
            PosB = CFrame.new(61260.15234375, 30.950881958008, 1193.4329833984),
            HasQuest = true
        },
        ["Wysper"] = {
            Mon = "Wysper",
            Qname = "SkyExp1Quest",
            Qdata = 3,
            PosQBoss = CFrame.new(-7861.947265625, 5545.517578125, -379.85974121094),
            PosB = CFrame.new(-7866.1333007813, 5576.4311523438, -546.74816894531),
            HasQuest = true
        },
        ["Thunder God"] = {
            Mon = "Thunder God",
            Qname = "SkyExp2Quest",
            Qdata = 3,
            PosQBoss = CFrame.new(-7903.3828125, 5635.9897460938, -1410.923828125),
            PosB = CFrame.new(-7994.984375, 5761.025390625, -2088.6479492188),
            HasQuest = true
        },
        ["Cyborg"] = {
            Mon = "Cyborg",
            Qname = "FountainQuest",
            Qdata = 3,
            PosQBoss = CFrame.new(5258.2788085938, 38.526931762695, 4050.044921875),
            PosB = CFrame.new(6094.0249023438, 73.770050048828, 3825.7348632813),
            HasQuest = true
        },
        ["Ice Admiral"] = {
            Mon = "Ice Admiral",
            PosQBoss = CFrame.new(1266.08948, 26.1757946, -1399.57678, -0.573599219, 0, -0.81913656, 0, 1, 0, 0.81913656, 0, -0.573599219),
            PosB = CFrame.new(1266.08948, 26.1757946, -1399.57678, -0.573599219, 0, -0.81913656, 0, 1, 0, 0.81913656, 0, -0.573599219),
            HasQuest = false
        },
        ["Greybeard"] = {
            Mon = "Greybeard",
            PosQBoss = CFrame.new(-5081.3452148438, 85.221641540527, 4257.3588867188),
            PosB = CFrame.new(-5081.3452148438, 85.221641540527, 4257.3588867188),
            HasQuest = false
        }
    },
    World2 = {
        ["Diamond"] = {
            Mon = "Diamond",
            Qname = "Area1Quest",
            Qdata = 3,
            PosQBoss = CFrame.new(-427.5666809082, 73.313781738281, 1835.4208984375),
            PosB = CFrame.new(-1576.7166748047, 198.59265136719, 13.724286079407),
            HasQuest = true
        },
        ["Jeremy"] = {
            Mon = "Jeremy",
            Qname = "Area2Quest",
            Qdata = 3,
            PosQBoss = CFrame.new(636.79943847656, 73.413787841797, 918.00415039063),
            PosB = CFrame.new(2006.9261474609, 448.95666503906, 853.98284912109),
            HasQuest = true
        },
        ["Fajita"] = {
            Mon = "Fajita",
            Qname = "MarineQuest3",
            Qdata = 3,
            PosQBoss = CFrame.new(-2441.986328125, 73.359344482422, -3217.5324707031),
            PosB = CFrame.new(-2172.7399902344, 103.32216644287, -4015.025390625),
            HasQuest = true
        },
        ["Don Swan"] = {
            Mon = "Don Swan",
            PosB = CFrame.new(2286.2004394531, 15.177839279175, 863.8388671875),
            HasQuest = false
        },
        ["Smoke Admiral"] = {
            Mon = "Smoke Admiral",
            Qname = "IceSideQuest",
            Qdata = 3,
            PosQBoss = CFrame.new(-5429.0473632813, 15.977565765381, -5297.9614257813),
            PosB = CFrame.new(-5275.1987304688, 20.757257461548, -5260.6669921875),
            HasQuest = true
        },
        ["Awakened Ice Admiral"] = {
            Mon = "Awakened Ice Admiral",
            Qname = "FrostQuest",
            Qdata = 3,
            PosQBoss = CFrame.new(5668.9780273438, 28.519989013672, -6483.3520507813),
            PosB = CFrame.new(6403.5439453125, 340.29766845703, -6894.5595703125),
            HasQuest = true
        },
        ["Tide Keeper"] = {
            Mon = "Tide Keeper",
            Qname = "ForgottenQuest",
            Qdata = 3,
            PosQBoss = CFrame.new(-3053.9814453125, 237.18954467773, -10145.0390625),
            PosB = CFrame.new(-3795.6423339844, 105.88877105713, -11421.307617188),
            HasQuest = true
        },
        ["Darkbeard"] = {
            Mon = "Darkbeard",
            PosQBoss = CFrame.new(3677.08203125, 62.751937866211, -3144.8332519531),
            PosB = CFrame.new(3677.08203125, 62.751937866211, -3144.8332519531),
            HasQuest = false
        },
        ["Cursed Captain"] = {
            Mon = "Cursed Captain",
            PosQBoss = CFrame.new(916.928589, 181.092773, 33422),
            PosB = CFrame.new(916.928589, 181.092773, 33422),
            HasQuest = false
        },
        ["Order"] = {
            Mon = "Order",
            PosQBoss = CFrame.new(-6217.2021484375, 28.047645568848, -5053.1357421875),
            PosB = CFrame.new(-6217.2021484375, 28.047645568848, -5053.1357421875),
            HasQuest = false
        }
    },
    World3 = {
        ["Stone"] = {
            Mon = "Stone",
            Qname = "PiratePortQuest",
            Qdata = 3,
            PosQBoss = CFrame.new(-289.76705932617, 43.819011688232, 5579.9384765625),
            PosB = CFrame.new(-1027.6512451172, 92.404174804688, 6578.8530273438),
            HasQuest = true
        },
        ["Hydra Leader"] = {
            Mon = "Hydra Leader",
            Qname = "AmazonQuest2",
            Qdata = 3,
            PosQBoss = CFrame.new(5821.8979492188, 1019.0950927734, -73.719230651855),
            PosB = CFrame.new(5821.8979492188, 1019.0950927734, -73.719230651855),
            HasQuest = true
        },
        ["Kilo Admiral"] = {
            Mon = "Kilo Admiral",
            Qname = "MarineTreeIsland",
            Qdata = 3,
            PosQBoss = CFrame.new(2179.3010253906, 28.731239318848, -6739.9741210938),
            PosB = CFrame.new(2764.2233886719, 432.46154785156, -7144.4580078125),
            HasQuest = true
        },
        ["Captain Elephant"] = {
            Mon = "Captain Elephant",
            Qname = "DeepForestIsland",
            Qdata = 3,
            PosQBoss = CFrame.new(-13232.682617188, 332.40396118164, -7626.01171875),
            PosB = CFrame.new(-13376.7578125, 433.28689575195, -8071.392578125),
            HasQuest = true
        },
        ["Beautiful Pirate"] = {
            Mon = "Beautiful Pirate",
            Qname = "DeepForestIsland2",
            Qdata = 3,
            PosQBoss = CFrame.new(-12682.096679688, 390.88653564453, -9902.1240234375),
            PosB = CFrame.new(5283.609375, 22.56223487854, -110.78285217285),
            HasQuest = true
        },
        ["Cake Queen"] = {
            Mon = "Cake Queen",
            Qname = "IceCreamIslandQuest",
            Qdata = 3,
            PosQBoss = CFrame.new(-819.376709, 64.9259796, -10967.2832, -0.766061664, 0, 0.642767608, 0, 1, 0, -0.642767608, 0, -0.766061664),
            PosB = CFrame.new(-678.648804, 381.353943, -11114.2012, -0.908641815, 0.00149294338, 0.41757378, 0.00837114919, 0.999857843, 0.0146408929, -0.417492568, 0.0167988986, -0.90852499),
            HasQuest = true
        },
        ["Longma"] = {
            Mon = "Longma",
            PosQBoss = CFrame.new(-10238.875976563, 389.7912902832, -9549.7939453125),
            PosB = CFrame.new(-10238.875976563, 389.7912902832, -9549.7939453125),
            HasQuest = false
        },
        ["Soul Reaper"] = {
            Mon = "Soul Reaper",
            PosQBoss = CFrame.new(-9524.7890625, 315.80429077148, 6655.7192382813),
            PosB = CFrame.new(-9524.7890625, 315.80429077148, 6655.7192382813),
            HasQuest = false
        }
    }
}

local bossFarmConnection = nil

if game.PlaceId == 2753915549 or game.PlaceId == 85211729168715 then
    FishingSettings.DefaultNPCPosition = CFrame.new(1058.5564, 6.37877321, -1079.41968, -0.69008112, 9.20977214e-08, 0.723732054, 1.72719101e-08, 1, -1.10785066e-07, -0.723732054, -6.39504449e-08, -0.69008112)
    FishingSettings.DefaultFishingPosition = CFrame.new(1095.36707, 6.37877369, -1101.31848, -0.655865908, 7.35584464e-08, -0.754877388, -2.74773662e-08, 1, 1.21317598e-07, 0.754877388, 1.00310125e-07, -0.655865908)
elseif game.PlaceId == 4442272183 or game.PlaceId == 79091703265657 then
    FishingSettings.DefaultNPCPosition = CFrame.new(128.523422, 14.3117542, 2874.78857, 0.500059903, -4.35886029e-08, -0.865990818, 1.32688411e-08, 1, -4.26718003e-08, 0.865990818, 9.84776261e-09, 0.500059903)
    FishingSettings.DefaultFishingPosition = CFrame.new(75.5415421, 10.3117542, 2908.24609, -0.153820768, 2.24435919e-08, 0.988098741, 9.55587831e-10, 1, -2.25651551e-08, -0.988098741, -2.52677457e-09, -0.153820768)
elseif game.PlaceId == 7449423635 or game.PlaceId == 100117331123089 then
    FishingSettings.DefaultNPCPosition = CFrame.new(21.4747581, 10.9772911, 5347.67822, 0.0672565997, 6.14363245e-08, -0.997735739, 4.46659332e-09, 1, 6.18768397e-08, 0.997735739, -8.61810534e-09, 0.0672565997)
    FishingSettings.DefaultFishingPosition = CFrame.new(25.4987526, 11.7082462, 5308.14648, 0.975708723, 1.19074484e-08, -0.219071791, -2.9416361e-10, 1, 5.30439372e-08, 0.219071791, -5.16909893e-08, 0.975708723)
end

local HttpService = game:GetService("HttpService")

local function SaveConfig()
    local data = {
        AutoFarm = Settings.AutoFarm,
        AutoChest = Settings.AutoChest,
        AutoChestHop = Settings.AutoChestHop,
        ChestHopAmount = Settings.ChestHopAmount,
        FarmMethod = Settings.FarmMethod,
        AutoFarmMethod = Settings.AutoFarmMethod,
        AutoMelee = Settings.AutoMelee,
        AutoDefense = Settings.AutoDefense,
        AutoSword = Settings.AutoSword,
        AutoGun = Settings.AutoGun,
        AutoFruit = Settings.AutoFruit,
        PointsValue = Settings.PointsValue,
        FarmHeight = Settings.FarmHeight,
        FlySpeed = Settings.FlySpeed,
        WeaponType = Settings.WeaponType,
        TravelDress = Settings.TravelDress,
        AutoZou = Settings.AutoZou,
        AutoFactory = Settings.AutoFactory,
        AutoRaidCastle = Settings.AutoRaidCastle,
        BartiloQuest = Settings.BartiloQuest,
        CitizenQuest = Settings.CitizenQuest,
        AutoDonAccess = Settings.AutoDonAccess,
        AutoBisento = Settings.AutoBisento,
        AutoRengoku = Settings.AutoRengoku,
        AutoBlackLeg = Settings.AutoBlackLeg,
        AutoElectro = Settings.AutoElectro,
        AutoFishmanKarate = Settings.AutoFishmanKarate,
        AutoDragonClaw = Settings.AutoDragonClaw,
        AutoSuperhuman = Settings.AutoSuperhuman,
        AutoDeathStep = Settings.AutoDeathStep,
        AutoRandomFruit = Settings.AutoRandomFruit,
        AutoStoreFruit = Settings.AutoStoreFruit,
        AutoCollectFruit = Settings.AutoCollectFruit,
        AutoSharkmanKarate = Settings.AutoSharkmanKarate,
        AutoElectricClaw = Settings.AutoElectricClaw,
        AutoDragonTalon = Settings.AutoDragonTalon,
        AutoGodhuman = Settings.AutoGodhuman,
        AutoSanguineArt = Settings.AutoSanguineArt,
        BringEnemy = Settings.BringEnemy
    }

    pcall(function()
        writefile("DiamondHub_Config.json", HttpService:JSONEncode(data))
    end)
end

local function LoadConfig()
    if not isfile("DiamondHub_Config.json") then return end

    pcall(function()
        local data = HttpService:JSONDecode(readfile("DiamondHub_Config.json"))

        for k, v in pairs(data) do
            if Settings[k] ~= nil then
                Settings[k] = v
            end
        end
    end)
end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser = game:GetService("VirtualUser")

local Player = Players.LocalPlayer
local CurrentTargetIndex = 1
local LastAttackTime = 0
local AttackDelay = 0.20
local AttackCount = 0
local MaxAttacksPerSecond = 15
local LastResetTime = tick()

repeat task.wait() until game:IsLoaded()

local Modules = ReplicatedStorage:WaitForChild("Modules", 30)
if not Modules then return end

local RegisterAttack = Modules.Net:WaitForChild("RE/RegisterAttack", 30)
local RegisterHit = Modules.Net:WaitForChild("RE/RegisterHit", 30)

if not RegisterAttack or not RegisterHit then return end

local CombatFrameworkLoaded = false
local CombatFrameworkR, RigLib

local function LoadCombatFramework()
    pcall(function()
        local PlayerScripts = Player:WaitForChild("PlayerScripts", 30)
        if not PlayerScripts then return end
        
        local CombatFramework = PlayerScripts:WaitForChild("CombatFramework", 30)
        if not CombatFramework then return end
        
        local CombatFrameworkModule = require(CombatFramework)
        CombatFrameworkR = debug.getupvalues(CombatFrameworkModule)[2]
        RigLib = require(ReplicatedStorage.CombatFramework.RigLib)
        CombatFrameworkLoaded = true
    end)
end

task.spawn(LoadCombatFramework)

local function SafeFire(remote, arg1, arg2, arg3, arg4)
    local success = pcall(function()
        if arg4 then
            remote:FireServer(arg1, arg2, arg3, arg4)
        elseif arg3 then
            remote:FireServer(arg1, arg2, arg3)
        elseif arg2 then
            remote:FireServer(arg1, arg2)
        elseif arg1 then
            remote:FireServer(arg1)
        else
            remote:FireServer()
        end
    end)
    return success
end

local function GetNearbyEnemies()
    local Character = Player.Character
    if not Character or not Character:FindFirstChild("HumanoidRootPart") then return {} end

    local enemies = {}
    local playerPos = Character.HumanoidRootPart.Position
    
    for _, enemy in ipairs(workspace.Enemies:GetChildren()) do
        if enemy and enemy.Parent then
            local hum = enemy:FindFirstChild("Humanoid")
            local hrp = enemy:FindFirstChild("HumanoidRootPart")

            if hum and hrp and hum.Health > 0 then
                local distance = (hrp.Position - playerPos).Magnitude
                if distance <= 60 then
                    table.insert(enemies, enemy)
                end
            end
        end
    end
    return enemies
end

local function AttackSingleTarget(enemy)
    if not enemy or not enemy.Parent then return false end
    
    local target = enemy:FindFirstChild("UpperTorso") or enemy:FindFirstChild("HumanoidRootPart") or enemy:FindFirstChild("Torso")
    if not target then return false end

    local currentTime = tick()
    if currentTime - LastResetTime >= 1 then
        AttackCount = 0
        LastResetTime = currentTime
    end
    
    if AttackCount >= MaxAttacksPerSecond then
        return false
    end

    SafeFire(RegisterAttack, 0)
    SafeFire(RegisterHit, target, {{enemy, target}})
    AttackCount = AttackCount + 1
    
    return true
end

local function AttackRotation()
    local Character = Player.Character
    if not Character or not Character:FindFirstChild("HumanoidRootPart") then return false end

    local Tool = Character:FindFirstChildOfClass("Tool")
    if not Tool then return false end

    local enemies = GetNearbyEnemies()
    if #enemies == 0 then 
        CurrentTargetIndex = 1
        return false 
    end

    if #enemies == 1 then
        CurrentTargetIndex = 1
        return AttackSingleTarget(enemies[1])
    end

    if CurrentTargetIndex > #enemies then
        CurrentTargetIndex = 1
    end

    local success = AttackSingleTarget(enemies[CurrentTargetIndex])
    CurrentTargetIndex = CurrentTargetIndex + 1
    
    return success
end

local function FastAttackPC()
    if not CombatFrameworkLoaded then 
        task.spawn(LoadCombatFramework)
        return false 
    end
    
    local Character = Player.Character
    if not Character then return false end
    
    local Tool = Character:FindFirstChildOfClass("Tool")
    if not Tool then return false end
    
    local enemies = GetNearbyEnemies()
    if #enemies == 0 then 
        CurrentTargetIndex = 1
        return false 
    end
    
    local success = pcall(function()
        if not CombatFrameworkR or not CombatFrameworkR.activeController then
            CombatFrameworkLoaded = false
            return
        end
        
        local AC = CombatFrameworkR.activeController
        if not AC or not AC.equipped then return end
        
        if AC.animator and AC.animator.anims and AC.animator.anims.basic then
            for _, anim in pairs(AC.animator.anims.basic) do
                if anim then
                    pcall(function() anim:Play(0.01, 0.01, 0.01) end)
                end
            end
        end
        
        if AC.blades and AC.blades[1] then
            local blade = AC.blades[1]
            
            local targetEnemy
            if #enemies == 1 then
                targetEnemy = enemies[1]
                CurrentTargetIndex = 1
            else
                if CurrentTargetIndex > #enemies then
                    CurrentTargetIndex = 1
                end
                targetEnemy = enemies[CurrentTargetIndex]
                CurrentTargetIndex = CurrentTargetIndex + 1
            end
            
            if not targetEnemy or not targetEnemy.Parent then return end
            
            local target = targetEnemy:FindFirstChild("HumanoidRootPart") or targetEnemy:FindFirstChild("UpperTorso") or targetEnemy:FindFirstChild("Torso")
            if target then
                local hits = {target}
                
                pcall(function()
                    if RigLib and RigLib.wrapAttackAnimationAsync then
                        local u1 = debug.getupvalue(RigLib.wrapAttackAnimationAsync, 2)
                        local u2 = debug.getupvalue(u1, 4)
                        local u3 = debug.getupvalue(u2, 6)
                        local u4 = debug.getupvalue(u3, 1)
                        local u5 = u4[1]
                        local u6 = u4[2]
                        
                        u5(hits, 3, "", u6)
                    end
                end)
                
                SafeFire(ReplicatedStorage.RigControllerEvent, "weaponChange", tostring(blade))
                SafeFire(ReplicatedStorage.RigControllerEvent, "hit", hits, 2, "")
            end
        end
    end)
    
    return success
end

local function MainAttack()
    pcall(function()
        local currentTime = tick()
        if currentTime - LastAttackTime < AttackDelay then return end

        local Character = Player.Character
        if not Character or not Character:FindFirstChild("HumanoidRootPart") then return end

        local hasTool = false
        for _, v in ipairs(Character:GetChildren()) do
            if v:IsA("Tool") then
                hasTool = true
                break
            end
        end
        
        if not hasTool then return end

        LastAttackTime = currentTime
        
        local usedFastAttack = FastAttackPC()
        
        if not usedFastAttack then
            AttackRotation()
        end
    end)
end

task.spawn(function()
    while task.wait() do
        MainAttack()
    end
end)

Player.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local CollectionService = game:GetService("CollectionService")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")

local player = Players.LocalPlayer

local World1 = false
local World2 = false
local World3 = false

if game.PlaceId == 2753915549 or game.PlaceId == 85211729168715 then
    World1 = true
elseif game.PlaceId == 4442272183 or game.PlaceId == 79091703265657 then
    World2 = true
elseif game.PlaceId == 7449423635 or game.PlaceId == 100117331123089 then
    World3 = true
end

local Mon, Qname, Qdata, NameMon, PosM, PosQ
local isInSubmergedZone = false
local isTravelingToSubmerged = false
local currentTween = nil
local autoFarmConnection
local lastTeleportAttempt = 0

pcall(function()
    local currentTeam = player.Team and player.Team.Name or nil
    if currentTeam ~= "Pirates" and currentTeam ~= "Marines" then
        ReplicatedStorage.Remotes.CommF_:InvokeServer("SetTeam", "Pirates")
    end
end)

LoadConfig()

local ModernUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Rizeniii/diamond/refs/heads/main/zero/main"))()

local Window = ModernUI.new({
    Title = "Cat Hub",
    SubTitle = "Blox Fruits",
    Icon = {"rbxassetid://138770682187300", "rbxassetid://110961158970233"},
    IconFPS = 0.1,
    FloatingButton = {
        Icon = {"rbxassetid://138770682187300", "rbxassetid://110961158970233"},
        Size = 52,
        Position = UDim2.new(1, -70, 0.5, -26)
    }
})

local Players = game:GetService("Players")
local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui")

local CreditsGui = Instance.new("ScreenGui")
CreditsGui.Name = "CatHubCredits"
CreditsGui.ResetOnSpawn = false
CreditsGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
CreditsGui.Parent = PlayerGui

local CreditsFrame = Instance.new("Frame")
CreditsFrame.Name = "CreditsFrame"
CreditsFrame.AnchorPoint = Vector2.new(0.5, 0)
CreditsFrame.Position = UDim2.new(0.5, 0, 0.01, 0)
CreditsFrame.Size = UDim2.new(0, 200, 0, 45)
CreditsFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
CreditsFrame.BorderSizePixel = 0
CreditsFrame.Parent = CreditsGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = CreditsFrame

local ContentFrame = Instance.new("Frame")
ContentFrame.Name = "ContentFrame"
ContentFrame.AnchorPoint = Vector2.new(0.5, 0.5)
ContentFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
ContentFrame.Size = UDim2.new(1, -10, 1, -5)
ContentFrame.BackgroundTransparency = 1
ContentFrame.Parent = CreditsFrame

local IconContainer = Instance.new("Frame")
IconContainer.Name = "IconContainer"
IconContainer.Position = UDim2.new(0, 10, 0.5, 0)
IconContainer.AnchorPoint = Vector2.new(0, 0.5)
IconContainer.Size = UDim2.new(0, 35, 0, 35)
IconContainer.BackgroundTransparency = 1
IconContainer.Parent = ContentFrame

local Icon1 = Instance.new("ImageLabel")
Icon1.Name = "Icon1"
Icon1.Size = UDim2.new(1, 0, 1, 0)
Icon1.BackgroundTransparency = 1
Icon1.Image = "rbxassetid://138770682187300"
Icon1.ScaleType = Enum.ScaleType.Fit
Icon1.Parent = IconContainer

local Icon2 = Instance.new("ImageLabel")
Icon2.Name = "Icon2"
Icon2.Size = UDim2.new(1, 0, 1, 0)
Icon2.BackgroundTransparency = 1
Icon2.Image = "rbxassetid://110961158970233"
Icon2.ScaleType = Enum.ScaleType.Fit
Icon2.Visible = false
Icon2.Parent = IconContainer

local CreditsText = Instance.new("TextLabel")
CreditsText.Name = "CreditsText"
CreditsText.AnchorPoint = Vector2.new(0.5, 0.5)
CreditsText.Position = UDim2.new(0.5, 15, 0.5, 0)
CreditsText.Size = UDim2.new(1, -60, 1, 0)
CreditsText.BackgroundTransparency = 1
CreditsText.Text = "By zerozxk"
CreditsText.TextColor3 = Color3.fromRGB(255, 255, 255)
CreditsText.TextSize = 18
CreditsText.Font = Enum.Font.GothamBold
CreditsText.TextXAlignment = Enum.TextXAlignment.Center
CreditsText.TextYAlignment = Enum.TextYAlignment.Center
CreditsText.Parent = ContentFrame

local currentIcon = 1
task.spawn(function()
    while CreditsGui.Parent do
        task.wait(0.1)
        if currentIcon == 1 then
            Icon1.Visible = false
            Icon2.Visible = true
            currentIcon = 2
        else
            Icon1.Visible = true
            Icon2.Visible = false
            currentIcon = 1
        end
    end
end)

CreditsFrame.Active = false
CreditsFrame.Draggable = false

local function getHRP()
    local c = player.Character
    return c and c:FindFirstChild("HumanoidRootPart")
end

local function CreateFlyPlatform()
    if flyPlatform and flyPlatform.Parent then
        return flyPlatform
    end
    
    local platform = Instance.new("Part")
    platform.Name = "FlyPlatform"
    platform.Size = Vector3.new(10, 1, 10)
    platform.Transparency = 1
    platform.Anchored = true
    platform.CanCollide = true
    platform.Parent = workspace
    
    flyPlatform = platform
    return platform
end

local function RemoveFlyPlatform()
    if flyPlatform and flyPlatform.Parent then
        flyPlatform:Destroy()
        flyPlatform = nil
    end
end

local function topos(targetCFrame)
    pcall(function()
        local char = player.Character
        if not char or not char:FindFirstChild("HumanoidRootPart") then return end
        local rootPart = char.HumanoidRootPart
        
        local distance = (rootPart.Position - targetCFrame.Position).Magnitude
        local speed = Settings.FlySpeed or 300
        
        if currentTween then
            currentTween:Cancel()
        end
        
        if distance > 10 then
            local tweenInfo = TweenInfo.new(distance / speed, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
            currentTween = TweenService:Create(rootPart, tweenInfo, {CFrame = targetCFrame})
            currentTween:Play()
            
            local platform = CreateFlyPlatform()
            
            spawn(function()
                while currentTween and currentTween.PlaybackState == Enum.PlaybackState.Playing do
                    pcall(function()
                        if char and char:FindFirstChild("HumanoidRootPart") then
                            char.HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
                            
                            if platform and platform.Parent then
                                platform.CFrame = CFrame.new(
                                    char.HumanoidRootPart.Position.X,
                                    char.HumanoidRootPart.Position.Y - 3.5,
                                    char.HumanoidRootPart.Position.Z
                                )
                            end
                        end
                    end)
                    task.wait()
                end
                RemoveFlyPlatform()
            end)
        else
            rootPart.CFrame = targetCFrame
            RemoveFlyPlatform()
        end
    end)
end

local function HasQuest()
    local hasQuest = false
    pcall(function()
        local main = player.PlayerGui:FindFirstChild("Main")
        if main then
            local quest = main:FindFirstChild("Quest")
            hasQuest = quest and quest.Visible and quest:FindFirstChild("Container")
        end
    end)
    return hasQuest
end

function EquipWeapon(weaponName)
    if not weaponName then return end
    pcall(function()
        local char = player.Character
        if not char then return end
        
        local currentTool = char:FindFirstChildOfClass("Tool")
        if currentTool and currentTool.Name == weaponName then
            return
        end
        
        local tool = player.Backpack:FindFirstChild(weaponName)
        if tool then
            local humanoid = char:FindFirstChild("Humanoid")
            if humanoid then
                humanoid:EquipTool(tool)
            end
        end
    end)
end

function UnEquipWeapon(Weapon)
    if game.Players.LocalPlayer.Character:FindFirstChild(Weapon) then
        _G.NotAutoEquip = true
        wait(.5)
        game.Players.LocalPlayer.Character:FindFirstChild(Weapon).Parent = game.Players.LocalPlayer.Backpack
        wait(.1)
        _G.NotAutoEquip = false
    end
end

local function getEnemies(char)
    if tick() - lastScan < 0.15 and #cachedEnemies > 0 then
        return cachedEnemies
    end

    cachedEnemies = {}
    lastScan = tick()

    for _, enemy in ipairs(workspace.Enemies:GetChildren()) do
        local hum = enemy:FindFirstChild("Humanoid")
        local hrp = enemy:FindFirstChild("HumanoidRootPart")
        if hum and hrp and hum.Health > 0 then
            local dist = (hrp.Position - char.HumanoidRootPart.Position).Magnitude
            if dist <= 150 then
                table.insert(cachedEnemies, enemy)
            end
        end
    end

    table.sort(cachedEnemies, function(a, b)
        return (a.HumanoidRootPart.Position - char.HumanoidRootPart.Position).Magnitude <
               (b.HumanoidRootPart.Position - char.HumanoidRootPart.Position).Magnitude
    end)

    return cachedEnemies
end

local function AutoHaki()
    pcall(function()
        local char = player.Character
        if char and not char:FindFirstChild("HasBuso") then
            ReplicatedStorage.Remotes.CommF_:InvokeServer("Buso")
        end
    end)
end

local function SetPlatform(state)
    pcall(function()
        local char = player.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.PlatformStand = state
        end
    end)
end

local function Float()
    if Settings.AutoFarm or Settings.AutoChest then
        pcall(function()
            local char = player.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                char.HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
            end
        end)
    end
end

local function EnableNoClip()
    if noclipConnection then return end
    noclipConnection = RunService.Stepped:Connect(function()
        pcall(function()
            if player.Character then
                for _, v in pairs(player.Character:GetDescendants()) do
                    if v:IsA("BasePart") then
                        v.CanCollide = false
                    end
                end
            end
        end)
    end)
end

EnableNoClip()

local function DisableNoClip()
    if noclipConnection then
        noclipConnection:Disconnect()
        noclipConnection = nil
    end
    pcall(function()
        if player.Character then
            for _, v in pairs(player.Character:GetDescendants()) do
                if v:IsA("BasePart") then
                    v.CanCollide = true
                end
            end
        end
    end)
end

function CheckQuest()
    local x = player.Data.Level.Value
    if World1 then
        if x >= 1 and x <= 9 then
            Mon = "Bandit"
            Qdata = 1
            Qname = "BanditQuest1"
            NameMon = "Bandit"
            PosM = CFrame.new(1045.9626464844, 27.002508163452, 1560.8203125)
            PosQ = CFrame.new(1045.9626464844, 27.002508163452, 1560.8203125)
        elseif x >= 10 and x <= 14 then
            Mon = "Monkey"
            Qdata = 1
            Qname = "JungleQuest"
            NameMon = "Monkey"
            PosQ = CFrame.new(-1598.08911, 35.5501175, 153.377838, 0, 0, 1, 0, 1, 0, -1, 0, 0)
            PosM = CFrame.new(-1448.5180664062, 67.853012084961, 11.465796470642)
        elseif x >= 15 and x <= 29 then
            Mon = "Gorilla"
            Qdata = 2
            Qname = "JungleQuest"
            NameMon = "Gorilla"
            PosQ = CFrame.new(-1598.08911, 35.5501175, 153.377838, 0, 0, 1, 0, 1, 0, -1, 0, 0)
            PosM = CFrame.new(-1129.8836669922, 40.46354675293, -525.42370605469)
        elseif x >= 30 and x <= 39 then
            Mon = "Pirate"
            Qdata = 1
            Qname = "BuggyQuest1"
            NameMon = "Pirate"
            PosQ = CFrame.new(-1141.07483, 4.10001802, 3831.5498, 0.965929627, 0, -0.258804798, 0, 1, 0, 0.258804798, 0, 0.965929627)
            PosM = CFrame.new(-1103.5134277344, 13.752052307129, 3896.0910644531)
        elseif x >= 40 and x <= 59 then
            Mon = "Brute"
            Qdata = 2
            Qname = "BuggyQuest1"
            NameMon = "Brute"
            PosQ = CFrame.new(-1141.07483, 4.10001802, 3831.5498, 0.965929627, 0, -0.258804798, 0, 1, 0, 0.258804798, 0, 0.965929627)
            PosM = CFrame.new(-1140.0837402344, 14.809885025024, 4322.9213867188)
        elseif x >= 60 and x <= 74 then
            Mon = "Desert Bandit"
            Qdata = 1
            Qname = "DesertQuest"
            NameMon = "Desert Bandit"
            PosQ = CFrame.new(894.488647, 5.14000702, 4392.43359, 0.819155693, 0, -0.573571265, 0, 1, 0, 0.573571265, 0, 0.819155693)
            PosM = CFrame.new(924.7998046875, 6.4486746788025, 4481.5859375)
        elseif x >= 75 and x <= 89 then
            Mon = "Desert Officer"
            Qdata = 2
            Qname = "DesertQuest"
            NameMon = "Desert Officer"
            PosQ = CFrame.new(894.488647, 5.14000702, 4392.43359, 0.819155693, 0, -0.573571265, 0, 1, 0, 0.573571265, 0, 0.819155693)
            PosM = CFrame.new(1608.2822265625, 8.6142244338989, 4371.0073242188)
        elseif x >= 90 and x <= 99 then
            Mon = "Snow Bandit"
            Qdata = 1
            Qname = "SnowQuest"
            NameMon = "Snow Bandit"
            PosQ = CFrame.new(1389.74451, 88.1519318, -1298.90796, -0.342042685, 0, 0.939684391, 0, 1, 0, -0.939684391, 0, -0.342042685)
            PosM = CFrame.new(1354.3479003906, 87.272773742676, -1393.9465332031)
        elseif x >= 100 and x <= 119 then
            Mon = "Snowman"
            Qdata = 2
            Qname = "SnowQuest"
            NameMon = "Snowman"
            PosQ = CFrame.new(1389.74451, 88.1519318, -1298.90796, -0.342042685, 0, 0.939684391, 0, 1, 0, -0.939684391, 0, -0.342042685)
            PosM = CFrame.new(6241.9951171875, 51.522083282471, -1243.9771728516)
        elseif x >= 120 and x <= 149 then
            Mon = "Chief Petty Officer"
            Qdata = 1
            Qname = "MarineQuest2"
            NameMon = "Chief Petty Officer"
            PosQ = CFrame.new(-5039.58643, 27.3500385, 4324.68018, 0, 0, -1, 0, 1, 0, 1, 0, 0)
            PosM = CFrame.new(-4881.2309570312, 22.652044296265, 4273.7524414062)
        elseif x >= 150 and x <= 174 then
            Mon = "Sky Bandit"
            Qdata = 1
            Qname = "SkyQuest"
            NameMon = "Sky Bandit"
            PosQ = CFrame.new(-4839.53027, 716.368591, -2619.44165, 0.866007268, 0, 0.500031412, 0, 1, 0, -0.500031412, 0, 0.866007268)
            PosM = CFrame.new(-4953.20703125, 295.74420166016, -2899.2290039062)
        elseif x >= 175 and x <= 189 then
            Mon = "Dark Master"
            Qdata = 2
            Qname = "SkyQuest"
            NameMon = "Dark Master"
            PosQ = CFrame.new(-4839.53027, 716.368591, -2619.44165, 0.866007268, 0, 0.500031412, 0, 1, 0, -0.500031412, 0, 0.866007268)
            PosM = CFrame.new(-5259.8447265625, 391.39767456055, -2229.0354003906)
       elseif x >= 190 and x <= 209 then
			Mon = "Prisoner"
			Qdata = 1
			Qname = "PrisonerQuest"
			NameMon = "Prisoner"
			PosQ = CFrame.new(5308.93115, 1.65517521, 475.120514, -0.0894274712, -5.00292918e-09, -0.995993316, 1.60817859e-09, 1, -5.16744869e-09, .995993316, -2.06384709e-09, -0.0894274712)
			PosM = CFrame.new(5098.9736328125, -0.3204058110714, 474.23733520508)
        elseif x >= 210 and x <= 249 then
            Mon = "Dangerous Prisoner"
            Qdata = 2
            Qname = "PrisonerQuest"
            NameMon = "Dangerous Prisoner"
            PosQ = CFrame.new(5308.93115, 1.65517521, 475.120514, -0.0894274712, -5.00292918e-09, -0.995993316, 1.60817859e-09, 1, -5.16744869e-09, 0.995993316, -2.06384709e-09, -0.0894274712)
            PosM = CFrame.new(5654.5634765625, 15.633401870728, 866.29919433594)
        elseif x >= 250 and x <= 299 then
            Mon = "Toga Warrior"
            Qdata = 1
            Qname = "ColosseumQuest"
            NameMon = "Toga Warrior"
            PosQ = CFrame.new(-1580.04663, 6.35000277, -2986.47534, -0.515037298, 0, -0.857167721, 0, 1, 0, 0.857167721, 0, -0.515037298)
            PosM = CFrame.new(-1820.21484375, 51.683856964111, -2740.6650390625)
        elseif x >= 300 and x <= 324 then
            Mon = "Military Soldier"
            Qdata = 1
            Qname = "MagmaQuest"
            NameMon = "Military Soldier"
            PosQ = CFrame.new(-5313.37012, 10.9500084, 8515.29395, -0.499959469, 0, 0.866048813, 0, 1, 0, -0.866048813, 0, -0.499959469)
            PosM = CFrame.new(-5411.1645507812, 11.081554412842, 8454.29296875)
        elseif x >= 325 and x <= 374 then
            Mon = "Military Spy"
            Qdata = 2
            Qname = "MagmaQuest"
            NameMon = "Military Spy"
            PosQ = CFrame.new(-5313.37012, 10.9500084, 8515.29395, -0.499959469, 0, 0.866048813, 0, 1, 0, -0.866048813, 0, -0.499959469)
            PosM = CFrame.new(-5802.8681640625, 86.262413024902, 8828.859375)
        elseif x >= 375 and x <= 399 then
            Mon = "Fishman Warrior"
            Qdata = 1
            Qname = "FishmanQuest"
            NameMon = "Fishman Warrior"
            PosQ = CFrame.new(61122.65234375, 18.497442245483, 1569.3997802734)
            PosM = CFrame.new(60878.30078125, 18.482830047607, 1543.7574462891)
            if Settings.AutoFarm and (PosQ.Position - player.Character.HumanoidRootPart.Position).Magnitude > 10000 then
                ReplicatedStorage.Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(61163.8515625, 11.6796875, 1819.7841796875))
            end
        elseif x >= 400 and x <= 449 then
            Mon = "Fishman Commando"
            Qdata = 2
            Qname = "FishmanQuest"
            NameMon = "Fishman Commando"
            PosQ = CFrame.new(61122.65234375, 18.497442245483, 1569.3997802734)
            PosM = CFrame.new(61922.6328125, 18.482830047607, 1493.9343261719)
            if Settings.AutoFarm and (PosQ.Position - player.Character.HumanoidRootPart.Position).Magnitude > 10000 then
                ReplicatedStorage.Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(61163.8515625, 11.6796875, 1819.7841796875))
            end
        elseif x >= 450 and x <= 474 then
            Mon = "God's Guard"
            Qdata = 1
            Qname = "SkyExp1Quest"
            NameMon = "God's Guard"
            PosQ = CFrame.new(-4721.88867, 843.874695, -1949.96643, 0.996191859, 0, -0.0871884301, 0, 1, 0, 0.0871884301, 0, 0.996191859)
            PosM = CFrame.new(-4710.04296875, 845.27697753906, -1927.3079833984)
            if Settings.AutoFarm and (PosQ.Position - player.Character.HumanoidRootPart.Position).Magnitude > 10000 then
                ReplicatedStorage.Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(-4607.82275, 872.54248, -1667.55688))
            end
        elseif x >= 475 and x <= 524 then
            Mon = "Shanda"
            Qdata = 2
            Qname = "SkyExp1Quest"
            NameMon = "Shanda"
            PosQ = CFrame.new(-7859.09814, 5544.19043, -381.476196, -0.422592998, 0, 0.906319618, 0, 1, 0, -0.906319618, 0, -0.422592998)
            PosM = CFrame.new(-7678.4897460938, 5566.4038085938, -497.21560668945)
            if Settings.AutoFarm and (PosQ.Position - player.Character.HumanoidRootPart.Position).Magnitude > 10000 then
                ReplicatedStorage.Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(-7894.6176757813, 5547.1416015625, -380.29119873047))
            end
        elseif x >= 525 and x <= 549 then
            Mon = "Royal Squad"
            Qdata = 1
            Qname = "SkyExp2Quest"
            NameMon = "Royal Squad"
            PosQ = CFrame.new(-7906.81592, 5634.6626, -1411.99194, 0, 0, -1, 0, 1, 0, 1, 0, 0)
            PosM = CFrame.new(-7624.2524414062, 5658.1333007812, -1467.3542480469)
        elseif x >= 550 and x <= 624 then
            Mon = "Royal Soldier"
            Qdata = 2
            Qname = "SkyExp2Quest"
            NameMon = "Royal Soldier"
            PosQ = CFrame.new(-7906.81592, 5634.6626, -1411.99194, 0, 0, -1, 0, 1, 0, 1, 0, 0)
            PosM = CFrame.new(-7836.7534179688, 5645.6640625, -1790.6236572266)
        elseif x >= 625 and x <= 649 then
            Mon = "Galley Pirate"
            Qdata = 1
            Qname = "FountainQuest"
            NameMon = "Galley Pirate"
            PosQ = CFrame.new(5259.81982, 37.3500175, 4050.0293, 0.087131381, 0, 0.996196866, 0, 1, 0, -0.996196866, 0, 0.087131381)
            PosM = CFrame.new(5551.0219726562, 78.901351928711, 3930.4128417969)
        elseif x >= 650 then
            Mon = "Galley Captain"
            Qdata = 2
            Qname = "FountainQuest"
            NameMon = "Galley Captain"
            PosQ = CFrame.new(5259.81982, 37.3500175, 4050.0293, 0.087131381, 0, 0.996196866, 0, 1, 0, -0.996196866, 0, 0.087131381)
            PosM = CFrame.new(5441.9516601562, 42.502059936523, 4950.09375)
        end
    elseif World2 then
        if x >= 700 and x <= 724 then
            Mon = "Raider"
            Qdata = 1
            Qname = "Area1Quest"
            NameMon = "Raider"
            PosQ = CFrame.new(-429.543518, 71.7699966, 1836.18188, -0.22495985, 0, -0.974368095, 0, 1, 0, 0.974368095, 0, -0.22495985)
            PosM = CFrame.new(-728.32672119141, 52.779319763184, 2345.7705078125)
        elseif x >= 725 and x <= 774 then
            Mon = "Mercenary"
            Qdata = 2
            Qname = "Area1Quest"
            NameMon = "Mercenary"
            PosQ = CFrame.new(-429.543518, 71.7699966, 1836.18188, -0.22495985, 0, -0.974368095, 0, 1, 0, 0.974368095, 0, -0.22495985)
            PosM = CFrame.new(-1004.3244018555, 80.158866882324, 1424.6193847656)
        elseif x >= 775 and x <= 799 then
            Mon = "Swan Pirate"
            Qdata = 1
            Qname = "Area2Quest"
            NameMon = "Swan Pirate"
            PosQ = CFrame.new(638.43811, 71.769989, 918.282898, 0.139203906, 0, 0.99026376, 0, 1, 0, -0.99026376, 0, 0.139203906)
            PosM = CFrame.new(1068.6643066406, 137.61428833008, 1322.1060791016)
        elseif x >= 800 and x <= 874 then
            Mon = "Factory Staff"
            Qname = "Area2Quest"
            Qdata = 2
            NameMon = "Factory Staff"
            PosQ = CFrame.new(632.698608, 73.1055908, 918.666321, -0.0319722369, 8.96074881e-10, -0.999488771, 1.36326533e-10, 1, 8.92172336e-10, 0.999488771, -1.07732087e-10, -0.0319722369)
            PosM = CFrame.new(73.078674316406, 81.863441467285, -27.470672607422)
        elseif x >= 875 and x <= 899 then
            Mon = "Marine Lieutenant"
            Qdata = 1
            Qname = "MarineQuest3"
            NameMon = "Marine Lieutenant"
            PosQ = CFrame.new(-2440.79639, 71.7140732, -3216.06812, 0.866007268, 0, 0.500031412, 0, 1, 0, -0.500031412, 0, 0.866007268)
            PosM = CFrame.new(-2821.3723144531, 75.897277832031, -3070.0891113281)
        elseif x >= 900 and x <= 949 then
            Mon = "Marine Captain"
            Qdata = 2
            Qname = "MarineQuest3"
            NameMon = "Marine Captain"
            PosQ = CFrame.new(-2440.79639, 71.7140732, -3216.06812, 0.866007268, 0, 0.500031412, 0, 1, 0, -0.500031412, 0, 0.866007268)
            PosM = CFrame.new(-1861.2310791016, 80.176582336426, -3254.6975097656)
        elseif x >= 950 and x <= 974 then
            Mon = "Zombie"
            Qdata = 1
            Qname = "ZombieQuest"
            NameMon = "Zombie"
            PosQ = CFrame.new(-5497.06152, 47.5923004, -795.237061, -0.29242146, 0, -0.95628953, 0, 1, 0, 0.95628953, 0, -0.29242146)
            PosM = CFrame.new(-5657.7768554688, 78.969734191895, -928.68701171875)
        elseif x >= 975 and x <= 999 then
            Mon = "Vampire"
            Qdata = 2
            Qname = "ZombieQuest"
            NameMon = "Vampire"
            PosQ = CFrame.new(-5497.06152, 47.5923004, -795.237061, -0.29242146, 0, -0.95628953, 0, 1, 0, 0.95628953, 0, -0.29242146)
            PosM = CFrame.new(-6037.66796875, 32.184638977051, -1340.6597900391)
        elseif x >= 1000 and x <= 1049 then
            Mon = "Snow Trooper"
            Qdata = 1
            Qname = "SnowMountainQuest"
            NameMon = "Snow Trooper"
            PosQ = CFrame.new(609.858826, 400.119904, -5372.25928, -0.374604106, 0, 0.92718488, 0, 1, 0, -0.92718488, 0, -0.374604106)
            PosM = CFrame.new(549.14733886719, 427.38705444336, -5563.6987304688)
        elseif x >= 1050 and x <= 1099 then
            Mon = "Winter Warrior"
            Qdata = 2
            Qname = "SnowMountainQuest"
            NameMon = "Winter Warrior"
            PosQ = CFrame.new(609.858826, 400.119904, -5372.25928, -0.374604106, 0, 0.92718488, 0, 1, 0, -0.92718488, 0, -0.374604106)
            PosM = CFrame.new(1142.7451171875, 475.63980102539, -5199.4165039062)
        elseif x >= 1100 and x <= 1124 then
            Mon = "Lab Subordinate"
            Qdata = 1
            Qname = "IceSideQuest"
            NameMon = "Lab Subordinate"
            PosQ = CFrame.new(-6064.06885, 15.2422857, -4902.97852, 0.453972578, 0, -0.891015649, 0, 1, 0, 0.891015649, 0, 0.453972578)
            PosM = CFrame.new(-5707.4716796875, 15.951709747314, -4513.3920898438)
        elseif x >= 1125 and x <= 1174 then
            Mon = "Horned Warrior"
            Qdata = 2
            Qname = "IceSideQuest"
            NameMon = "Horned Warrior"
            PosQ = CFrame.new(-6064.06885, 15.2422857, -4902.97852, 0.453972578, 0, -0.891015649, 0, 1, 0, 0.891015649, 0, 0.453972578)
            PosM = CFrame.new(-6341.3666992188, 15.951770782471, -5723.162109375)
        elseif x >= 1175 and x <= 1199 then
            Mon = "Magma Ninja"
            Qdata = 1
            Qname = "FireSideQuest"
            NameMon = "Magma Ninja"
            PosQ = CFrame.new(-5428.03174, 15.0622921, -5299.43457, -0.882952213, 0, 0.469463557, 0, 1, 0, -0.469463557, 0, -0.882952213)
            PosM = CFrame.new(-5449.6728515625, 76.658744812012, -5808.2006835938)
        elseif x >= 1200 and x <= 1249 then
            Mon = "Lava Pirate"
            Qdata = 2
            Qname = "FireSideQuest"
            NameMon = "Lava Pirate"
            PosQ = CFrame.new(-5428.03174, 15.0622921, -5299.43457, -0.882952213, 0, 0.469463557, 0, 1, 0, -0.469463557, 0, -0.882952213)
            PosM = CFrame.new(-5213.3315429688, 49.737880706787, -4701.451171875)
        elseif x >= 1250 and x <= 1274 then
            Mon = "Ship Deckhand"
            Qdata = 1
            Qname = "ShipQuest1"
            NameMon = "Ship Deckhand"
            PosQ = CFrame.new(1037.80127, 125.092171, 32911.6016)
            PosM = CFrame.new(1212.0111083984, 150.79205322266, 33059.24609375)
            if Settings.AutoFarm and (PosQ.Position - player.Character.HumanoidRootPart.Position).Magnitude > 500 then
                ReplicatedStorage.Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(923.21252441406, 126.9760055542, 32852.83203125))
            end
        elseif x >= 1275 and x <= 1299 then
            Mon = "Ship Engineer"
            Qdata = 2
            Qname = "ShipQuest1"
            NameMon = "Ship Engineer"
            PosQ = CFrame.new(1037.80127, 125.092171, 32911.6016)
            PosM = CFrame.new(919.47863769531, 43.544013977051, 32779.96875)
            if Settings.AutoFarm and (PosQ.Position - player.Character.HumanoidRootPart.Position).Magnitude > 500 then
                ReplicatedStorage.Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(923.21252441406, 126.9760055542, 32852.83203125))
            end
        elseif x >= 1300 and x <= 1324 then
            Mon = "Ship Steward"
            Qdata = 1
            Qname = "ShipQuest2"
            NameMon = "Ship Steward"
            PosQ = CFrame.new(968.80957, 125.092171, 33244.125)
            PosM = CFrame.new(919.43853759766, 129.55599975586, 33436.03515625)
            if Settings.AutoFarm and (PosQ.Position - player.Character.HumanoidRootPart.Position).Magnitude > 500 then
                ReplicatedStorage.Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(923.21252441406, 126.9760055542, 32852.83203125))
            end
        elseif x >= 1325 and x <= 1349 then
            Mon = "Ship Officer"
            Qdata = 2
            Qname = "ShipQuest2"
            NameMon = "Ship Officer"
            PosQ = CFrame.new(968.80957, 125.092171, 33244.125)
            PosM = CFrame.new(1036.0179443359, 181.4390411377, 33315.7265625)
            if Settings.AutoFarm and (PosQ.Position - player.Character.HumanoidRootPart.Position).Magnitude > 500 then
                ReplicatedStorage.Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(923.21252441406, 126.9760055542, 32852.83203125))
            end
        elseif x >= 1350 and x <= 1374 then
            Mon = "Arctic Warrior"
            Qdata = 1
            Qname = "FrostQuest"
            NameMon = "Arctic Warrior"
            PosQ = CFrame.new(5667.6582, 26.7997818, -6486.08984, -0.933587909, 0, -0.358349502, 0, 1, 0, 0.358349502, 0, -0.933587909)
            PosM = CFrame.new(5966.24609375, 62.970020294189, -6179.3828125)
        elseif x >= 1375 and x <= 1424 then
            Mon = "Snow Lurker"
            Qdata = 2
            Qname = "FrostQuest"
            NameMon = "Snow Lurker"
            PosQ = CFrame.new(5667.6582, 26.7997818, -6486.08984, -0.933587909, 0, -0.358349502, 0, 1, 0, 0.358349502, 0, -0.933587909)
            PosM = CFrame.new(5407.0737304688, 69.194374084473, -6880.8803710938)
        elseif x >= 1425 and x <= 1449 then
            Mon = "Sea Soldier"
            Qdata = 1
            Qname = "ForgottenQuest"
            NameMon = "Sea Soldier"
            PosQ = CFrame.new(-3054.44458, 235.544281, -10142.8193, 0.990270376, 0, -0.13915664, 0, 1, 0, 0.13915664, 0, 0.990270376)
            PosM = CFrame.new(-3028.2236328125, 64.674514770508, -9775.4267578125)
        elseif x >= 1450 then
            Mon = "Water Fighter"
            Qdata = 2
            Qname = "ForgottenQuest"
            NameMon = "Water Fighter"
            PosQ = CFrame.new(-3054.44458, 235.544281, -10142.8193, 0.990270376, 0, -0.13915664, 0, 1, 0, 0.13915664, 0, 0.990270376)
            PosM = CFrame.new(-3352.9013671875, 285.01556396484, -10534.841796875)
        end
    elseif World3 then
        if x >= 1500 and x <= 1524 then
            Mon = "Pirate Millionaire"
            Qdata = 1
            Qname = "PiratePortQuest"
            NameMon = "Pirate Millionaire"
            PosQ = CFrame.new(-290.07, 42.90, 5581.59)
            PosM = CFrame.new(-246.00, 47.31, 5584.10)
        elseif x >= 1525 and x <= 1574 then
            Mon = "Pistol Billionaire"
            Qdata = 2
            Qname = "PiratePortQuest"
            NameMon = "Pistol Billionaire"
            PosQ = CFrame.new(-290.07, 42.90, 5581.59)
            PosM = CFrame.new(-187.33, 86.24, 6013.51)
        elseif x >= 1575 and x <= 1599 then
            Mon = "Dragon Crew Warrior"
            Qdata = 1
            Qname = "DragonCrewQuest"
            NameMon = "Dragon Crew Warrior"
            PosQ = CFrame.new(6737.06055,127.417763,-712.300659,-0.463954359,-7.19574755e-09,0.885859072,7.69187665e-08,1,4.84078626e-08,-0.885859072,9.05982276e-08,-0.463954359)
            PosM = CFrame.new(6709.76367,52.3442993,-1139.02966,-0.763515472,0,0.645789504,0,1,0,-0.645789504,0,-0.763515472)
        elseif x >= 1600 and x <= 1624 then
            Mon = "Dragon Crew Archer"
            Qname = "DragonCrewQuest"
            Qdata = 2
            NameMon = "Dragon Crew Archer"
            PosQ = CFrame.new(6737.06055,127.417763,-712.300659,-0.463954359,-7.19574755e-09,0.885859072,7.69187665e-08,1,4.84078626e-08,-0.885859072,9.05982276e-08,-0.463954359)
            PosM = CFrame.new(6668.76172,481.376923,329.12207,-0.121787429,0,-0.992556155,0,1,0,0.992556155,0,-0.121787429)
        elseif x >= 1625 and x <= 1649 then
            Mon = "Hydra Enforcer"
            Qname = "VenomCrewQuest"
            Qdata = 1
            NameMon = "Hydra Enforcer"
            PosQ = CFrame.new(5206.40185546875, 1004.10498046875, 748.3504638671875)
            PosM = CFrame.new(4547.11523, 1003.10217, 334.194824, 0.388810456, -0, -0.921317935, 0, 1, -0, 0.921317935, 0, 0.388810456)
        elseif x >= 1650 and x <= 1699 then
            Mon = "Venomous Assailant"
            Qname = "VenomCrewQuest"
            Qdata = 2
            NameMon = "Venomous Assailant"
            PosQ = CFrame.new(5206.40185546875, 1004.10498046875, 748.3504638671875)
            PosM = CFrame.new(4674.92676, 1134.82654, 996.308838, 0.731321394, -0, -0.682033002, 0, 1, -0, 0.682033002, 0, 0.731321394)
        elseif x >= 1700 and x <= 1724 then
            Mon = "Marine Commodore"
            Qdata = 1
            Qname = "MarineTreeIsland"
            NameMon = "Marine Commodore"
            PosQ = CFrame.new(2180.54126, 27.8156815, -6741.5498)
            PosM = CFrame.new(2286.0078125, 73.13391876220703, -7159.80908203125)
        elseif x >= 1725 and x <= 1774 then
            Mon = "Marine Rear Admiral"
            NameMon = "Marine Rear Admiral"
            Qname = "MarineTreeIsland"
            Qdata = 2
            PosQ = CFrame.new(2179.98828125, 28.731239318848, -6740.0551757813)
            PosM = CFrame.new(3656.773681640625, 160.52406311035156, -7001.5986328125)
        elseif x >= 1775 and x <= 1799 then
            Mon = "Fishman Raider"
            Qdata = 1
            Qname = "DeepForestIsland3"
            NameMon = "Fishman Raider"
            PosQ = CFrame.new(-10581.6563, 330.872955, -8761.18652)
            PosM = CFrame.new(-10407.5263671875, 331.76263427734375, -8368.5166015625)
        elseif x >= 1800 and x <= 1824 then
            Mon = "Fishman Captain"
            Qdata = 2
            Qname = "DeepForestIsland3"
            NameMon = "Fishman Captain"
            PosQ = CFrame.new(-10581.6563, 330.872955, -8761.18652)
            PosM = CFrame.new(-10994.701171875, 352.38140869140625, -9002.1103515625)
        elseif x >= 1825 and x <= 1849 then
            Mon = "Forest Pirate"
            Qdata = 1
            Qname = "DeepForestIsland"
            NameMon = "Forest Pirate"
            PosQ = CFrame.new(-13234.04, 331.488495, -7625.40137)
            PosM = CFrame.new(-13274.478515625, 332.3781433105469, -7769.58056640625)
        elseif x >= 1850 and x <= 1899 then
            Mon = "Mythological Pirate"
            Qdata = 2
            Qname = "DeepForestIsland"
            NameMon = "Mythological Pirate"
            PosQ = CFrame.new(-13234.04, 331.488495, -7625.40137)
            PosM = CFrame.new(-13680.607421875, 501.08154296875, -6991.189453125)
        elseif x >= 1900 and x <= 1924 then
            Mon = "Jungle Pirate"
            Qdata = 1
            Qname = "DeepForestIsland2"
            NameMon = "Jungle Pirate"
            PosQ = CFrame.new(-12680.3818, 389.971039, -9902.01953)
            PosM = CFrame.new(-12256.16015625, 331.73828125, -10485.8369140625)
        elseif x >= 1925 and x <= 1974 then
            Mon = "Musketeer Pirate"
            Qdata = 2
            Qname = "DeepForestIsland2"
            NameMon = "Musketeer Pirate"
            PosQ = CFrame.new(-12680.3818, 389.971039, -9902.01953)
            PosM = CFrame.new(-13457.904296875, 391.545654296875, -9859.177734375)
        elseif x >= 1975 and x <= 1999 then
            Mon = "Reborn Skeleton"
            Qdata = 1
            Qname = "HauntedQuest1"
            NameMon = "Reborn Skeleton"
            PosQ = CFrame.new(-9479.2168, 141.215088, 5566.09277)
            PosM = CFrame.new(-8763.7236328125, 165.72299194335938, 6159.86181640625)
        elseif x >= 2000 and x <= 2024 then
            Mon = "Living Zombie"
            Qdata = 2
            Qname = "HauntedQuest1"
            NameMon = "Living Zombie"
            PosQ = CFrame.new(-9479.2168, 141.215088, 5566.09277)
            PosM = CFrame.new(-10144.1318359375, 138.62667846679688, 5838.0888671875)
        elseif x >= 2025 and x <= 2049 then
            Mon = "Demonic Soul"
            Qdata = 1
            Qname = "HauntedQuest2"
            NameMon = "Demonic Soul"
            PosQ = CFrame.new(-9516.99316, 172.017181, 6078.46533)
            PosM = CFrame.new(-9505.8720703125, 172.10482788085938, 6158.9931640625)
        elseif x >= 2050 and x <= 2074 then
            Mon = "Posessed Mummy"
            Qdata = 2
            Qname = "HauntedQuest2"
            NameMon = "Posessed Mummy"
            PosQ = CFrame.new(-9516.99316, 172.017181, 6078.46533)
            PosM = CFrame.new(-9582.0224609375, 6.251527309417725, 6205.478515625)
        elseif x >= 2075 and x <= 2099 then
            Mon = "Peanut Scout"
            Qdata = 1
            Qname = "NutsIslandQuest"
            NameMon = "Peanut Scout"
            PosQ = CFrame.new(-2104.3908691406, 38.104167938232, -10194.21875)
            PosM = CFrame.new(-2143.241943359375, 47.72198486328125, -10029.9951171875)
        elseif x >= 2100 and x <= 2124 then
            Mon = "Peanut President"
            Qdata = 2
            Qname = "NutsIslandQuest"
            NameMon = "Peanut President"
            PosQ = CFrame.new(-2104.3908691406, 38.104167938232, -10194.21875)
            PosM = CFrame.new(-1859.35400390625, 38.10316848754883, -10422.4296875)
        elseif x >= 2125 and x <= 2149 then
            Mon = "Ice Cream Chef"
            Qdata = 1
            Qname = "IceCreamIslandQuest"
            NameMon = "Ice Cream Chef"
            PosQ = CFrame.new(-820.64825439453, 65.819526672363, -10965.795898438)
            PosM = CFrame.new(-872.24658203125, 65.81957244873047, -10919.95703125)
        elseif x >= 2150 and x <= 2199 then
            Mon = "Ice Cream Commander"
            Qdata = 2
            Qname = "IceCreamIslandQuest"
            NameMon = "Ice Cream Commander"
            PosQ = CFrame.new(-820.64825439453, 65.819526672363, -10965.795898438)
            PosM = CFrame.new(-558.06103515625, 112.04895782470703, -11290.7744140625)
        elseif x >= 2200 and x <= 2224 then
            Mon = "Cookie Crafter"
            Qdata = 1
            Qname = "CakeQuest1"
            NameMon = "Cookie Crafter"
            PosQ = CFrame.new(-2021.32007, 37.7982254, -12028.7295)
            PosM = CFrame.new(-2374.13671875, 37.79826354980469, -12125.30859375)
        elseif x >= 2225 and x <= 2249 then
            Mon = "Cake Guard"
            Qdata = 2
            Qname = "CakeQuest1"
            NameMon = "Cake Guard"
            PosQ = CFrame.new(-2021.32007, 37.7982254, -12028.7295)
            PosM = CFrame.new(-1598.3070068359375, 43.773197174072266, -12244.5810546875)
        elseif x >= 2250 and x <= 2274 then
            Mon = "Baking Staff"
            Qdata = 1
            Qname = "CakeQuest2"
            NameMon = "Baking Staff"
            PosQ = CFrame.new(-1927.91602, 37.7981339, -12842.5391)
            PosM = CFrame.new(-1887.8099365234375, 77.6185073852539, -12998.3505859375)
        elseif x >= 2275 and x <= 2299 then
            Mon = "Head Baker"
            Qdata = 2
            Qname = "CakeQuest2"
            NameMon = "Head Baker"
            PosQ = CFrame.new(-1927.91602, 37.7981339, -12842.5391)
            PosM = CFrame.new(-2216.188232421875, 82.884521484375, -12869.2939453125)
        elseif x >= 2300 and x <= 2324 then
            Mon = "Cocoa Warrior"
            Qdata = 1
            Qname = "ChocQuest1"
            NameMon = "Cocoa Warrior"
            PosQ = CFrame.new(233.22836303710938, 29.876001358032227, -12201.2333984375)
            PosM = CFrame.new(-21.55328369140625, 80.57499694824219, -12352.3876953125)
        elseif x >= 2325 and x <= 2349 then
            Mon = "Chocolate Bar Battler"
            Qdata = 2
            Qname = "ChocQuest1"
            NameMon = "Chocolate Bar Battler"
            PosQ = CFrame.new(233.22836303710938, 29.876001358032227, -12201.2333984375)
            PosM = CFrame.new(582.590576171875, 77.18809509277344, -12463.162109375)
        elseif x >= 2350 and x <= 2374 then
            Mon = "Sweet Thief"
            Qdata = 1
            Qname = "ChocQuest2"
            NameMon = "Sweet Thief"
            PosQ = CFrame.new(150.5066375732422, 30.693693161010742, -12774.5029296875)
            PosM = CFrame.new(165.1884765625, 76.05885314941406, -12600.8369140625)
        elseif x >= 2375 and x <= 2399 then
            Mon = "Candy Rebel"
            Qdata = 2
            Qname = "ChocQuest2"
            NameMon = "Candy Rebel"
            PosQ = CFrame.new(150.5066375732422, 30.693693161010742, -12774.5029296875)
            PosM = CFrame.new(134.86563110351562, 77.2476806640625, -12876.5478515625)
        elseif x >= 2400 and x <= 2449 then
            Mon = "Candy Pirate"
            Qdata = 1
            Qname = "CandyQuest1"
            NameMon = "Candy Pirate"
            PosQ = CFrame.new(-1150.0400390625, 20.378934860229492, -14446.3349609375)
            PosM = CFrame.new(-1310.5003662109375, 26.016523361206055, -14562.404296875)
        elseif x >= 2450 and x <= 2474 then
            Mon = "Isle Outlaw"
            Qdata = 1
            Qname = "TikiQuest1"
            NameMon = "Isle Outlaw"
            PosQ = CFrame.new(-16548.8164, 55.6059914, -172.8125)
            PosM = CFrame.new(-16479.900390625, 226.6117401123047, -300.3114318847656)
        elseif x >= 2475 and x <= 2499 then
            Mon = "Island Boy"
            Qdata = 2
            Qname = "TikiQuest1"
            NameMon = "Island Boy"
            PosQ = CFrame.new(-16548.8164, 55.6059914, -172.8125)
            PosM = CFrame.new(-16849.396484375, 192.86505126953125, -150.7853240966797)
        elseif x >= 2500 and x <= 2524 then
            Mon = "Sun-kissed Warrior"
            Qdata = 1
            Qname = "TikiQuest2"
            NameMon = "Sun-kissed Warrior"
            PosM = CFrame.new(-16347, 64, 984)
            PosQ = CFrame.new(-16538, 55, 1049)
        elseif x >= 2525 and x <= 2550 then
            Mon = "Isle Champion"
            Qdata = 2
            Qname = "TikiQuest2"
            NameMon = "Isle Champion"
            PosQ = CFrame.new(-16541.0215, 57.3082275, 1051.46118)
            PosM = CFrame.new(-16602.1015625, 130.38734436035156, 1087.24560546875)
        elseif x >= 2551 and x <= 2574 then
            Mon = "Serpent Hunter"
            Qdata = 1
            Qname = "TikiQuest3"
            NameMon = "Serpent Hunter"
            PosQ = CFrame.new(-16679.4785, 176.7473, 1474.3995)
            PosM = CFrame.new(-16679.4785, 176.7473, 1474.3995)
        elseif x >= 2575 and x <= 2599 then
            Mon = "Skull Slayer"
            Qdata = 2
            Qname = "TikiQuest3"
            NameMon = "Skull Slayer"
            PosQ = CFrame.new(-16759.5898, 71.2837, 1595.3399)
            PosM = CFrame.new(-16759.5898, 71.2837, 1595.3399)
        elseif x >= 2600 and x <= 2624 then
            Mon = "Reef Bandit"
            Qdata = 1
            Qname = "SubmergedQuest1"
            NameMon = "Reef Bandit"
            PosQ = CFrame.new(10882.264, -2086.322, 10034.226)
            PosM = CFrame.new(10736.6191, -2087.8439, 9338.4882)
        elseif x >= 2625 and x <= 2649 then
            Mon = "Coral Pirate"
            Qdata = 2
            Qname = "SubmergedQuest1"
            NameMon = "Coral Pirate"
            PosQ = CFrame.new(10882.264, -2086.322, 10034.226)
            PosM = CFrame.new(10965.1025, -2158.8842, 9177.2597)
        elseif x >= 2650 and x <= 2674 then
            Mon = "Sea Chanter"
            Qdata = 1
            Qname = "SubmergedQuest2"
            NameMon = "Sea Chanter"
            PosQ = CFrame.new(10882.264, -2086.322, 10034.226)
            PosM = CFrame.new(10621.0342, -2087.8440, 10102.0332)
        elseif x >= 2675 and x <= 2699 then
            Mon = "Ocean Prophet"
            Qdata = 2
            Qname = "SubmergedQuest2"
            NameMon = "Ocean Prophet"
            PosQ = CFrame.new(10882.264, -2086.322, 10034.226)
            PosM = CFrame.new(11056.1445, -2001.6717, 10117.4493)
        elseif x >= 2700 and x <= 2724 then
            Mon = "High Disciple"
            Qdata = 1
            Qname = "SubmergedQuest3"
            NameMon = "High Disciple"
            PosQ = CFrame.new(9636.52441, -1992.19507, 9609.52832)
            PosM = CFrame.new(9828.087890625, -1940.908935546875, 9693.0634765625)
        elseif x >= 2725 then
            Mon = "Grand Devotee"
            Qdata = 2
            Qname = "SubmergedQuest3"
            NameMon = "Grand Devotee"
            PosQ = CFrame.new(9636.52441, -1992.19507, 9609.52832)
            PosM = CFrame.new(9557.5849609375, -1928.0404052734375, 9859.1826171875)
        end
    end
end

local function StabilizePlayer()
    local player = game.Players.LocalPlayer
    local char = player.Character
    if not char then return end

    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    if hrp:FindFirstChild("Stabilizer") then return end

    local bv = Instance.new("BodyVelocity")
    bv.Name = "Stabilizer"
    bv.MaxForce = Vector3.new(0, 1e6, 0)
    bv.Velocity = Vector3.new(0, 0.1, 0)
    bv.Parent = hrp
end

local function IsRaidMob(mob)
    return mob:GetAttribute("IsBoat") or mob:FindFirstChild("IsRaidEnemy") ~= nil
end

local function FarmAtivo()
    return Settings.AutoFarm or Settings.TravelDress or Settings.AutoZou or Settings.AutoFactory or Settings.AutoRaidCastle or Settings.BartiloQuest or Settings.CitizenQuest
end

_G.BringRange = 320
_G.SpeedB = 300
_G.MobM = 15

local BossList = {
    "Saber Expert","The Saw","Greybeard","Mob Leader","The Gorilla King","Bobby","Yeti",
    "Vice Admiral","Warden","Chief Warden","Swan","Magma Admiral","Fishman Lord","Wysper",
    "Thunder God","Cyborg","Ice Admiral","Don Swan","Darkbeard","Order",
    "Awakened Ice Admiral","Tide Keeper"
}

BringEnemy = function()
    if not _B or not PosMon then return end

    local player = game.Players.LocalPlayer
    local char = player.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    local BringRange = _G.BringRange
    local MaxMob = _G.MobM
    local count = 0

    for _, enemy in pairs(workspace.Enemies:GetChildren()) do
        if count >= MaxMob then break end

        if IsRaidMob(enemy) then continue end

        local isBoss = false
        for _, b in ipairs(BossList) do
            if enemy.Name == b then
                isBoss = true
                break
            end
        end
        if isBoss then continue end

        local hum = enemy:FindFirstChild("Humanoid")
        local root = enemy:FindFirstChild("HumanoidRootPart")
        if not hum or not root or hum.Health <= 0 then continue end

        if (root.Position - PosMon).Magnitude > BringRange then continue end

        count += 1

        local fixedPos = Vector3.new(PosMon.X, root.Position.Y, PosMon.Z)
        root.CFrame = CFrame.new(fixedPos)

        root.CanCollide = false
        root.AssemblyLinearVelocity = Vector3.zero
        root.AssemblyAngularVelocity = Vector3.zero

        hum:ChangeState(Enum.HumanoidStateType.Physics)

        if root:FindFirstChild("BodyVelocity") then
            root.BodyVelocity:Destroy()
        end

        if not root:FindFirstChild("BodyPosition") then
            local bp = Instance.new("BodyPosition")
            bp.Name = "BodyPosition"
            bp.MaxForce = Vector3.new(1e9, 0, 1e9)
            bp.Position = fixedPos
            bp.D = 1000
            bp.P = 20000
            bp.Parent = root
        else
            root.BodyPosition.Position = fixedPos
        end

        pcall(function()
            sethiddenproperty(player, "SimulationRadius", math.huge)
        end)
    end
end

task.spawn(function()
    while true do
        task.wait()
        pcall(function()
            if setscriptable then
                setscriptable(player, "SimulationRadius", true)
            end
            if sethiddenproperty then
                sethiddenproperty(player, "SimulationRadius", math.huge)
            end
        end)
    end
end)

task.spawn(function()
    while task.wait() do
        pcall(function()
            _B = FarmAtivo() and Settings.BringEnemy
            if _B then
                BringEnemy()
            end
        end)
    end
end)

task.spawn(function()
    while task.wait(0.3) do
        pcall(function()
            if Settings.AutoFarm and Settings.BringEnemy then
                local char = player.Character
                if not char then return end

                local hrp = char:FindFirstChild("HumanoidRootPart")
                if not hrp then return end

                if not hrp:FindFirstChild("Stabilizer") then
                    local bv = Instance.new("BodyVelocity")
                    bv.Name = "Stabilizer"
                    bv.MaxForce = Vector3.new(0, 1e6, 0)
                    bv.Velocity = Vector3.new(0, 0.1, 0)
                    bv.Parent = hrp
                end
            else
                local char = player.Character
                if not char then return end

                local hrp = char:FindFirstChild("HumanoidRootPart")
                if not hrp then return end

                if hrp:FindFirstChild("Stabilizer") then
                    hrp.Stabilizer:Destroy()
                end
            end
        end)
    end
end)

local function GetExecutor()
    if identifyexecutor then
        return identifyexecutor()
    elseif getexecutorname then
        return getexecutorname()
    end
    return "Unknown"
end

local function SendWebhook()
    local webhookUrl = ""
    
    local executor = GetExecutor()
    
    local data = {
        embeds = {{
            title = "EXECUTION",
            description = "A server member just ran the cat hub on the executor ```" .. executor .. "```\n> 🙏 Run the cat hub right now!",
            color = 65793,
            timestamp = os.date("!%Y-%m-%dT%H:%M:%S")
        }},
        components = {{
            type = 1,
            components = {{
                type = 2,
                style = 5,
                label = "Get Script",
                url = "https://discord.com/channels/1197904780899667968/1459928061246963775",
                emoji = {
                    name = "🙏"
                }
            }}
        }}
    }
    
    local headers = {
        ["Content-Type"] = "application/json"
    }
    
    local success, response = pcall(function()
        return request({
            Url = webhookUrl,
            Method = "POST",
            Headers = headers,
            Body = HttpService:JSONEncode(data)
        })
    end)
    
    if success then
        print("Webhook sent successfully!")
    else
        print("Failed to send webhook:", response)
    end
end

task.spawn(function()
    task.wait(2)
    SendWebhook()
end)

local function TravelToSubmergedIsland()
    if isTravelingToSubmerged then return false end
    isTravelingToSubmerged = true

    local success = pcall(function()
        if not Settings.AutoFarm or not World3 or player.Data.Level.Value < 2600 then
            isTravelingToSubmerged = false
            return
        end

        CheckQuest()

        if not PosQ then
            isTravelingToSubmerged = false
            return
        end

        local hrp = getHRP()
        if not hrp then
            isTravelingToSubmerged = false
            return
        end

        if hrp.Position.Y < -1500 then
            isInSubmergedZone = true
            isTravelingToSubmerged = false
            return
        end

        local currentTime = tick()
        if currentTime - lastTeleportAttempt < 10 then
            isTravelingToSubmerged = false
            return
        end

        lastTeleportAttempt = currentTime

        local submarinePos = Vector3.new(-16246.041015625, 38.48049545288086, 1376.5396728515625)
        
        while Settings.AutoFarm and getHRP() and (getHRP().Position - submarinePos).Magnitude > 120 do
            topos(CFrame.new(submarinePos))
            task.wait(0.3)
        end

        if not Settings.AutoFarm then
            isTravelingToSubmerged = false
            return
        end

        local flyLoop = task.spawn(function()
            while Settings.AutoFarm and getHRP() and getHRP().Position.Y >= -1500 do
                pcall(function()
                    local h = getHRP()
                    if h then
                        h.Velocity = Vector3.new(0, 0, 0)
                    end
                end)
                task.wait()
            end
        end)

        ReplicatedStorage.Modules.Net["RF/SubmarineWorkerSpeak"]:InvokeServer("TravelToSubmergedIsland")
        task.wait(2)

        local waitTime = 0
        while waitTime < 15 and Settings.AutoFarm do
            pcall(function()
                local h = getHRP()
                if h then
                    h.Velocity = Vector3.new(0, 0, 0)
                end
            end)
            
            if getHRP() and getHRP().Position.Y < -1500 then
                isInSubmergedZone = true
                pcall(function()
                    task.cancel(flyLoop)
                end)
                isTravelingToSubmerged = false
                return
            end
            
            task.wait(0.5)
            waitTime = waitTime + 0.5
        end

        pcall(function()
            task.cancel(flyLoop)
        end)
    end)

    isTravelingToSubmerged = false
    return success
end

local function GetWeaponByType(weaponType)
    local weapons = {
        Melee = {},
        Sword = {},
        Gun = {},
        Fruit = {}
    }
    
    for _, tool in pairs(player.Backpack:GetChildren()) do
        if tool:IsA("Tool") then
            local toolTip = tool.ToolTip
            if toolTip == "Combat" or toolTip == "Melee" then
                table.insert(weapons.Melee, tool.Name)
            elseif toolTip == "Sword" then
                table.insert(weapons.Sword, tool.Name)
            elseif toolTip == "Gun" then
                table.insert(weapons.Gun, tool.Name)
            elseif toolTip == "Blox Fruit" then
                table.insert(weapons.Fruit, tool.Name)
            end
        end
    end
    
    for _, tool in pairs(player.Character:GetChildren()) do
        if tool:IsA("Tool") then
            local toolTip = tool.ToolTip
            if toolTip == "Combat" or toolTip == "Melee" then
                table.insert(weapons.Melee, tool.Name)
            elseif toolTip == "Sword" then
                table.insert(weapons.Sword, tool.Name)
            elseif toolTip == "Gun" then
                table.insert(weapons.Gun, tool.Name)
            elseif toolTip == "Blox Fruit" then
                table.insert(weapons.Fruit, tool.Name)
            end
        end
    end
    
    return weapons[weaponType][1]
end

local function UpdateSelectWeapon()
    pcall(function()
        local weaponName = GetWeaponByType(Settings.WeaponType)
        if weaponName then
            _G.SelectWeapon = weaponName
        end
    end)
end

local function FarmLevel()
    if autoFarmConnection then 
        autoFarmConnection:Disconnect() 
        autoFarmConnection = nil
    end
    if floatConnection then 
        floatConnection:Disconnect() 
        floatConnection = nil
    end
        
    EnableNoClip()
    Settings.BringEnemy = true
    _G.NoClip = true
    
    floatConnection = RunService.Heartbeat:Connect(function()
        Float()
    end)
    
    local savedPositions = {}
    local currentSavedIndex = 1
    local lastPositionSaveTime = 0
    local positionSaveInterval = 5
    local maxSavedPositions = 8
    local lastQuestMon = nil
    local shouldPatrol = true
    local isReturningToSaved = false
    
    autoFarmConnection = RunService.Heartbeat:Connect(function()
        pcall(function()
            if not Settings.AutoFarm then 
                _G.FastAttack = false
                _G.NoClip = false
                StopAutoFarm()
                return 
            end
                        
            local char = player.Character
            if not char or not char:FindFirstChild("HumanoidRootPart") then return end
            
            AutoHaki()
            CheckQuest()
            UpdateSelectWeapon()
            
            if World3 and player.Data.Level.Value >= 2600 and not isInSubmergedZone then
                if not isTravelingToSubmerged then
                    TravelToSubmergedIsland()
                end
                return
            end
            
            if _G.SelectWeapon then
                EquipWeapon(_G.SelectWeapon)
            end
            
            if not HasQuest() then
                if PosQ and (char.HumanoidRootPart.Position - PosQ.Position).Magnitude > 10 then
                    topos(PosQ)
                else
                    task.wait(0.5)
                    if Qname and Qdata then
                        ReplicatedStorage.Remotes.CommF_:InvokeServer("StartQuest", Qname, Qdata)
                        savedPositions = {}
                        currentSavedIndex = 1
                        isReturningToSaved = false
                    end
                end
                return
            end
            
            if not Mon then return end
            
            if lastQuestMon ~= Mon then
                savedPositions = {}
                currentSavedIndex = 1
                lastQuestMon = Mon
                shouldPatrol = Mon ~= "Snow Bandit" and Mon ~= "Snowman"
                isReturningToSaved = false
                lastPositionSaveTime = 0
            end
            
            local nearestTarget
            local nearestDistance = math.huge
            
            for _, enemy in pairs(workspace.Enemies:GetChildren()) do
                if enemy.Name == Mon
                    and enemy:FindFirstChild("HumanoidRootPart")
                    and enemy:FindFirstChild("Humanoid")
                    and enemy.Humanoid.Health > 0 then
                    local dist = (char.HumanoidRootPart.Position - enemy.HumanoidRootPart.Position).Magnitude
                    if dist < nearestDistance then
                        nearestDistance = dist
                        nearestTarget = enemy
                    end
                end
            end
            
            if nearestTarget then
                _G.CurrentTarget = nearestTarget
                local hrpPos = nearestTarget.HumanoidRootPart.Position
                local farmPos = CFrame.new(hrpPos.X, hrpPos.Y + Settings.FarmHeight, hrpPos.Z)
                
                PosMon = hrpPos
                
                local currentTime = tick()
                if shouldPatrol and (currentTime - lastPositionSaveTime) >= positionSaveInterval then
                    local isDuplicate = false
                    for _, savedPos in ipairs(savedPositions) do
                        if (savedPos.Position - farmPos.Position).Magnitude < 50 then
                            isDuplicate = true
                            break
                        end
                    end
                    
                    if not isDuplicate then
                        table.insert(savedPositions, farmPos)
                        if #savedPositions > maxSavedPositions then
                            table.remove(savedPositions, 1)
                        end
                    end
                    lastPositionSaveTime = currentTime
                end
                
                if (char.HumanoidRootPart.Position - farmPos.Position).Magnitude > 10 then
                    topos(farmPos)
                else
                    char.HumanoidRootPart.CFrame = farmPos
                end
                
                if _G.SelectWeapon then
                    EquipWeapon(_G.SelectWeapon)
                end
                
                isReturningToSaved = false
            else
                _G.CurrentTarget = nil
                
                if not shouldPatrol then
                    local basePos = PosM and PosM.Position
                    if basePos then
                        local waitPos = CFrame.new(basePos.X, basePos.Y + Settings.FarmHeight, basePos.Z)
                        PosMon = waitPos.Position
                        if (char.HumanoidRootPart.Position - waitPos.Position).Magnitude > 10 then
                            topos(waitPos)
                        else
                            char.HumanoidRootPart.CFrame = waitPos
                        end
                    end
                    return
                end
                
                if #savedPositions > 0 then
                    if currentSavedIndex > #savedPositions then
                        currentSavedIndex = 1
                    end
                    
                    local targetPos = savedPositions[currentSavedIndex]
                    local dist = (char.HumanoidRootPart.Position - targetPos.Position).Magnitude
                    
                    PosMon = targetPos.Position
                    
                    if dist < 15 then
                        currentSavedIndex = currentSavedIndex + 1
                        if currentSavedIndex > #savedPositions then
                            currentSavedIndex = 1
                        end
                    end
                    
                    topos(savedPositions[currentSavedIndex])
                    isReturningToSaved = true
                else
                    local basePos = PosM and PosM.Position
                    if basePos then
                        local waitPos = CFrame.new(basePos.X, basePos.Y + Settings.FarmHeight, basePos.Z)
                        PosMon = waitPos.Position
                        topos(waitPos)
                    end
                end
            end
        end)
    end)
end

local function GetBoneMobInfo(level)
    if level >= 1975 and level <= 1999 then
        return {
            Mon = "Reborn Skeleton",
            Qdata = 1,
            Qname = "HauntedQuest1",
            NameMon = "Reborn Skeleton",
            PosQ = CFrame.new(-9479.2168, 141.215088, 5566.09277),
            PosM = CFrame.new(-8763.7236328125, 165.72299194335938, 6159.86181640625)
        }
    elseif level >= 2000 and level <= 2024 then
        return {
            Mon = "Living Zombie",
            Qdata = 2,
            Qname = "HauntedQuest1",
            NameMon = "Living Zombie",
            PosQ = CFrame.new(-9479.2168, 141.215088, 5566.09277),
            PosM = CFrame.new(-10144.1318359375, 138.62667846679688, 5838.0888671875)
        }
    elseif level >= 2025 and level <= 2049 then
        return {
            Mon = "Demonic Soul",
            Qdata = 1,
            Qname = "HauntedQuest2",
            NameMon = "Demonic Soul",
            PosQ = CFrame.new(-9516.99316, 172.017181, 6078.46533),
            PosM = CFrame.new(-9505.8720703125, 172.10482788085938, 6158.9931640625)
        }
    elseif level >= 2050 and level <= 2074 then
        return {
            Mon = "Posessed Mummy",
            Qdata = 2,
            Qname = "HauntedQuest2",
            NameMon = "Posessed Mummy",
            PosQ = CFrame.new(-9516.99316, 172.017181, 6078.46533),
            PosM = CFrame.new(-9582.0224609375, 6.251527309417725, 6205.478515625)
        }
    end
    
    return {
        Mon = "Reborn Skeleton",
        Qdata = 1,
        Qname = "HauntedQuest1",
        NameMon = "Reborn Skeleton",
        PosQ = CFrame.new(-9479.2168, 141.215088, 5566.09277),
        PosM = CFrame.new(-8763.7236328125, 165.72299194335938, 6159.86181640625)
    }
end

local BoneMobAreas = {
    {
        Mon = "Reborn Skeleton",
        Qdata = 1,
        Qname = "HauntedQuest1",
        NameMon = "Reborn Skeleton",
        PosQ = CFrame.new(-9479.2168, 141.215088, 5566.09277),
        PosM = CFrame.new(-8763.7236328125, 165.72299194335938, 6159.86181640625)
    },
    {
        Mon = "Living Zombie",
        Qdata = 2,
        Qname = "HauntedQuest1",
        NameMon = "Living Zombie",
        PosQ = CFrame.new(-9479.2168, 141.215088, 5566.09277),
        PosM = CFrame.new(-10144.1318359375, 138.62667846679688, 5838.0888671875)
    },
    {
        Mon = "Demonic Soul",
        Qdata = 1,
        Qname = "HauntedQuest2",
        NameMon = "Demonic Soul",
        PosQ = CFrame.new(-9516.99316, 172.017181, 6078.46533),
        PosM = CFrame.new(-9505.8720703125, 172.10482788085938, 6158.9931640625)
    },
    {
        Mon = "Posessed Mummy",
        Qdata = 2,
        Qname = "HauntedQuest2",
        NameMon = "Posessed Mummy",
        PosQ = CFrame.new(-9516.99316, 172.017181, 6078.46533),
        PosM = CFrame.new(-9582.0224609375, 6.251527309417725, 6205.478515625)
    }
}

function FarmBone()
    if autoFarmConnection then autoFarmConnection:Disconnect() end
    if floatConnection then floatConnection:Disconnect() end
    
    EnableNoClip()
    Settings.AutoFarm = true
    Settings.BringEnemy = true
    _G.FastAttack = true
    
    floatConnection = RunService.Heartbeat:Connect(function()
        Float()
    end)
    
    local currentAreaIndex = 1
    local patrolPositions = {}
    local currentPatrolIndex = 1
    local lastPatrolTime = tick()
    
    autoFarmConnection = RunService.Heartbeat:Connect(function()
        pcall(function()
            if not Settings.AutoFarmMethod or Settings.FarmMethod ~= "Farm Bone" then
                StopAutoFarm()
                return
            end
            
            local char = player.Character
            if not char or not char:FindFirstChild("HumanoidRootPart") then return end
            
            AutoHaki()
            UpdateSelectWeapon()
            
            local currentArea = BoneMobAreas[currentAreaIndex]
            
            if _G.SelectWeapon then
                EquipWeapon(_G.SelectWeapon)
            end
            
            local nearestTarget
            local nearestDistance = math.huge
            
            for _, enemy in pairs(workspace.Enemies:GetChildren()) do
                if enemy.Name == currentArea.Mon
                and enemy:FindFirstChild("HumanoidRootPart")
                and enemy:FindFirstChild("Humanoid")
                and enemy.Humanoid.Health > 0 then
                    local dist = (char.HumanoidRootPart.Position - enemy.HumanoidRootPart.Position).Magnitude
                    if dist < nearestDistance then
                        nearestDistance = dist
                        nearestTarget = enemy
                    end
                end
            end
            
            if nearestTarget then
                _G.CurrentTarget = nearestTarget
                
                local hrpPos = nearestTarget.HumanoidRootPart.Position
                local farmPos = CFrame.new(hrpPos.X, hrpPos.Y + Settings.FarmHeight, hrpPos.Z)
                PosMon = farmPos.Position
                
                if (char.HumanoidRootPart.Position - farmPos.Position).Magnitude > 10 then
                    topos(farmPos)
                else
                    char.HumanoidRootPart.CFrame = farmPos
                end
                
                if _G.FastAttack then
                    pcall(AttackNoCoolDown)
                end
                
                patrolPositions = {}
                currentPatrolIndex = 1
            else
                _G.CurrentTarget = nil
                
                if not currentArea.PosM then return end
                
                if #patrolPositions == 0 then
                    local basePos = currentArea.PosM.Position
                    local offset = 100
                    table.insert(patrolPositions, CFrame.new(basePos.X + offset, basePos.Y + Settings.FarmHeight, basePos.Z))
                    table.insert(patrolPositions, CFrame.new(basePos.X - offset, basePos.Y + Settings.FarmHeight, basePos.Z))
                    table.insert(patrolPositions, CFrame.new(basePos.X, basePos.Y + Settings.FarmHeight, basePos.Z + offset))
                    table.insert(patrolPositions, CFrame.new(basePos.X, basePos.Y + Settings.FarmHeight, basePos.Z - offset))
                end
                
                local currentPos = patrolPositions[currentPatrolIndex]
                local dist = (char.HumanoidRootPart.Position - currentPos.Position).Magnitude
                
                if dist < 15 or (tick() - lastPatrolTime) > 3 then
                    currentPatrolIndex += 1
                    if currentPatrolIndex > #patrolPositions then
                        currentAreaIndex += 1
                        if currentAreaIndex > #BoneMobAreas then
                            currentAreaIndex = 1
                        end
                        patrolPositions = {}
                        currentPatrolIndex = 1
                    end
                    lastPatrolTime = tick()
                end
                
                topos(patrolPositions[currentPatrolIndex])
            end
        end)
    end)
end

function FarmAura()
    if autoFarmConnection then autoFarmConnection:Disconnect() end
    if floatConnection then floatConnection:Disconnect() end
    
    EnableNoClip()
    Settings.AutoFarm = true
    Settings.BringEnemy = true
    _G.FastAttack = true
    
    floatConnection = RunService.Heartbeat:Connect(function()
        Float()
    end)
    
    autoFarmConnection = RunService.Heartbeat:Connect(function()
        pcall(function()
            if not Settings.AutoFarmMethod or Settings.FarmMethod ~= "Farm Aura" then
                StopAutoFarm()
                return
            end
            
            local char = player.Character
            if not char or not char:FindFirstChild("HumanoidRootPart") then return end
            
            AutoHaki()
            UpdateSelectWeapon()
            
            if _G.SelectWeapon then
                EquipWeapon(_G.SelectWeapon)
            end
            
            local mobsInRange = {}
            for _, enemy in pairs(workspace.Enemies:GetChildren()) do
                if enemy:FindFirstChild("Humanoid")
                and enemy:FindFirstChild("HumanoidRootPart")
                and enemy.Humanoid.Health > 0
                and not IsRaidMob(enemy) then
                    local dist = (enemy.HumanoidRootPart.Position - char.HumanoidRootPart.Position).Magnitude
                    if dist <= 300 then
                        table.insert(mobsInRange, enemy)
                    end
                end
            end
            
            if #mobsInRange > 0 then
                local centerMob = mobsInRange[1]
                _G.CurrentTarget = centerMob
                
                local hrpPos = centerMob.HumanoidRootPart.Position
                local farmPos = CFrame.new(hrpPos.X, hrpPos.Y + Settings.FarmHeight, hrpPos.Z)
                PosMon = farmPos.Position
                
                if (char.HumanoidRootPart.Position - farmPos.Position).Magnitude > 10 then
                    topos(farmPos)
                else
                    char.HumanoidRootPart.CFrame = farmPos
                end
                
                if _G.FastAttack then
                    pcall(AttackNoCoolDown)
                end
            else
                _G.CurrentTarget = nil
            end
        end)
    end)
end

local function GetFishingPosition()
    return FishingSettings.CustomPosition or FishingSettings.DefaultFishingPosition
end

local function HasFishingRod()
    return player.Backpack:FindFirstChild("Fishing Rod") or (player.Character and player.Character:FindFirstChild("Fishing Rod"))
end

local function EquipFishingRod()
    if player.Character and player.Character:FindFirstChild("Fishing Rod") then
        return
    end
    
    local rod = player.Backpack:FindFirstChild("Fishing Rod")
    if rod then
        local humanoid = player.Character and player.Character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid:EquipTool(rod)
            task.wait(0.5)
        end
    end
end

local function EnsureRodAndBait()
    pcall(function()
        ReplicatedStorage.Modules.Net["RF/JobsRemoteFunction"]:InvokeServer("FishingNPC", "FirstTimeFreeRod")
        task.wait(0.5)
        ReplicatedStorage.Remotes.CommF_:InvokeServer("LoadItem", "Fishing Rod", {"Gear"})
    end)
    task.wait(0.5)
    
    local Data = player:FindFirstChild("Data") and player.Data:FindFirstChild("FishingData")
    if Data and (Data:GetAttribute("SelectedBait") == "None" or Data:GetAttribute("SelectedBait") == nil) then
        local inv = ReplicatedStorage.Remotes.CommF_:InvokeServer("getInventory")
        if inv then
            for _, v in pairs(inv) do
                if v.Type == "Bait" and v.Name == "Basic Bait" then
                    ReplicatedStorage.Remotes.CommF_:InvokeServer("LoadItem", v.Name, {"Usables"})
                    return
                end
            end
        end
        ReplicatedStorage.Modules.Net["RF/Craft"]:InvokeServer("Craft", "Basic Bait")
        task.wait(2)
        ReplicatedStorage.Remotes.CommF_:InvokeServer("LoadItem", "Basic Bait", {"Usables"})
    end
end

local function CheckBaitCount()
    local inv = ReplicatedStorage.Remotes.CommF_:InvokeServer("getInventory")
    local baitCount = 0
    if inv then
        for _, v in pairs(inv) do
            if v.Type == "Bait" then
                baitCount = baitCount + (v.Count or 1)
            end
        end
    end
    return baitCount
end

local function AutoFish()
    task.spawn(function()
        while FishingSettings.AutoFish do
            pcall(function()
                if not HasFishingRod() then
                    local hrp = getHRP()
                    if hrp and (hrp.Position - FishingSettings.DefaultNPCPosition.Position).Magnitude > 10 then
                        topos(FishingSettings.DefaultNPCPosition)
                        task.wait(1)
                    end
                    EnsureRodAndBait()
                    task.wait(1)
                end
                
                local fishingPos = GetFishingPosition()
                local hrp = getHRP()
                if hrp and (hrp.Position - fishingPos.Position).Magnitude > 10 then
                    topos(fishingPos)
                    task.wait(1)
                end
                
                EquipFishingRod()
                EnableNoClip()
                task.wait(1)
                
                hrp = getHRP()
                if hrp then
                    local targetPos = hrp.Position + hrp.CFrame.LookVector * 50
                    
                    ReplicatedStorage.FishReplicated.FishingRequest:InvokeServer("CastLineAtLocation", targetPos, 78.73346733234683, true)
                    task.wait(0.3)
                    ReplicatedStorage.FishReplicated.FishingRequest:InvokeServer("Catching", true, {["FastBite"] = true})
                    task.wait(0.3)
                    local result = ReplicatedStorage.FishReplicated.FishingRequest:InvokeServer("Catch", 1, 0, 0.9224466865571423)
                    ReplicatedStorage.Modules.Net["RF/JobToolAbilities"]:InvokeServer("Z", true)
                    
                    if result and type(result) == "table" and result.Name then
                        Window:Notify({
                            Title = "Fishing",
                            Body = result.Name .. " Captured",
                            Duration = 2
                        })
                    elseif result and type(result) == "string" then
                        Window:Notify({
                            Title = "Fishing",
                            Body = result .. " Captured",
                            Duration = 2
                        })
                    end
                end
            end)
            task.wait(0.5)
        end
    end)
end

local function AutoSellFish()
    task.spawn(function()
        while FishingSettings.AutoSellFish do
            pcall(function()
                ReplicatedStorage.Modules.Net["RF/JobsRemoteFunction"]:InvokeServer("FishingNPC", "SellFish")
            end)
            task.wait(1)
        end
    end)
end

local function AutoBuyBait()
    task.spawn(function()
        while FishingSettings.AutoBuyBait do
            pcall(function()
                local baitCount = CheckBaitCount()
                if baitCount == 0 then
                    ReplicatedStorage.Modules.Net["RF/Craft"]:InvokeServer("Craft", "Basic Bait", {})
                    task.wait(1)
                    ReplicatedStorage.Remotes.CommF_:InvokeServer("getInventory")
                    task.wait(0.5)
                    ReplicatedStorage.Remotes.CommF_:InvokeServer("LoadItem", "Basic Bait", {"Usables"})
                    task.wait(1)
                end
            end)
            task.wait(1)
        end
    end)
end

local function UpdateStoreFruit()
    local currentFruits = {}
    
    for _, item in pairs(player.Backpack:GetChildren()) do
        local storeFruit = item:FindFirstChild("EatRemote", true)
        if storeFruit then
            local fruitName = storeFruit.Parent:GetAttribute("OriginalName")
            
            if not currentFruits[fruitName] then
                currentFruits[fruitName] = 0
            end
            currentFruits[fruitName] = currentFruits[fruitName] + 1
        end
    end
    
    for fruitName, count in pairs(currentFruits) do
        if not storedFruits[fruitName] then
            storedFruits[fruitName] = 0
        end
        
        local toStore = count - storedFruits[fruitName]
        
        if toStore > 0 then
            for _, item in pairs(player.Backpack:GetChildren()) do
                if toStore <= 0 then break end
                
                local storeFruit = item:FindFirstChild("EatRemote", true)
                if storeFruit and storeFruit.Parent:GetAttribute("OriginalName") == fruitName then
                    ReplicatedStorage.Remotes.CommF_:InvokeServer("StoreFruit", fruitName, item)
                    storedFruits[fruitName] = storedFruits[fruitName] + 1
                    toStore = toStore - 1
                    task.wait(0.1)
                end
            end
        end
    end
    
    for fruitName in pairs(storedFruits) do
        if not currentFruits[fruitName] then
            storedFruits[fruitName] = nil
        end
    end
end

local function CountChests()
    local count = 0
    pcall(function()
        for _, chest in pairs(CollectionService:GetTagged("_ChestTagged")) do
            if chest and chest.Parent and not chest:GetAttribute("IsDisabled") then
                count += 1
            end
        end
    end)
    return count
end

local function ForceServerHop()
    if isServerHopping then return end
    isServerHopping = true

    if autoChestConnection then autoChestConnection:Disconnect() end
    if floatConnection then floatConnection:Disconnect() end
    if noclipConnection then noclipConnection:Disconnect() end

    task.spawn(function()
        task.wait(2)

        pcall(function()
            local url = "https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100"
            local data = HttpService:JSONDecode(game:HttpGet(url))

            if data and data.data then
                for _, server in pairs(data.data) do
                    if server.id ~= game.JobId and server.playing < server.maxPlayers then
                        TeleportService:TeleportToPlaceInstance(game.PlaceId, server.id, player)
                        return
                    end
                end
            end
        end)

        task.wait(1)
        TeleportService:Teleport(game.PlaceId, player)
    end)
end

local function StopAutoChest()
    if autoChestConnection then autoChestConnection:Disconnect() autoChestConnection = nil end
    if floatConnection then floatConnection:Disconnect() floatConnection = nil end
    SetPlatform(false)
end

local function CheckForSpecialItems()
    if not Settings.StopWhenChalice then
        return false
    end
    
    if player.Backpack:FindFirstChild("God's Chalice") or player.Backpack:FindFirstChild("Fist of Darkness") then
        return true
    end
    
    if player.Character then
        if player.Character:FindFirstChild("God's Chalice") or player.Character:FindFirstChild("Fist of Darkness") then
            return true
        end
    end
    
    local inv = ReplicatedStorage.Remotes.CommF_:InvokeServer("getInventory")
    if inv then
        for _, item in pairs(inv) do
            if item.Name == "God's Chalice" or item.Name == "Fist of Darkness" then
                return true
            end
        end
    end
    
    return false
end

local function GetCurrentWorldBosses()
    if World1 then
        return BossData.World1
    elseif World2 then
        return BossData.World2
    elseif World3 then
        return BossData.World3
    end
    return {}
end

local function GetAvailableBosses()
    local available = {}
    local worldBosses = GetCurrentWorldBosses()
    for bossName, _ in pairs(worldBosses) do
        for _, enemy in pairs(workspace.Enemies:GetChildren()) do
            if enemy.Name == bossName and enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 then
                table.insert(available, bossName)
                break
            end
        end
    end
    return available
end

local function IsBossAlive(bossName)
    local worldBosses = GetCurrentWorldBosses()
    local bossData = worldBosses[bossName]
    if not bossData then return false, nil end
    local hrp = getHRP()
    if hrp and (hrp.Position - bossData.PosB.Position).Magnitude > 500 then
        topos(bossData.PosB)
        task.wait(2)
    end
    for _, enemy in pairs(workspace.Enemies:GetChildren()) do
        if enemy.Name == bossName and enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 then
            return true, enemy
        end
    end
    return false, nil
end

local function KillBoss(bossName, getQuest)
    local worldBosses = GetCurrentWorldBosses()
    local bossData = worldBosses[bossName]
    if not bossData then return end
    local isAlive, boss = IsBossAlive(bossName)
    if not isAlive then return end
    EnableNoClip()
    CreateFlyPlatform()
    _G.FastAttack = true
    if getQuest and bossData.HasQuest then
        local hrp = getHRP()
        if hrp then
            local distanceToQuest = (hrp.Position - bossData.PosQBoss.Position).Magnitude
            if distanceToQuest > 10 then
                topos(bossData.PosQBoss)
                repeat
                    task.wait()
                    hrp = getHRP()
                    if hrp then
                        distanceToQuest = (hrp.Position - bossData.PosQBoss.Position).Magnitude
                    end
                until distanceToQuest <= 10 or not (Settings.KillSelectedBoss or Settings.KillAllBoss or Settings.FarmBossesSelectedHop or Settings.FarmAllBossesHop)
            end
            task.wait(0.5)
            ReplicatedStorage.Remotes.CommF_:InvokeServer("StartQuest", bossData.Qname, bossData.Qdata)
            task.wait(0.5)
        end
    end
    while (Settings.KillSelectedBoss or Settings.KillAllBoss or Settings.FarmBossesSelectedHop or Settings.FarmAllBossesHop) and boss and boss.Parent do
        task.wait()
        if not boss:FindFirstChild("Humanoid") or boss.Humanoid.Health <= 0 then
            break
        end
        AutoHaki()
        UpdateSelectWeapon()
        if _G.SelectWeapon then
            EquipWeapon(_G.SelectWeapon)
        end
        local hrpPos = boss.HumanoidRootPart.Position
        local farmPos = CFrame.new(hrpPos.X, hrpPos.Y + Settings.FarmHeight, hrpPos.Z)
        PosMon = farmPos.Position
        local hrp = getHRP()
        if hrp then
            if (hrp.Position - farmPos.Position).Magnitude > 10 then
                topos(farmPos)
            else
                hrp.CFrame = farmPos
            end
            if flyPlatform and flyPlatform.Parent then
                flyPlatform.CFrame = CFrame.new(hrp.Position.X, hrp.Position.Y - 3.5, hrp.Position.Z)
            end
        end
        _G.CurrentTarget = boss
    end
    _G.FastAttack = false
    _G.CurrentTarget = nil
end

local function ResetBossState()
    return false, false, false, 0
end

local function HandleQuestLogic(hrp, bossData, hasCompletedQuest)
    if not Settings.GetQuestBosses or not bossData.HasQuest or hasCompletedQuest then
        return hasCompletedQuest
    end
    local questPos = bossData.PosQBoss.Position
    local distanceToQuest = (hrp.Position - questPos).Magnitude
    if distanceToQuest > 5 then
        topos(bossData.PosQBoss)
        return false
    else
        topos(bossData.PosQBoss)
        task.wait(0.5)
        ReplicatedStorage.Remotes.CommF_:InvokeServer("StartQuest", bossData.Qname, bossData.Qdata)
        task.wait(0.5)
        return true
    end
end

local function HandleBossConfirmation(currentBossName, hasConfirmedBoss)
    if hasConfirmedBoss then return true end
    local isAlive, boss = IsBossAlive(currentBossName)
    return isAlive
end

local function HandleBossTimeout(hrp, bossPos, distanceToPosition, hasReachedPosition, lastBossChangeTime)
    if distanceToPosition <= 50 then
        if not hasReachedPosition then
            return true, tick()
        end
        if tick() - lastBossChangeTime >= 5 then
            return nil, 0
        end
        return hasReachedPosition, lastBossChangeTime
    else
        return false, lastBossChangeTime
    end
end

local function AttackBoss(boss, hrp)
    _G.CurrentTarget = boss
    _G.FastAttack = true
    AutoHaki()
    UpdateSelectWeapon()
    CreateFlyPlatform()
    if _G.SelectWeapon then
        EquipWeapon(_G.SelectWeapon)
    end
    local hrpPos = boss.HumanoidRootPart.Position
    local farmPos = CFrame.new(hrpPos.X, hrpPos.Y + Settings.FarmHeight, hrpPos.Z)
    PosMon = farmPos.Position
    if (hrp.Position - farmPos.Position).Magnitude > 10 then
        topos(farmPos)
    else
        hrp.CFrame = farmPos
    end
    if flyPlatform and flyPlatform.Parent then
        flyPlatform.CFrame = CFrame.new(hrp.Position.X, hrp.Position.Y - 3.5, hrp.Position.Z)
    end
end

local function MoveToBoss(hrp, bossPos, hasConfirmedBoss)
    _G.CurrentTarget = nil
    if not hasConfirmedBoss then
        topos(CFrame.new(bossPos.X, bossPos.Y, bossPos.Z))
    end
end

local function GetAllBossesInCurrentWorld()
    local bossList = {}
    local worldBosses = GetCurrentWorldBosses()
    for bossName, _ in pairs(worldBosses) do
        table.insert(bossList, bossName)
    end
    return bossList
end

_G.BossFarmState = _G.BossFarmState or "Idle"

local function HasActiveQuest()
    local success, result = pcall(function()
        local questData = game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest
        if questData.Visible == true then
            local questTitle = questData.Container.QuestTitle.Title.Text
            if questTitle and questTitle ~= "" then
                return true
            end
        end
        return false
    end)
    return success and result
end

local function FarmSelectedBossesHop()
    task.spawn(function()
        local currentBossIndex = 1
        local lastBossIndex
        local lastBossChangeTime = 0
        local hasReachedPosition = false
        local searchRadius = 1000
        local questGotForThisBoss = false
        local lastSeenBossTime = 0
        local bossesKilled = {}

        EnableNoClip()

        if floatConnection then
            floatConnection:Disconnect()
            floatConnection = nil
        end

        floatConnection = RunService.Heartbeat:Connect(function()
            Float()
        end)

        while Settings.FarmBossesSelectedHop do
            task.wait(0.1)
            pcall(function()
                if #Settings.SelectedBosses == 0 then return end

                local currentBossName = Settings.SelectedBosses[currentBossIndex]
                if lastBossIndex ~= currentBossIndex then
                    questGotForThisBoss = false
                    lastBossIndex = currentBossIndex
                end

                local worldBosses = GetCurrentWorldBosses()
                local bossData = worldBosses[currentBossName]
                if not bossData then
                    currentBossIndex += 1
                    if currentBossIndex > #Settings.SelectedBosses then
                        currentBossIndex = 1
                    end
                    return
                end

                local hrp = getHRP()
                if not hrp then return end

                if Settings.GetQuestBosses and bossData.HasQuest and not questGotForThisBoss and not HasActiveQuest() then
                    local questPos = bossData.PosQBoss.Position
                    if (hrp.Position - questPos).Magnitude > 10 then
                        topos(bossData.PosQBoss)
                        return
                    else
                        if currentTween then currentTween:Cancel() end
                        hrp.CFrame = bossData.PosQBoss
                        task.wait(0.6)
                        ReplicatedStorage.Remotes.CommF_:InvokeServer("StartQuest", bossData.Qname, bossData.Qdata)
                        task.wait(1)
                        if HasActiveQuest() then
                            questGotForThisBoss = true
                        end
                        return
                    end
                end

                local foundBoss
                for _, enemy in pairs(workspace.Enemies:GetChildren()) do
                    if enemy.Name == currentBossName
                    and enemy:FindFirstChild("Humanoid")
                    and enemy:FindFirstChild("HumanoidRootPart")
                    and enemy.Humanoid.Health > 0 then
                        if (enemy.HumanoidRootPart.Position - bossData.PosB.Position).Magnitude <= searchRadius then
                            foundBoss = enemy
                            break
                        end
                    end
                end

                if foundBoss then
                    lastSeenBossTime = tick()
                    hasReachedPosition = false
                    lastBossChangeTime = 0

                    _G.CurrentTarget = foundBoss
                    _G.FastAttack = true
                    AutoHaki()
                    UpdateSelectWeapon()
                    
                    if _G.SelectWeapon then
                        EquipWeapon(_G.SelectWeapon)
                    end

                    local bossPos = foundBoss.HumanoidRootPart.Position
                    local farmPos = CFrame.new(bossPos.X, bossPos.Y + 25, bossPos.Z)
                    PosMon = farmPos.Position

                    if (hrp.Position - farmPos.Position).Magnitude > 10 then
                        topos(farmPos)
                    else
                        hrp.CFrame = farmPos
                        hrp.Velocity = Vector3.new(0, 0, 0)
                    end

                    if flyPlatform and flyPlatform.Parent then
                        flyPlatform.CFrame = CFrame.new(hrp.Position.X, hrp.Position.Y - 3.5, hrp.Position.Z)
                    end
                else
                    _G.CurrentTarget = nil
                    _G.FastAttack = false

                    if tick() - lastSeenBossTime < 2 then return end

                    if hasReachedPosition and not bossesKilled[currentBossName] then
                        bossesKilled[currentBossName] = true
                        
                        local allKilled = true
                        for _, bossName in ipairs(Settings.SelectedBosses) do
                            if not bossesKilled[bossName] then
                                allKilled = false
                                break
                            end
                        end
                        
                        if allKilled then
                            Window:Notify({
                                Title = "Boss Farm Complete",
                                Body = "All selected bosses killed. Server hopping...",
                                Duration = 3
                            })
                            task.wait(1)
                            ForceServerHop()
                            return
                        end
                    end

                    local bossPos = bossData.PosB.Position
                    if (hrp.Position - bossPos).Magnitude <= 50 then
                        if not hasReachedPosition then
                            hasReachedPosition = true
                            lastBossChangeTime = tick()
                        end
                        if tick() - lastBossChangeTime >= 3 then
                            currentBossIndex += 1
                            if currentBossIndex > #Settings.SelectedBosses then
                                currentBossIndex = 1
                            end
                            hasReachedPosition = false
                            questGotForThisBoss = false
                        end
                    else
                        hasReachedPosition = false
                        lastBossChangeTime = 0
                        topos(CFrame.new(bossPos))
                    end
                end
            end)
        end

        if floatConnection then
            floatConnection:Disconnect()
            floatConnection = nil
        end
        RemoveFlyPlatform()
        _G.FastAttack = false
        _G.CurrentTarget = nil
        DisableNoClip()
    end)
end

local function FarmSelectedBosses()
    task.spawn(function()
        local currentBossIndex = 1
        local lastBossIndex
        local questGotForThisBoss = false
        local lastSeenBossTime = 0
        local hasReachedBossPosition = false
        local waitStartTime = 0

        EnableNoClip()

        if floatConnection then
            floatConnection:Disconnect()
            floatConnection = nil
        end

        floatConnection = RunService.Heartbeat:Connect(function()
            Float()
        end)

        while Settings.KillSelectedBoss do
            task.wait(0.1)
            pcall(function()
                if #Settings.SelectedBosses == 0 then return end

                local currentBossName = Settings.SelectedBosses[currentBossIndex]
                
                if lastBossIndex ~= currentBossIndex then
                    questGotForThisBoss = false
                    lastBossIndex = currentBossIndex
                    hasReachedBossPosition = false
                    waitStartTime = 0
                end

                local worldBosses = GetCurrentWorldBosses()
                local bossData = worldBosses[currentBossName]
                
                if not bossData then
                    currentBossIndex = currentBossIndex % #Settings.SelectedBosses + 1
                    return
                end

                local hrp = getHRP()
                if not hrp then return end

                if Settings.GetQuestBosses and bossData.HasQuest and not questGotForThisBoss then
                    if HasActiveQuest() then
                        local questTitle = game.Players.LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text
                        if not string.find(questTitle, currentBossName) then
                            ReplicatedStorage.Remotes.CommF_:InvokeServer("AbandonQuest")
                            task.wait(0.5)
                        end
                    end
                    
                    if not HasActiveQuest() then
                        local questPos = bossData.PosQBoss.Position
                        if (hrp.Position - questPos).Magnitude > 10 then
                            topos(bossData.PosQBoss)
                            return
                        else
                            if currentTween then currentTween:Cancel() end
                            task.wait(0.3)
                            ReplicatedStorage.Remotes.CommF_:InvokeServer("StartQuest", bossData.Qname, bossData.Qdata)
                            task.wait(0.8)
                            if HasActiveQuest() then
                                questGotForThisBoss = true
                            end
                            return
                        end
                    end
                end

                local foundBoss
                for _, enemy in pairs(workspace.Enemies:GetChildren()) do
                    if enemy.Name == currentBossName
                    and enemy:FindFirstChild("Humanoid")
                    and enemy:FindFirstChild("HumanoidRootPart")
                    and enemy.Humanoid.Health > 0 then
                        foundBoss = enemy
                        break
                    end
                end

                if foundBoss then
                    lastSeenBossTime = tick()
                    hasReachedBossPosition = false
                    waitStartTime = 0

                    _G.CurrentTarget = foundBoss
                    _G.FastAttack = true
                    AutoHaki()
                    UpdateSelectWeapon()
                    
                    if _G.SelectWeapon then
                        EquipWeapon(_G.SelectWeapon)
                    end

                    local bossPos = foundBoss.HumanoidRootPart.Position
                    local farmPos = CFrame.new(bossPos.X, bossPos.Y + 25, bossPos.Z)
                    PosMon = farmPos.Position

                    if (hrp.Position - farmPos.Position).Magnitude > 10 then
                        topos(farmPos)
                    else
                        hrp.CFrame = farmPos
                        hrp.Velocity = Vector3.new(0, 0, 0)
                    end

                    if flyPlatform and flyPlatform.Parent then
                        flyPlatform.CFrame = CFrame.new(hrp.Position.X, hrp.Position.Y - 3.5, hrp.Position.Z)
                    end

                    if foundBoss.Humanoid.Health <= 0 then
                        questGotForThisBoss = false
                        currentBossIndex = currentBossIndex % #Settings.SelectedBosses + 1
                    end
                else
                    _G.CurrentTarget = nil
                    _G.FastAttack = false

                    local bossPos = bossData.PosB.Position
                    
                    if (hrp.Position - bossPos).Magnitude > 50 then
                        hasReachedBossPosition = false
                        waitStartTime = 0
                        topos(CFrame.new(bossPos))
                    else
                        if not hasReachedBossPosition then
                            hasReachedBossPosition = true
                            waitStartTime = tick()
                        end
                        
                        if tick() - waitStartTime >= 3 then
                            questGotForThisBoss = false
                            currentBossIndex = currentBossIndex % #Settings.SelectedBosses + 1
                        end
                    end
                end
            end)
        end

        if floatConnection then
            floatConnection:Disconnect()
            floatConnection = nil
        end
        RemoveFlyPlatform()
        _G.FastAttack = false
        _G.CurrentTarget = nil
        DisableNoClip()
    end)
end

function FarmMaterial()
    if autoFarmConnection then autoFarmConnection:Disconnect() end
    if floatConnection then floatConnection:Disconnect() end

    _G.FastAttack = true
    _G.NoClip = true
    Settings.BringEnemy = true
    EnableNoClip()

    floatConnection = RunService.Heartbeat:Connect(function()
        if _G.NoClip then
            EnableNoClip()
        end
        Float()
    end)

    local patrolPositions = {}
    local currentPatrolIndex = 1
    local lastPatrolTime = tick()

    autoFarmConnection = RunService.Heartbeat:Connect(function()
        pcall(function()
            if not Settings.AutoFarmMaterial then
                _G.FastAttack = false
                _G.NoClip = false
                Settings.BringEnemy = false
                StopAutoFarm()
                return
            end

            Settings.BringEnemy = true

            local char = player.Character
            if not char or not char:FindFirstChild("HumanoidRootPart") then return end

            local materialData = MaterialData[Settings.SelectMaterial]
            if not materialData then return end

            local currentWorld = World1 and 1 or (World2 and 2 or 3)
            if currentWorld ~= materialData.World then
                if materialData.World == 2 then
                    ReplicatedStorage.Remotes.CommF_:InvokeServer("TravelDressrosa")
                elseif materialData.World == 3 then
                    ReplicatedStorage.Remotes.CommF_:InvokeServer("TravelZou")
                end
                task.wait(10)
                return
            end

            if materialData.RequireEntrance then
                local hrp = char.HumanoidRootPart
                if (hrp.Position - materialData.RequireEntrance).Magnitude > 5000 then
                    ReplicatedStorage.Remotes.CommF_:InvokeServer("requestEntrance", materialData.RequireEntrance)
                    task.wait(1)
                end
            end

            AutoHaki()
            UpdateSelectWeapon()

            if _G.SelectWeapon then
                EquipWeapon(_G.SelectWeapon)
            end

            if Settings.AcceptQuestForMaterial and not HasQuest() then
                if materialData.PosQ and (char.HumanoidRootPart.Position - materialData.PosQ.Position).Magnitude > 10 then
                    topos(materialData.PosQ)
                else
                    task.wait(0.5)
                    if materialData.Qname and materialData.Qdata then
                        ReplicatedStorage.Remotes.CommF_:InvokeServer("StartQuest", materialData.Qname, materialData.Qdata)
                        patrolPositions = {}
                        currentPatrolIndex = 1
                    end
                end
                return
            end

            local nearestTarget
            local nearestDistance = math.huge

            for _, enemy in pairs(workspace.Enemies:GetChildren()) do
                if enemy.Name == materialData.Mon
                and enemy:FindFirstChild("HumanoidRootPart")
                and enemy:FindFirstChild("Humanoid")
                and enemy.Humanoid.Health > 0 then
                    local dist = (char.HumanoidRootPart.Position - enemy.HumanoidRootPart.Position).Magnitude
                    if dist < nearestDistance then
                        nearestDistance = dist
                        nearestTarget = enemy
                    end
                end
            end

            if nearestTarget then
                _G.CurrentTarget = nearestTarget
                _G.FastAttack = true

                local hrpPos = nearestTarget.HumanoidRootPart.Position
                local farmPos = CFrame.new(hrpPos.X, hrpPos.Y + Settings.FarmHeight, hrpPos.Z)
                PosMon = farmPos.Position

                if (char.HumanoidRootPart.Position - farmPos.Position).Magnitude > 10 then
                    topos(farmPos)
                else
                    char.HumanoidRootPart.CFrame = farmPos
                end

                if _G.SelectWeapon then
                    EquipWeapon(_G.SelectWeapon)
                end

                AttackNoCoolDown()
                patrolPositions = {}
                currentPatrolIndex = 1
            else
                _G.CurrentTarget = nil
                if not materialData.PosM then return end

                if #patrolPositions == 0 then
                    local basePos = materialData.PosM.Position
                    local offset = 100
                    patrolPositions = {
                        CFrame.new(basePos.X + offset, basePos.Y + Settings.FarmHeight, basePos.Z),
                        CFrame.new(basePos.X - offset, basePos.Y + Settings.FarmHeight, basePos.Z),
                        CFrame.new(basePos.X, basePos.Y + Settings.FarmHeight, basePos.Z + offset),
                        CFrame.new(basePos.X, basePos.Y + Settings.FarmHeight, basePos.Z - offset)
                    }
                end

                local currentPos = patrolPositions[currentPatrolIndex]
                if (char.HumanoidRootPart.Position - currentPos.Position).Magnitude < 15 or (tick() - lastPatrolTime) > 3 then
                    currentPatrolIndex += 1
                    if currentPatrolIndex > #patrolPositions then
                        currentPatrolIndex = 1
                    end
                    lastPatrolTime = tick()
                end

                topos(patrolPositions[currentPatrolIndex])
            end
        end)
    end)
end

local function FindCakePrince()
    for _, enemy in pairs(workspace.Enemies:GetChildren()) do
        if enemy.Name == "Cake Prince" and enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 then
            return enemy
        end
    end
    return nil
end

local function GetCakeMobByLevel(level)
    if level >= 2200 and level <= 2224 then
        return {
            Mon = "Cookie Crafter",
            Qdata = 1,
            Qname = "CakeQuest1",
            PosQ = CFrame.new(-2021.32007, 37.7982254, -12028.7295),
            PosM = CFrame.new(-2374.13671875, 37.79826354980469, -12125.30859375)
        }
    elseif level >= 2225 and level <= 2249 then
        return {
            Mon = "Cake Guard",
            Qdata = 2,
            Qname = "CakeQuest1",
            PosQ = CFrame.new(-2021.32007, 37.7982254, -12028.7295),
            PosM = CFrame.new(-1598.3070068359375, 43.773197174072266, -12244.5810546875)
        }
    elseif level >= 2250 and level <= 2274 then
        return {
            Mon = "Baking Staff",
            Qdata = 1,
            Qname = "CakeQuest2",
            PosQ = CFrame.new(-1927.91602, 37.7981339, -12842.5391),
            PosM = CFrame.new(-1887.8099365234375, 77.6185073852539, -12998.3505859375)
        }
    elseif level >= 2275 then
        return {
            Mon = "Head Baker",
            Qdata = 2,
            Qname = "CakeQuest2",
            PosQ = CFrame.new(-1927.91602, 37.7981339, -12842.5391),
            PosM = CFrame.new(-2216.188232421875, 82.884521484875, -12869.2939453125)
        }
    end
    return nil
end

local function CheckCakePrinceStatus()
    local result = ReplicatedStorage.Remotes.CommF_:InvokeServer("CakePrinceSpawner")
    if type(result) == "number" then
        Window:Notify({
            Title = "Cake Prince",
            Body = result .. " of NPCs are missing for the Cake Prince to spawn.",
            Duration = 3
        })
        return false
    else
        return true
    end
end

local function AutoCakePrince()
    if autoCakePrinceConnection then
        autoCakePrinceConnection:Disconnect()
    end
    
    EnableNoClip()
    Settings.BringEnemy = true
    _G.FastAttack = true
    _G.NoClip = true
    
    local patrolPositions = {}
    local currentPatrolIndex = 1
    local lastPatrolTime = tick()
    local savedMobPosition = nil
    local currentMobIndex = 1
    local mobAreas = {
        {
            Mon = "Cookie Crafter",
            Qdata = 1,
            Qname = "CakeQuest1",
            PosQ = CFrame.new(-2021.32007, 37.7982254, -12028.7295),
            PosM = CFrame.new(-2374.13671875, 37.79826354980469, -12125.30859375)
        },
        {
            Mon = "Cake Guard",
            Qdata = 2,
            Qname = "CakeQuest1",
            PosQ = CFrame.new(-2021.32007, 37.7982254, -12028.7295),
            PosM = CFrame.new(-1598.3070068359375, 43.773197174072266, -12244.5810546875)
        },
        {
            Mon = "Baking Staff",
            Qdata = 1,
            Qname = "CakeQuest2",
            PosQ = CFrame.new(-1927.91602, 37.7981339, -12842.5391),
            PosM = CFrame.new(-1887.8099365234375, 77.6185073852539, -12998.3505859375)
        },
        {
            Mon = "Head Baker",
            Qdata = 2,
            Qname = "CakeQuest2",
            PosQ = CFrame.new(-1927.91602, 37.7981339, -12842.5391),
            PosM = CFrame.new(-2216.188232421875, 82.884521484375, -12869.2939453125)
        }
    }
    
    task.spawn(function()
        pcall(function()
            local result = ReplicatedStorage.Remotes.CommF_:InvokeServer("CakePrinceSpawner")
            if type(result) == "number" then
                Window:Notify({
                    Title = "Cake Prince",
                    Body = result .. " of NPCs are missing for the Cake Prince to spawn.",
                    Duration = 3
                })
            end
        end)
    end)
    
    autoCakePrinceConnection = RunService.Heartbeat:Connect(function()
        pcall(function()
            if not Settings.AutoCakePrince then
                if autoCakePrinceConnection then
                    autoCakePrinceConnection:Disconnect()
                    autoCakePrinceConnection = nil
                end
                _G.FastAttack = false
                _G.NoClip = false
                Settings.BringEnemy = false
                DisableNoClip()
                RemoveFlyPlatform()
                return
            end
            
            local char = player.Character
            if not char or not char:FindFirstChild("HumanoidRootPart") then return end
            
            AutoHaki()
            UpdateSelectWeapon()
            CreateFlyPlatform()
            
            if _G.SelectWeapon then
                EquipWeapon(_G.SelectWeapon)
            end
            
            local mirror = workspace.Map:FindFirstChild("CakeLoaf")
            mirror = mirror and mirror:FindFirstChild("BigMirror")
            local other = mirror and mirror:FindFirstChild("Other")
            local portalOpen = other and other.Transparency == 0
            
            local cakePrince = FindCakePrince()
            
            if cakePrince or portalOpen then
                if cakePrince then
                    _G.CurrentTarget = cakePrince
                    local hrpPos = cakePrince.HumanoidRootPart.Position
                    local farmPos = CFrame.new(hrpPos.X, hrpPos.Y + Settings.FarmHeight, hrpPos.Z)
                    PosMon = hrpPos
                    
                    if (char.HumanoidRootPart.Position - farmPos.Position).Magnitude > 10 then
                        topos(farmPos)
                    else
                        char.HumanoidRootPart.CFrame = farmPos
                    end
                    
                    if flyPlatform and flyPlatform.Parent then
                        flyPlatform.CFrame = CFrame.new(char.HumanoidRootPart.Position.X, char.HumanoidRootPart.Position.Y - 3.5, char.HumanoidRootPart.Position.Z)
                    end
                    
                    patrolPositions = {}
                    currentPatrolIndex = 1
                else
                    local portalPos = CFrame.new(-2151.82, 149.32, -12404.91)
                    if (char.HumanoidRootPart.Position - portalPos.Position).Magnitude > 10 then
                        topos(portalPos)
                    end
                end
                return
            end
            
            if tick() - lastCakePrinceRemoteTime >= 1 then
                lastCakePrinceRemoteTime = tick()
                ReplicatedStorage.Remotes.CommF_:InvokeServer("CakePrinceSpawner", true)
            end
            
            local currentArea = mobAreas[currentMobIndex]
            
            if Settings.TakeMissionOnCakePrince and player.Data.Level.Value >= 2200 then
                if not HasQuest() then
                    if (char.HumanoidRootPart.Position - currentArea.PosQ.Position).Magnitude > 10 then
                        topos(currentArea.PosQ)
                    else
                        task.wait(0.5)
                        ReplicatedStorage.Remotes.CommF_:InvokeServer("StartQuest", currentArea.Qname, currentArea.Qdata)
                    end
                    return
                end
            end
            
            local nearestMob = nil
            local nearestDistance = math.huge
            
            for _, enemy in pairs(workspace.Enemies:GetChildren()) do
                if enemy.Name == currentArea.Mon and enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 then
                    local dist = (char.HumanoidRootPart.Position - enemy.HumanoidRootPart.Position).Magnitude
                    if dist < nearestDistance then
                        nearestDistance = dist
                        nearestMob = enemy
                    end
                end
            end
            
            if nearestMob then
                _G.CurrentTarget = nearestMob
                local hrpPos = nearestMob.HumanoidRootPart.Position
                local farmPos = CFrame.new(hrpPos.X, hrpPos.Y + Settings.FarmHeight, hrpPos.Z)
                PosMon = hrpPos
                
                if not savedMobPosition then
                    savedMobPosition = hrpPos
                end
                
                if (char.HumanoidRootPart.Position - farmPos.Position).Magnitude > 10 then
                    topos(farmPos)
                else
                    char.HumanoidRootPart.CFrame = farmPos
                end
                
                if flyPlatform and flyPlatform.Parent then
                    flyPlatform.CFrame = CFrame.new(char.HumanoidRootPart.Position.X, char.HumanoidRootPart.Position.Y - 3.5, char.HumanoidRootPart.Position.Z)
                end
                
                patrolPositions = {}
                currentPatrolIndex = 1
            else
                _G.CurrentTarget = nil
                
                local basePos = savedMobPosition or currentArea.PosM.Position
                PosMon = basePos
                
                if #patrolPositions == 0 then
                    local offset = 100
                    table.insert(patrolPositions, CFrame.new(basePos.X + offset, basePos.Y + Settings.FarmHeight, basePos.Z))
                    table.insert(patrolPositions, CFrame.new(basePos.X - offset, basePos.Y + Settings.FarmHeight, basePos.Z))
                    table.insert(patrolPositions, CFrame.new(basePos.X, basePos.Y + Settings.FarmHeight, basePos.Z + offset))
                    table.insert(patrolPositions, CFrame.new(basePos.X, basePos.Y + Settings.FarmHeight, basePos.Z - offset))
                end
                
                local currentPos = patrolPositions[currentPatrolIndex]
                local dist = (char.HumanoidRootPart.Position - currentPos.Position).Magnitude
                
                if dist < 15 or (tick() - lastPatrolTime) > 3 then
                    currentPatrolIndex += 1
                    if currentPatrolIndex > #patrolPositions then
                        currentMobIndex += 1
                        if currentMobIndex > #mobAreas then
                            currentMobIndex = 1
                        end
                        patrolPositions = {}
                        currentPatrolIndex = 1
                        savedMobPosition = nil
                    end
                    lastPatrolTime = tick()
                end
                
                topos(patrolPositions[currentPatrolIndex])
            end
        end)
    end)
end

local function GetBP(itemName)
    return player.Backpack:FindFirstChild(itemName) or (player.Character and player.Character:FindFirstChild(itemName))
end

local function IsRaidActive()
    for i = 1, 5 do
        if workspace:FindFirstChild("RaidIsland" .. i) then
            return true
        end
    end
    return false
end

local function HasMicrochip()
    local backpackChip = player.Backpack:FindFirstChild("Special Microchip")
    local characterChip = player.Character and player.Character:FindFirstChild("Special Microchip")
    
    if backpackChip or characterChip then
        return true
    end
    
    local inv = ReplicatedStorage.Remotes.CommF_:InvokeServer("getInventory")
    if inv then
        for _, item in pairs(inv) do
            if item.Name == "Special Microchip" then
                return true
            end
        end
    end
    
    return false
end

local function GetStoredFruit()
    local fruits = ReplicatedStorage.Remotes.CommF_:InvokeServer("GetFruits")
    if type(fruits) ~= "table" then return nil end
    
    for _, data in pairs(fruits) do
        local price = tonumber(data.Price) or math.huge
        local rarity = tostring(data.Rarity or ""):lower()
        if price <= 1150000 or rarity == "common" or rarity == "uncommon" or rarity == "rare" then
            return data.Name
        end
    end
    return nil
end

spawn(function()
    while wait() do
        pcall(function()
            if Settings.AutoRaid then
                local isInRaid = player.PlayerGui.Main.TopHUDList.RaidTimer.Visible
                
                if not isInRaid and not raidStarted and not IsRaidActive() then
                    if not HasMicrochip() and (tick() - chipBuyAttemptTime >= 60) then
                        local fruitToLoad = GetStoredFruit()
                        
                        if fruitToLoad then
                            ReplicatedStorage.Remotes.CommF_:InvokeServer("LoadFruit", fruitToLoad)
                            task.wait(0.5)
                            
                            local hrp = getHRP()
                            if hrp then
                                repeat
                                    topos(CFrame.new(-5059.13916, 314.882812, -2951.67334))
                                    task.wait()
                                until (hrp.Position - Vector3.new(-5059.13916, 314.882812, -2951.67334)).Magnitude <= 10 or not Settings.AutoRaid
                            end
                            
                            if Settings.AutoRaid then
                                ReplicatedStorage.Remotes.CommF_:InvokeServer("RaidsNpc", "Select", Settings.SelectedChip)
                                chipBuyAttemptTime = tick()
                                task.wait(1)
                            end
                        end
                    end
                    
                    if HasMicrochip() and Settings.AutoRaid then
                        if World3 then
                            ReplicatedStorage.Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(-5097.93164, 316.447021, -3142.66602))
                            task.wait(1)
                            fireclickdetector(workspace.Map["Boat Castle"].RaidSummon2.Button.Main.ClickDetector)
                            raidStarted = true
                            raidCurrentIslandIndex = 1
                            raidLastMobTime = tick()
                            task.wait(5)
                        end
                    end
                end
                
                if isInRaid or IsRaidActive() then
                    _G.FastAttack = true
                    _G.NoClip = true
                    EnableNoClip()
                    AutoHaki()
                    UpdateSelectWeapon()
                    CreateFlyPlatform()
                    
                    local function GetHighestRaidIsland()
                        local mapFolder = workspace.Map:FindFirstChild("RaidMap")
                        if not mapFolder then return nil end
                        
                        local highestIsland = nil
                        local highestNum = 0
                        
                        for i = 1, 5 do
                            local islandName = "RaidIsland" .. i
                            local island = mapFolder:FindFirstChild(islandName)
                            
                            if island and i > highestNum then
                                highestNum = i
                                highestIsland = island
                            end
                        end
                        
                        if highestIsland then
                            local parts = highestIsland:GetDescendants()
                            local centerPos = Vector3.new(0, 0, 0)
                            local partCount = 0
                            
                            for _, part in pairs(parts) do
                                if part:IsA("BasePart") then
                                    centerPos = centerPos + part.Position
                                    partCount = partCount + 1
                                end
                            end
                            
                            if partCount > 0 then
                                centerPos = centerPos / partCount
                                return {
                                    name = "RaidIsland" .. highestNum,
                                    pos = CFrame.new(centerPos.X, centerPos.Y + 50, centerPos.Z),
                                    num = highestNum,
                                    island = highestIsland
                                }
                            end
                        end
                        
                        return nil
                    end
                    
                    local function CountMobsNearby(position, range)
                        local count = 0
                        for _, mob in pairs(workspace.Enemies:GetChildren()) do
                            if mob:FindFirstChild("HumanoidRootPart") and mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 then
                                local dist = (mob.HumanoidRootPart.Position - position).Magnitude
                                if dist <= range then
                                    count = count + 1
                                end
                            end
                        end
                        return count
                    end
                    
                    local nearestMob = nil
                    local nearestDist = math.huge
                    
                    for _, mob in pairs(workspace.Enemies:GetChildren()) do
                        if mob:FindFirstChild("HumanoidRootPart") and mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 then
                            local dist = (mob.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
                            if dist < nearestDist and dist <= 5000 then
                                nearestDist = dist
                                nearestMob = mob
                            end
                        end
                    end
                    
                    if nearestMob then
                        raidLastMobTime = tick()
                        _G.CurrentTarget = nearestMob
                        
                        if _G.SelectWeapon then
                            EquipWeapon(_G.SelectWeapon)
                        end
                        
                        local hrpPos = nearestMob.HumanoidRootPart.Position
                        PosMon = hrpPos
                        
                        local farmCFrame = CFrame.new(hrpPos.X, hrpPos.Y + Settings.FarmHeight, hrpPos.Z)
                        
                        local hrp = getHRP()
                        if hrp then
                            if (hrp.Position - farmCFrame.Position).Magnitude > 10 then
                                topos(farmCFrame)
                            else
                                hrp.CFrame = farmCFrame
                            end
                            
                            if flyPlatform and flyPlatform.Parent then
                                flyPlatform.CFrame = CFrame.new(hrp.Position.X, hrp.Position.Y - 3.5, hrp.Position.Z)
                            end
                        end
                        
                        AttackNoCoolDown()
                    else
                        _G.CurrentTarget = nil
                        
                        local currentIsland = GetHighestRaidIsland()
                        
                        if currentIsland then
                            local hrp = getHRP()
                            if hrp then
                                local mobCount = CountMobsNearby(currentIsland.pos.Position, 80)
                                
                                if mobCount == 0 and (tick() - raidLastMobTime) >= 5 then
                                    topos(currentIsland.pos)
                                elseif (hrp.Position - currentIsland.pos.Position).Magnitude > 100 then
                                    topos(currentIsland.pos)
                                end
                            end
                        end
                    end
                else
                    RemoveFlyPlatform()
                end
                
                if not isInRaid and not IsRaidActive() and raidStarted then
                    raidStarted = false
                    chipBuyAttemptTime = 0
                    _G.FastAttack = false
                    _G.NoClip = false
                    _G.CurrentTarget = nil
                    raidCurrentIslandIndex = 1
                    raidLastMobTime = tick()
                    DisableNoClip()
                    RemoveFlyPlatform()
                end
            else
                raidStarted = false
                chipBuyAttemptTime = 0
                _G.FastAttack = false
                _G.NoClip = false
                _G.CurrentTarget = nil
                raidCurrentIslandIndex = 1
                RemoveFlyPlatform()
            end
        end)
    end
end)

local function IsIslandRaid(cu)
    local locs = workspace["_WorldOrigin"].Locations
    if locs:FindFirstChild("Island " .. cu) then
        local min = 4500
        
        for _, v in ipairs(locs:GetChildren()) do
            if v.Name == "Island " .. cu then
                local dist = (v.Position - player.Character.HumanoidRootPart.Position).Magnitude
                if dist < min then
                    min = dist
                end
            end
        end
        
        for _, v in ipairs(locs:GetChildren()) do
            if v.Name == "Island " .. cu then
                local dist = (v.Position - player.Character.HumanoidRootPart.Position).Magnitude
                if dist <= min then
                    return v
                end
            end
        end
    end
end

local function getNextIsland()
    local order = {5, 4, 3, 2, 1}
    for _, id in ipairs(order) do
        local island = IsIslandRaid(id)
        if island then
            local dist = (island.Position - player.Character.HumanoidRootPart.Position).Magnitude
            if dist <= 4500 then
                return island
            end
        end
    end
end

local function attackNearbyEnemies()
    for _, mob in pairs(workspace.Enemies:GetChildren()) do
        if mob:FindFirstChild("HumanoidRootPart") and mob:FindFirstChild("Humanoid") then
            if mob.Humanoid.Health > 0 then
                local dist = (mob.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
                if dist <= 1000 then
                    repeat
                        _G.CurrentTarget = mob
                        _G.FastAttack = true
                        if _G.SelectWeapon then
                            EquipWeapon(_G.SelectWeapon)
                        end
                        local hrpPos = mob.HumanoidRootPart.Position
                        topos(CFrame.new(hrpPos.X, hrpPos.Y + Settings.FarmHeight, hrpPos.Z))
                        task.wait()
                    until not Settings.AutoCompleteRaid or not mob.Parent or mob.Humanoid.Health <= 0
                    _G.FastAttack = false
                end
            end
        end
    end
end

spawn(function()
    while wait() do
        pcall(function()
            if Settings.AutoCompleteRaid then
                if player.PlayerGui.Main.TopHUDList.RaidTimer.Visible then
                    UpdateSelectWeapon()
                    attackNearbyEnemies()
                    
                    local nextIsland = getNextIsland()
                    if nextIsland then
                        topos(nextIsland.CFrame * CFrame.new(0, 50, 0))
                    end
                end
            else
                _G.FastAttack = false
            end
        end)
    end
end)

local function AutoChest()
    StopAutoChest()

    EnableNoClip()
    SetPlatform(true)

    visitedChests = {}
    lastChestCount = CountChests()
    chestsCollected = 0
    checkInterval = 0
    isServerHopping = false

    floatConnection = RunService.Heartbeat:Connect(function()
        if Settings.AutoChest then
            pcall(Float)
        end
    end)

    autoChestConnection = RunService.Heartbeat:Connect(function()
        if not Settings.AutoChest or isServerHopping then
            StopAutoChest()
            return
        end

        checkInterval += 1
        if checkInterval >= 30 then
            checkInterval = 0
            local currentCount = CountChests()

            if currentCount < lastChestCount then
                chestsCollected += (lastChestCount - currentCount)
                lastChestCount = currentCount
            end

            if Settings.AutoChestHop then
                if chestsCollected >= Settings.ChestHopAmount or currentCount == 0 then
                    ForceServerHop()
                    return
                end
            end
        end

        pcall(function()
            local char = player.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if not hrp then return end

            local nearest
            local nearestDist = math.huge

            for _, chest in pairs(CollectionService:GetTagged("_ChestTagged")) do
                if chest and chest.Parent and not chest:GetAttribute("IsDisabled") then
                    local id = tostring(chest)
                    if not visitedChests[id] then
                        local pos
                        if chest:IsA("Model") then
                            pos = chest:GetPivot().Position
                        elseif chest:IsA("BasePart") then
                            pos = chest.Position
                        end

                        if pos then
                            local dist = (hrp.Position - pos).Magnitude
                            if dist < nearestDist then
                                nearestDist = dist
                                nearest = {id = id, pos = pos}
                            end
                        end
                    end
                end
            end

            if nearest then
                hrp.Velocity = Vector3.zero
                if nearestDist <= 4 then
                    visitedChests[nearest.id] = true
                else
                    topos(CFrame.new(nearest.pos + Vector3.new(0,5,0)))
                end
            end
        end)
    end)
end

task.spawn(function()
    while task.wait(60) do
        if Settings.AutoChest and Settings.AutoChestHop and not isServerHopping then
            if CountChests() == 0 then
                ForceServerHop()
            end
        end
    end
end)

local function FindDarkbeard()
    for _, enemy in pairs(workspace.Enemies:GetChildren()) do
        if enemy.Name == "Darkbeard" and enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 then
            return enemy
        end
    end
    return nil
end

local function HasFistOfDarkness()
    if player.Backpack:FindFirstChild("Fist of Darkness") or (player.Character and player.Character:FindFirstChild("Fist of Darkness")) then
        return true
    end
    
    local inv = ReplicatedStorage.Remotes.CommF_:InvokeServer("getInventory")
    if inv then
        for _, item in pairs(inv) do
            if item.Name == "Fist of Darkness" then
                return true
            end
        end
    end
    
    return false
end

local function AutoDarkbeard()
    autoDarkbeardActive = true
    EnableNoClip()
    
    task.spawn(function()
        while autoDarkbeardActive do
            local success = pcall(function()
                local darkbeard = FindDarkbeard()
                
                if darkbeard then
                    Window:Notify({
                        Title = "Darkbeard",
                        Body = "Darkbeard found! Attacking...",
                        Duration = 3
                    })
                    
                    local hrp = getHRP()
                    if hrp and (hrp.Position - Vector3.new(3853.7168, 14.6319571, -3443.65771)).Magnitude > 20 then
                        topos(CFrame.new(3853.7168, 14.6319571, -3443.65771, 0.544479251, -1.39625449e-08, 0.838774323, 8.04618683e-09, 1, 1.14232908e-08, -0.838774323, 5.29190247e-10, 0.544479251))
                        task.wait(2)
                    end
                    
                    UpdateSelectWeapon()
                    
                    while autoDarkbeardActive and darkbeard and darkbeard.Parent and darkbeard:FindFirstChild("Humanoid") and darkbeard.Humanoid.Health > 0 do
                        task.wait()
                        
                        _G.CurrentTarget = darkbeard
                        _G.FastAttack = true
                        AutoHaki()
                        
                        if _G.SelectWeapon then
                            EquipWeapon(_G.SelectWeapon)
                        end
                        
                        local hrpPos = darkbeard.HumanoidRootPart.Position
                        local farmPos = CFrame.new(hrpPos.X, hrpPos.Y + Settings.FarmHeight, hrpPos.Z)
                        
                        hrp = getHRP()
                        if hrp then
                            if (hrp.Position - farmPos.Position).Magnitude > 10 then
                                topos(farmPos)
                            else
                                hrp.CFrame = farmPos
                            end
                        end
                    end
                    
                    _G.FastAttack = false
                    _G.CurrentTarget = nil
                    
                    if autoDarkbeardActive then
                        Window:Notify({
                            Title = "Darkbeard Defeated",
                            Body = "Server hopping for next Darkbeard",
                            Duration = 3
                        })
                        
                        task.wait(2)
                        ForceServerHop()
                    end
                    return
                else
                    if HasFistOfDarkness() then
                        Window:Notify({
                            Title = "Darkbeard",
                            Body = "Using Fist of Darkness to spawn boss...",
                            Duration = 3
                        })
                        
                        local hrp = getHRP()
                        if hrp then
                            topos(CFrame.new(3779.83789, 15.873497, -3498.81079, 0.929591, -2.9286424e-08, -0.368592709, -7.28157046e-09, 1, -9.78188268e-08, 0.368592709, 9.36154336e-08, 0.929591))
                            task.wait(2)
                            
                            EquipFistOfDarkness()
                            task.wait(3)
                        end
                    else
                        Window:Notify({
                            Title = "Darkbeard",
                            Body = "Farming chests for Fist of Darkness...",
                            Duration = 3
                        })
                        
                        if not Settings.AutoChest then
                            Settings.AutoChest = true
                            Settings.StopWhenChalice = true
                            AutoChest()
                        end
                        
                        while not HasFistOfDarkness() and autoDarkbeardActive do
                            task.wait(1)
                        end
                        
                        if Settings.AutoChest then
                            Settings.AutoChest = false
                            Settings.StopWhenChalice = false
                            StopAutoChest()
                        end
                    end
                end
            end)
            
            if not success then
                task.wait(2)
            end
            
            task.wait(1)
        end
        
        StopAutoDarkbeard()
    end)
end

local function StopAutoDarkbeard()
    autoDarkbeardActive = false
    _G.FastAttack = false
    _G.CurrentTarget = nil
    
    if Settings.AutoChest then
        Settings.AutoChest = false
        Settings.StopWhenChalice = false
        StopAutoChest()
    end
    
    DisableNoClip()
end

local function EquipFistOfDarkness()
    ReplicatedStorage.Remotes.CommF_:InvokeServer("LoadItem", "Fist of Darkness", {"Gear"})
    task.wait(0.5)
    local fist = player.Backpack:FindFirstChild("Fist of Darkness")
    if fist then
        local humanoid = player.Character and player.Character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid:EquipTool(fist)
            task.wait(0.5)
        end
    end
end

local function StopAutoFarm()
    if autoFarmConnection then
        autoFarmConnection:Disconnect()
        autoFarmConnection = nil
    end
    if floatConnection then
        floatConnection:Disconnect()
        floatConnection = nil
    end
    DisableNoClip()
    SetPlatform(false)
    _G.CurrentTarget = nil
    isInSubmergedZone = false
    isTravelingToSubmerged = false
    Settings.BringEnemy = false
    
    RemoveFlyPlatform()
    
    pcall(function()
        local char = player.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            local hrp = char.HumanoidRootPart
            if hrp:FindFirstChild("Stabilizer") then
                hrp.Stabilizer:Destroy()
            end
        end
    end)
end

local function InitializeActiveToggles()
    task.wait(2)
    
    if Settings.AutoFarm then
        _G.FastAttack = true
        _G.NoClip = true
        FarmLevel()
    end
    
    if Settings.AutoChest then
        AutoChest()
    end
end

task.spawn(InitializeActiveToggles)

local DiscordTab = Window:CreateTab({
    Name = "Discord",
    Icon = {"rbxassetid://99394760607229"}
})

Window:AddInviteDiscord(DiscordTab, {
    Name = "Cat Hub",
    Link = "https://discord.gg/SenZqyaRvr",
    Icon = "rbxassetid://138770682187300",
    ButtonText = "Join"
})

local SettingsTab = Window:CreateTab({
    Name = "Settings Tab",
    Icon = {"rbxassetid://75702206405738"}
})

Window:AddSection(SettingsTab, {
    Name = "Teleport Island"
})

local IslandList = {
    "WindMill", "Marine", "Middle Town", "Jungle", "Pirate Village", "Desert", 
    "Snow Island", "MarineFord", "Colosseum", "Sky Island 1", "Sky Island 2", 
    "Sky Island 3", "Prison", "Magma Village", "Under Water Island", "Fountain City",
    "Shank Room", "Mob Island", "The Cafe", "Frist Spot", "Dark Area", 
    "Flamingo Mansion", "Flamingo Room", "Green Zone", "Factory", "Colossuim",
    "Zombie Island", "Two Snow Mountain", "Punk Hazard", "Cursed Ship", "Ice Castle",
    "Forgotten Island", "Ussop Island", "Mini Sky Island", "Great Tree", 
    "Castle On The Sea", "MiniSky", "Port Town", "Hydra Island", "Floating Turtle",
    "Mansion", "Haunted Castle", "Ice Cream Island", "Peanut Island", "Cake Island",
    "Cocoa Island", "Candy Island", "Tiki Outpost"
}

Settings.SelectedIsland = Settings.SelectedIsland or "WindMill"
Settings.AutoTeleportIsland = false

local function GetIslandPosition(island)
    if island == "WindMill" then
        return CFrame.new(979.79895019531, 16.516613006592, 1429.0466308594)
    elseif island == "Marine" then
        return CFrame.new(-2566.4296875, 6.8556680679321, 2045.2561035156)
    elseif island == "Middle Town" then
        return CFrame.new(-690.33081054688, 15.09425163269, 1582.2380371094)
    elseif island == "Jungle" then
        return CFrame.new(-1612.7957763672, 36.852081298828, 149.12843322754)
    elseif island == "Pirate Village" then
        return CFrame.new(-1181.3093261719, 4.7514905929565, 3803.5456542969)
    elseif island == "Desert" then
        return CFrame.new(944.15789794922, 20.919729232788, 4373.3002929688)
    elseif island == "Snow Island" then
        return CFrame.new(1347.8067626953, 104.66806030273, -1319.7370605469)
    elseif island == "MarineFord" then
        return CFrame.new(-4914.8212890625, 50.963626861572, 4281.0278320313)
    elseif island == "Colosseum" then
        return CFrame.new(-1427.6203613281, 7.2881078720093, -2792.7722167969)
    elseif island == "Sky Island 1" then
        return CFrame.new(-4869.1025390625, 733.46051025391, -2667.0180664063)
    elseif island == "Prison" then
        return CFrame.new(4875.330078125, 5.6519818305969, 734.85021972656)
    elseif island == "Magma Village" then
        return CFrame.new(-5247.7163085938, 12.883934020996, 8504.96875)
    elseif island == "Fountain City" then
        return CFrame.new(5127.1284179688, 59.501365661621, 4105.4458007813)
    elseif island == "Shank Room" then
        return CFrame.new(-1442.16553, 29.8788261, -28.3547478)
    elseif island == "Mob Island" then
        return CFrame.new(-2850.20068, 7.39224768, 5354.99268)
    elseif island == "Frist Spot" then
        return CFrame.new(-11.311455726624, 29.276733398438, 2771.5224609375)
    elseif island == "Dark Area" then
        return CFrame.new(3780.0302734375, 22.652164459229, -3498.5859375)
    elseif island == "Green Zone" then
        return CFrame.new(-2448.5300292969, 73.016105651855, -3210.6306152344)
    elseif island == "Factory" then
        return CFrame.new(424.12698364258, 211.16171264648, -427.54049682617)
    elseif island == "Colossuim" then
        return CFrame.new(-1503.6224365234, 219.7956237793, 1369.3101806641)
    elseif island == "Zombie Island" then
        return CFrame.new(-5622.033203125, 492.19604492188, -781.78552246094)
    elseif island == "Two Snow Mountain" then
        return CFrame.new(753.14288330078, 408.23559570313, -5274.6147460938)
    elseif island == "Punk Hazard" then
        return CFrame.new(-6127.654296875, 15.951762199402, -5040.2861328125)
    elseif island == "Ice Castle" then
        return CFrame.new(6148.4116210938, 294.38687133789, -6741.1166992188)
    elseif island == "Forgotten Island" then
        return CFrame.new(-3032.7641601563, 317.89672851563, -10075.373046875)
    elseif island == "Ussop Island" then
        return CFrame.new(4816.8618164063, 8.4599885940552, 2863.8195800781)
    elseif island == "Mini Sky Island" then
        return CFrame.new(-288.74060058594, 49326.31640625, -35248.59375)
    elseif island == "Great Tree" then
        return CFrame.new(2681.2736816406, 1682.8092041016, -7190.9853515625)
    elseif island == "MiniSky" then
        return CFrame.new(-260.65557861328, 49325.8046875, -35253.5703125)
    elseif island == "Port Town" then
        return CFrame.new(-290.7376708984375, 6.729952812194824, 5343.5537109375)
    elseif island == "Floating Turtle" then
        return CFrame.new(-13274.528320313, 531.82073974609, -7579.22265625)
    elseif island == "Haunted Castle" then
        return CFrame.new(-9515.3720703125, 164.00624084473, 5786.0610351562)
    elseif island == "Ice Cream Island" then
        return CFrame.new(-902.56817626953, 79.93204498291, -10988.84765625)
    elseif island == "Peanut Island" then
        return CFrame.new(-2062.7475585938, 50.473892211914, -10232.568359375)
    elseif island == "Cake Island" then
        return CFrame.new(-1884.7747802734375, 19.327526092529297, -11666.8974609375)
    elseif island == "Cocoa Island" then
        return CFrame.new(87.94276428222656, 73.55451202392578, -12319.46484375)
    elseif island == "Candy Island" then
        return CFrame.new(-1014.4241943359375, 149.11068725585938, -14555.962890625)
    elseif island == "Hydra Island" then
        return CFrame.new(5632.45312, 1013.02594, -181.175201, -0.575584888, -6.23996925e-08, -0.81774205, -5.95003513e-08, 1, -3.4426737e-08, 0.81774205, 2.88404287e-08, -0.575584888)
    elseif island == "Castle On The Sea" then
        return CFrame.new(-5010.95508, 314.497437, -3006.16357, -0.498317689, 1.85795095e-08, 0.8669945, -6.02422068e-09, 1, -2.4892298e-08, -0.8669945, -1.76272383e-08, -0.498317689)
    elseif island == "Mansion" then
        return CFrame.new(-12550.4775, 332.35965, -7602.93848, 0.998581827, 2.42359786e-08, 0.0532384589, -2.58890651e-08, 1, 3.03609404e-08, -0.0532384589, -3.16961781e-08, 0.998581827)
    elseif island == "Tiki Outpost" then
        return CFrame.new(-16542.447265625, 55.68632888793945, 1044.41650390625)
    end
    return nil
end

local function TeleportToIsland(island)
    local pos = GetIslandPosition(island)
    
    if island == "Sky Island 2" then
        pcall(function()
            ReplicatedStorage.Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(-4607.82275, 872.54248, -1667.55688))
        end)
        task.wait(0.3)
        topos(CFrame.new(-4607.82275, 872.54248, -1667.55688))
    elseif island == "Sky Island 3" then
        pcall(function()
            ReplicatedStorage.Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(-7894.6176757813, 5547.1416015625, -380.29119873047))
        end)
        task.wait(0.3)
        topos(CFrame.new(-7894.6176757813, 5547.1416015625, -380.29119873047))
    elseif island == "Under Water Island" then
        pcall(function()
            ReplicatedStorage.Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(61163.8515625, 11.6796875, 1819.7841796875))
        end)
        task.wait(0.3)
        topos(CFrame.new(61163.8515625, 11.6796875, 1819.7841796875))
    elseif island == "The Cafe" then
        pcall(function()
            ReplicatedStorage.Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(-281.93707275390625, 306.130615234375, 609.280029296875))
        end)
        task.wait(0.3)
        topos(CFrame.new(-380.47927856445, 77.220390319824, 255.82550048828))
    elseif island == "Flamingo Mansion" then
        pcall(function()
            ReplicatedStorage.Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(-281.93707275390625, 306.130615234375, 609.280029296875))
        end)
        task.wait(0.3)
        topos(CFrame.new(-281.93707275390625, 306.130615234375, 609.280029296875))
    elseif island == "Flamingo Room" then
        pcall(function()
            ReplicatedStorage.Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(2284.912109375, 15.152034759521484, 905.48291015625))
        end)
        task.wait(0.3)
        topos(CFrame.new(2284.912109375, 15.152034759521484, 905.48291015625))
    elseif island == "Cursed Ship" then
        pcall(function()
            ReplicatedStorage.Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(923.40197753906, 125.05712890625, 32885.875))
        end)
        task.wait(0.3)
        topos(CFrame.new(923.40197753906, 125.05712890625, 32885.875))
    elseif pos then
        topos(pos)
    end
end

local autoTeleportConnection

Window:AddDropdown(SettingsTab, {
    Name = "Select Island",
    Options = IslandList,
    Default = Settings.SelectedIsland,
    Callback = function(value)
        Settings.SelectedIsland = value
        SaveConfig()
        
        if Settings.AutoTeleportIsland then
            if currentTween then
                currentTween:Cancel()
            end
            
            task.wait(0.2)
            
            TeleportToIsland(value)
            
            Window:Notify({
                Title = "Island Changed",
                Body = "Teleporting to: " .. value,
                Duration = 2
            })
        end
    end
})

Window:AddToggle(SettingsTab, {
    Name = "Teleport to Island",
    Callback = function(value)
        Settings.AutoTeleportIsland = value
        SaveConfig()
        
        if value then
            EnableNoClip()
            
            if autoTeleportConnection then
                autoTeleportConnection:Disconnect()
            end
            
            autoTeleportConnection = RunService.Heartbeat:Connect(function()
                pcall(function()
                    if not Settings.AutoTeleportIsland then
                        if autoTeleportConnection then
                            autoTeleportConnection:Disconnect()
                            autoTeleportConnection = nil
                        end
                        DisableNoClip()
                        return
                    end
                    
                    local hrp = getHRP()
                    if not hrp then return end
                    
                    local targetPos = GetIslandPosition(Settings.SelectedIsland)
                    if targetPos and (hrp.Position - targetPos.Position).Magnitude > 20 then
                        TeleportToIsland(Settings.SelectedIsland)
                    end
                end)
            end)
            
            Window:Notify({
                Title = "Auto Teleport",
                Body = "Teleporting to: " .. Settings.SelectedIsland,
                Duration = 2
            })
        else
            if currentTween then
                currentTween:Cancel()
            end
            DisableNoClip()
            if autoTeleportConnection then
                autoTeleportConnection:Disconnect()
                autoTeleportConnection = nil
            end
            
            if currentTween then
                currentTween:Cancel()
            end
            
            DisableNoClip()
        end
    end
})

Window:AddSection(SettingsTab, {
    Name = "Teleport Seas"
})

Window:AddButton(SettingsTab, {
    Name = "Sea 1",
    Callback = function()
        ReplicatedStorage.Remotes.CommF_:InvokeServer("TravelMain")
        Window:Notify({
            Title = "Teleporting",
            Body = "Traveling to Sea 1",
            Duration = 2
        })
    end
})

Window:AddButton(SettingsTab, {
    Name = "Sea 2",
    Callback = function()
        ReplicatedStorage.Remotes.CommF_:InvokeServer("TravelDressrosa")
        Window:Notify({
            Title = "Teleporting",
            Body = "Traveling to Sea 2",
            Duration = 2
        })
    end
})

Window:AddButton(SettingsTab, {
    Name = "Sea 3",
    Callback = function()
        ReplicatedStorage.Remotes.CommF_:InvokeServer("TravelZou")
        Window:Notify({
            Title = "Teleporting",
            Body = "Traveling to Sea 3",
            Duration = 2
        })
    end
})

Window:AddSection(SettingsTab, {
    Name = "Codes"
})

local AllCodes = {
    "NOMOREHACK",
    "BANEXPLOIT",
    "WildDares",
    "BossBuild",
    "GetPranked",
    "EARN_FRUITS",
    "FIGHT4FRUIT",
    "NOEXPLOITER",
    "NOOB2ADMIN",
    "CODESLIDE",
    "ADMINHACKED",
    "ADMINDARES",
    "fruitconcepts",
    "krazydares",
    "TRIPLEABUSE",
    "SEATROLLING",
    "24NOADMIN",
    "REWARDFUN",
    "Chandler",
    "NEWTROLL",
    "KITT_RESET",
    "Sub2CaptainMaui",
    "kittgaming",
    "Sub2Fer999",
    "Enyu_is_Pro",
    "Magicbus",
    "JCWK",
    "Starcodeheo",
    "Bluxxy",
    "fudd10_v2",
    "SUB2GAMERROBOT_EXP1",
    "Sub2NoobMaster123",
    "Sub2UncleKizaru",
    "Sub2Daigrock",
    "Axiore",
    "TantaiGaming",
    "StrawHatMaine",
    "Sub2OfficialNoobie",
    "Fudd10",
    "Bignews",
    "TheGreatAce",
    "SECRET_ADMIN",
    "SUB2GAMERROBOT_RESET1",
    "SUB2OFFICIALNOOBIE",
    "AXIORE",
    "BIGNEWS",
    "BLUXXY",
    "CHANDLER",
    "ENYU_IS_PRO",
    "FUDD10",
    "FUDD10_V2",
    "KITTGAMING",
    "MAGICBUS",
    "STARCODEHEO",
    "STRAWHATMAINE",
    "SUB2CAPTAINMAUI",
    "SUB2DAIGROCK",
    "SUB2FER999",
    "SUB2NOOBMASTER123",
    "SUB2UNCLEKIZARU",
    "TANTAIGAMING",
    "THEGREATACE"
}

Window:AddButton(SettingsTab, {
    Name = "Redeem All Codes",
    Callback = function()
        local codesRedeemed = 0
        local codesFailed = 0
        
        for _, code in ipairs(AllCodes) do
            pcall(function()
                local result = ReplicatedStorage.Remotes.Redeem:InvokeServer(code)
                if result then
                    codesRedeemed = codesRedeemed + 1
                else
                    codesFailed = codesFailed + 1
                end
            end)
            task.wait(0.1)
        end
        
        Window:Notify({
            Title = "Codes Redeemed",
            Body = "Successfully redeemed " .. codesRedeemed .. " codes. " .. codesFailed .. " codes failed or already used.",
            Duration = 5
        })
    end
})

Window:AddToggle(SettingsTab, {
    Name = "No Clip",
    Default = false,
    Callback = function(value)
        _G.NoClip = value
        Settings.NoClipEnabled = value
        SaveConfig()
        
        if value then
            EnableNoClip()
            Window:Notify({
                Title = "No Clip",
                Body = "No Clip enabled",
                Duration = 2
            })
        else
            DisableNoClip()
            Window:Notify({
                Title = "No Clip",
                Body = "No Clip disabled",
                Duration = 2
            })
        end
    end
})

Window:AddSection(SettingsTab, {
    Name = "Auto Stats"
})

Window:AddToggle(SettingsTab, {
    Name = "Auto Melee",
    Default = false,
    Callback = function(value)
        _G.Auto_Stats_Melee = value
        Settings.AutoMelee = value
        SaveConfig()
    end
})

Window:AddToggle(SettingsTab, {
    Name = "Auto Defense",
    Default = false,
    Callback = function(value)
        _G.Auto_Stats_Defense = value
        Settings.AutoDefense = value
        SaveConfig()
    end
})

Window:AddToggle(SettingsTab, {
    Name = "Auto Sword",
    Default = false,
    Callback = function(value)
        _G.Auto_Stats_Sword = value
        Settings.AutoSword = value
        SaveConfig()
    end
})

Window:AddToggle(SettingsTab, {
    Name = "Auto Gun",
    Default = false,
    Callback = function(value)
        _G.Auto_Stats_Gun = value
        Settings.AutoGun = value
        SaveConfig()
    end
})

Window:AddToggle(SettingsTab, {
    Name = "Auto Fruit",
    Default = false,
    Callback = function(value)
        _G.Auto_Stats_Devil_Fruit = value
        Settings.AutoFruit = value
        SaveConfig()
    end
})

spawn(function()
    while true do
        if _G.Auto_Stats_Devil_Fruit and player.Data.Points.Value > 0 then
            local points = math.min(player.Data.Points.Value, 1)
            ReplicatedStorage.Remotes.CommF_:InvokeServer("AddPoint", "Demon Fruit", points)
        end
        task.wait(0.1)
    end
end)

spawn(function()
    while true do
        if _G.Auto_Stats_Gun and player.Data.Points.Value > 0 then
            local points = math.min(player.Data.Points.Value, 1)
            ReplicatedStorage.Remotes.CommF_:InvokeServer("AddPoint", "Gun", points)
        end
        task.wait(0.1)
    end
end)

spawn(function()
    while true do
        if _G.Auto_Stats_Sword and player.Data.Points.Value > 0 then
            local points = math.min(player.Data.Points.Value, 1)
            ReplicatedStorage.Remotes.CommF_:InvokeServer("AddPoint", "Sword", points)
        end
        task.wait(0.1)
    end
end)

spawn(function()
    while true do
        if _G.Auto_Stats_Defense and player.Data.Points.Value > 0 then
            local points = math.min(player.Data.Points.Value, 1)
            ReplicatedStorage.Remotes.CommF_:InvokeServer("AddPoint", "Defense", points)
        end
        task.wait(0.1)
    end
end)

spawn(function()
    while true do
        if _G.Auto_Stats_Melee and player.Data.Points.Value > 0 then
            local points = math.min(player.Data.Points.Value, 1)
            ReplicatedStorage.Remotes.CommF_:InvokeServer("AddPoint", "Melee", points)
        end
        task.wait(0.1)
    end
end)

Window:AddSection(SettingsTab, {
    Name = "Farm Settings"
})

Window:AddSlider(SettingsTab, {
    Name = "Farm Height",
    Min = 5,
    Max = 50,
    Default = 15,
    Callback = function(value)
        Settings.FarmHeight = value
        SaveConfig()
    end
})

Window:AddSlider(SettingsTab, {
    Name = "Fly Speed",
    Min = 100,
    Max = 500,
    Default = 300,
    Callback = function(value)
        Settings.FlySpeed = value
        SaveConfig()
    end
})

Window:AddSlider(SettingsTab, {
    Name = "Bring Mob Range",
    Min = 100,
    Max = 500,
    Default = 320,
    Callback = function(value)
        _G.BringRange = value
        SaveConfig()
    end
})

local FarmingTab = Window:CreateTab({
    Name = "Tab Farming",
    Icon = {"rbxassetid://107147540309708"}
})

Window:AddSection(FarmingTab, {
    Name = "Auto Farm"
})

Window:AddDropdown(FarmingTab, {
    Name = "Weapon Type",
    Options = {"Melee", "Sword", "Gun", "Fruit"},
    Default = "Melee",
    Callback = function(option)
        Settings.WeaponType = option
        UpdateSelectWeapon()
        SaveConfig()
    end
})

Window:AddDropdown(FarmingTab, {
    Name = "Select Method",
    Options = {"Farm Level", "Farm Bone", "Farm Aura"},
    Default = Settings.FarmMethod or "Farm Level",
    Callback = function(value)
        Settings.FarmMethod = value
        SaveConfig()
        
        if Settings.AutoFarmMethod then
            StopAutoFarm()
            task.wait(0.3)
            
            _G.FastAttack = true
            _G.NoClip = true
            
            if value == "Farm Level" then
                Settings.AutoFarm = true
                SaveConfig()
                FarmLevel()
                Window:Notify({
                    Title = "Method Changed",
                    Body = "Now farming: Level",
                    Duration = 2
                })
            elseif value == "Farm Bone" then
                Settings.AutoFarm = false
                SaveConfig()
                FarmBone()
                Window:Notify({
                    Title = "Method Changed",
                    Body = "Now farming: Bone",
                    Duration = 2
                })
            elseif value == "Farm Aura" then
                Settings.AutoFarm = false
                SaveConfig()
                FarmAura()
                Window:Notify({
                    Title = "Method Changed",
                    Body = "Now farming: Aura (Nearby Mobs)",
                    Duration = 2
                })
            end
        else
            Window:Notify({
                Title = "Method Selected",
                Body = "Selected: " .. value,
                Duration = 2
            })
        end
    end
})

Window:AddToggle(FarmingTab, {
    Name = "Farm Selected Method",
    Callback = function(value)
        Settings.AutoFarmMethod = value
        SaveConfig()
        
        if value then
            EnableNoClip()
            _G.FastAttack = true
            _G.NoClip = true
            
            if Settings.FarmMethod == "Farm Level" or not Settings.FarmMethod then
                Settings.AutoFarm = true
                SaveConfig()
                FarmLevel()
            elseif Settings.FarmMethod == "Farm Bone" then
                Settings.AutoFarm = false
                SaveConfig()
                FarmBone()
            elseif Settings.FarmMethod == "Farm Aura" then
                Settings.AutoFarm = false
                SaveConfig()
                FarmAura()
            end
        else
            if currentTween then
                currentTween:Cancel()
            end
            DisableNoClip()
            Settings.AutoFarm = false
            _G.FastAttack = false
            _G.NoClip = false
            SaveConfig()
        end
    end
})

Window:AddToggle(FarmingTab, {
    Name = "Accept Quest For Bone Method",
    Callback = function(value)
        Settings.AcceptQuestForBone = value
        SaveConfig()
    end
})

Window:AddSection(FarmingTab, {
    Name = "Farm Material"
})

Window:AddDropdown(FarmingTab, {
    Name = "Select Material",
    Options = MaterialsList,
    Default = Settings.SelectMaterial,
    Callback = function(value)
        Settings.SelectMaterial = value
        SaveConfig()
    end
})

Window:AddToggle(FarmingTab, {
    Name = "Auto Farm Material",
    Callback = function(value)
        Settings.AutoFarmMaterial = value
        SaveConfig()
        if value then
            EnableNoClip()
            FarmMaterial()
        else
            if currentTween then
                currentTween:Cancel()
            end
            DisableNoClip()
            StopAutoFarm()
        end
    end
})

Window:AddToggle(FarmingTab, {
    Name = "Accept Quest For Material Farm",
    Callback = function(value)
        Settings.AcceptQuestForMaterial = value
        SaveConfig()
    end
})

Window:AddSection(FarmingTab, { Name = "Auto Chest" })

Window:AddToggle(FarmingTab, {
    Name = "Auto Collect Chest",
    Callback = function(v)
        Settings.AutoChest = v
        if v then
            AutoChest()
        else
            StopAutoChest()
        end
        SaveConfig()
    end
})

Window:AddToggle(FarmingTab, {
    Name = "Auto Chest Hop",
    Callback = function(v)
        Settings.AutoChestHop = v
        SaveConfig()
    end
})

Window:AddToggle(FarmingTab, {
    Name = "Stop when got God's Chalice or Fist of Darkness",
    Callback = function(value)
        Settings.StopWhenChalice = value
        SaveConfig()
    end
})

Window:AddSlider(FarmingTab, {
    Name = "Chest Hop Amount",
    Min = 1,
    Max = 20,
    Default = 5,
    Callback = function(v)
        Settings.ChestHopAmount = v
        SaveConfig()
    end
})

Window:AddSection(FarmingTab, {
    Name = "Auto Darkbeard"
})

Window:AddToggle(FarmingTab, {
    Name = "Auto Darkbeard",
    Callback = function(value)
        if value then
            EnableNoClip()
            AutoDarkbeard()
        else
            if currentTween then
                currentTween:Cancel()
            end
            DisableNoClip()
            StopAutoDarkbeard()
        end
    end
})

Window:AddSection(FarmingTab, {
    Name = "Cake Prince"
})

task.spawn(function()
    while task.wait(1) do
        if Settings.AutoCakePrince then
            pcall(function()
                local response = game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CakePrinceSpawner")
                if type(response) == "string" then
                    local kills = response:match("(%d+)")
                    if kills then
                        Window:Notify({
                            Title = "Cake Prince",
                            Body = "Kill : " .. kills,
                            Duration = 1
                        })
                    else
                        Window:Notify({
                            Title = "Cake Prince",
                            Body = "READY",
                            Duration = 1
                        })
                    end
                else
                    Window:Notify({
                        Title = "Cake Prince",
                        Body = "READY",
                        Duration = 1
                    })
                end
            end)
        end
    end
end)

Window:AddToggle(FarmingTab, {
    Name = "Auto Cake Prince",
    Callback = function(value)
        Settings.AutoCakePrince = value
        SaveConfig()
        if value then
            EnableNoClip()
            AutoCakePrince()
        else
            if currentTween then
                currentTween:Cancel()
            end
            _G.FastAttack = false
            Settings.BringEnemy = false
            DisableNoClip()
            RemoveFlyPlatform()
            if autoCakePrinceConnection then
                autoCakePrinceConnection:Disconnect()
                autoCakePrinceConnection = nil
            end
            _G.FastAttack = false
            _G.NoClip = false
            Settings.BringEnemy = false
            DisableNoClip()
            RemoveFlyPlatform()
        end
    end
})

Window:AddToggle(FarmingTab, {
    Name = "Take Mission On Farm Cake Prince",
    Callback = function(value)
        Settings.TakeMissionOnCakePrince = value
        SaveConfig()
    end
})

Window:AddSection(FarmingTab, {
    Name = "Boss Farm"
})

Window:AddMultiDropdown(FarmingTab, {
    Name = "Select Boss",
    Options = GetAllBossesInCurrentWorld(),
    Default = Settings.SelectedBosses,
    Callback = function(selected)
        Settings.SelectedBosses = selected
        SaveConfig()
    end
})

Window:AddToggle(FarmingTab, {
    Name = "Farm Bosses Selected Hop",
    Callback = function(value)
        Settings.FarmBossesSelectedHop = value
        SaveConfig()
        if value then
            EnableNoClip()
            Settings.KillSelectedBoss = false
            Settings.KillAllBoss = false
            Settings.FarmAllBossesHop = false
            if bossFarmConnection then
                bossFarmConnection:Disconnect()
                bossFarmConnection = nil
            end
            FarmSelectedBossesHop()
        else
            if currentTween then
                currentTween:Cancel()
            end
            if bossFarmConnection then
                bossFarmConnection:Disconnect()
                bossFarmConnection = nil
            end
            _G.FastAttack = false
            _G.CurrentTarget = nil
            DisableNoClip()
            RemoveFlyPlatform()
        end
    end
})

Window:AddToggle(FarmingTab, {
    Name = "Kill Selected Boss",
    Callback = function(value)
        Settings.KillSelectedBoss = value
        SaveConfig()
        if value then
            EnableNoClip()
            Settings.KillAllBoss = false
            Settings.FarmBossesSelectedHop = false
            Settings.FarmAllBossesHop = false
            if bossFarmConnection then
                bossFarmConnection:Disconnect()
                bossFarmConnection = nil
            end
            FarmSelectedBosses()
        else
            if currentTween then
                currentTween:Cancel()
            end
            _G.FastAttack = false
            _G.CurrentTarget = nil
            DisableNoClip()
            RemoveFlyPlatform()
            if bossFarmConnection then
                bossFarmConnection:Disconnect()
                bossFarmConnection = nil
            end
            _G.FastAttack = false
            _G.CurrentTarget = nil
            DisableNoClip()
            RemoveFlyPlatform()
        end
    end
})

Window:AddToggle(FarmingTab, {
    Name = "Get Quest Bosses",
    Callback = function(value)
        Settings.GetQuestBosses = value
        SaveConfig()
    end
})

Window:AddSection(FarmingTab, {
    Name = "Fishing"
})

Window:AddButton(FarmingTab, {
    Name = "Set Position",
    Callback = function()
        local hrp = getHRP()
        if hrp then
            FishingSettings.CustomPosition = hrp.CFrame
            Window:Notify({
                Title = "Position Set",
                Body = "Custom fishing position saved",
                Duration = 2
            })
        end
    end
})

Window:AddButton(FarmingTab, {
    Name = "Return Default Position",
    Callback = function()
        FishingSettings.CustomPosition = nil
        Window:Notify({
            Title = "Position Reset",
            Body = "Using default fishing position",
            Duration = 2
        })
    end
})

Window:AddToggle(FarmingTab, {
    Name = "Auto Fish",
    Callback = function(value)
        FishingSettings.AutoFish = value
        if value then
            EnableNoClip()
            AutoFish()
        end
    end
})

Window:AddToggle(FarmingTab, {
    Name = "Auto Sell Fish",
    Callback = function(value)
        FishingSettings.AutoSellFish = value
        if value then
            EnableNoClip()
            AutoSellFish()
        end
    end
})

Window:AddToggle(FarmingTab, {
    Name = "Auto Buy Bait",
    Callback = function(value)
        FishingSettings.AutoBuyBait = value
        if value then
            EnableNoClip()
            AutoBuyBait()
        end
    end
})

local ItemsQuestTab = Window:CreateTab({
    Name = "Itens/Quest Tab",
    Icon = {"rbxassetid://97535254376308"}
})

Window:AddSection(ItemsQuestTab, {
    Name = "Auto Next Sea"
})

Window:AddToggle(ItemsQuestTab, {
    Name = "Auto Sea 2",
    Callback = function(value)
        Settings.TravelDress = value
        SaveConfig()
        if value then
            EnableNoClip()
            task.spawn(function()
                while Settings.TravelDress do
                    pcall(function()
                        if player.Data.Level.Value >= 700 then
                            UpdateSelectWeapon()
                            if workspace.Map.Ice.Door.CanCollide == true and workspace.Map.Ice.Door.Transparency == 0 then
                                ReplicatedStorage.Remotes.CommF_:InvokeServer("DressrosaQuestProgress", "Detective")
                                EquipWeapon("Key")
                                repeat
                                    task.wait()
                                    topos(CFrame.new(1347.7124, 37.3751602, -1325.6488))
                                until not Settings.TravelDress or (getHRP().Position - Vector3.new(1347.7124, 37.3751602, -1325.6488)).Magnitude < 5
                            elseif workspace.Map.Ice.Door.CanCollide == false and workspace.Map.Ice.Door.Transparency == 1 then
                                local iceAdmiral = nil
                                for _, enemy in pairs(workspace.Enemies:GetChildren()) do
                                    if enemy.Name == "Ice Admiral" and enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 then
                                        iceAdmiral = enemy
                                        break
                                    end
                                end
                                if iceAdmiral then
                                    repeat
                                        task.wait()
                                        _G.CurrentTarget = iceAdmiral
                                        _G.FastAttack = true
                                        if _G.SelectWeapon then
                                            EquipWeapon(_G.SelectWeapon)
                                        end
                                        local hrpPos = iceAdmiral.HumanoidRootPart.Position
                                        PosMon = hrpPos
                                        topos(CFrame.new(hrpPos.X, hrpPos.Y + Settings.FarmHeight, hrpPos.Z))
                                    until not Settings.TravelDress or not iceAdmiral.Parent or iceAdmiral.Humanoid.Health <= 0
                                    _G.FastAttack = false
                                    ReplicatedStorage.Remotes.CommF_:InvokeServer("TravelDressrosa")
                                else
                                    if currentTween then
                                        currentTween:Cancel()
                                    end
                                    _G.FastAttack = false
                                    _G.CurrentTarget = nil
                                    DisableNoClip()
                                    topos(CFrame.new(1347.7124, 37.3751602, -1325.6488))
                                end
                            else
                                if currentTween then
                                    currentTween:Cancel()
                                end
                                _G.FastAttack = false
                                _G.CurrentTarget = nil
                                DisableNoClip()
                                ReplicatedStorage.Remotes.CommF_:InvokeServer("TravelDressrosa")
                            end
                        end
                    end)
                    task.wait(1)
                end
            end)
        end
    end
})

Window:AddToggle(ItemsQuestTab, {
    Name = "Auto Sea 3",
    Callback = function(value)
        Settings.AutoZou = value
        SaveConfig()
        if value then
            EnableNoClip()
            task.spawn(function()
                while Settings.AutoZou do
                    pcall(function()
                        if player.Data.Level.Value >= 1500 then
                            UpdateSelectWeapon()
                            if ReplicatedStorage.Remotes.CommF_:InvokeServer("BartiloQuestProgress", "Bartilo") == 3 then
                                if ReplicatedStorage.Remotes.CommF_:InvokeServer("GetUnlockables").FlamingoAccess ~= nil then
                                    ReplicatedStorage.Remotes.CommF_:InvokeServer("TravelZou")
                                    if ReplicatedStorage.Remotes.CommF_:InvokeServer("ZQuestProgress", "Check") == 0 then
                                        local ripIndra = nil
                                        for _, enemy in pairs(workspace.Enemies:GetChildren()) do
                                            if enemy.Name == "rip_indra" and enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 then
                                                ripIndra = enemy
                                                break
                                            end
                                        end
                                        if ripIndra then
                                            repeat
                                                task.wait()
                                                _G.CurrentTarget = ripIndra
                                                _G.FastAttack = true
                                                if _G.SelectWeapon then
                                                    EquipWeapon(_G.SelectWeapon)
                                                end
                                                local hrpPos = ripIndra.HumanoidRootPart.Position
                                                PosMon = hrpPos
                                                topos(CFrame.new(hrpPos.X, hrpPos.Y + Settings.FarmHeight, hrpPos.Z))
                                            until not Settings.AutoZou or not ripIndra.Parent or ripIndra.Humanoid.Health <= 0
                                            _G.FastAttack = false
                                            repeat
                                                task.wait()
                                                ReplicatedStorage.Remotes.CommF_:InvokeServer("TravelZou")
                                            until ReplicatedStorage.Remotes.CommF_:InvokeServer("ZQuestProgress", "Check") == 1
                                        else
                                            if currentTween then
                                                currentTween:Cancel()
                                            end
                                            _G.FastAttack = false
                                            _G.CurrentTarget = nil
                                            DisableNoClip()
                                            ReplicatedStorage.Remotes.CommF_:InvokeServer("ZQuestProgress", "Check")
                                            task.wait(0.1)
                                            ReplicatedStorage.Remotes.CommF_:InvokeServer("ZQuestProgress", "Begin")
                                        end
                                    elseif ReplicatedStorage.Remotes.CommF_:InvokeServer("ZQuestProgress", "Check") == 1 then
                                        ReplicatedStorage.Remotes.CommF_:InvokeServer("TravelZou")
                                    else
                                        if currentTween then
                                            currentTween:Cancel()
                                        end
                                        _G.FastAttack = false
                                        _G.CurrentTarget = nil
                                        DisableNoClip()
                                        local donSwan = nil
                                        for _, enemy in pairs(workspace.Enemies:GetChildren()) do
                                            if enemy.Name == "Don Swan" and enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 then
                                                donSwan = enemy
                                                break
                                            end
                                        end
                                        if donSwan then
                                            repeat
                                                task.wait()
                                                _G.CurrentTarget = donSwan
                                                _G.FastAttack = true
                                                if _G.SelectWeapon then
                                                    EquipWeapon(_G.SelectWeapon)
                                                end
                                                local hrpPos = donSwan.HumanoidRootPart.Position
                                                PosMon = hrpPos
                                                topos(CFrame.new(hrpPos.X, hrpPos.Y + Settings.FarmHeight, hrpPos.Z))
                                            until not Settings.AutoZou or not donSwan.Parent or donSwan.Humanoid.Health <= 0
                                            _G.FastAttack = false
                                        else
                                            if currentTween then
                                                currentTween:Cancel()
                                            end
                                            _G.FastAttack = false
                                            _G.CurrentTarget = nil
                                            DisableNoClip()
                                            repeat
                                                task.wait()
                                                topos(CFrame.new(2288.802, 15.1870775, 863.034607))
                                            until not Settings.AutoZou or (getHRP().Position - Vector3.new(2288.802, 15.1870775, 863.034607)).Magnitude < 5
                                        end
                                    end
                                else
                                    if currentTween then
                                        currentTween:Cancel()
                                    end
                                    _G.FastAttack = false
                                    _G.CurrentTarget = nil
                                    DisableNoClip()
                                    local fruitPrice = {}
                                    local fruitStore = {}
                                    for _, fruit in pairs(ReplicatedStorage.Remotes.CommF_:InvokeServer("GetFruits")) do
                                        if fruit.Price >= 1000000 then
                                            table.insert(fruitPrice, fruit.Name)
                                        end
                                    end
                                    for _, fruit in pairs(ReplicatedStorage.Remotes.CommF_:InvokeServer("getInventoryFruits")) do
                                        for k, v in pairs(fruit) do
                                            if k == "Name" then
                                                table.insert(fruitStore, v)
                                            end
                                        end
                                    end
                                    for _, priceFruit in pairs(fruitPrice) do
                                        for _, storeFruit in pairs(fruitStore) do
                                            if priceFruit == storeFruit and ReplicatedStorage.Remotes.CommF_:InvokeServer("GetUnlockables").FlamingoAccess == nil then
                                                if not player.Backpack:FindFirstChild(storeFruit) then
                                                    ReplicatedStorage.Remotes.CommF_:InvokeServer("LoadFruit", storeFruit)
                                                else
                                                    if currentTween then
                                                        currentTween:Cancel()
                                                    end
                                                    _G.FastAttack = false
                                                    _G.CurrentTarget = nil
                                                    DisableNoClip()
                                                    ReplicatedStorage.Remotes.CommF_:InvokeServer("TalkTrevor", "1")
                                                    ReplicatedStorage.Remotes.CommF_:InvokeServer("TalkTrevor", "2")
                                                    ReplicatedStorage.Remotes.CommF_:InvokeServer("TalkTrevor", "3")
                                                end
                                            end
                                        end
                                    end
                                    ReplicatedStorage.Remotes.CommF_:InvokeServer("TalkTrevor", "1")
                                    ReplicatedStorage.Remotes.CommF_:InvokeServer("TalkTrevor", "2")
                                    ReplicatedStorage.Remotes.CommF_:InvokeServer("TalkTrevor", "3")
                                end
                            else
                                if currentTween then
                                    currentTween:Cancel()
                                end
                                _G.FastAttack = false
                                _G.CurrentTarget = nil
                                DisableNoClip()
                                if ReplicatedStorage.Remotes.CommF_:InvokeServer("BartiloQuestProgress", "Bartilo") == 0 then
                                    if string.find(player.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, "Swan Pirates") and string.find(player.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, "50") and player.PlayerGui.Main.Quest.Visible == true then
                                        local swanPirate = nil
                                        for _, enemy in pairs(workspace.Enemies:GetChildren()) do
                                            if enemy.Name == "Swan Pirate" and enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 then
                                                swanPirate = enemy
                                                break
                                            end
                                        end
                                        if swanPirate then
                                            repeat
                                                task.wait()
                                                _G.CurrentTarget = swanPirate
                                                _G.FastAttack = true
                                                if _G.SelectWeapon then
                                                    EquipWeapon(_G.SelectWeapon)
                                                end
                                                local hrpPos = swanPirate.HumanoidRootPart.Position
                                                PosMon = hrpPos
                                                topos(CFrame.new(hrpPos.X, hrpPos.Y + Settings.FarmHeight, hrpPos.Z))
                                            until not Settings.AutoZou or not swanPirate.Parent or swanPirate.Humanoid.Health <= 0 or player.PlayerGui.Main.Quest.Visible == false
                                            _G.FastAttack = false
                                        else
                                            if currentTween then
                                                currentTween:Cancel()
                                            end
                                            _G.FastAttack = false
                                            _G.CurrentTarget = nil
                                            DisableNoClip()
                                            topos(CFrame.new(1057.92761, 137.614319, 1242.08069))
                                        end
                                    else
                                        if currentTween then
                                            currentTween:Cancel()
                                        end
                                        _G.FastAttack = false
                                        _G.CurrentTarget = nil
                                        DisableNoClip()
                                        topos(CFrame.new(-456.28952, 73.0200958, 299.895966))
                                        if (getHRP().Position - Vector3.new(-456.28952, 73.0200958, 299.895966)).Magnitude <= 30 then
                                            task.wait(1.5)
                                            ReplicatedStorage.Remotes.CommF_:InvokeServer("StartQuest", "BartiloQuest", 1)
                                        end
                                    end
                                elseif ReplicatedStorage.Remotes.CommF_:InvokeServer("BartiloQuestProgress", "Bartilo") == 1 then
                                    local jeremy = nil
                                    for _, enemy in pairs(workspace.Enemies:GetChildren()) do
                                        if enemy.Name == "Jeremy" and enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 then
                                            jeremy = enemy
                                            break
                                        end
                                    end
                                    if jeremy then
                                        repeat
                                            task.wait()
                                            _G.CurrentTarget = jeremy
                                            _G.FastAttack = true
                                            if _G.SelectWeapon then
                                                EquipWeapon(_G.SelectWeapon)
                                            end
                                            local hrpPos = jeremy.HumanoidRootPart.Position
                                            PosMon = hrpPos
                                            topos(CFrame.new(hrpPos.X, hrpPos.Y + Settings.FarmHeight, hrpPos.Z))
                                        until not Settings.AutoZou or not jeremy.Parent or jeremy.Humanoid.Health <= 0
                                        _G.FastAttack = false
                                    else
                                        if currentTween then
                                            currentTween:Cancel()
                                        end
                                        _G.FastAttack = false
                                        _G.CurrentTarget = nil
                                        DisableNoClip()
                                        topos(CFrame.new(2099.88159, 448.931, 648.997375))
                                    end
                                elseif ReplicatedStorage.Remotes.CommF_:InvokeServer("BartiloQuestProgress", "Bartilo") == 2 then
                                    repeat
                                        task.wait()
                                        topos(CFrame.new(-1836, 11, 1714))
                                    until not Settings.AutoZou or (getHRP().Position - Vector3.new(-1836, 11, 1714)).Magnitude < 5
                                    task.wait(0.5)
                                    getHRP().CFrame = workspace.Map.Dressrosa.BartiloPlates.Plate1.CFrame
                                    task.wait(0.5)
                                    getHRP().CFrame = workspace.Map.Dressrosa.BartiloPlates.Plate2.CFrame
                                    task.wait(0.5)
                                    getHRP().CFrame = workspace.Map.Dressrosa.BartiloPlates.Plate3.CFrame
                                    task.wait(0.5)
                                    getHRP().CFrame = workspace.Map.Dressrosa.BartiloPlates.Plate4.CFrame
                                    task.wait(0.5)
                                    getHRP().CFrame = workspace.Map.Dressrosa.BartiloPlates.Plate5.CFrame
                                    task.wait(0.5)
                                    getHRP().CFrame = workspace.Map.Dressrosa.BartiloPlates.Plate6.CFrame
                                    task.wait(0.5)
                                    getHRP().CFrame = workspace.Map.Dressrosa.BartiloPlates.Plate7.CFrame
                                    task.wait(0.5)
                                    getHRP().CFrame = workspace.Map.Dressrosa.BartiloPlates.Plate8.CFrame
                                    task.wait(2.5)
                                end
                            end
                        end
                    end)
                    task.wait(1)
                end
            end)
        end
    end
})

Window:AddSection(ItemsQuestTab, {
    Name = "Others"
})

Window:AddToggle(ItemsQuestTab, {
    Name = "Auto Farm Factory",
    Callback = function(value)
        Settings.AutoFactory = value
        SaveConfig()
        if value then
            EnableNoClip()
            task.spawn(function()
                while Settings.AutoFactory do
                    pcall(function()
                        UpdateSelectWeapon()
                        local core = nil
                        for _, enemy in pairs(workspace.Enemies:GetChildren()) do
                            if enemy.Name == "Core" and enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 then
                                core = enemy
                                break
                            end
                        end
                        if core then
                            repeat
                                task.wait()
                                _G.CurrentTarget = core
                                _G.FastAttack = true
                                if _G.SelectWeapon then
                                    EquipWeapon(_G.SelectWeapon)
                                end
                                PosMon = CFrame.new(448.46756, 199.356781, -441.389252).Position
                                topos(CFrame.new(448.46756, 199.356781, -441.389252))
                            until not Settings.AutoFactory or not core.Parent or core.Humanoid.Health <= 0
                            _G.FastAttack = false
                        else
                            if currentTween then
                                currentTween:Cancel()
                            end
                            _G.FastAttack = false
                            _G.CurrentTarget = nil
                            DisableNoClip()
                            topos(CFrame.new(448.46756, 199.356781, -441.389252))
                        end
                    end)
                    task.wait(1)
                end
            end)
        end
    end
})

Window:AddToggle(ItemsQuestTab, {
    Name = "Auto Farm Raid Castle",
    Callback = function(value)
        Settings.AutoRaidCastle = value
        SaveConfig()
        if value then
            EnableNoClip()
            task.spawn(function()
                while Settings.AutoRaidCastle do
                    pcall(function()
                        UpdateSelectWeapon()
                        if (getHRP().Position - Vector3.new(-5539.3115234375, 313.80053710938, -2972.3723144531)).Magnitude <= 500 then
                            for _, enemy in pairs(workspace.Enemies:GetChildren()) do
                                if enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 then
                                    if (enemy.HumanoidRootPart.Position - getHRP().Position).Magnitude <= 2000 then
                                        repeat
                                            task.wait()
                                            _G.CurrentTarget = enemy
                                            _G.FastAttack = true
                                            if _G.SelectWeapon then
                                                EquipWeapon(_G.SelectWeapon)
                                            end
                                            local hrpPos = enemy.HumanoidRootPart.Position
                                            PosMon = hrpPos
                                            topos(CFrame.new(hrpPos.X, hrpPos.Y + Settings.FarmHeight, hrpPos.Z))
                                        until not Settings.AutoRaidCastle or not enemy.Parent or enemy.Humanoid.Health <= 0
                                        _G.FastAttack = false
                                    end
                                end
                            end
                        else
                            if currentTween then
                                currentTween:Cancel()
                            end
                            _G.FastAttack = false
                            _G.CurrentTarget = nil
                            DisableNoClip()
                            topos(CFrame.new(-5496.17432, 313.768921, -2841.53027))
                        end
                    end)
                    task.wait(1)
                end
            end)
        end
    end
})

Window:AddSection(ItemsQuestTab, {
    Name = "Quest"
})

Window:AddToggle(ItemsQuestTab, {
    Name = "Auto Bartilo Quest",
    Callback = function(value)
        Settings.BartiloQuest = value
        if value then
            EnableNoClip()
            Settings.BringEnemy = true
        end
        SaveConfig()
        if value then
            EnableNoClip()
            task.spawn(function()
                while Settings.BartiloQuest do
                    pcall(function()
                        if player.Data.Level.Value >= 850 then
                            UpdateSelectWeapon()
                            if ReplicatedStorage.Remotes.CommF_:InvokeServer("BartiloQuestProgress", "Bartilo") == 0 then
                                if player.PlayerGui.Main.Quest.Visible == true then
                                    local swanPirate = nil
                                    for _, enemy in pairs(workspace.Enemies:GetChildren()) do
                                        if enemy.Name == "Swan Pirate" and enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 then
                                            swanPirate = enemy
                                            break
                                        end
                                    end
                                    if swanPirate then
                                        repeat
                                            task.wait(0.1)
                                            if not string.find(player.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, "Swan Pirate") then
                                                ReplicatedStorage.Remotes.CommF_:InvokeServer("AbandonQuest")
                                            else
                                                if currentTween then
                                                    currentTween:Cancel()
                                                end
                                                _G.FastAttack = false
                                                _G.CurrentTarget = nil
                                                Settings.BringEnemy = false
                                                DisableNoClip()
                                                _G.CurrentTarget = swanPirate
                                                _G.FastAttack = true
                                                if _G.SelectWeapon then
                                                    EquipWeapon(_G.SelectWeapon)
                                                end
                                                local hrpPos = swanPirate.HumanoidRootPart.Position
                                                PosMon = hrpPos
                                                topos(CFrame.new(hrpPos.X, hrpPos.Y + Settings.FarmHeight, hrpPos.Z))
                                            end
                                        until not Settings.BartiloQuest or not swanPirate.Parent or swanPirate.Humanoid.Health <= 0 or player.PlayerGui.Main.Quest.Visible == false or ReplicatedStorage.Remotes.CommF_:InvokeServer("BartiloQuestProgress", "Bartilo") ~= 0
                                        _G.FastAttack = false
                                    else
                                        if currentTween then
                                            currentTween:Cancel()
                                        end
                                        _G.FastAttack = false
                                        _G.CurrentTarget = nil
                                        Settings.BringEnemy = false
                                        DisableNoClip()
                                        topos(CFrame.new(970.369446, 142.653198, 1217.3667))
                                    end
                                else
                                    if currentTween then
                                        currentTween:Cancel()
                                    end
                                    _G.FastAttack = false
                                    _G.CurrentTarget = nil
                                    Settings.BringEnemy = false
                                    DisableNoClip()
                                    repeat
                                        task.wait()
                                        topos(CFrame.new(-461.533203, 72.3478546, 300.311096))
                                    until (getHRP().Position - Vector3.new(-461.533203, 72.3478546, 300.311096)).Magnitude <= 20 or not Settings.BartiloQuest
                                    if (getHRP().Position - Vector3.new(-461.533203, 72.3478546, 300.311096)).Magnitude <= 20 then
                                        ReplicatedStorage.Remotes.CommF_:InvokeServer("StartQuest", "BartiloQuest", 1)
                                    end
                                end
                            elseif ReplicatedStorage.Remotes.CommF_:InvokeServer("BartiloQuestProgress", "Bartilo") == 1 then
                                local jeremy = nil
                                for _, enemy in pairs(workspace.Enemies:GetChildren()) do
                                    if enemy.Name == "Jeremy" and enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 then
                                        jeremy = enemy
                                        break
                                    end
                                end
                                if jeremy then
                                    repeat
                                        task.wait(0.1)
                                        _G.CurrentTarget = jeremy
                                        _G.FastAttack = true
                                        if _G.SelectWeapon then
                                            EquipWeapon(_G.SelectWeapon)
                                        end
                                        local hrpPos = jeremy.HumanoidRootPart.Position
                                        PosMon = hrpPos
                                        topos(CFrame.new(hrpPos.X, hrpPos.Y + Settings.FarmHeight, hrpPos.Z))
                                    until not Settings.BartiloQuest or not jeremy.Parent or jeremy.Humanoid.Health <= 0 or ReplicatedStorage.Remotes.CommF_:InvokeServer("BartiloQuestProgress", "Bartilo") ~= 1
                                    _G.FastAttack = false
                                else
                                    if currentTween then
                                        currentTween:Cancel()
                                    end
                                    _G.FastAttack = false
                                    _G.CurrentTarget = nil
                                    Settings.BringEnemy = false
                                    DisableNoClip()
                                    topos(CFrame.new(2158.97412, 449.056244, 705.411682))
                                end
                            elseif ReplicatedStorage.Remotes.CommF_:InvokeServer("BartiloQuestProgress", "Bartilo") == 2 then
                                repeat
                                    task.wait()
                                    topos(CFrame.new(-1830.83972, 10.5578213, 1680.60229))
                                until (getHRP().Position - Vector3.new(-1830.83972, 10.5578213, 1680.60229)).Magnitude <= 10 or not Settings.BartiloQuest
                                task.wait(0.5)
                                getHRP().CFrame = workspace.Map.Dressrosa.BartiloPlates.Plate1.CFrame
                                task.wait(0.5)
                                getHRP().CFrame = workspace.Map.Dressrosa.BartiloPlates.Plate2.CFrame
                                task.wait(0.5)
                                getHRP().CFrame = workspace.Map.Dressrosa.BartiloPlates.Plate3.CFrame
                                task.wait(0.5)
                                getHRP().CFrame = workspace.Map.Dressrosa.BartiloPlates.Plate4.CFrame
                                task.wait(0.5)
                                getHRP().CFrame = workspace.Map.Dressrosa.BartiloPlates.Plate5.CFrame
                                task.wait(0.5)
                                getHRP().CFrame = workspace.Map.Dressrosa.BartiloPlates.Plate6.CFrame
                                task.wait(0.5)
                                getHRP().CFrame = workspace.Map.Dressrosa.BartiloPlates.Plate7.CFrame
                                task.wait(0.5)
                                getHRP().CFrame = workspace.Map.Dressrosa.BartiloPlates.Plate8.CFrame
                                task.wait(2.5)
                            end
                        end
                    end)
                    task.wait(0.1)
                end
                if not Settings.AutoFarm and not Settings.AutoFarmMethod and not Settings.CitizenQuest then
                    Settings.BringEnemy = false
                end
            end)
        else
            if currentTween then
                currentTween:Cancel()
            end
            _G.FastAttack = false
            _G.CurrentTarget = nil
            DisableNoClip()
            if not Settings.AutoFarm and not Settings.AutoFarmMethod and not Settings.CitizenQuest then
                Settings.BringEnemy = false
            end
        end
    end
})

Window:AddToggle(ItemsQuestTab, {
    Name = "Auto Citizen Quest",
    Callback = function(value)
        Settings.CitizenQuest = value
        if value then
            EnableNoClip()
            Settings.BringEnemy = true
        end
        SaveConfig()
        if value then
            EnableNoClip()
            task.spawn(function()
                while Settings.CitizenQuest do
                    pcall(function()
                        if player.Data.Level.Value >= 1800 then
                            UpdateSelectWeapon()
                            local questProgress = ReplicatedStorage.Remotes.CommF_:InvokeServer("CitizenQuestProgress")
                            if questProgress.KilledBandits == false then
                                if string.find(player.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, "Forest Pirate") and string.find(player.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, "50") and player.PlayerGui.Main.Quest.Visible == true then
                                    local forestPirate = nil
                                    for _, enemy in pairs(workspace.Enemies:GetChildren()) do
                                        if enemy.Name == "Forest Pirate" and enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 then
                                            forestPirate = enemy
                                            break
                                        end
                                    end
                                    if forestPirate then
                                        repeat
                                            task.wait(0.1)
                                            _G.CurrentTarget = forestPirate
                                            _G.FastAttack = true
                                            if _G.SelectWeapon then
                                                EquipWeapon(_G.SelectWeapon)
                                            end
                                            local hrpPos = forestPirate.HumanoidRootPart.Position
                                            PosMon = hrpPos
                                            topos(CFrame.new(hrpPos.X, hrpPos.Y + Settings.FarmHeight, hrpPos.Z))
                                        until not Settings.CitizenQuest or not forestPirate.Parent or forestPirate.Humanoid.Health <= 0 or player.PlayerGui.Main.Quest.Visible == false or ReplicatedStorage.Remotes.CommF_:InvokeServer("CitizenQuestProgress").KilledBandits == true
                                        _G.FastAttack = false
                                    else
                                        if currentTween then
                                            currentTween:Cancel()
                                        end
                                        _G.FastAttack = false
                                        _G.CurrentTarget = nil
                                        Settings.BringEnemy = false
                                        DisableNoClip()
                                        topos(CFrame.new(-13206.452148438, 425.89199829102, -7964.5537109375))
                                    end
                                else
                                    if currentTween then
                                        currentTween:Cancel()
                                    end
                                    _G.FastAttack = false
                                    _G.CurrentTarget = nil
                                    Settings.BringEnemy = false
                                    DisableNoClip()
                                    topos(CFrame.new(-12443.8671875, 332.40396118164, -7675.4892578125))
                                    if (getHRP().Position - Vector3.new(-12443.8671875, 332.40396118164, -7675.4892578125)).Magnitude <= 30 then
                                        task.wait(1.5)
                                        ReplicatedStorage.Remotes.CommF_:InvokeServer("StartQuest", "CitizenQuest", 1)
                                    end
                                end
                            elseif questProgress.KilledBoss == false then
                                local captainElephant = nil
                                for _, enemy in pairs(workspace.Enemies:GetChildren()) do
                                    if enemy.Name == "Captain Elephant" and enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 then
                                        captainElephant = enemy
                                        break
                                    end
                                end
                                if player.PlayerGui.Main.Quest.Visible and string.find(player.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, "Captain Elephant") then
                                    if captainElephant then
                                        repeat
                                            task.wait(0.1)
                                            _G.CurrentTarget = captainElephant
                                            _G.FastAttack = true
                                            if _G.SelectWeapon then
                                                EquipWeapon(_G.SelectWeapon)
                                            end
                                            local hrpPos = captainElephant.HumanoidRootPart.Position
                                            PosMon = hrpPos
                                            topos(CFrame.new(hrpPos.X, hrpPos.Y + Settings.FarmHeight, hrpPos.Z))
                                        until not Settings.CitizenQuest or not captainElephant.Parent or captainElephant.Humanoid.Health <= 0 or player.PlayerGui.Main.Quest.Visible == false or ReplicatedStorage.Remotes.CommF_:InvokeServer("CitizenQuestProgress").KilledBoss == true
                                        _G.FastAttack = false
                                    else
                                        if currentTween then
                                            currentTween:Cancel()
                                        end
                                        _G.FastAttack = false
                                        _G.CurrentTarget = nil
                                        Settings.BringEnemy = false
                                        DisableNoClip()
                                        topos(CFrame.new(-13374.889648438, 421.27752685547, -8225.208984375))
                                    end
                                else
                                    if currentTween then
                                        currentTween:Cancel()
                                    end
                                    _G.FastAttack = false
                                    _G.CurrentTarget = nil
                                    Settings.BringEnemy = false
                                    DisableNoClip()
                                    topos(CFrame.new(-12443.8671875, 332.40396118164, -7675.4892578125))
                                    if (getHRP().Position - Vector3.new(-12443.8671875, 332.40396118164, -7675.4892578125)).Magnitude <= 10 then
                                        task.wait(1.5)
                                        ReplicatedStorage.Remotes.CommF_:InvokeServer("CitizenQuestProgress", "Citizen")
                                    end
                                end
                            elseif ReplicatedStorage.Remotes.CommF_:InvokeServer("CitizenQuestProgress", "Citizen") == 2 then
                                topos(CFrame.new(-12512.138671875, 340.39279174805, -9872.8203125))
                            end
                        end
                    end)
                    task.wait(0.1)
                end
                if not Settings.AutoFarm and not Settings.AutoFarmMethod and not Settings.BartiloQuest then
                    Settings.BringEnemy = false
                end
            end)
        else
            if currentTween then
                currentTween:Cancel()
            end
            _G.FastAttack = false
            _G.CurrentTarget = nil
            DisableNoClip()
            if not Settings.AutoFarm and not Settings.AutoFarmMethod and not Settings.BartiloQuest then
                Settings.BringEnemy = false
            end
        end
    end
})

local FruitRaidTab = Window:CreateTab({
    Name = "Fruit & Raid",
    Icon = {"rbxassetid://127191713652891"}
})

Window:AddSection(FruitRaidTab, {
    Name = "Fruit"
})

Window:AddToggle(FruitRaidTab, {
    Name = "Auto Random Fruit",
    Callback = function(value)
        Settings.AutoRandomFruit = value
        SaveConfig()
    end
})

spawn(function()
    while wait(0.1) do
        pcall(function()
            if Settings.AutoRandomFruit then
                ReplicatedStorage.Remotes.CommF_:InvokeServer("Cousin", "Buy")
            end
        end)
    end
end)

Window:AddToggle(FruitRaidTab, {
    Name = "Auto Store Fruit",
    Callback = function(value)
        Settings.AutoStoreFruit = value
        SaveConfig()
    end
})

spawn(function()
    while wait(1) do
        if Settings.AutoStoreFruit then
            pcall(function()
                UpdateStoreFruit()
            end)
        end
    end
end)

Window:AddToggle(FruitRaidTab, {
    Name = "Auto Collect Fruit",
    Callback = function(value)
        Settings.AutoCollectFruit = value
        SaveConfig()
    end
})

spawn(function()
    while wait(0.1) do
        if Settings.AutoCollectFruit then
            pcall(function()
                for _, item in pairs(workspace:GetChildren()) do
                    if string.find(item.Name, "Fruit") and item:FindFirstChild("Handle") then
                        topos(item.Handle.CFrame)
                    end
                end
            end)
        end
    end
end)

Window:AddSection(FruitRaidTab, {
    Name = "Auto Raid"
})

Window:AddDropdown(FruitRaidTab, {
    Name = "Select Chip",
    Options = ChipsList,
    Default = Settings.SelectedChip,
    Callback = function(value)
        Settings.SelectedChip = value
        SaveConfig()
    end
})

Window:AddToggle(FruitRaidTab, {
    Name = "Auto Raid",
    Callback = function(value)
        Settings.AutoRaid = value
        SaveConfig()
    end
})

local ShopTab = Window:CreateTab({
    Name = "Shop Tab",
    Icon = {"rbxassetid://78513040135508"}
})

Window:AddSection(ShopTab, {
    Name = "Fighting Styles"
})

local FightingStyleData = {
    ["Black Leg"] = {
        World = 1,
        PlaceIds = {2753915549, 85211729168715},
        Position = CFrame.new(-990.922729, 13.7915573, 3988.41089),
        BuyCommand = "BuyBlackLeg"
    },
    ["Electro"] = {
        World = 3,
        PlaceIds = {7449423635, 100117331123089},
        Position = CFrame.new(-4982.47168, 314.555542, -3209.17261),
        BuyCommand = "BuyElectro"
    },
    ["Fishman Karate"] = {
        World = 1,
        PlaceIds = {2753915549, 85211729168715},
        Position = CFrame.new(61576.6133, 18.9105434, 987.176331),
        BuyCommand = "BuyFishmanKarate"
    },
    ["Dragon Claw"] = {
        World = 3,
        PlaceIds = {7449423635, 100117331123089},
        Position = CFrame.new(-4982.47168, 314.555542, -3209.17261),
        BuyCommand = {"BlackbeardReward", "DragonClaw", "1"}
    },
    ["Superhuman"] = {
        World = 3,
        PlaceIds = {7449423635, 100117331123089},
        Position = CFrame.new(-4982.47168, 314.555542, -3209.17261),
        BuyCommand = "BuySuperhuman"
    },
    ["Death Step"] = {
        World = 3,
        PlaceIds = {7449423635, 100117331123089},
        Position = CFrame.new(-4982.47168, 314.555542, -3209.17261),
        BuyCommand = "BuyDeathStep"
    },
    ["Sharkman Karate"] = {
        World = 2,
        PlaceIds = {4442272183, 79091703265657},
        Position = CFrame.new(-2606.92505, 239.445969, -10318.3018),
        BuyCommand = "BuySharkmanKarate"
    },
    ["Electric Claw"] = {
        World = 3,
        PlaceIds = {7449423635, 100117331123089},
        Position = CFrame.new(-10366.0703, 331.693695, -10121.3584),
        BuyCommand = "BuyElectricClaw"
    },
    ["Dragon Talon"] = {
        World = 3,
        PlaceIds = {7449423635, 100117331123089},
        Position = CFrame.new(5662.28857, 1206.85913, 870.284912),
        BuyCommand = "BuyDragonTalon"
    },
    ["Godhuman"] = {
        World = 3,
        PlaceIds = {7449423635, 100117331123089},
        Position = CFrame.new(-13781.1611, 334.662018, -9875.79004),
        BuyCommand = "BuyGodhuman"
    },
    ["Sanguine Art"] = {
        World = 3,
        PlaceIds = {7449423635, 100117331123089},
        Position = CFrame.new(-16516.3359, 23.1574669, -196.572144),
        BuyCommand = "BuySanguineArt"
    }
}

local StylesList = {}
for styleName, _ in pairs(FightingStyleData) do
    table.insert(StylesList, styleName)
end
table.sort(StylesList)

Settings.SelectedFightingStyle = Settings.SelectedFightingStyle or StylesList[1]

local function IsInCorrectWorld(worldNum)
    if worldNum == 1 then
        return game.PlaceId == 2753915549 or game.PlaceId == 85211729168715
    elseif worldNum == 2 then
        return game.PlaceId == 4442272183 or game.PlaceId == 79091703265657
    elseif worldNum == 3 then
        return game.PlaceId == 7449423635 or game.PlaceId == 100117331123089
    end
    return false
end

local function TravelToWorld(worldNum)
    if worldNum == 2 then
        ReplicatedStorage.Remotes.CommF_:InvokeServer("TravelDressrosa")
    elseif worldNum == 3 then
        ReplicatedStorage.Remotes.CommF_:InvokeServer("TravelZou")
    end
end

local function BuyFightingStyle(styleName, styleData)
    task.spawn(function()
        while Settings.AutoBuyStyle and Settings.SelectedFightingStyle == styleName do
            pcall(function()
                if not IsInCorrectWorld(styleData.World) then
                    Window:Notify({
                        Title = "Teleporting",
                        Body = "Traveling to World " .. styleData.World .. " to buy " .. styleName,
                        Duration = 3
                    })
                    TravelToWorld(styleData.World)
                    task.wait(10)
                    return
                end

                local hrp = getHRP()
                if hrp and (hrp.Position - styleData.Position.Position).Magnitude > 10 then
                    topos(styleData.Position)
                    task.wait(0.5)
                end

                if type(styleData.BuyCommand) == "table" then
                    ReplicatedStorage.Remotes.CommF_:InvokeServer(unpack(styleData.BuyCommand))
                    task.wait(0.5)
                    ReplicatedStorage.Remotes.CommF_:InvokeServer("BlackbeardReward", "DragonClaw", "2")
                elseif styleName == "Electric Claw" then
                    ReplicatedStorage.Remotes.CommF_:InvokeServer(styleData.BuyCommand, "Start")
                    task.wait(0.5)
                    ReplicatedStorage.Remotes.CommF_:InvokeServer(styleData.BuyCommand)
                else
                    ReplicatedStorage.Remotes.CommF_:InvokeServer(styleData.BuyCommand)
                end
            end)
            task.wait(2)
        end
    end)
end

Window:AddDropdown(ShopTab, {
    Name = "Select Style",
    Options = StylesList,
    Default = Settings.SelectedFightingStyle,
    Callback = function(value)
        Settings.SelectedFightingStyle = value
        SaveConfig()
        Window:Notify({
            Title = "Style Selected",
            Body = "Selected: " .. value,
            Duration = 2
        })
    end
})

Window:AddToggle(ShopTab, {
    Name = "Buy Style",
    Callback = function(value)
        Settings.AutoBuyStyle = value
        SaveConfig()
        if value then
            EnableNoClip()
            local selectedStyle = Settings.SelectedFightingStyle
            local styleData = FightingStyleData[selectedStyle]
            if styleData then
                Window:Notify({
                    Title = "Auto Buy Started",
                    Body = "Buying " .. selectedStyle,
                    Duration = 3
                })
                BuyFightingStyle(selectedStyle, styleData)
            end
        end
    end
})

Window:Notify({
    Title = "Script Loaded",
    Body = "Cat Hub loaded successfully!",
    Icon = {"rbxassetid://92677765459164"},
    Duration = 5
})