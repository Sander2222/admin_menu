local xPlayerList = {}

function ShowPlayerMenu()
    local PlayerTable = GetAllPlayers()
    
    lib.registerContext({
        id = 'PlayerMenu',
        title = 'Adminmenu',
        options =  PlayerTable
    })

    lib.showContext('PlayerMenu')
end

function GetAllPlayers()
    local PlayerList = {}


    ESX.TriggerServerCallback("admin_menu:callback:GetAllPlayer", function(Players)
        xPlayerList = Players 

        local Search = {
            title = 'Suchen',
            description = 'Spieler suchen',
            icon = 'magnifying-glass',
            onSelect = function()
    
            end,
        }
    
        local Refresh = {
            title = 'Refresh',
            description = 'Spieler Refresh',
            icon = 'arrows-rotate',
            onSelect = function()
    
            end,
        }
    
        table.insert(PlayerList, Search)
        table.insert(PlayerList, Refresh)
        table.insert(PlayerList, AddPlaceHolder())



        for i, xPlayer in ipairs(Players) do

            local TmpTable = {
                title = xPlayer.name,
                description = 'ID: ' .. xPlayer.source,
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
    for k, xPlayer in ipairs(xPlayerList) do
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
                title = 'Inventory',
                description = 'Spieler Inventory',
                icon = 'boxes-stacked',
                onSelect = function()
                    OpenPlayerInventory(PlayerID)
                end,
            },
            {
                title = 'Weapon',
                description = 'Spieler Inventory',
                icon = 'weapon',
                onSelect = function()
                    OpenPlayerWeaponMenu(PlayerID)
                end,
            },
            {
                title = 'Job Menu',
                description = 'Job Menu',
                icon = 'user-doctor',
                onSelect = function()
                    OpenPlayerJobMenu(PlayerID)
                end,
            },
            {
                title = 'Send Message',
                description = 'Spieler eine Nachricht schicken',
                icon = 'message',
                onSelect = function()
                    OpenSendMSGPlayerDialog(PlayerID)
                end,
            },
            {
                title = 'Kick Player',
                description = 'Ein Spieler von dem Server kicken',
                icon = 'message',
                onSelect = function()
                    KickPlayerDialog(PlayerID)
                end,
            },
            {
                title = 'Kill Player',
                description = 'einen Spieler töten',
                icon = 'message',
                onSelect = function()
                    TriggerServerEvent('admin_menu:server:KillPlayer', PlayerID)
                end,
            },
            {
                title = 'Give Armor Player',
                description = 'einem Spieler Armor geben',
                icon = 'message',
                onSelect = function()
                    TriggerServerEvent('admin_menu:server:GiveArmorToPlayer', PlayerID)
                end,
            },
        }
    })

    lib.showContext('SinglePlayerMenu')
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

    print(ESX.DumpTable(WeaponData))

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

function OpenWeaponPlayerMenu(PlayerID, WeaponName, WeaponLabel, Ammo, Components)
    print(PlayerID, WeaponName, WeaponLabel, Ammo, Components)

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
        print("Remove")
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