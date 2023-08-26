--- @usage This function checks if the player is able to use the adminmenu
function CheckGroup(Player, DoAction)
    if Config.UseAceSystem then
        if IsPlayerAceAllowed(Player, 'adminmenu') then
            return true
        end
    else
        local xPlayer = ESX.GetPlayerFromId(Player)
        local PlayerGroup = xPlayer.getGroup()

        for k, v in ipairs(Config.ESXGroups) do
            if v == PlayerGroup then
                return true
            end
        end
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
        print(Target)
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

RegisterNetEvent('admin_menu:server:GiveWeapon')
AddEventHandler('admin_menu:server:GiveWeapon',function(Weapon, Ammo)
    if CheckGroup(source, true) then
        local xPlayer = ESX.GetPlayerFromId(source)

        xPlayer.addWeapon(string.upper(Weapon), Ammo)
        AddWebhookMessage(source, nil, 'Ein Admin hat sich eine Waffe gegeben', 'self', {'Weapon: ' .. Weapon, 'Ammu: ' .. Ammo})
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
        AddWebhookMessage(source, nil, 'Ein Admin hat sich Bargeld gegeben', 'self', {'Count: ' .. Money})
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


RegisterServerEvent('SyncAnnounceToClients')
AddEventHandler('SyncAnnounceToClients', function(message)
    TriggerClientEvent('DisplaySyncAnnounce', -1, message)
end)

RegisterServerEvent('ReviveAllPlayer')
AddEventHandler('ReviveAllPlayer', function()
    TriggerClientEvent('esx_ambulancejob:revive', -1)
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