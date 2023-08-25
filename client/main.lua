if Config.UseOpenKey then
    RegisterKeyMapping('adminmenu', 'Open Adminmenu', 'keyboard', Config.DefaultOpenKey)
end

RegisterCommand('adminmenu', function(source, args)
    ESX.TriggerServerCallback('admin_menu:callback:CheckGroup', function(CanOpen)
        if CanOpen then
            OpenMenu()
        else
            Config.ClientNotify('Server: Dieser Befehl ist nur für Admins verfügbar.')
        end
    end)
end)

function OpenMenu()
    lib.registerContext({
        id = 'some_menu',
        title = 'Adminmenu',
        options = {
            {
                title = 'Self',
                description = 'Self Actions',
                icon = 'user',
                arrow = true,
                onSelect = function()
                    OpenSelfMenu()
                end,
            },
            {
                title = 'Player',
                description = 'Player Actions',
                icon = 'circle',
                arrow = true,
                onSelect = function()
                    ShowPlayerMenu()
                end,
            },
            {
                title = 'Vehicle',
                description = 'Player Actions',
                icon = 'circle',
                arrow = true,
                onSelect = function()
                    OpenVehMenu()
                end,
            },
            {
                title = 'Server',
                description = 'Player Actions',
                icon = 'circle',
                arrow = true,
                onSelect = function()
                    OpenServerMenu()
                end,
            },
            {
                title = 'Weather',
                description = 'Waether Actions',
                icon = 'circle',
                arrow = true,
                onSelect = function()
                    OpenWeatherMenu()
                end,
            },
            --   {
            --     title = 'Menu button',
            --     description = 'Takes you to another menu!',
            --     menu = 'other_menu',
            --     icon = 'bars'
            --   },
            --   {
            --     title = 'Event button',
            --     description = 'Open a menu from the event and send event data',
            --     icon = 'check',
            --     event = 'test_event',
            --     arrow = true,
            --     args = {
            --       someValue = 500
            --     }
            --   }
        }
    })

    lib.showContext('some_menu')
end