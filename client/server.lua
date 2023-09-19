function OpenServerMenu()
    lib.registerContext({
        id = 'ServMenu',
        title = Locals.Self.Menu,
        options = {
            {
                title = Locals.Server.SendAnnounce,
                description = Locals.Self.Menu,
                icon = 'bullhorn',
                arrow = true,
                onSelect = function()
                    if CanUseFunction('announce') then
                        OpenAnnounceDialog()
                    end
                end,
            },
            {
                title = Locals.Server.ReviveAll,
                description = Locals.Self.Menu,
                icon = 'laptop-medical',
                onSelect = function()
                if CanUseFunction('reviveall') then
                    OpenReviveDialog()
                end
                end,
            },
            {
                title = Locals.Server.DeleteAllVeh,
                description = Locals.Self.Menu,
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
        header = Locals.Server.DeleteAllVeh,
        content =  Locals.Server.DeleteAllVehDesc,
        centered = true,
        cancel = true
    })
     
    if alert then
        TriggerServerEvent('admin_menu:server:DelAllVehicles')
    end
end

function OpenReviveDialog()
    local alert = lib.alertDialog({
        header = Locals.Server.ReviveAll,
        content = Locals.Server.ReviveAllDesc,
        centered = true,
        cancel = true
    })
     
    if alert then
        TriggerServerEvent('admin_menu:server:ReviveAllPlayer')
    end
end

function OpenAnnounceDialog()
    local input = lib.inputDialog(Locals.Self.MoneyAdd, {
        {type = 'input', label = Locals.Server.AnnounceMSG, description = Locals.Server.AnnounceMSGDesc},
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