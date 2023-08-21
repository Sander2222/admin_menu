ESX = exports['es_extended']:getSharedObject()

local adminBlipsActive = {}

RegisterCommand('free_adminBlips', function(source, args, rawCommand)
    -- if IsPlayerAceAllowed(source, 'free_adminBlips') then
        if not adminBlipsActive[source] then
            adminBlipsActive[source] = true
            TriggerEvent('free_adminBlips:ToggleBlips', source, true)
        else
            adminBlipsActive[source] = false
            TriggerEvent('free_adminBlips:ToggleBlips', source, false)
        end
    -- else
        -- TriggerEvent('chatMessage', source, '[Server]', {255, 0, 0}, 'Du hast keine Berechtigung für diesen Befehl.')
    -- end
end, false)

RegisterNetEvent('free_adminBlips:ToggleBlips')
AddEventHandler('free_adminBlips:ToggleBlips', function(enable)
    local playerId = source

    while enable and adminBlipsActive[playerId] do
        local players = GetActivePlayersWithNames()
        TriggerClientEvent('free_adminBlips:UpdateBlips', playerId, players)
        Wait(Config.RefreshRate)
    end
end)

function GetActivePlayersWithNames()
    local players = {}
    local activePlayers = GetPlayers()
    for _, playerId in ipairs(activePlayers) do
        if NetworkIsPlayerActive(playerId) then
            local playerName = GetPlayerName(playerId)
            table.insert(players, {id = playerId, name = playerName})
        end
    end
    return players
end


RegisterServerEvent('free_adminBlips:UpdatePosition')
AddEventHandler('free_adminBlips:UpdatePosition', function(updatedPlayers)
    local source = source
    TriggerClientEvent('free_adminBlips:UpdateBlips', source, updatedPlayers)
end)
