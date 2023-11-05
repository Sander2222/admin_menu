--- @usage This function checks if the player is able to use the adminmenu
--- @param Player integer If from the player
--- @param DoAction boolean If this is true then the player get kicked when he doenst have a admin role
function CheckGroup(Player, DoAction)
    local xPlayer = ESX.GetPlayerFromId(Player)
    local PlayerGroup = xPlayer.getGroup()

    if Config.Groups[PlayerGroup] then
        return true
    end

    if DoAction then
        xPlayer.kick(Locals.Server.NoGroup)
        AddWebhookMessage(Player, nil, Locals.Server.PlayerInjection, 'self', {})
    end

    return false
end

RegisterNetEvent('admin_menu:server:SendWebhook')
AddEventHandler('admin_menu:server:SendWebhook',function(msg, type, Data)
    AddWebhookMessage(source, nil, type, Data)
end)

function AddWebhookMessage(AdminID, Target, msg, type, Data)
    if CheckGroup(AdminID, false) then
        if type == 'self' then
            local msg = msg

            if #Data ~= 0 then

                msg = msg .. '\n\n **' .. Locals.Server.Data .. ':** \n'

                for k, v in pairs(Data) do
                    msg = msg .. v .. '\n'
                end
            end

            msg = msg .. '\n\n **' .. Locals.Server.PlayerInfo .. ':** \n' .. GetPlayerFootprints(AdminID)

            SendDiscord(msg)
        elseif type == 'player' and Target ~= nil then
            local msg = msg

            if #Data ~= 0 then

                msg = msg .. '\n\n **'.. Locals.Server.Data .. ':** \n'

                for k, v in pairs(Data) do
                    msg = msg .. v .. '\n'
                end
            end

            msg = msg .. '\n\n **' .. Locals.Server.AdminInfo .. ':** \n' .. GetPlayerFootprints(AdminID)


            msg = msg .. '\n\n **' .. Locals.Server.PlayerInfo .. ':** \n' .. GetPlayerFootprints(Target)

            SendDiscord(msg)
        end
    end
end

RegisterNetEvent('admin_menu:server:KillPlayer')
AddEventHandler('admin_menu:server:KillPlayer',function(Target)
    if CheckGroup(source, true) then
        TriggerClientEvent('esx:killPlayer', Target)

        AddWebhookMessage(source, Target, Locals.Server.AdminKillPlayer, 'player', {'Target ID: ' .. tostring(Target)})
    end
end)

RegisterNetEvent('admin_menu:server:GiveArmorToPlayer')
AddEventHandler('admin_menu:server:GiveArmorToPlayer',function(Target)
    if CheckGroup(source, true) then
        local Ped = GetPlayerPed(Target)

        SetPedArmour(Ped, 100)

        AddWebhookMessage(source, Target, Locals.Server.AdminArmorPlayr, 'player', {'Target ID: ' .. tostring(Target)})
    end
end)

RegisterNetEvent('admin_menu:server:RemoveWeaponComponent')
AddEventHandler('admin_menu:server:RemoveWeaponComponent',function(Target, WeaponName, Component)
    if CheckGroup(source, true) then
        local xTarget = ESX.GetPlayerFromId(Target)

        if xTarget.hasWeaponComponent(string.upper(WeaponName), Component) then
            xTarget.removeWeaponComponent(string.upper(WeaponName), Component)
            AddWebhookMessage(source, Target, Locals.ser.AdminRemoveCompPlayer, 'player', {'Weapon: ' .. WeaponName, 'Component: ' .. Component})
            Config.ServerNotify(Target, Locals.Server.AdminRemoveCompPlayerNotifyTarget .. ': ' .. Component)
        else
            Config.ServerNotify(source, Locals.Server.AdminRemoveCompPlayerNotifyAdmin)
        end
    end
end)

RegisterNetEvent('admin_menu:server:KickPlayer')
AddEventHandler('admin_menu:server:KickPlayer',function(msg, Target)
    if CheckGroup(source, true) then
        local xTarget = ESX.GetPlayerFromId(Target)

        if xTarget ~= nil then
            xTarget.kick(Locals.Server.ServerKick .. ': ' ..msg)
            AddWebhookMessage(source, Target, Locals.Server.AdminKickPlayer, 'player', {'Message: ' .. msg})

        else 
            Config.ServerNotify(source, Locals.Server.AdminKickPlayerAdmin)
        end
    end
end)

