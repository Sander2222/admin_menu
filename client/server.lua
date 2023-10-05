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
            {
                title = 'Banlist',
                description = 'Banlist wo alle gebannten spieler drin sind',
                icon = 'car-burst',
                arrow = true,
                onSelect = function()
                    if CanUseFunction('delallveh') then
                        OpenBanList()
                    end
                end,
            }
        }
    })

    lib.showContext('ServMenu')
end

function OpenBanList()

    lib.registerContext({
        id = 'TEst',
        title = 'test',
        options = GetBannedPlayers()
    })

    lib.showContext('TEst')
end

function GetBannedPlayers()
    local PlayerList = {}
     
    ESX.TriggerServerCallback('admin_menu:callback:GetAllBannedPlayers', function(BannedPlayers)
    
        if #BannedPlayers == 0 then
            Config.ClientNotify('Es gibt keine gebannten Spieler')
            return
        end
    
        for k, v in ipairs(BannedPlayers) do
            local TmpTable = {
                title = v.firstname .. v.lastname,
                description = v.identifier,
                icon = 'user',
                arrow = true,
                onSelect = function()
                    OpenUnbanPlayerDialog(v.identifier, v.firstname .. v.lastname, v.bantime, v.banreason)
                end,
                metadata = {
                    {label = 'Time bis zum unbann', value = v.bantime},
                    {label = 'Grund', value = v.banreason}
                },
            }

            table.insert(PlayerList, TmpTable)
        end
    end)

    while #PlayerList == 0 do
        Wait(0)
    end

    return PlayerList
end

function OpenUnbanPlayerDialog(Identifier, Name, BanTime, Reason)
    local alert = lib.alertDialog({
        header = 'Unban player',
        content =  ('Willst du diesen Spieler entbannen:\n\n Identifier: %s\n\nName: %s\n\nBantime: %s\n\nReason: %s'):format(Identifier, Name, BanTime, Reason),
        size = 'xl',
        centered = true,
        cancel = true
    })
     
    print(alert)
    if alert == 'confirm' then
        TriggerServerEvent('admin_menu:server:UnbanPlayer', string.sub(Identifier, 7))
    end
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