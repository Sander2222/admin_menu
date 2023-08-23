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
    AddWebhookMessage(source, type, Data)
end)

function AddWebhookMessage(source, msg, type, Data)
    if CheckGroup(source, false) then
        if type == 'self' then
            local msg = msg

            if #Data ~= 0 then

                msg = msg .. '\n\n **Data:** \n'

                for k, v in pairs(Data) do
                    msg = msg .. v .. '\n'
                end
            end

            msg = msg .. '\n\n **Player Info:** \n' .. GetPlayerFootprints(source)

            SendDiscord(msg)
        end
    end
end

RegisterNetEvent('admin_menu:server:GiveWeapon')
AddEventHandler('admin_menu:server:GiveWeapon',function(Weapon, Ammo)
    if CheckGroup(source, true) then
        local xPlayer = ESX.GetPlayerFromId(source)

        xPlayer.addWeapon(Weapon, Ammo)
        AddWebhookMessage(source, 'Ein Admin hat sich eine Waffe gegeben', 'self', {'Weapon: ' .. Weapon, 'Ammu: ' .. Ammo})
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
        AddWebhookMessage(source, 'Ein Admin hat sich Bargeld gegeben', 'self', {'Count: ' .. Money})
    end
end)

RegisterNetEvent('admin_menu:server:GiveItem')
AddEventHandler('admin_menu:server:GiveItem',function(ItemName, Count)
    if CheckGroup(source, true) then
        local xPlayer = ESX.GetPlayerFromId(source)

        if xPlayer.canCarryItem(ItemName, Count) then
            xPlayer.addInventoryItem(ItemName, Count)
            AddWebhookMessage(source, 'Ein Admin hat sich ein Item gegeben', 'self', {'Item: ' .. ItemName, 'Count: ' .. Count})
        else 
            Config.ServerNotify(source, 'Du kannst das Item nicht tragen')
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