RegisterNetEvent('admin_menu:server:GiveWeaponToPlayer')
AddEventHandler('admin_menu:server:GiveWeaponToPlayer',function(WeaponName, Ammo, Target)
    if CheckGroup(source, true) then
        local xTarget = ESX.GetPlayerFromId(Target)

        if not xTarget.hasWeapon(string.upper(WeaponName)) then
            xTarget.addWeapon(string.upper(WeaponName), Ammo)
            Config.ServerNotify(Target, Locals.Server.AdminGiveWeaponPlayerTarget ..': ' .. ESX.GetWeaponLabel(string.upper(WeaponName)))

            AddWebhookMessage(source, Target, Locals.Server.AdminGiveWeaponPlayer, 'player', {'Weapon: ' .. WeaponName, 'Ammu: ' .. Ammo})
        else
            Config.ServerNotify(source, Locals.Server.AdminGiveWeaponPlayerAdmin)
        end

    end
end)

RegisterNetEvent('admin_menu:server:GiveWeapon')
AddEventHandler('admin_menu:server:GiveWeapon',function(Weapon, Ammo)
    if CheckGroup(source, true) then
        local xPlayer = ESX.GetPlayerFromId(source)

        xPlayer.addWeapon(string.upper(Weapon), Ammo)
        AddWebhookMessage(source, nil, Locals.Server.AdminGiveWeaponSelf, 'self', {'Weapon: ' .. Weapon, 'Ammu: ' .. Ammo})
    end
end)

RegisterNetEvent('admin_menu:server:UpdatePlayerAmmo')
AddEventHandler('admin_menu:server:UpdatePlayerAmmo',function(Weapon, Ammo, BasicAmmo, Target)
    if CheckGroup(source, true) then
        local xTarget = ESX.GetPlayerFromId(source)

        xTarget.removeWeaponAmmo(string.upper(Weapon), BasicAmmo)
        xTarget.addWeaponAmmo(string.upper(Weapon), Ammo)
        
        AddWebhookMessage(source, Target, Locals.Server.AdminUpdateAmmuPlayer, 'player', {'Weapon: ' .. Weapon, 'Ammu: ' .. Ammo})
    end
end)

RegisterNetEvent('admin_menu:server:RemovePlayerWeapon')
AddEventHandler('admin_menu:server:RemovePlayerWeapon',function(Weapon, Target)
    if CheckGroup(source, true) then
        local xTarget = ESX.GetPlayerFromId(source)

        xTarget.removeWeapon(string.upper(Weapon))
        Config.ServerNotify(Target, Locals.Server.AdminRemoveWeaponTarget .. ': ' .. ESX.GetWeaponLabel(Weapon))
        AddWebhookMessage(source, Target, Locals.Server.AdminRemoveWeapon, 'player', {'Weapon: ' .. Weapon})
    end
end)

RegisterNetEvent('admin_menu:server:SendPrivateMessage')
AddEventHandler('admin_menu:server:SendPrivateMessage',function(MSG, Target)
    if CheckGroup(source, true) then

        Config.ServerNotify(Target, MSG)
        Config.ServerNotify(source, Locals.Server.AdminPrivateMSGAdmin)
        AddWebhookMessage(source, Target, Locals.Server.AdminPrivateMSG, 'player', {'Message: ' .. MSG})
    end
end)

RegisterNetEvent('admin_menu:server:UpdatePlayerJob')
AddEventHandler('admin_menu:server:UpdatePlayerJob',function(JobName, Grade, Target)
    if CheckGroup(source, true) then
        local xTarget = ESX.GetPlayerFromId(Target)

        if ESX.DoesJobExist(string.lower(JobName), Grade)  then
            xTarget.setJob(JobName, tonumber(Grade))
            Config.ServerNotify(Target, Locals.Server.AdminUpdateJobPlayerTarget)
            AddWebhookMessage(source, Target, Locals.Server.AdminUpdateJobPlayer, 'player', {'new Job: ' .. JobName, 'Grade: ' .. Grade})
        else
            Config.ServerNotify(source, Locals.Server.AdminUpdateJobPlayerAdmin)
        end
    end
end)

