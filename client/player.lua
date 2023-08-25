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
            }
        }
    })

    lib.showContext('SinglePlayerMenu')
end

function OpenPlayerInventory(PlayerID)


    lib.registerContext({
        id = 'SinglePlayerInventarMenu',
        title = 'Adminmenu',
        options =  GetInventoryItem(PlayerID)
    })

    lib.showContext('SinglePlayerInventarMenu')
end

function GetInventoryItem(PlayerID)
    local InventoryData = GetSinglePlayerData(PlayerID).inventory
    local Invs = {}

    local Search = {
        title = 'Suchen',
        description = 'Spieler suchen',
        icon = 'magnifying-glass',
        onSelect = function()

        end,
    }

    local Add = {
        title = 'Item hinzufügen',
        description = 'Einem Spieler ein Item hinzufügen',
        icon = 'magnifying-glass',
        onSelect = function()

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

    table.insert(Invs, Search)
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
        -- removen
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