function OpenServerMenu()
    lib.registerContext({
        id = 'ServMenu',
        title = Locals.ServerMenu.Menu,
        options = {
            {
                title = Locals.ServerMenu.SendAnnounce,
                description = Locals.ServerMenu.Menu,
                icon = 'bullhorn',
                arrow = true,
                onSelect = function()
                    if CanUseFunction('announce') then
                        OpenAnnounceDialog()
                    end
                end,
            },
            {
                title = Locals.ServerMenu.ReviveAll,
                description = Locals.ServerMenu.Menu,
                icon = 'laptop-medical',
                onSelect = function()
                if CanUseFunction('reviveall') then
                    OpenReviveDialog()
                end
                end,
            },
            {
                title = Locals.ServerMenu.DeleteAllVeh,
                description = Locals.ServerMenu.Menu,
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
        header = Locals.ServerMenu.DeleteAllVeh,
        content =  Locals.ServerMenu.DeleteAllVehDesc,
        centered = true,
        cancel = true
    })
     
    if alert then
        TriggerServerEvent('admin_menu:server:DelAllVehicles')
    end
end

function OpenReviveDialog()
    local alert = lib.alertDialog({
        header = Locals.ServerMenu.ReviveAll,
        content = Locals.ServerMenu.ReviveAllDesc,
        centered = true,
        cancel = true
    })
     
    if alert then
        TriggerServerEvent('admin_menu:server:ReviveAllPlayer')
    end
end

function OpenAnnounceDialog()
    local input = lib.inputDialog(Locals.ServerMenu.Menu, {
        {type = 'input', label = Locals.ServerMenu.AnnounceMSG, description = Locals.ServerMenu.AnnounceMSGDesc},
    })

    if not input then return end

    TriggerServerEvent('admin_menu:server:SendAnnounce', input[1])
end

-- RegisterNetEvent('DisplaySyncAnnounce')
-- AddEventHandler('DisplaySyncAnnounce', function(message)
--     ESX.ShowNotification(message, true, true, 3000)
-- end)

-- function BlackOut()
--     TriggerServerEvent('BlackOut')
-- end

-- RegisterNetEvent('toggleBlackout')
-- AddEventHandler('toggleBlackout', function(state)
--     if state then
--         SetArtificialLightsState(true)
--         SetStreetlights(false)
--     else
--         SetArtificialLightsState(false)
--         SetStreetlights(true)
--     end
-- end)