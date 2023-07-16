Config = Config or {}

Config = {
    health = 10, -- Vie au début
    water = 10, -- Eau au début
    interval = 0.3, -- Intervale en minute
    props = { -- En fonction de la vie de la plante
        [1] = {name = "bkr_prop_weed_01_small_01a", hash = 1027382312}, -- < 40
        [2] = {name = "bkr_prop_weed_med_01b", hash = 870605061}, -- >= 40 et < 70
        [3] = {name = "bkr_prop_weed_lrg_01b", hash = 716763602}-- >= 70
    },
    gain = {
        addBottle = 10, -- Quantité d'eau ajouter lorsque vous arrosez la plante
        -- Nombre de weed récolter
        recolteMin = 1,
        recolteMax = 3,
        -- Nombre de graine récolter
        recolteGraineMin = 1,
        recolteGraineMax = 3,
        -- Chance de récupérer le pot
        recoltePotMin = 1,
        recoltePotMax = 2
    },
    update = {
        removeWater = 5, -- Perte d'eau à chaque interval
        removeHealth_1 = 50, -- Si l'eau = 0
        removeHealth_2 = 20, -- Si l'eau > 0 et <= 25
        removeHealth_3 = 10, -- Si l'eau > 25 et < 50
        addHealth = 10 -- Si l'eau >= 50 et < 100
    }
}