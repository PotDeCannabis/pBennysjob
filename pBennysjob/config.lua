local second = 1000
local minute = 60 * second

EarlyRespawnTimer          = 8 * minute -- Temps avant respawn (En étant Coma)

Config = {

    Garage = { 
    	{buttoname = "Tow Truck", rightlabel = "→", spawnname = "towtruck", spawnzone = vector3(-180.28, -1315.35, 31.29), headingspawn = 0.21},

    },

    Fournisseur = {
        {Nom = "Kit de Réparation", Item = "kitreparation"},
        {Nom = "Kit de Nettoyage", Item = "kitnettoyage"},
    },

    Position = {
    	    Boss = {vector3(-207.08, -1341.67, 34.89)},
    	    Coffre = {vector3(-215.75, -1318.99, 30.89)},
            Fournisseur = {vector3(-227.46, -1327.85, 30.89)},
            Vestaire = {vector3(-205.93, -1327.19, 30.89)}, 
            Garage = {vector3(-180.28, -1315.35, 31.29)},
            Blips = {x = -205.49, y = -1307.44, z = 31.25},
        }
    }

    Vestiaire = {
    	clothes = {
            grades = {
                [0] = {
                    label = "Tenue Personnel",
                    minimum_grade = 0,
                    variations = {male = {}, female = {}},
                    onEquip = function()
                        ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin) TriggerEvent('skinchanger:loadSkin', skin) end)
                        SetPedArmour(PlayerPedId(), 0)
                    end
                },
                [1] = {
                    label = "Tenue Mécaniciens",
                    minimum_grade = 0,
                    variations = {
                    male = {
                        bags_1 = 0, bags_2 = 0,
                        tshirt_1 = 129, tshirt_2 = 0,
                        torso_1 = 73, torso_2 = 6,
                        arms = 86,
                        pants_1 = 33, pants_2 = 0,
                        shoes_1 = 25, shoes_2 = 0,
                        mask_1 = 0, mask_2 = 0,
                        bproof_1 = 14, bproof_2 = 0,
                        helmet_1 = -1, helmet_2 = 0,
                        chain_1 = 0, chain_2 = 0,
                        decals_1 = 0, decals_2 = 0,
                    },
                    female = {
                        bags_1 = 0, bags_2 = 0,
                        tshirt_1 = 129, tshirt_2 = 0,
                        torso_1 = 79, torso_2 = 6,
                        arms = 86,
                        pants_1 = 33, pants_2 = 0,
                        shoes_1 = 25, shoes_2 = 0,
                        mask_1 = 0, mask_2 = 0,
                        bproof_1 = 14, bproof_2 = 0,
                        helmet_1 = -1, helmet_2 = 0,
                        chain_1 = 0, chain_2 = 0,
                        decals_1 = 0, decals_2 = 0
                    }
                },
                onEquip = function()
                end
            }
        }
    }
}
