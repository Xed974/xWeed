local function refreshPlants()
    cachePlant = json.decode(LoadResourceFile("xWeed", "plants.json"))
end

ESX.RegisterServerCallback("xWeed:getPlants", function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)

    if (not xPlayer) then return end
    if #cachePlant == 0 then
        refreshPlants()
        Wait(1000)
        if #cachePlant > 0 then
            for _,v in pairs(cachePlant) do
                local props = CreateObject(v.model, v.pos.x, v.pos.y, v.pos.z, true, false, true)
                v.id = props
                FreezeEntityPosition(props, true)
            end
            SaveResourceFile("xWeed", "plants.json", json.encode(cachePlant, {indent = true}), -1)
            TriggerClientEvent("core:refreshPlants", -1, cachePlant)
            cb(cachePlant)
        end
    else
        cb(cachePlant)
    end
end)

local function getExistPlant(id)
    if #cachePlant == 0 then return false end
    for _,v in pairs(cachePlant) do
        if v.id == id then
            return true
        end
    end
    return false
end

local function updateValuesInCache(id, name, value, refresh, source)
    if #cachePlant == 0 then return end
    for _,v in pairs(cachePlant) do
        if v.id == id then
            if v.status[name] + value >= 0 and v.status[name] + value <= 100 then
                v.status[name] = v.status[name] + value
                if source then TriggerClientEvent('esx:showNotification', source, '(~g~Succès~s~)\nVous avez arroser la plante.') end
                if refresh then TriggerClientEvent("xWeed:refreshPlants", -1, cachePlant) end
                return true
            else
                if source then TriggerClientEvent('esx:showNotification', source, '(~r~Erreur~s~)\nVous ne pouvez pas arroser cette plante.') end
            end
        end
    end
    return false
end

RegisterNetEvent("xWeed:arroserPlant")
AddEventHandler("xWeed:arroserPlant", function(id)
    local xPlayer = ESX.GetPlayerFromId(source)

    if (not xPlayer) then return end
    if xPlayer.getInventoryItem("water").count > 0 then
        if getExistPlant(id) then
            if updateValuesInCache(id, "water", Config.gain.addBottle, true, xPlayer.source) then
                xPlayer.removeInventoryItem("water", 1)
            end
        end
    else
        TriggerClientEvent('esx:showNotification', xPlayer.source, '(~r~Erreur~s~)\nVous n\'avez pas assez d\'Eau sur vous.')
    end
end)

RegisterNetEvent("xWeed:removePlant")
AddEventHandler("xWeed:removePlant", function(id)
    local xPlayer = ESX.GetPlayerFromId(source)

    if (not xPlayer) then return end
    if getExistPlant(id) then
        for _,v in pairs(cachePlant) do
            if v.id == id then
                DeleteEntity(id)
                table.remove(cachePlant, _)
            end
        end
        SaveResourceFile("xWeed", "plants.json", json.encode(cachePlant, {indent = true}), -1)
        TriggerClientEvent("xWeed:refreshPlants", -1, cachePlant)
    end
end)

RegisterNetEvent("xWeed:recolterPlant")
AddEventHandler("xWeed:recolterPlant", function(id)
    local xPlayer = ESX.GetPlayerFromId(source)

    if (not xPlayer) then return end
    if getExistPlant(id) then
        for _,v in pairs(cachePlant) do
            if v.id == id then
                local recolte, graine, pot = math.random(Config.gain.recolteMin, Config.gain.recolteMax), math.random(Config.gain.recolteGraineMin, Config.gain.recolteGraineMax), math.random(Config.gain.recoltePotMin, Config.gain.recoltePotMax) 
                xPlayer.addInventoryItem("weed", recolte)
                xPlayer.addInventoryItem("graine_weed", graine)
                if pot == 1 then xPlayer.addInventoryItem("pot", 1) else TriggerClientEvent('esx:showNotification', xPlayer.source, '(~y~Information~s~)\nLe pot s\'est casser.') end
                TriggerClientEvent('esx:showNotification', xPlayer.source, ('(~g~Succès~s~)\nVous avez récoltez x%s Weed et x%s Graine(s) de Weed.'):format(recolte, graine))
                DeleteEntity(v.id)
                table.remove(cachePlant, _)
                SaveResourceFile("xWeed", "plants.json", json.encode(cachePlant, {indent = true}), -1)
                TriggerClientEvent("xWeed:refreshPlants", -1, cachePlant)
            end
        end
    end
end)

CreateThread(function()
    while true do
        Wait(Config.interval * 60000)
        for _,v in pairs(cachePlant) do
            if v.status["health"] == 0 then
                DeleteEntity(v.id)
                table.remove(cachePlant, _)
            elseif v.status["health"] >= 40 and v.status["health"] < 70 and v.model ~= Config.props[2].name then
                v.model = Config.props[2].name
                print(v.id)
                DeleteEntity(v.id)
                local props = CreateObject(v.model, v.pos.x, v.pos.y, v.pos.z - 2.5, true, false, true)
                v.id = props
            elseif v.status["health"] >= 70 and v.model ~= Config.props[3].name then
                v.model = Config.props[3].name
                DeleteEntity(v.id)
                local props = CreateObject(v.model, v.pos.x, v.pos.y, v.pos.z - 2.5, true, false, true)
                v.id = props
            end
            v.status["water"] = v.status["water"] - Config.update.removeWater
            if v.status["water"] == 0 then
                updateValuesInCache(v.id, "health", -Config.update.removeHealth_1, false, false)
            elseif v.status["water"] > 0 and v.status["water"] <= 25 then
                updateValuesInCache(v.id, "health", -Config.update.removeHealth_2, false, false)
            elseif v.status["water"] > 25 and v.status["water"] < 50 then
                updateValuesInCache(v.id, "health", -Config.update.removeHealth_3, false, false)
            elseif v.status["water"] >= 50 and v.status["water"] < 100 then
                updateValuesInCache(v.id, "health", Config.update.addHealth, false, false)
            end
        end
        SaveResourceFile("xWeed", "plants.json", json.encode(cachePlant, {indent = true}), -1)
        TriggerClientEvent("xWeed:refreshPlants", -1, cachePlant)
    end
end)
