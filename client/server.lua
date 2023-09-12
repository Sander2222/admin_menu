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
                    if CanUseFunction('announce') then
                        OpenAnnounceDialog()
                    end
                end,
            },
            {
                title = 'Revive All',
                description = 'Player Actions',
                icon = 'laptop-medical',
                onSelect = function()
                if CanUseFunction('reviveall') then
                    OpenReviveDialog()
                end
                end,
            },
            {
                title = 'Detele all Vehicle',
                description = 'Player Actions',
                icon = 'car-burst',
                arrow = true,
                onSelect = function()
                    if CanUseFunction('delallveh') then
                        OpenDelAllVehDialog()
                    end
                end,
            },
            -- {
            --     title = 'Blackout',
            --     description = 'Player Actions',
            --     icon = 'bolt',
            --     arrow = true,
            --     onSelect = function()
            --         BlackOut()
            --     end,
            -- }
        }
    })

    lib.showContext('ServMenu')
end

function OpenDelAllVehDialog()
    local alert = lib.alertDialog({
        header = 'Delete all Vehicles',
        content = 'Sicher das du alle Fahrzeuge löschen möchtest?',
        centered = true,
        cancel = true
    })
     
    if alert then
        TriggerServerEvent('admin_menu:server:DelAllVehicles')
    end
end

function OpenReviveDialog()
    local alert = lib.alertDialog({
        header = 'Revive Player',
        content = 'Sicher das du jeden Spieler reviven möchtest?',
        centered = true,
        cancel = true
    })
     
    if alert then
        TriggerServerEvent('admin_menu:server:ReviveAllPlayer')
    end
end

function OpenAnnounceDialog()
    local input = lib.inputDialog(Locals.Self.MoneyAdd, {
        {type = 'input', label = 'Announce Message', description = 'dings'},
    })

    if not input then return end

    TriggerServerEvent('admin_menu:server:SendAnnounce', input[1])
end

RegisterNetEvent('DisplaySyncAnnounce')
AddEventHandler('DisplaySyncAnnounce', function(message)
    ESX.ShowNotification(message, true, true, 3000)
end)

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