local xPlayerList = {}

function ShowPlayerMenu(PlayerList)
    local PlayerTable = GetAllPlayers(PlayerList)
    
    lib.registerContext({
        id = 'PlayerMenu',
        title = 'Adminmenu',
        options =  PlayerTable
    })

    lib.showContext('PlayerMenu')
end

function OpenSearchPlayerDialog()
    local input = lib.inputDialog('Spieler Kicken', {
        {type = 'input', label = 'Steamname/ID/Name', description = 'Gebe hier ein Steamnamen, ID oder den Namen von einem Spieler ein', required = true, min = 1, max = 1000}
    })

    if not input then return end      
    
    local Search = input[1]
    local IsNumber = false
    
    if Search == '' or Search == ' ' then 
        Config.ClientNotify('Deine Nachricht ist leer')

        return
    end

    if tonumber(Search) then
        IsNumber = true
    end

    if string.len(Search) < 3 and not IsNumber then
        Config.ClientNotify('du musst mindestens 3 zeichen eingeben')

        return
    end

    ShowPlayerMenu(SearchForPlayers(Search))
end

function SearchForPlayers(Search)
    local Players = {}
    local UpperSearch = string.upper(Search)

    for k, v in pairs(xPlayerList) do

        -- Check ID
        if UpperSearch == string.upper(tostring(v.playerId)) then

            table.insert(Players, v)
            break
        end

        -- Checkname
        if string.match(string.upper(v.name), UpperSearch) ~= nil then

            table.insert(Players, v)
            break
        end

        if string.match(string.upper(v.steam), UpperSearch) ~= nil then

            table.insert(Players, v)
            break
        end
    end

    if #Players == 0 then
        Config.ClientNotify('Es wurde kein Spieler gefunden')
    else
        Config.ClientNotify(('Es wurden %s Spieler gefunden'):format(tostring(#Players)))
        return Players
    end

end

function GetAllPlayers(PlayerList)
    local PlayerList = {}


    ESX.TriggerServerCallback("admin_menu:callback:GetAllPlayer", function(Players)
        xPlayerList = Players 

        if #PlayerList > 0 then
            xPlayerList = PlayerList
        end

        local Search = {
            title = 'Suchen',
            description = 'Spieler suchen',
            icon = 'magnifying-glass',
            arrow = true,
            onSelect = function()
                OpenSearchPlayerDialog()
            end,
        }
    
        local Refresh = {
            title = 'Refresh',
            description = 'Spieler Refresh',
            icon = 'arrows-rotate',
            onSelect = function()
                ShowPlayerMenu()
            end,
        }
    
        table.insert(PlayerList, Search)
        table.insert(PlayerList, Refresh)
        table.insert(PlayerList, AddPlaceHolder())

        for i, xPlayer in pairs(xPlayerList) do

            local TmpTable = {
                title = xPlayer.name,
                description = 'ID: ' .. xPlayer.source .. '  Steam: ' .. xPlayer.steam,
                icon = 'user',
                arrow = true,
                onSelect = function()
                    OpenSinglePlayerMenu(xPlayer.source)
                end,
                metadata = {
                    {label = 'Job', value = xPlayer.job.label},
                    {label = 'Group', value = xPlayer.group}
                },
            }

            table.insert(PlayerList, TmpTable)
        end
    end)

    -- fuck lua async shit
    while #PlayerList == 0 do
        Wait(0)
    end

    return PlayerList
end

function GetSinglePlayerData(PlayerID)
    for k, xPlayer in pairs(xPlayerList) do
        if xPlayer.source == PlayerID then
            return xPlayer
        end
    end
end

function OpenSinglePlayerMenu(PlayerID)
    
    lib.registerContext({
        id = 'SinglePlayerMenu',
        title = 'Adminmenu',
        options =  {
            {
                title = 'Ban Player',
                description = 'Spieler Bannen',
                icon = 'user-doctor',
                arrow = true,
                onSelect = function()
                    if CanUseFunction('ban') then
                        OpenPlayerBanMenu(PlayerID)
                    end
                end,
            },
            {
                title = 'Inventory',
                description = 'Spieler Inventory',
                icon = 'boxes-stacked',
                arrow = true,
                onSelect = function()
                    if CanUseFunction('inventory') then
                        OpenPlayerInventory(PlayerID)
                    end
                end,
            },
            {
                title = 'Weapon',
                description = 'Spieler Inventory',
                icon = 'weapon',
                arrow = true,
                onSelect = function()
                    if CanUseFunction('pWeapon') then
                        OpenPlayerWeaponMenu(PlayerID)
                    end
                end,
            },
            {
                title = 'Take Screenshot',
                description = 'Take a screenshot from a player',
                icon = 'weapon',
                arrow = true,
                onSelect = function()
                    if CanUseFunction('screenshot') then
                        TriggerServerEvent('admin_menu:server:TakePlayerScreenshot', PlayerID)
                    end
                end,
            },
            {
                title = 'Job Menu',
                description = 'Job Menu',
                icon = 'user-doctor',
                arrow = true,
                onSelect = function()
                    if CanUseFunction('job') then
                        OpenPlayerJobMenu(PlayerID)
                    end
                end,
            },
            {
                title = 'Send Message',
                description = 'Spieler eine Nachricht schicken',
                icon = 'message',
                arrow = true,
                onSelect = function()
                    if CanUseFunction('msg') then
                        OpenSendMSGPlayerDialog(PlayerID)
                    end
                end,
            },
            {
                title = 'Kick Player',
                description = 'Ein Spieler von dem Server kicken',
                icon = 'message',
                arrow = true,
                onSelect = function()
                    if CanUseFunction('kick') then
                        KickPlayerDialog(PlayerID)
                    end
                end,
            },
            {
                title = 'Kill Player',
                description = 'einen Spieler töten',
                icon = 'message',
                onSelect = function()
                    if CanUseFunction('pkill') then
                        TriggerServerEvent('admin_menu:server:KillPlayer', PlayerID)
                    end
                end,
            },
            {
                title = 'Give Armor Player',
                description = 'einem Spieler Armor geben',
                icon = 'message',
                onSelect = function()
                    if CanUseFunction('parmor') then
                        TriggerServerEvent('admin_menu:server:GiveArmorToPlayer', PlayerID)
                    end
                end,
            },
            {
                title = 'GiveMoney',
                description = 'einem Spieler Geld geben',
                icon = 'money',
                onSelect = function()
                    if CanUseFunction('pmoney') then
                        OpenGivePlayerMoneyMenu(PlayerID)
                    end
                end,
            },
        }
    })

    lib.showContext('SinglePlayerMenu')
end


function OpenPlayerBanMenu(PlayerID)
    lib.registerContext({
        id = 'BanPlayerMenu',
        title = 'Money Menu',
        options = {
            {
                title = 'Spezifisch bannen',
                description = 'Spieler nach bestimmten Tagen bannen',
                icon = 'money-bill',
                onSelect = function()
                    OpenPlayerBanDialog(PlayerID)
                end,
            },
            {
                title = 'Für eine Stunde',
                description = 'Bannen für eine Stunde',
                icon = 'money-check',
                onSelect = function()
                    OpenAddBanReasonDialog(PlayerID, Config.Times.hour)
                end,
            },
            {
                title = 'Für einen Tag',
                description = 'Bannen für eine Stunde',
                icon = 'money-check',
                onSelect = function()
                    OpenAddBanReasonDialog(PlayerID, Config.Times.day)
                end,
            },
            {
                title = 'Für eine Woche',
                description = 'Bannen für eine Stunde',
                icon = 'money-check',
                onSelect = function()
                    OpenAddBanReasonDialog(PlayerID, Config.Times.day * 7)
                end,
            },
            {
                title = 'Permanent',
                description = 'Bannen für eine Stunde',
                icon = 'money-check',
                onSelect = function()
                    if CanUseFunction('banperm') then
                        OpenAddBanReasonDialog(PlayerID, Config.Times.per)
                    end
                end,
            },
        }
    })

    lib.showContext('BanPlayerMenu')
end

function OpenAddBanReasonDialog(PlayerID, Time)
    local input = lib.inputDialog('Dialog title', {
        {type = 'input', label = 'Reason', description = 'Some input description', required = true, min = 3, max = 200},
      })

      local Reason = input[1]

      TriggerServerEvent('admin_menu:server:AddPlayerBan', Time, Reason, 'custom', PlayerID)
end

function OpenPlayerBanDialog(PlayerID)
    local input = lib.inputDialog('Dialog title', {
        {type = 'date', label = 'Date input', icon = {'far', 'calendar'}, default = true, format = "DD/MM/YYYY"},
        {type = 'input', label = 'Reason', description = 'Some input description', default = 'Modding', required = true, min = 3, max = 200},
      })

      local timestamp = math.floor(input[1] / 1000)
      local Reason = input[2]

      TriggerServerEvent('admin_menu:server:AddPlayerBan', timestamp, Reason, 'normal', PlayerID)
end

function OpenGivePlayerMoneyMenu(PlayerID)
    lib.registerContext({
        id = 'MoneyPlayerMenu',
        title = 'Money Menu',
        options = {
            {
                title = 'Give Money',
                description = 'Player Actions',
                icon = 'money-bill',
                onSelect = function()
                    GiveMoneyToPlayerDialog('Hand', PlayerID)
                end,
            },
            {
                title = 'Give Bank Money',
                description = 'Player Actions',
                icon = 'money-check',
                onSelect = function()
                    GiveMoneyToPlayerDialog('Bank', PlayerID)
                end,
            },
        }
    })

    lib.showContext('MoneyPlayerMenu')
end

function GiveMoneyToPlayerDialog(Type, PlayerID)
    local input = lib.inputDialog('Add Money', {
        {type = 'number', label = 'Money', description = 'Wie viel Geld', icon = 'hashtag'},
    })

    if not input then return end

    local Money = tonumber(input[1])

    if Money == nil then
        Config.ClientNotify('Du musst eine Zahl angeben')

        return
    end

    TriggerServerEvent('admin_menu:server:GiveMoneyToPlayer', Money, Type, PlayerID)
end

function OpenPlayerWeaponMenu(PlayerID)
    lib.registerContext({
        id = 'SinglePlayerWeaponMenu',
        title = 'Adminmenu',
        options =  GetPlayerWeapon(PlayerID)
    })

    lib.showContext('SinglePlayerWeaponMenu')
end

function GetPlayerWeapon(PlayerID)
    local WeaponData = GetSinglePlayerData(PlayerID).loadout
    local Weapons = {}

    local Add = {
        title = 'Waffe hinzufügen',
        description = 'Einem Spieler eine Waffe hinzufügen',
        icon = 'magnifying-glass',
        onSelect = function()
            OpenAddWeaponMenu(PlayerID)
        end,
    }

    local DelAll = {
        title = 'Alle Waffen löshen',
        description = 'Einem Spieler alle Waffen löschen',
        icon = 'magnifying-glass',
        onSelect = function()
            DeleteAllWeapons(PlayerID)
        end,
    }

    table.insert(Weapons, Add)
    table.insert(Weapons, DelAll)
    table.insert(Weapons, AddPlaceHolder())

    for k, v in ipairs(WeaponData) do
        if v.count ~= 0 then

            local TmpTable = {
                title = v.label,
                description = v.name,
                icon = 'gun',
                arrow = true,
                onSelect = function()
                    OpenWeaponPlayerMenu(PlayerID, v.name, v.label, v.ammo, v.components)
                end,
                metadata = {
                    {label = 'Ammo', value = v.ammo},
                    {label = 'Tint Index', value = v.tintIndex}
                },
            }

            table.insert(Weapons, TmpTable)
        end
    end

    return Weapons
end

function OpenAddWeaponMenu(PlayerID)
    lib.registerContext({
        id = 'WeaponListMenu',
        title = 'Add Weapon',
        options = GetAllGunsPlayer(PlayerID)
    })

    lib.showContext('WeaponListMenu')
end

function GetAllGunsPlayer(PlayerID)
    local Guns = {}

    local SpeedMenu =  {
        title = 'Schnellauswahl',
        description = 'Schnell Waffe geben',
        icon = 'gun',
        onSelect = function()
            SearchForWeapon()
        end,
    }

    table.insert(Guns, SpeedMenu)
    table.insert(Guns, AddPlaceHolder())

    for k, WeaponData in ipairs(ESX.GetWeaponList()) do
        local TmpTable =
            {
                title = WeaponData.label,
                description = WeaponData.name,
                icon = 'gun',
                onSelect = function()
                    GiveWeaponToPlayer(WeaponData.name, WeaponData.label, PlayerID)
                end,
            }

            table.insert(Guns, TmpTable)
    end
    return Guns
end

function GiveWeaponToPlayer(WeaponName, WeaponLabel, PlayerID)
    local input = lib.inputDialog('Weapon Info: ' .. WeaponLabel, {
        {type = 'input', label = 'Ammunation', description = 'Anzahl von der Munition', default= 250, required = true, min = 1, max = 600}
    })

    if not input then return end

    local Ammo = tonumber(input[1])

    if Ammo == nil then
        Config.ClientNotify('Du musst eine Zahl angeben')

        return
    end

    TriggerServerEvent('admin_menu:server:GiveWeaponToPlayer', WeaponName, Ammo, PlayerID)
end

function DeleteAllWeapons(PlayerID)
    local alert = lib.alertDialog({
        header = 'Alle Waffen entfernen',
        content = 'Sicher das du dem Spieler alle Wafen entfernen möchtest? \nID: ' .. PlayerID,
        centered = true,
        cancel = true
    })
     
    if alert == 'confirm' then
        TriggerServerEvent('admin_menu:server:RemoveAllPlayerWeapons', PlayerID)
    end
end

function OpenWeaponPlayerMenu(PlayerID, WeaponName, WeaponLabel, Ammo, Components)

    lib.registerContext({
        id = 'PlayerWeaponActionsMenu',
        title = 'Item: ' .. WeaponLabel,
        options = {
            {
                title = 'Munition anpassen',
                description = 'Munition: ' .. Ammo,
                icon = 'plus',
                arrow = true,
                onSelect = function()
                    OpenUpdateAmmonationDialog(PlayerID, WeaponName, Ammo)
                end,
            },
            {
                title = 'Waffe entfernen',
                description = 'Diese Waffe entfernen (' ..  WeaponLabel.. ')',
                icon = 'magnifying-glass',
                onSelect = function()
                    TriggerServerEvent('admin_menu:server:RemovePlayerWeapon', WeaponName, PlayerID)
                end,
            },
            {
                title = 'Componenten anpassen',
                description = 'Spieler hat so viele Componenten: ' .. #Components,
                icon = 'magnifying-glass',
                arrow = true,
                onSelect = function()
                    if #Components ~= 0 then
                        OpenWeaponComponentMenu(PlayerID, WeaponName, Components)
                    else 
                        ESX.ShowNotification('Der Spieler hat keine Componenten')
                    end
                end,
            },
        } 
    })

    lib.showContext('PlayerWeaponActionsMenu')
end

function OpenWeaponComponentMenu(PlayerID, WeaponName, Components)
    lib.registerContext({
        id = 'WeaponComponentMenu',
        title = 'Waffen Components Menu',
        options = GetWeaponComponentsMenu(PlayerID, WeaponName, Components)
    })

    lib.showContext('WeaponComponentMenu')
end

function GetWeaponComponentsMenu(PlayerID, WeaponName, Components)
    local Comps = {}

    for k, v in pairs(Components) do
        local TmpTable = {
            title = 'Component: ' .. v,
            description = 'Component entfernen',
            icon = 'user-doctor',
            arrow = true,
            onSelect = function()
                TriggerServerEvent('admin_menu:server:RemoveWeaponComponent', PlayerID, WeaponName, v)
            end,
        }

        table.insert(Comps, TmpTable)
    end

    return Comps
end

function OpenUpdateAmmonationDialog(PlayerID, WeaponName, Ammo)
    local input = lib.inputDialog('Weapon: ' ..  ESX.GetWeaponLabel(WeaponName), {
        {type = 'input', label = 'Ammo', description = 'Waffen Munition', default = Ammo, required = true, min = 1, max = 1000}
    })

    if not input then return end      
    
    local Count = tonumber(input[1])
    
    if Count == tonumber(Ammo) then 
        Config.ClientNotify('Es ist der gleich Betrag')

        return
    end

    TriggerServerEvent('admin_menu:server:UpdatePlayerAmmo', WeaponName, Count, Ammo, PlayerID)
end

function KickPlayerDialog(PlayerID)
    local input = lib.inputDialog('Spieler Kicken', {
        {type = 'input', label = 'Message', description = 'Nachricht die beim Kick angezeigt wird', required = true, min = 1, max = 1000}
    })

    if not input then return end      
    
    local MSG = input[1]
    
    if MSG == '' or MSG == ' ' then 
        Config.ClientNotify('Deine Nachricht ist leer')

        return
    end

    TriggerServerEvent('admin_menu:server:KickPlayer', MSG, PlayerID)
end

function OpenSendMSGPlayerDialog(PlayerID)

    local input = lib.inputDialog('Send Message', {
        {type = 'input', label = 'Message', description = 'Privatnachricht', required = true, min = 1, max = 1000}    
    })

    if not input then return end      
    
    local MSG = input[1]
    
    if MSG == '' or MSG == ' ' then 
        Config.ClientNotify('Deine Nachricht ist leer')

        return
    end

    TriggerServerEvent('admin_menu:server:SendPrivateMessage', MSG, PlayerID)
end

function OpenPlayerJobMenu(PlayerID)
    local JobData = GetSinglePlayerData(PlayerID).job

    lib.registerContext({
        id = 'JobMenu',
        title = 'Job: ' .. JobData.name ..  ' Grade: ' .. JobData.grade,
        options = {
            {
                title = 'Job ändern',
                description = 'Job Daten ändern',
                icon = 'user-doctor',
                arrow = true,
                onSelect = function()
                    OpenUpdateJobDialog(PlayerID)
                end,
            },
            {
                title = 'Job zurücksetzen',
                description = 'Job auf Arbietslos setzten',
                icon = 'user-doctor',
                arrow = true,
                onSelect = function()
                    TriggerServerEvent('admin_menu:server:UpdatePlayerJob', Config.UnemployedJob, Config.UnemployedJobGrade, PlayerID)
                end,
            },
        }
    })

    lib.showContext('JobMenu')
end

function OpenUpdateJobDialog(PlayerID)
    local JobData = GetSinglePlayerData(PlayerID).job

    local input = lib.inputDialog('Change Job Data', {
        {type = 'input', label = 'Jobname', description = JobData.name, default = JobData.name, required = true, min = 1, max = 600},
        {type = 'number', label = 'Grade', description = '', default = JobData.grade, icon = 'hashtag'},
    })

    if not input then return end      
    
    local JobName = string.lower(input[1])
    local JobGrade = tonumber(input[2])

    TriggerServerEvent('admin_menu:server:UpdatePlayerJob', JobName, JobGrade, PlayerID)
end

function OpenPlayerInventory(PlayerID)
    lib.registerContext({
        id = 'SinglePlayerInventarMenu',
        title = 'Adminmenu',
        options =  GetInventoryItem(PlayerID)
    })

    lib.showContext('SinglePlayerInventarMenu')
end

function AddNewItemToPlayer(PlayerID)
    local input = lib.inputDialog('Add Item', {
        {type = 'input', label = 'Item name', description = 'Item', required = true, min = 1, max = 600},
        {type = 'number', label = 'Counter', description = 'Wie viele Items', default = 1, icon = 'hashtag'},
    })

    if not input then return end      
    
    local ItemName = string.lower(input[1])
    local Count = tonumber(input[2])

    TriggerServerEvent('admin_menu:server:GiveItem', ItemName, Count, PlayerID)
end

function GetInventoryItem(PlayerID)
    local InventoryData = GetSinglePlayerData(PlayerID).inventory
    local Invs = {}


    local Add = {
        title = 'Item hinzufügen',
        description = 'Einem Spieler ein Item hinzufügen',
        icon = 'magnifying-glass',
        onSelect = function()
            AddNewItemToPlayer(PlayerID)
        end,
    }

    local DelAll = {
        title = 'Alle Items löshen',
        description = 'Einem Spieler alle Items löschen',
        icon = 'magnifying-glass',
        onSelect = function()
            DeleteAllInventoryItems(PlayerID)
        end,
    }

    table.insert(Invs, Add)
    table.insert(Invs, DelAll)
    table.insert(Invs, AddPlaceHolder())

    for k, v in ipairs(InventoryData) do
        if v.count ~= 0 then

            local TmpTable = {
                title = v.label,
                description = v.name,
                icon = 'user',
                arrow = true,
                onSelect = function()
                    OpenItemPlayerMenu(PlayerID, v.name, v.label, v.count)
                end,
                metadata = {
                    {label = 'Count', value = v.count},
                    {label = 'Max Weight', value = v.count * v.weight},
                },
            }


            table.insert(Invs, TmpTable)
        end
    end

    return Invs
end

function OpenItemPlayerMenu(PlayerID, ItemName, ItemLabel, ItemCount)
    lib.registerContext({
        id = 'PlayerItemActionsMenu',
        title = 'Item: ' .. ItemName,
        options = {
            {
                title = 'Item hinzufügen',
                description = 'Diesen Item hinzufügen (' ..  ItemLabel.. ')',
                icon = 'plus',
                arrow = true,
                onSelect = function()
                    AddItemToPlayer(PlayerID, ItemName, ItemLabel)
                end,
            },
            {
                title = 'Alle Items entfernen',
                description = 'Dieses item komplett entfernen (' ..  ItemLabel.. ')',
                icon = 'magnifying-glass',
                onSelect = function()
                    TriggerServerEvent('admin_menu:server:RemoveItem', ItemName, ItemCount, PlayerID, true)
                end,
            },
            {
                title = 'Item einzelne Items entfernen',
                description = 'Nur einzelne Items entfernen (' ..  ItemLabel.. ')',
                icon = 'magnifying-glass',
                arrow = true,
                onSelect = function()
                    RemovePlayerItems(PlayerID, ItemName, ItemLabel)
                end,
            },
        } 
    })

    lib.showContext('PlayerItemActionsMenu')
end

function DeleteAllInventoryItems(PlayerID)
    local alert = lib.alertDialog({
        header = 'Alle Items entfernen',
        content = 'Sicher das du dem Spieler alle Items entfernen möchtest? \nID: ' .. PlayerID,
        centered = true,
        cancel = true
    })
     
    if alert == 'confirm' then
        TriggerServerEvent('admin_menu:server:RemoveAllPlayerItems', PlayerID)
    end
end

function RemovePlayerItems(PlayerID, ItemName, ItemLabel)
    local input = lib.inputDialog('Remove Item: ' .. ItemLabel, {
        {type = 'input', label = 'Item name', description = 'Ausgewähltes Item', disabled = true, default = ItemName, required = true, min = 1, max = 600},
        {type = 'number', label = 'Counter', description = 'Wie viele Items', default = 1, icon = 'hashtag'},
    })

    if not input then return end      
    
    local Count = input[2]

    TriggerServerEvent('admin_menu:server:RemoveItem', ItemName, Count, PlayerID, false)
end

function AddItemToPlayer(PlayerID, ItemName, ItemLabel)
    local input = lib.inputDialog('Add Item: ' .. ItemLabel, {
        {type = 'input', label = 'Item name', description = 'Welches item', disabled = true, default = ItemName, required = true, min = 1, max = 600},
        {type = 'number', label = 'Counter', description = 'Wie viele Items', default = 1, icon = 'hashtag'},
    })

    if not input then return end

    local ItemName = input[1]
    local Count = tonumber(input[2])

    TriggerServerEvent('admin_menu:server:GiveItem', ItemName, Count, PlayerID)
end