RegisterServerEvent('admin_menu:server:RemoveAllPlayerWeapons')
AddEventHandler('admin_menu:server:RemoveAllPlayerWeapons', function(Target)
    if CheckGroup(source, true) then
        local xTarget = ESX.GetPlayerFromId(Target)
        local PlayerWeapons = xTarget.getLoadout()
        local msg = ''

        if #PlayerWeapons == 0 then
            Config.ServerNotify(source, Locals.Server.AdminRemoveAllWeaponAdmin)
            return
        end
        
        for k, v in ipairs(PlayerWeapons) do
            xTarget.removeWeapon(v.name)
            msg = msg .. v.name .. ', '
        end

        Config.ServerNotify(Target, Locals.Server.AdminRemoveAllWeaponTarget)

        AddWebhookMessage(source, Target, Locals.Server.AdminRemoveAllWeapon, 'player', {'Weapons: ' .. msg})
    end
end)

RegisterNetEvent('admin_menu:server:RemoveAllPlayerItems')
AddEventHandler('admin_menu:server:RemoveAllPlayerItems',function(Target)
    if CheckGroup(source, true) then
        local xTarget = ESX.GetPlayerFromId(Target)
        local TargetInventory = xTarget.getInventory(true)
        local msg = ''

        if #TargetInventory == 0 then
            Config.ServerNotify(source, Locals.Server.AdminRemoveAllItemAdmin)
            
            return
        end

        for k, v in pairs(TargetInventory) do
            xTarget.removeInventoryItem(k, v)

            msg = msg .. k .. '(Count: ' .. v ..'), '
        end

        Config.ServerNotify(Target, Locals.Server.AdminRemoveAllItemTarget)
        AddWebhookMessage(source, Target, Locals.Server.AdminRemoveAllItem, 'player', {'Items: ' .. msg})
    end
end)

RegisterNetEvent('admin_menu:server:GiveMoney')
AddEventHandler('admin_menu:server:GiveMoney',function(Money, Type)
    if CheckGroup(source, true) then
        local xPlayer = ESX.GetPlayerFromId(source)

        if Type == 'Hand' then
            xPlayer.addMoney(Money)
            Config.ServerNotify(source, (Locals.Server.AdminGiveMoneyAdmin):format(tostring(Money)))
        elseif Type == 'Bank' then
            xPlayer.addAccountMoney('bank', Money)
            Config.ServerNotify(source, (Locals.Server.AdminGiveMoneyAdmin):format(tostring(Money)))
        end
        AddWebhookMessage(source, nil, Locals.Server.AdminGiveMoney, 'self', {'Count: ' .. Money, 'Type: ' ..Type})
    end
end)

RegisterNetEvent('admin_menu:server:GiveMoneyToPlayer')
AddEventHandler('admin_menu:server:GiveMoneyToPlayer',function(Money, Type, Target)
    if CheckGroup(source, true) then
        local xTarget = ESX.GetPlayerFromId(Target)

        if Type == 'Hand' then
            xTarget.addMoney(Money)
            Config.ServerNotify(Target, (Locals.Server.AdminGiveMoneyPlayerTarget):format(tostring(Money)))
        elseif Type == 'Bank' then
            xTarget.addAccountMoney('bank', Money)
            Config.ServerNotify(Target, (Locals.Server.AdminGiveMoneyPlayerTarget):format(tostring(Money)))
        end

        AddWebhookMessage(source, Target, Locals.Server.AdminGiveMoneyPlayer, 'player', {'Count: ' .. Money, 'Type: ' ..Type})
    end
end)

