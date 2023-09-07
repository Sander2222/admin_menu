--- @usage This function checks if the player is able to use the adminmenu
function CheckGroup(Player, DoAction)
    local xPlayer = ESX.GetPlayerFromId(Player)
    local PlayerGroup = xPlayer.getGroup()

    if Config.Groups[PlayerGroup] then
        return true
    end

    if DoAction then
        print("Kick Player Modder")
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

                msg = msg .. '\n\n **Data:** \n'

                for k, v in pairs(Data) do
                    msg = msg .. v .. '\n'
                end
            end

            msg = msg .. '\n\n **Player Info:** \n' .. GetPlayerFootprints(AdminID)

            SendDiscord(msg)
        elseif type == 'player' then
            local msg = msg

            if #Data ~= 0 then

                msg = msg .. '\n\n **Data:** \n'

                for k, v in pairs(Data) do
                    msg = msg .. v .. '\n'
                end
            end

            msg = msg .. '\n\n **Admin Info:** \n' .. GetPlayerFootprints(AdminID)


            msg = msg .. '\n\n **Player Info:** \n' .. GetPlayerFootprints(Target)

            SendDiscord(msg)
        end
    end
end

RegisterNetEvent('admin_menu:server:KillPlayer')
AddEventHandler('admin_menu:server:KillPlayer',function(Target)
    if CheckGroup(source, true) then
        TriggerClientEvent('esx:killPlayer', Target)
    end
end)

RegisterNetEvent('admin_menu:server:GiveArmorToPlayer')
AddEventHandler('admin_menu:server:GiveArmorToPlayer',function(Target)
    if CheckGroup(source, true) then
        local Ped = GetPlayerPed(Target)

        SetPedArmour(Ped, 100)
    end
end)

RegisterNetEvent('admin_menu:server:RemoveWeaponComponent')
AddEventHandler('admin_menu:server:RemoveWeaponComponent',function(Target, WeaponName, Component)
    if CheckGroup(source, true) then
        local xTarget = ESX.GetPlayerFromId(Target)

        if xTarget.hasWeaponComponent(string.upper(WeaponName), Component) then
            xTarget.removeWeaponComponent(string.upper(WeaponName), Component)
            AddWebhookMessage(source, Target, 'Ein Admin hat von einem Spieler eine Waffen Componente entfernt', 'player', {'Weapon: ' .. WeaponName, 'Component: ' .. Component})
            Config.ServerNotify(Target, 'Ein Admin hat die eine Waffen Componente entfernt: ' .. Component)
        else
            Config.ServerNotify(source, 'Der Spieler hat diese Componente nicht')
        end
    end
end)

RegisterNetEvent('admin_menu:server:KickPlayer')
AddEventHandler('admin_menu:server:KickPlayer',function(msg, Target)
    if CheckGroup(source, true) then
        local xTarget = ESX.GetPlayerFromId(Target)

        if xTarget ~= nil then
            xTarget.kick('Server Kick: ' ..msg)
            AddWebhookMessage(source, Target, 'Ein Admin hat einen Spieler gekickt', 'player', {'Message: ' .. msg})

        else 
            Config.ServerNotify(source, 'Dieser Spieler ist nicht online')
        end
    end
end)

RegisterNetEvent('admin_menu:server:GiveWeaponToPlayer')
AddEventHandler('admin_menu:server:GiveWeaponToPlayer',function(WeaponName, Ammo, Target)
    if CheckGroup(source, true) then
        local xTarget = ESX.GetPlayerFromId(Target)

        print(WeaponName)
        if not xTarget.hasWeapon(string.upper(WeaponName)) then
            xTarget.addWeapon(string.upper(WeaponName), Ammo)
            Config.ServerNotify(Target, 'Ein Admin hat dir eine Waffe gegeben: ' .. ESX.GetWeaponLabel(string.upper(WeaponName)))
        else
            Config.ServerNotify(source, 'Der Spieler hat diese Waffe schon')
        end

        AddWebhookMessage(source, Target, 'Ein Admin hat einem anderen Spieler eine Waffe gegeben', 'player', {'Weapon: ' .. WeaponName, 'Ammu: ' .. Ammo})
    end
end)

RegisterNetEvent('admin_menu:server:GiveWeapon')
AddEventHandler('admin_menu:server:GiveWeapon',function(Weapon, Ammo)
    if CheckGroup(source, true) then
        local xPlayer = ESX.GetPlayerFromId(source)

        xPlayer.addWeapon(string.upper(Weapon), Ammo)
        AddWebhookMessage(source, nil, 'Ein Admin hat sich eine Waffe gegeben', 'self', {'Weapon: ' .. Weapon, 'Ammu: ' .. Ammo})
    end
end)

RegisterNetEvent('admin_menu:server:UpdatePlayerAmmo')
AddEventHandler('admin_menu:server:UpdatePlayerAmmo',function(Weapon, Ammo, BasicAmmo, Target)
    if CheckGroup(source, true) then
        local xTarget = ESX.GetPlayerFromId(source)

        xTarget.removeWeaponAmmo(string.upper(Weapon), BasicAmmo)
        xTarget.addWeaponAmmo(string.upper(Weapon), Ammo)
        
        AddWebhookMessage(source, Target, 'Ein Admin hat von einem Spieler seiner Waffe die Munition geupdated', 'player', {'Weapon: ' .. Weapon, 'Ammu: ' .. Ammo})
    end
end)

