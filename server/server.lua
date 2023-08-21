ESX.RegisterServerCallback('admin_menu:callback:CheckGroup', function(src, cb)

    if CheckGroup(src) then
        cb(true)
    else 
        cb(false)
    end
end)

function CheckGroup(Player)
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

    return false
end

RegisterNetEvent('admin_menu:server:SendWebhook')
AddEventHandler('admin_menu:server:SendWebhook',function(msg, type)
    if CheckGroup(source) then
        if type == 'self' then
            local msg = msg .. '\n\n' .. GetPlayerFootprints(source) 

            SendDiscord(msg)
        end
        
    else
        -- Kick Ban idk?
    end
end)

function GetPlayerFootprints(Player)
    local Footer = ''

  for k,v in pairs(GetPlayerIdentifiers(source))do
    print(v)
        
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
