cachePlant = {}

ESX.RegisterUsableItem("pot", function(source)
    local xPlayer = ESX.GetPlayerFromId(source)

    if (not xPlayer) then return end
    if GetEntityRoutingBucket(GetPlayerPed(source)) == 0 then
        TriggerClientEvent("xWeed:planter", source)
    else
        TriggerClientEvent('esx:showNotification', source, "(~r~Erreur~s~)\nVous ne pouvez pas utiliser cet objet pour le moment.")
    end
end)

ESX.RegisterServerCallback("xWeed:usePot", function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)

    if (not xPlayer) then return end
    if xPlayer.getInventoryItem("graine_weed"). count > 0 then
        cb(true)
        xPlayer.removeInventoryItem("graine_weed", 1)
        xPlayer.removeInventoryItem("pot", 1)
        FreezeEntityPosition(GetPlayerPed(source), true)
        local props = CreateObject(Config.props[1].name, GetEntityCoords(GetPlayerPed(source)).x + 0.5, GetEntityCoords(GetPlayerPed(source)).y, GetEntityCoords(GetPlayerPed(source)).z - 1.0, true, false, true)
        FreezeEntityPosition(props, true)
        table.insert(cachePlant, {id = props, model = Config.props[1].name, pos = (vector3(GetEntityCoords(GetPlayerPed(source)).x + 0.5, GetEntityCoords(GetPlayerPed(source)).y, GetEntityCoords(GetPlayerPed(source)).z - 1.0)), status = { water = Config.water, health = Config.health }})
        SaveResourceFile("xWeed", "plants.json", json.encode(cachePlant, {indent = true}), -1)
        Wait(5000)
        TriggerClientEvent("xWeed:refreshPlants", -1, cachePlant)
        FreezeEntityPosition(GetPlayerPed(source), false)
    else
        TriggerClientEvent('esx:showNotification', source, "(~r~Erreur~s~)\nIl vous manque des objets pour utiliser le pot.")
        cb(false)
    end
end)