RegisterNetEvent('admin_menu:server:RemovePlayerWeapon')
AddEventHandler('admin_menu:server:RemovePlayerWeapon',function(Weapon, Target)
    if CheckGroup(source, true) then
        local xTarget = ESX.GetPlayerFromId(source)

        
        xTarget.removeWeapon(string.upper(Weapon))
        Config.ServerNotify(Target, 'Ein Admin hat dir eine Waffe entzogen: ' .. ESX.GetWeaponLabel(Weapon))
        AddWebhookMessage(source, Target, 'Ein Admin hat einem Spieler eine Waffe entfernt', 'player', {'Weapon: ' .. Weapon})
    end
end)

RegisterNetEvent('admin_menu:server:SendPrivateMessage')
AddEventHandler('admin_menu:server:SendPrivateMessage',function(MSG, Target)
    if CheckGroup(source, true) then

        Config.ServerNotify(Target, MSG)
        Config.ServerNotify(source, 'Nachricht wurde geschickt')
        AddWebhookMessage(source, Target, 'Ein Admin hat einem anderen Spieler eine Nachricht geschickt', 'player', {'Message: ' .. MSG})
    end
end)

RegisterNetEvent('admin_menu:server:UpdatePlayerJob')
AddEventHandler('admin_menu:server:UpdatePlayerJob',function(JobName, Grade, Target)
    if CheckGroup(source, true) then
        local xTarget = ESX.GetPlayerFromId(Target)

        if ESX.DoesJobExist(string.lower(JobName), Grade)  then
            xTarget.setJob(JobName, tonumber(Grade))
            Config.ServerNotify(Target, 'Dein Job wurde zurückgesetzt')
            AddWebhookMessage(source, Target, 'Ein Admin hat von einem Spieler den Job geändert', 'player', {'Neuer Job: ' .. JobName, 'Neuer Jobgrade: ' .. Grade})
        else
            Config.ServerNotify(source, 'Dein angegebener Job existiert nicht')
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
            Config.ServerNotify(source, 'Der Spieler hat keine Waffen')
            return
        end
        
        for k, v in ipairs(PlayerWeapons) do
            xTarget.removeWeapon(v.name)
            msg = msg .. v.name .. ', '
        end

        Config.ServerNotify(Target, 'Dir wurden alle deine Waffen entfernt')

        AddWebhookMessage(source, Target, 'Ein Admin hat einem Spieler alle Waffen entfernt', 'player', {'Waffen: ' .. msg})
    end
end)

RegisterNetEvent('admin_menu:server:RemoveAllPlayerItems')
AddEventHandler('admin_menu:server:RemoveAllPlayerItems',function(Target)
    if CheckGroup(source, true) then
        local xTarget = ESX.GetPlayerFromId(Target)
        local TargetInventory = xTarget.getInventory(true)
        local msg = ''

        if #TargetInventory == 0 then
            Config.ServerNotify(source, 'Der Spieler hat keine Items im Inventar')
            
            return
        end

        for k, v in pairs(TargetInventory) do
            xTarget.removeInventoryItem(k, v)

            msg = msg .. k .. '(Count: ' .. v ..'), '
        end

        AddWebhookMessage(source, Target, 'Ein Admin hat einem das ganze Inventar entfernt', 'player', {'Items: ' .. msg})
    end
end)

RegisterNetEvent('admin_menu:server:GiveMoney')
AddEventHandler('admin_menu:server:GiveMoney',function(Money, Type)
    if CheckGroup(source, true) then
        local xPlayer = ESX.GetPlayerFromId(source)

        if Type == 'Hand' then
            xPlayer.addMoney(Money)
            Config.ServerNotify(source, 'Du hast dir ' .. tostring(Money).. '$ gegeben')
        elseif Type == 'Bank' then
            xPlayer.addAccountMoney('bank', Money)
            Config.ServerNotify(source, 'Du hast dir ' .. tostring(Money).. '$ gegeben')
        end
        AddWebhookMessage(source, nil, 'Ein Admin hat sich Bargeld gegeben', 'self', {'Count: ' .. Money, 'Type: ' ..Type})
    end
end)

RegisterNetEvent('admin_menu:server:GiveMoneyToPlayer')
AddEventHandler('admin_menu:server:GiveMoneyToPlayer',function(Money, Type, Target)
    if CheckGroup(source, true) then
        local xTarget = ESX.GetPlayerFromId(Target)

        if Type == 'Hand' then
            xTarget.addMoney(Money)
            Config.ServerNotify(Target, 'Dir wurden ' .. tostring(Money).. '$ gegeben')
        elseif Type == 'Bank' then
            xTarget.addAccountMoney('bank', Money)
            Config.ServerNotify(Target, 'Dir wurden ' .. tostring(Money).. '$ gegeben')
        end

        AddWebhookMessage(source, Target, 'Ein Admin hat einem Spieler geld gegeben', 'player', {'Count: ' .. Money, 'Type: ' ..Type})
    end
end)

