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
    
        local Placeholder =  {
            title = ' ',
            description = ' ',
            icon = ' ',
        }
    
        table.insert(PlayerList, Search)
        table.insert(PlayerList, Refresh)
        table.insert(PlayerList, Placeholder)



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

    local Placeholder =  {
        title = ' ',
        description = ' ',
        icon = ' ',
    }

    table.insert(Invs, Search)
    table.insert(Invs, Placeholder)

    for k, v in ipairs(InventoryData) do
        if v.count ~= 0 then

            local TmpTable = {
                title = v.label,
                description = v.name,
                icon = 'user',
                arrow = true,
                onSelect = function()
                    RemovePlayerItem(PlayerID, v.name)
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

function RemovePlayerItem(PlayerID, ItemName)
    print(ItemName)
end