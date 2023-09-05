local cachePlants, isAnim = {}, false

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function()
    Wait(5000)
    ESX.TriggerServerCallback("xWeed:getPlants", function(plants)
        cachePlants = plants
    end)
end)

RegisterNetEvent("xWeed:planter")
AddEventHandler("xWeed:planter", function()
    local object, dst = ESX.Game.GetClosestObject()
    for i = 1, #Config.props do
        if GetEntityModel(object) == Config.props[i].hash and dst <= 3.0 then
            ESX.ShowNotification("(~r~Erreur~s~)\nVous êtes trop proche des autres pots.")
            return
        end
    end
    if not isAnim then
        ESX.TriggerServerCallback("xWeed:usePot", function(can) 
            if can then
                isAnim = true
                FreezeEntityPosition(PlayerPedId(), true)
                TaskStartScenarioInPlace(PlayerPedId(), "WORLD_HUMAN_GARDENER_PLANT", 0, true)
                Wait(5000)
                ClearPedTasks(PlayerPedId())
                FreezeEntityPosition(PlayerPedId(), false)
                isAnim = false
            end
        end)
    end
end)

RegisterNetEvent("xWeed:refreshPlants")
AddEventHandler("xWeed:refreshPlants", function(plants)
    cachePlants = plants
end)

local function getColor(number)
    if number == 0 then
        return ("~r~%s%s"):format(number, "%")
    elseif number <= 25 then
        return ("~o~%s%s"):format(number, "%")
    elseif number > 25 and number <= 50 then
        return ("~y~%s%s"):format(number, "%")
    elseif number > 50 and number <= 100 then
        return ("~g~%s%s"):format(number, "%")
    end
end

--- Initialisation

CreateThread(function()
    while true do
        local wait = 1000
        if #cachePlants > 0 then
            for i = 1, #cachePlants do
                local x = GetClosestObjectOfType(GetEntityCoords(PlayerPedId()).x, GetEntityCoords(PlayerPedId()).y, GetEntityCoords(PlayerPedId()).z, 2.0, GetHashKey(cachePlants[i].model), false, false, false)
                local dst = Vdist(GetEntityCoords(PlayerPedId()).x, GetEntityCoords(PlayerPedId()).y, GetEntityCoords(PlayerPedId()).z, cachePlants[i].pos.x, cachePlants[i].pos.y, cachePlants[i].pos.z)

                if dst <= 2.0 then
                    if DoesEntityExist(x) then
                        wait = 0
                        if cachePlants[i].status.health == 100 then
                            ESX.ShowHelpNotification("Appuyez ~INPUT_CONTEXT~ pour récolter.")
                            if IsControlJustPressed(1, 51) then
                                TriggerServerEvent("xWeed:recolterPlant", cachePlants[i].id)
                            end
                        else
                            ESX.ShowHelpNotification("Appuyez ~INPUT_CONTEXT~ pour intéragir.")
                            if IsControlJustPressed(1, 51) then
                                SetNuiFocus(true, true)
                                StartScreenEffect('CamPushInFranklin', 0, false)
                                Wait(1000)
                                SetTimecycleModifier("hud_def_blur")
                                SetTimecycleModifierStrength(0.9)
                                SendNUIMessage({ action = "XWEED_EVENT_NUI_SHOW", payload = { health = cachePlants[i].status.health, water = cachePlants[i].status.water, id = cachePlants[i].id }})
                            end
                        end
                    end
                end
            end
        end
        Wait(wait)
    end
end)