RegisterNetEvent('admin_menu:server:GiveItem')
AddEventHandler('admin_menu:server:GiveItem',function(ItemName, Count, Target)
    if CheckGroup(source, true) then

        if Target == nil then
            local xPlayer = ESX.GetPlayerFromId(source)

            if xPlayer.canCarryItem(ItemName, Count) then
                xPlayer.addInventoryItem(ItemName, Count)
                AddWebhookMessage(source, nil, 'Ein Admin hat sich ein Item gegeben', 'self', {'Item: ' .. ItemName, 'Count: ' .. Count})
            else 
                Config.ServerNotify(source, 'Du kannst das Item nicht tragen')
            end
        else
            local xTarget = ESX.GetPlayerFromId(Target)

            if xTarget.canCarryItem(ItemName, Count) then
                xTarget.addInventoryItem(ItemName, Count)
                AddWebhookMessage(source, Target, 'Ein Admin hat einem Spieler ein Item gegeben', 'player', {'Item: ' .. ItemName, 'Count: ' .. Count})
            else 
                Config.ServerNotify(source, 'Er kannst das Item nicht tragen')
            end
        end
    end
end)

RegisterNetEvent('admin_menu:server:RemoveItem')
AddEventHandler('admin_menu:server:RemoveItem',function(ItemName, Count, Target, All)
    if CheckGroup(source, true) then
        local xTarget = ESX.GetPlayerFromId(Target)

        xTarget.removeInventoryItem(ItemName, Count)
        if All then
            AddWebhookMessage(source, Target, 'Ein Admin hat von einem Spieler von einem Item alle entfernt', 'player', {'Item: ' .. ItemName, 'Count: ' .. Count})
        else
            AddWebhookMessage(source, Target, 'Ein Admin hat einem Spieler eine Anzahl von Items entfernt', 'player', {'Item: ' .. ItemName, 'Count: ' .. Count})
        end
    end
end)

RegisterNetEvent('admin_menu:server:DeletePlayerVehicle')
AddEventHandler('admin_menu:server:DeletePlayerVehicle',function(Plate, DeleteIngame)
    if CheckGroup(source, true) then
        local Plate = string.upper(Trim(Plate))

        print(Plate)
        MySQL.query('SELECT owner FROM owned_vehicles WHERE plate = ?', {Plate}, function(response)
            if #response ~= 0 then
                MySQL.update('DELETE FROM owned_vehicles WHERE owner = ? AND plate = ?', {response[1].owner, Plate}, function(affectedRows)
                    if affectedRows then
                        if DeleteIngame then
                            Vehicles = GetAllVehicles()

                            print(ESX.DumpTable(Vehicles))
                            for k, Vehicle in pairs(Vehicles) do
                                if GetVehicleNumberPlateText(Vehicle) == Plate then
                                    DeleteEntity(Vehicle)
                                    print("fahrzeug weg")
                                end
                            end
                        end
                    end
                end)
            else 
                -- Notify gibts nicht
            end
        end)
    end
end)

RegisterNetEvent('admin_menu:server:AddVehicleToPlayer')
AddEventHandler('admin_menu:server:AddVehicleToPlayer', function (vehicleProps, Target)
    local source = source
    if CheckGroup(source, true) then

        function InsertVehicleInDB(Target)
            local xTarget = ESX.GetPlayerFromId(Target)

            MySQL.Async.execute('INSERT INTO owned_vehicles (owner, plate, vehicle) VALUES (@owner, @plate, @vehicle)',
            {
                ['@owner']   = xTarget.identifier,
                ['@plate']   = vehicleProps.plate,
                ['@vehicle'] = json.encode(vehicleProps)
            }, function (rowsChanged)
                if Target ~= source then
                    Config.ServerNotify(Target, 'Dir wurde ein Fahrzeug gegeben')
                    Config.ServerNotify(source, 'Du hast einem Spieler ein Fahrzeug gegeben')
                else 
                    Config.ServerNotify(source, 'Du hast dir das Fahrzeug in die Garage gepackt')
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

RegisterServerEvent('admin_menu:server:SendAnnounce')
AddEventHandler('admin_menu:server:SendAnnounce', function(Message)
    if CheckGroup(source, true) then
        Config.SendAnnounce(source, Message)
    end
end)

RegisterServerEvent('admin_menu:server:ReviveAllPlayer')
AddEventHandler('admin_menu:server:ReviveAllPlayer', function()
    if CheckGroup(source, true) then
        TriggerClientEvent('esx_ambulancejob:revive', -1)
    end
end)

local blackoutActive = false

RegisterServerEvent('BlackOut')
AddEventHandler('BlackOut', function()
    blackoutActive = not blackoutActive
    if blackoutActive then
        TriggerClientEvent('toggleBlackout', -1, true)
        print("Blackout activated")
    else
        TriggerClientEvent('toggleBlackout', -1, false)
        print("Blackout deactivated")
    end
end)