RegisterNetEvent('admin_menu:server:GiveItem')
AddEventHandler('admin_menu:server:GiveItem',function(ItemName, Count, Target)
    if CheckGroup(source, true) then

        if Target == nil then
            local xPlayer = ESX.GetPlayerFromId(source)

            if xPlayer.canCarryItem(ItemName, Count) then
                xPlayer.addInventoryItem(ItemName, Count)
                AddWebhookMessage(source, nil, Locals.Server.AdminGiveItem, 'self', {'Item: ' .. ItemName, 'Count: ' .. Count})
            else 
                Config.ServerNotify(source, Locals.Server.CantCarry)
            end
        else
            local xTarget = ESX.GetPlayerFromId(Target)

            if xTarget.canCarryItem(ItemName, Count) then
                xTarget.addInventoryItem(ItemName, Count)
                AddWebhookMessage(source, Target, Locals.Server.AdminGiveItem, 'player', {'Item: ' .. ItemName, 'Count: ' .. Count})
            else 
                Config.ServerNotify(source, Locals.Server.CantCarry)
            end
        end
    end
end)

RegisterNetEvent('admin_menu:server:DelAllVehicles')
AddEventHandler('admin_menu:server:DelAllVehicles',function()
    local source = source
    if CheckGroup(source, true) then
        Vehicles = GetAllVehicles()

        for k, Vehicle in pairs(Vehicles) do
            DeleteEntity(Vehicle)
        end

        Config.ServerNotify(source, (Locals.Server.AdminDelAllVehiclesAdmin):format(tostring(#Vehicles)))
        AddWebhookMessage(source, nil, Locals.Server.AdminDelAllVehicles, 'self', {})
    end
end)

RegisterNetEvent('admin_menu:server:RemoveItem')
AddEventHandler('admin_menu:server:RemoveItem',function(ItemName, Count, Target, All)
    if CheckGroup(source, true) then
        local xTarget = ESX.GetPlayerFromId(Target)

        xTarget.removeInventoryItem(ItemName, Count)
        if All then
            AddWebhookMessage(source, Target, Locals.Server.AdminRemoveAlltemPlayer, 'player', {'Item: ' .. ItemName, 'Count: ' .. Count})
        else
            AddWebhookMessage(source, Target,  Locals.Server.AdminRemoveItemPlayer, 'player', {'Item: ' .. ItemName, 'Count: ' .. Count})
        end
    end
end)

RegisterNetEvent('admin_menu:server:DeletePlayerVehicle')
AddEventHandler('admin_menu:server:DeletePlayerVehicle',function(Plate, DeleteIngame)
    if CheckGroup(source, true) then
        local source = source
        local Plate = string.upper(Trim(Plate))

        MySQL.query('SELECT owner FROM owned_vehicles WHERE plate = ?', {Plate}, function(response)
            if #response ~= 0 then
                MySQL.update('DELETE FROM owned_vehicles WHERE owner = ? AND plate = ?', {response[1].owner, Plate}, function(affectedRows)
                    if affectedRows then
                        if DeleteIngame then
                            Vehicles = GetAllVehicles()

                            for k, Vehicle in pairs(Vehicles) do
                                if GetVehicleNumberPlateText(Vehicle) == Plate then
                                    DeleteEntity(Vehicle)
                                end
                            end

                            local xTarget = ESX.GetPlayerFromIdentifier(response[1].owner)

                            if xTarget then
                                Config.ServerNotify(xTarget.playerId, (Locals.Server.AdminRemoveVehiclePlayerTarget):format(Plate))
                                AddWebhookMessage(source, xTarget.playerId, Locals.Server.AdminRemoveVehiclePlayer, 'player', {'Target license: ' .. response[1].owner, 'Plate: ' .. Plate})
                            else
                                AddWebhookMessage(source, xTarget.playerId, Locals.Server.AdminRemoveVehiclePlayer, 'player', {'Target license: ' .. response[1].owner, 'Plate: ' .. Plate})
                            end
                        end
                    end
                end)
            else
                Config.ServerNotify(source, Locals.Server.VehicleDoenstExist)
            end
        end)
    end
end)

RegisterNetEvent('admin_menu:server:AddVehicleToPlayer')
AddEventHandler('admin_menu:server:AddVehicleToPlayer', function (vehicleProps, Target)
    local source = source
    if CheckGroup(source, true) then

        if not CheckIfPlayerIsOnline(Target) then
            Config.ServerNotify(source, Locals.Server.IDDoenstExist)
            return
        end

        function InsertVehicleInDB(Target)
            local xTarget = ESX.GetPlayerFromId(Target)

            MySQL.Async.execute('INSERT INTO owned_vehicles (owner, plate, vehicle) VALUES (@owner, @plate, @vehicle)',
            {
                ['@owner']   = xTarget.identifier,
                ['@plate']   = vehicleProps.plate,
                ['@vehicle'] = json.encode(vehicleProps)
            }, function (rowsChanged)
                if Target ~= source then
                    Config.ServerNotify(Target, Locals.Server.AdminGiveVehiclePlayerTarget)
                    Config.ServerNotify(source, Locals.Server.AdminGiveVehiclePlayerAdmin)

                    AddWebhookMessage(source, Target, Locals.Server.AdminGiveVehiclePlayer, 'player', {'Target ID: ' .. tostring(Target), 'Plate: ' .. vehicleProps.plate})
                else
                    AddWebhookMessage(source, nil, Locals.Server.AdminGiveVehicle, 'self', {'Plate: ' .. vehicleProps.plate})
                end
            end)
        end

        if Target ~= nil then
            InsertVehicleInDB(Target)
        else 
            InsertVehicleInDB(source)
        end
    end
end)

RegisterServerEvent('admin_menu:server:TakePlayerScreenshot')
AddEventHandler('admin_menu:server:TakePlayerScreenshot', function(Target)
    if CheckGroup(source, true) then
        AddWebhookMessage(source, Target, Locals.Server.AdminTookScreenshot, 'player', {})

        TriggerClientEvent('admin_menu:client:TakeScreenshot', Target, SVConfig.Webhooks)
    end
end)

RegisterServerEvent('admin_menu:server:SendAnnounce')
AddEventHandler('admin_menu:server:SendAnnounce', function(Message)
    if CheckGroup(source, true) then
        Config.SendAnnounce(source, Message)

        AddWebhookMessage(source, nil, Locals.Server.AdminAnnounce, 'self', {'Message: ' .. Message})
    end
end)

RegisterServerEvent('admin_menu:server:ReviveAllPlayer')
AddEventHandler('admin_menu:server:ReviveAllPlayer', function()
    if CheckGroup(source, true) then
        TriggerClientEvent('esx_ambulancejob:revive', -1)

        AddWebhookMessage(source, nil, Locals.Server.AdminRevivedAll, 'self', {})
    end
end)

function CheckIfPlayerIsOnline(Target)
    local xPlayers = ESX.GetExtendedPlayers()

    for _, xPlayer in pairs(xPlayers) do
        if xPlayer.source == Target then
            return true
        end
    end

    return false
end

function GetPlayerFootprints(Player)
    local Footer = ''

    Footer = Footer .. 'Steamname: ' ..GetPlayerName(Player) .. '\n'

  for _, v in pairs(GetPlayerIdentifiers(Player))do
        
      if string.sub(v, 1, string.len("steam:")) == "steam:" then
        Footer = Footer .. 'Steam: ' ..v .. '\n'
      elseif string.sub(v, 1, string.len("license:")) == "license:" then
        Footer = Footer .. 'license: ' ..v .. '\n'
      elseif string.sub(v, 1, string.len("xbl:")) == "xbl:" then
        Footer = Footer .. 'xbl: ' ..v .. '\n'
      elseif string.sub(v, 1, string.len("ip:")) == "ip:" then
        Footer = Footer .. 'ip: ' ..v .. '\n'
      elseif string.sub(v, 1, string.len("discord:")) == "discord:" then
        Footer = Footer .. 'discord: ' ..v .. '\n'
      elseif string.sub(v, 1, string.len("live:")) == "live:" then
        Footer = Footer .. 'live: ' ..v .. '\n'
      end
  end

  return Footer
end

function SendDiscord(message)
    local embed = {
          {
              ["color"] = 134,
              ["title"] = 'Logs',
              ["description"] = message,
              ["footer"] = {
                  ["text"] = 'logs',
              },
          }
      }
    PerformHttpRequest(SVConfig.Webhooks, function(err, text, headers) end, 'POST', json.encode({username = name, embeds = embed}), { ['Content-Type'] = 'application/json' })
end

-- Deletes all spaces
function Trim(str)

    str = string.gsub(str, "^%s+", "")
    str = string.gsub(str, "%s+$", "")
    
    return str
end