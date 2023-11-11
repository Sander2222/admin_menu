local Group

if Config.UseOpenKey then
    RegisterKeyMapping('adminmenu', 'Open Adminmenu', 'keyboard', Config.DefaultOpenKey)
end

RegisterCommand('adminmenu', function(source, args)
    ESX.TriggerServerCallback('admin_menu:callback:CheckGroup', function(CanOpen, PlayerGroup)
        if CanOpen then
            Group = PlayerGroup
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
                icon = 'image-portrait',
                arrow = true,
                onSelect = function()
                    if CanUseFunction('self') then
                        OpenSelfMenu()
                    end
                end,
            },
            {
                title = Locals.Main.Player,
                description = Locals.Main.Player .. Locals.Main.Actions,
                icon = 'user',
                arrow = true,
                onSelect = function()
                    if CanUseFunction('player') then
                        ShowPlayerMenu()
                    end
                end,
            },
            {
                title = Locals.Main.Vehicle,
                description = Locals.Main.Vehicle .. Locals.Main.Actions,
                icon = 'car',
                arrow = true,
                onSelect = function()
                    if CanUseFunction('vehicle') then
                        OpenVehMenu()
                    end
                end,
            },
            {
                title = Locals.Main.Server,
                description = Locals.Main.Server .. Locals.Main.Actions,
                icon = 'server',
                arrow = true,
                onSelect = function()
                    if CanUseFunction('server') then
                        OpenServerMenu()
                    end
                end,
            },
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

function CanUseFunction(Menu)
    if Config.Groups[Group] then
        if Config.Groups[Group][Menu] then
            return true
        else
            Config.ClientNotify('Diese Funktion ist nicht für dich freigeschalten')
            return false
        end
    else 
        Config.ClientNotify('lol')
    end
end

RegisterNetEvent('admin_menu:client:TakeScreenshot')
AddEventHandler('admin_menu:client:TakeScreenshot', function(Webhook)
    exports['screenshot-basic']:requestScreenshotUpload(Webhook, 'files[]', function()end)
end)