if Config.UseOpenKey then
    RegisterKeyMapping('adminmenu', 'Open Adminmenu', 'keyboard', Config.DefaultOpenKey)
end

RegisterCommand('adminmenu', function(source, args)
    ESX.TriggerServerCallback('admin_menu:callback:CheckGroup', function(CanOpen)
        if CanOpen then
            OpenMenu()
        else
            Config.ClientNotify(Locals.OnlyAdmin)
        end
    end)
end)

function OpenMenu()
    lib.registerContext({
        id = 'MainMenu',
        title = Locals.Main.AdminMenu,
        options = {
            {
                title = Locals.Main.Self,
                description = Locals.Main.Self .. Locals.Main.Actions,
                icon = 'user',
                arrow = true,
                onSelect = function()
                    OpenSelfMenu()
                end,
            },
            {
                title = Locals.Main.Player,
                description = Locals.Main.Player .. Locals.Main.Actions,
                icon = 'circle',
                arrow = true,
                onSelect = function()
                    ShowPlayerMenu()
                end,
            },
            {
                title = Locals.Main.Vehicle,
                description = Locals.Main.Vehicle .. Locals.Main.Actions,
                icon = 'circle',
                arrow = true,
                onSelect = function()
                    OpenVehMenu()
                end,
            },
            {
                title = Locals.Main.Server,
                description = Locals.Main.Server .. Locals.Main.Actions,
                icon = 'circle',
                arrow = true,
                onSelect = function()
                    OpenServerMenu()
                end,
            },
            -- {
            --     title = 'Weather',
            --     description = 'Waether Actions',
            --     icon = 'circle',
            --     arrow = true,
            --     onSelect = function()
            --         -- lib.showMenu('menu_world_related_options')
            --     end,
            -- },
        }
    })

    lib.showContext('MainMenu')
end

function AddPlaceHolder()
    local Placeholder =  {
        title = ' ',
        description = ' ',
        icon = ' ',
    }

    return Placeholder
end

function ConvertHexToRGB(hex)
    hex = hex:gsub("#","")
    return tonumber("0x"..hex:sub(1,2)), tonumber("0x"..hex:sub(3,4)), tonumber("0x"..hex:sub(5,6))
end