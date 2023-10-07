local xPlayerList = {}

function ShowPlayerMenu(PlayerList)
    local PlayerTable = GetAllPlayers(PlayerList)
    
    lib.registerContext({
        id = 'PlayerMenu',
        title = Locals.Main.AdminMenu,
        options =  PlayerTable
    })

    lib.showContext('PlayerMenu')
end

function OpenSearchPlayerDialog()
    local input = lib.inputDialog(Locals.Player.KickPlayer, {
        {type = 'input', label = Locals.Player.IDs, description = Locals.Player.EnterIDs, required = true, min = 1, max = 1000}
    })

    if not input then return end      
    
    local Search = input[1]
    local IsNumber = false
    
    if Search == '' or Search == ' ' then 
        Config.ClientNotify(Locals.Main.Empty)

        return
    end

    if tonumber(Search) then
        IsNumber = true
    end

    if string.len(Search) < 3 and not IsNumber then
        Config.ClientNotify(Locals.Player.AtLeast3)

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

        -- Steamname
        if string.match(string.upper(v.steam), UpperSearch) ~= nil then

            table.insert(Players, v)
            break
        end
    end

    if #Players == 0 then
        Config.ClientNotify(Locals.Player.NoPlayerFound)
    else
        Config.ClientNotify((Locals.Player.PlayerFound):format(tostring(#Players)))
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
            title = Locals.Player.Search,
            description = Locals.Player.SearchPlayer,
            icon = 'magnifying-glass',
            arrow = true,
            onSelect = function()
                OpenSearchPlayerDialog()
            end,
        }
    
        local Refresh = {
            title = Locals.Player.Refresh,
            description = Locals.Player.RefreshList,
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
                description = Locals.Main.ID .. ': ' .. xPlayer.source .. Locals.Player.Steam .. ' : ' .. xPlayer.steam,
                icon = 'user',
                arrow = true,
                onSelect = function()
                    OpenSinglePlayerMenu(xPlayer.source)
                end,
                metadata = {
                    {label = Locals.Player.Job, value = xPlayer.job.label},
                    {label = Locals.Player.Group, value = xPlayer.group}
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
        title = Locals.Main.AdminMenu,
        options =  {
            {
                title = Locals.Player.Ban,
                description = Locals.Player.BanPlayer,
                icon = 'user-doctor',
                arrow = true,
                onSelect = function()
                    if CanUseFunction('ban') then
                        if Config.UseBanMenu then
                            OpenPlayerBanMenu(PlayerID)
                        else
                            Config.ClientNotify(Locals.Ban.DontActive)
                        end
                    end
                end,
            },
            {
                title = Locals.Player.Inventory,
                description = Locals.Player.PlayerInventory,
                icon = 'boxes-stacked',
                arrow = true,
                onSelect = function()
                    if CanUseFunction('inventory') then
                        OpenPlayerInventory(PlayerID)
                    end
                end,
            },
            {
                title = Locals.Player.Weapon,
                description = Locals.Player.PlayerWeapons,
                icon = 'weapon',
                arrow = true,
                onSelect = function()
                    if CanUseFunction('pWeapon') then
                        OpenPlayerWeaponMenu(PlayerID)
                    end
                end, 
            },
            {
                title = Locals.Player.TakeScreenshot,
                description = Locals.Player.PlayerScreenshot,
                icon = 'weapon',
                arrow = true,
                onSelect = function()
                    if CanUseFunction('screenshot') then
                        TriggerServerEvent('admin_menu:server:TakePlayerScreenshot', PlayerID)
                    end
                end,
            },
            {
                title = Locals.Player.JobMenu,
                description = Locals.Player.PlayerJobMenu,
                icon = 'user-doctor',
                arrow = true,
                onSelect = function()
                    if CanUseFunction('job') then
                        OpenPlayerJobMenu(PlayerID)
                    end
                end,
            },
            {
                title = Locals.Player.SendMsg,
                description = Locals.Player.PlayerSendMsg,
                icon = 'message',
                arrow = true,
                onSelect = function()
                    if CanUseFunction('msg') then
                        OpenSendMSGPlayerDialog(PlayerID)
                    end
                end,
            },
            {
                title = Locals.Player.Kick,
                description = Locals.Player.PlayerKick,
                icon = 'message',
                arrow = true,
                onSelect = function()
                    if CanUseFunction('kick') then
                        KickPlayerDialog(PlayerID)
                    end
                end,
            },
            {
                title = Locals.Player.Kill,
                description =  Locals.Player.PlayerKill,
                icon = 'message',
                onSelect = function()
                    if CanUseFunction('pkill') then
                        TriggerServerEvent('admin_menu:server:KillPlayer', PlayerID)
                    end
                end,
            },
            {
                title = Locals.Player.Armor,
                description = Locals.Player.PlayerArmor,
                icon = 'message',
                onSelect = function()
                    if CanUseFunction('parmor') then
                        TriggerServerEvent('admin_menu:server:GiveArmorToPlayer', PlayerID)
                    end
                end,
            },
            {
                title =  Locals.Player.Money,
                description = Locals.Player.PlayerMoney,
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
        title = Locals.Player.BanMenu,
        options = {
            {
                title = Locals.Player.SpecificBan,
                description = Locals.Player.SpecificBanDesc,
                icon = 'money-bill',
                onSelect = function()
                    OpenPlayerBanDialog(PlayerID)
                end,
            },
            {
                title = Locals.Player.BanHour,
                description = Locals.Player.BanHourDesc,
                icon = 'money-check',
                onSelect = function()
                    OpenAddBanReasonDialog(PlayerID, Config.Times.hour)
                end,
            },
            {
                title = Locals.Player.BanDay,
                description = Locals.Player.BanDayDesc,
                icon = 'money-check',
                onSelect = function()
                    OpenAddBanReasonDialog(PlayerID, Config.Times.day)
                end,
            },
            {
                title = Locals.Player.BanWeek,
                description = Locals.Player.BanWeekDesc,
                icon = 'money-check',
                onSelect = function()
                    OpenAddBanReasonDialog(PlayerID, Config.Times.day * 7)
                end,
            },
            {
                title = Locals.Player.BanPerm,
                description = Locals.Player.BanPermDesc,
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
    local input = lib.inputDialog(Locals.Player.Ban, {
        {type = 'input', label = Locals.Player.Reason, description = Locals.Player.ReasonDesc, required = true, min = 3, max = 200},
      })

      local Reason = input[1]

      TriggerServerEvent('admin_menu:server:AddPlayerBan', Time, Reason, 'custom', PlayerID)
end

function OpenPlayerBanDialog(PlayerID)
    local input = lib.inputDialog(Locals.Player.Ban, {
        {type = 'date', label = Locals.Player.DateInput, icon = {'far', 'calendar'}, default = true, format = "DD/MM/YYYY"},
        {type = 'input', label = Locals.Player.Reason, description = Locals.Player.ReasonDesc, required = true, min = 3, max = 200},
      })

      local timestamp = math.floor(input[1] / 1000)
      local Reason = input[2]

      TriggerServerEvent('admin_menu:server:AddPlayerBan', timestamp, Reason, 'normal', PlayerID)
end

function OpenGivePlayerMoneyMenu(PlayerID)
    lib.registerContext({
        id = 'MoneyPlayerMenu',
        title = Locals.Player.MoneyMenu,
        options = {
            {
                title = Locals.Player.Money,
                description = Locals.Player.MoneyAdd,
                icon = 'money-bill',
                onSelect = function()
                    GiveMoneyToPlayerDialog('Hand', PlayerID)
                end,
            },
            {
                title = Locals.Player.MoneyBank,
                description = Locals.Player.MoneyAdd,
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
    local input = lib.inputDialog(Locals.Player.MoneyAdd, {
        {type = 'number', label = Locals.Player.MoneyName, description = Locals.Player.MoneyMuch, icon = 'hashtag'},
    })

    if not input then return end

    local Money = tonumber(input[1])

    if Money == nil then
        Config.ClientNotify(Locals.Player.MoneyEnterNumber)

        return
    end

    TriggerServerEvent('admin_menu:server:GiveMoneyToPlayer', Money, Type, PlayerID)
end

function OpenPlayerWeaponMenu(PlayerID)
    lib.registerContext({
        id = 'SinglePlayerWeaponMenu',
        title = Locals.Main.AdminMenu,
        options =  GetPlayerWeapon(PlayerID)
    })

    lib.showContext('SinglePlayerWeaponMenu')
end

function GetPlayerWeapon(PlayerID)
    local WeaponData = GetSinglePlayerData(PlayerID).loadout
    local Weapons = {}

    local Add = {
        title = Locals.Main.WeaponGive,
        description = Locals.Player.WeaponAddPlayer,
        icon = 'magnifying-glass',
        onSelect = function()
            OpenAddWeaponMenu(PlayerID)
        end,
    }

    local DelAll = {
        title = Locals.Player.WeaponDelAll,
        description = Locals.Player.WeaponDelAllDesc,
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
                    {label = Locals.Player.WeaponAmmu, value = v.ammo},
                    {label = Locals.Player.WeaponTintIndex, value = v.tintIndex}
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
        title = Locals.Player.WeaponAdd,
        options = GetAllGunsPlayer(PlayerID)
    })

    lib.showContext('WeaponListMenu')
end

function GetAllGunsPlayer(PlayerID)
    local Guns = {}

    local SpeedMenu =  {
        title = Locals.Player.WeaponQuickSelection,
        description = Locals.Player.WeaponDsec,
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
    local input = lib.inputDialog( Locals.Player.WeaponInfo .. ': ' .. WeaponLabel, {
        {type = 'input', label = Locals.Player.WeaponAmmu, description = Locals.Player.WeaponAmmuDesc, default= 250, required = true, min = 1, max = 600}
    })

    if not input then return end

    local Ammo = tonumber(input[1])

    if Ammo == nil then
        Config.ClientNotify(Locals.Player.WeaponEnterNumber)

        return
    end

    TriggerServerEvent('admin_menu:server:GiveWeaponToPlayer', WeaponName, Ammo, PlayerID)
end

function DeleteAllWeapons(PlayerID)
    local alert = lib.alertDialog({
        header = Locals.Player.WeaponDelAll,
        content = Locals.Player.WeaponDelAllSure .. '\nID: ' .. PlayerID,
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
        title = Locals.Player.Weapon .. ': ' .. WeaponLabel,
        options = {
            {
                title = Locals.Player.WeaponAdjustAmmunition,
                description = Locals.Player.WeaponAmmu .. ': ' .. Ammo,
                icon = 'plus',
                arrow = true,
                onSelect = function()
                    OpenUpdateAmmonationDialog(PlayerID, WeaponName, Ammo)
                end,
            },
            {
                title = Locals.Player.WeaponRemove,
                description = Locals.Player.WeaponRemoveDesc .. ' (' ..  WeaponLabel.. ')',
                icon = 'magnifying-glass',
                onSelect = function()
                    TriggerServerEvent('admin_menu:server:RemovePlayerWeapon', WeaponName, PlayerID)
                end,
            },
            {
                title = Locals.Player.WeaponAdjustComponent,
                description = Locals.Player.WeaponHasComponent .. ': ' .. #Components,
                icon = 'magnifying-glass',
                arrow = true,
                onSelect = function()
                    if #Components ~= 0 then
                        OpenWeaponComponentMenu(PlayerID, WeaponName, Components)
                    else
                        Config.ClientNotify(Locals.Player.WeaponNoComponent)
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
        title = Locals.Player.ComponentMenu,
        options = GetWeaponComponentsMenu(PlayerID, WeaponName, Components)
    })

    lib.showContext('WeaponComponentMenu')
end

function GetWeaponComponentsMenu(PlayerID, WeaponName, Components)
    local Comps = {}

    for k, v in pairs(Components) do
        local TmpTable = {
            title = Locals.Player.WeaponComponent .. ': ' .. v,
            description = Locals.Player.WeaponComponentRemove,
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
    local input = lib.inputDialog(Locals.Player.Weapon .. ': ' ..  ESX.GetWeaponLabel(WeaponName), {
        {type = 'input', label = Locals.Player.WeaponAmmu, description = Locals.Player.WeaponAmmuDesc, default = Ammo, required = true, min = 1, max = 1000}
    })

    if not input then return end      
    
    local Count = tonumber(input[1])

    TriggerServerEvent('admin_menu:server:UpdatePlayerAmmo', WeaponName, Count, Ammo, PlayerID)
end

function KickPlayerDialog(PlayerID)
    local input = lib.inputDialog(Locals.Player.KickPlayer, {
        {type = 'input', label = Locals.Main.Message, description = Locals.Player.KickDesc, required = true, min = 1, max = 1000}
    })

    if not input then return end
    
    local MSG = input[1]
    
    if MSG == '' or MSG == ' ' then
        Config.ClientNotify(Locals.Main.Empty)

        return
    end

    TriggerServerEvent('admin_menu:server:KickPlayer', MSG, PlayerID)
end

function OpenSendMSGPlayerDialog(PlayerID)

    local input = lib.inputDialog(Locals.Player.SendMessage, {
        {type = 'input', label = Locals.Main.Message, description = Locals.Player.PrivateMessage, required = true, min = 1, max = 1000}
    })

    if not input then return end      
    
    local MSG = input[1]
    
    if MSG == '' or MSG == ' ' then 
        Config.ClientNotify(Locals.Main.Empty)

        return
    end

    TriggerServerEvent('admin_menu:server:SendPrivateMessage', MSG, PlayerID)
end

function OpenPlayerJobMenu(PlayerID)
    local JobData = GetSinglePlayerData(PlayerID).job

    lib.registerContext({
        id = 'JobMenu',
        title = Locals.Player.JobName .. ': ' .. JobData.name ..  Locals.Player.JobGrade.. ': ' .. JobData.grade,
        options = {
            {
                title = Locals.Player.JobChange,
                description = Locals.Player.JobChange .. ': ' .. JobData.name,
                icon = 'user-doctor',
                arrow = true,
                onSelect = function()
                    OpenUpdateJobDialog(PlayerID)
                end,
            },
            {
                title = Locals.Player.JobReset,
                description = Locals.Player.JobResetDesc,
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

    local input = lib.inputDialog(Locals.Player.JobChange, {
        {type = 'input', label = Locals.Player.JobName, description = JobData.name, default = JobData.name, required = true, min = 1, max = 600},
        {type = 'number', label = Locals.Player.JobGrade, default = JobData.grade, icon = 'hashtag'},
    })

    if not input then return end      
    
    local JobName = string.lower(input[1])
    local JobGrade = tonumber(input[2])

    TriggerServerEvent('admin_menu:server:UpdatePlayerJob', JobName, JobGrade, PlayerID)
end

function OpenPlayerInventory(PlayerID)
    lib.registerContext({
        id = 'SinglePlayerInventarMenu',
        title = Locals.Main.AdminMenu,
        options =  GetInventoryItem(PlayerID)
    })

    lib.showContext('SinglePlayerInventarMenu')
end

function AddNewItemToPlayer(PlayerID)
    local input = lib.inputDialog(Locals.Player.ItemAdd, {
        {type = 'input', label = Locals.Player.ItemName, description = Locals.Player.Item, required = true, min = 1, max = 600},
        {type = 'number', label = Locals.Player.ItemCount, description = Locals.Player.ItemMuch, default = 1, icon = 'hashtag'},
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
        title = Locals.Player.ItemAdd,
        description = Locals.Player.ItemAddDesc,
        icon = 'magnifying-glass',
        onSelect = function()
            AddNewItemToPlayer(PlayerID)
        end,
    }

    local DelAll = {
        title = Locals.Player.ItemDellAll,
        description = Locals.Player.ItemDellAllDesc,
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
                    {label = Locals.Player.ItemCount, value = v.count},
                    {label = Locals.Player.ItemMax, value = v.count * v.weight},
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
        title = Locals.Player.Item .. ': ' .. ItemName,
        options = {
            {
                title = Locals.Player.ItemAdd,
                description = Locals.Player.ItemAddDesc .. ' (' ..  ItemLabel.. ')',
                icon = 'plus',
                arrow = true,
                onSelect = function()
                    AddItemToPlayer(PlayerID, ItemName, ItemLabel)
                end,
            },
            {
                title = Locals.Player.ItemDellAll,
                description = Locals.Player.ItemDellAllDesc .. ' (' ..  ItemLabel.. ')',
                icon = 'magnifying-glass',
                onSelect = function()
                    TriggerServerEvent('admin_menu:server:RemoveItem', ItemName, ItemCount, PlayerID, true)
                end,
            },
            {
                title = Locals.Player.ItemOnlySingle,
                description = Locals.Player.ItemOnlySingleDesc .. ' (' ..  ItemLabel.. ')',
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
        header = Locals.Player.ItemDellAll,
        content = Locals.Player.ItemDelAllDia .. ' \nID: ' .. PlayerID,
        centered = true,
        cancel = true
    })
     
    if alert == 'confirm' then
        TriggerServerEvent('admin_menu:server:RemoveAllPlayerItems', PlayerID)
    end
end

function RemovePlayerItems(PlayerID, ItemName, ItemLabel)
    local input = lib.inputDialog(Locals.Player.ItemRemove .. ': ' .. ItemLabel, {
        {type = 'input', label = Locals.Player.Item, description = Locals.Player.Item, disabled = true, default = ItemName, required = true, min = 1, max = 600},
        {type = 'number', label = Locals.Player.ItemCount, description = Locals.Player.ItemMuch, default = 1, icon = 'hashtag'},
    })

    if not input then return end      
    
    local Count = input[2]

    TriggerServerEvent('admin_menu:server:RemoveItem', ItemName, Count, PlayerID, false)
end

function AddItemToPlayer(PlayerID, ItemName, ItemLabel)
    local input = lib.inputDialog(Locals.Player.ItemAdd .. ': ' .. ItemLabel, {
        {type = 'input', label = Locals.Player.Item, description = Locals.Player.Item, disabled = true, default = ItemName, required = true, min = 1, max = 600},
        {type = 'number', label = Locals.Player.ItemCount, description = Locals.Player.ItemMuch, default = 1, icon = 'hashtag'},
    })

    if not input then return end

    local ItemName = input[1]
    local Count = tonumber(input[2])

    TriggerServerEvent('admin_menu:server:GiveItem', ItemName, Count, PlayerID)
end