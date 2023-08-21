ESX = exports['es_extended']:getSharedObject()

local blips = {}

RegisterNetEvent('free_adminBlips:UpdateBlips')
AddEventHandler('free_adminBlips:UpdateBlips', function(players)
    for _, blip in pairs(blips) do
        RemoveBlip(blip)
    end
    blips = {}
    for _, player in pairs(players) do
        local blip = AddBlipForCoord(0.0, 0.0, 0.0)
        SetBlipSprite(blip, 1)
        SetBlipDisplay(blip, 4)
        SetBlipScale(blip, 1.0)
        SetBlipColour(blip, 1)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentString(player.name)
        EndTextCommandSetBlipName(blip)
        blips[player.id] = blip
    end
end)

Citizen.CreateThread(function()
    while true do
        Wait(Config.RefreshRate)
        local updatedPlayers = {}
        for playerId, blip in pairs(blips) do
            local x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(playerId), false))
            updatedPlayers[playerId] = {name = blips[playerId].name, x = x, y = y, z = z}
        end

        TriggerServerEvent('free_adminBlips:UpdatePosition', updatedPlayers)
    end
end)
