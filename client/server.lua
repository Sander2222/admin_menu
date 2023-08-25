function OpenServerMenu()
    lib.registerContext({
        id = 'ServMenu',
        title = 'Server Menu',
        options = {
            {
                title = 'Send Announce',
                description = 'Player Actions',
                icon = 'bullhorn',
                arrow = true,
                onSelect = function()
                    OpenAnnounceMenu()
                end,
            },
            {
                title = 'Revive All',
                description = 'Player Actions',
                icon = 'laptop-medical',
                onSelect = function()
                    ReviveAllPlayer()
                end,
            },
            {
                title = 'Blackout',
                description = 'Player Actions',
                icon = 'bolt',
                arrow = true,
                onSelect = function()
                    BlackOut()
                end,
            },
            {
                title = 'Detele all Vehicle',
                description = 'Player Actions',
                icon = 'car-burst',
                arrow = true,
                onSelect = function()
                    local vehicles = GetGamePool("CVehicle")
                    for _, vehicle in pairs(vehicles) do
                        DeleteEntity(vehicle)
                    end
                    print("All vehicles deleted.")
                end,
            },
            {
                title = 'Resource Monitor',
                description = 'Player Actions',
                icon = 'list-check',
                arrow = true,
                onSelect = function()
                    local resources = GetResourceList()

                    for _, resource in ipairs(resources) do
                        print(resource)
                    end
                end,
            },
        }
    })

    lib.showContext('ServMenu')
end

function OpenAnnounceMenu()
    local msg = lib.inputDialog('Announce', {'msg'})
    if not msg then return end
    TriggerServerEvent('SyncAnnounceToClients', msg)
end

RegisterNetEvent('DisplaySyncAnnounce')
AddEventHandler('DisplaySyncAnnounce', function(message)
    ESX.ShowNotification(message, true, true, 3000)
end)

function ReviveAllPlayer()
    TriggerServerEvent('ReviveAllPlayer')
end

function BlackOut()
    TriggerServerEvent('BlackOut')
end

RegisterNetEvent('toggleBlackout')
AddEventHandler('toggleBlackout', function(state)
    if state then
        SetArtificialLightsState(true)
        SetStreetlights(false)
    else
        SetArtificialLightsState(false)
        SetStreetlights(true)
    end
end)