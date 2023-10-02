CreateThread(function()
    MySQL.query("SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'users' AND COLUMN_NAME = 'banreason';", {}, function(response)
        if next(response) == nil then
            local SQLStatemant = [[
                ALTER TABLE users
                ADD bantime TIMESTAMP,
                ADD banreason VARCHAR(500);
            ]]
            MySQL.query(SQLStatemant, {}, function(response)
            end)
        end
    end)
end)

RegisterNetEvent('admin_menu:server:AddPlayerBan')
AddEventHandler('admin_menu:server:AddPlayerBan',function(Timestamp, Reason, Type, Target)
    local source = source
    local xTarget = ESX.GetPlayerFromId(Target)
    
    local entryDuration
    local formattedDate

    if CanPlayerGetBanned(source) then
        if Type == 'normal' then
            -- Add Day to ban the player to the next day 
            entryDuration = Timestamp + Config.Times.day
            formattedDate = os.date("%Y-%m-%d %H:%M:%S", entryDuration)
        elseif Type == 'custom' then
            if Config.Times.per == Timestamp then
                entryDuration = Timestamp
                formattedDate = os.date("%Y-%m-%d %H:%M:%S", entryDuration)
    
                MySQL.insert('UPDATE users SET bantime = ?, banreason = ? WHERE identifier = ?', { formattedDate, Reason, xTarget.getIdentifier() }, function(id)
                    xTarget.kick((Locals.Ban.Banned ..  '\n ' .. Locals.Ban.Reason .. ': %s\n\n '.. Locals.Ban.Discord .. ': %s'):format(Reason, Locals.Ban.DiscordLink))
                end)
    
                return
            else 
                entryDuration = os.time() + Timestamp
                formattedDate = os.date("%Y-%m-%d %H:%M:%S", entryDuration)
            end
        end
    
        MySQL.insert('UPDATE users SET bantime = ?, banreason = ? WHERE identifier = ?', { formattedDate, Reason, xTarget.getIdentifier() }, function(id)
            local Date = os.date("%d.%m.%Y", entryDuration)
            local Time = os.date("%H:%M:%S", entryDuration)
            xTarget.kick((Locals.Ban.Banned .. '\n '.. Locals.Ban.Reason .. ': %s\n\n ' .. Locals.Ban.Date .. ': %s\n ' .. Locals.Ban.Time .. ': %s \n\n '.. Locals.Ban.Discord .. ': %s'):format(Reason,  Date, Time, Locals.Ban.Locals.Ban.DiscordLink))
        end)
    else 
        Config.ServerNotify(source, Locals.Ban.PlayerCantBeBanned)
    end
end)

AddEventHandler('playerConnecting', function(playerName, setKickReason, deferrals)
    local source = source
    local license = GetPlayerIdentifierByType(source, 'license')
    license = string.gsub(license, "license:", "")

    MySQL.query("SELECT bantime, banreason, identifier FROM users WHERE SUBSTRING_INDEX(`identifier`, ':', -1) = ? LIMIT 1", { license }, function(result)
        deferrals.defer()
        deferrals.update(Locals.Ban.BanGetCheckeck)
        Wait(1000)
        
        if #result == 0 then            
            deferrals.done()
        else 

            local DBTime = result[1].bantime
            local Reason = result[1].banreason
            if tonumber(DBTime) ~= 0 then

                -- Check if permanet
                if Config.Times.per == (DBTime / 1000) then

                    deferrals.done(('\n' .. Locals.Ban.BannedPerma .. '\n ' .. Locals.Ban.Reason .. ': %s\n\n ' .. Locals.Ban.Discord .. ': %s \n (%s)'):format(Reason, Locals.Ban.DiscordLink, result[1].identifier))
                end

                local Time = DBTime / 1000
                local NowTime = os.time()
                
                local timedif = Time - NowTime
                local future_time = os.date("%d.%m.%Y %H:%M", NowTime + timedif)
                
                if timedif <= 0 then
                    deferrals.update(Locals.Ban.BanExpired)
                    Wait(1500)
                    deferrals.done()
                else
                    local years = math.floor(timedif / Config.Times.year)
                    timedif = timedif % 31536000
                
                    local months = math.floor(timedif / Config.Times.month)
                    timedif = timedif % 2592000
                
                    local days = math.floor(timedif / Config.Times.day)
                    timedif = timedif % 86400
                
                    local hours = math.floor(timedif / Config.Times.hour)
                    timedif = timedif % 3600
                
                    local minutes, seconds = math.floor(timedif / Config.Times.minute), timedif % Config.Times.sec
                
                    deferrals.done(('\n ' .. Locals.Ban.Banned .. ': %s\n' .. Locals.Ban.TimeRemaining .. ': %d ' .. Locals.Ban.Year .. ', %d ' .. Locals.Ban.Month .. ', %d ' .. Locals.Ban.Day .. ', %d ' .. Locals.Ban.Hour', %d ' .. Locals.Ban.Min .. ', %d ' .. Locals.Ban.Sec .. '\n\n ' .. Locals.Ban.Reason .. ': %s \n ()'):format(future_time, years, months, days, hours, minutes, seconds, Reason, result[1].identifier))
                end
            else
                deferrals.done()
            end
        end
    end)
end)

RegisterCommand('unban', function (source, args)
    TriggerEvent('admin_menu:server:UnbanPlayer', args[1], source)
end)

RegisterNetEvent('admin_menu:server:UnbanPlayer')
AddEventHandler('admin_menu:server:UnbanPlayer',function(identifier, PlayerID)

    function Notify(MSG)
        if PlayerID == 0 then
            print(MSG)
        else 
            Config.ServerNotify(PlayerID, MSG)
        end
    end

    function UnbanPlayer(identifier)
        MySQL.query("SELECT identifier, bantime, banreason FROM users WHERE SUBSTRING_INDEX(`identifier`, ':', -1) = ? LIMIT 1", { identifier }, function(result)
            if #result == 0 then
                Notify("Diesen Spieler gibt es nicht")
                return
            end
    
            local char = result[1].identifier:match("^(.-):")
    
            if char then
                if result[1].bantime ~= 0 then
                    MySQL.update("UPDATE users SET bantime = NULL, banreason = '' WHERE identifier = ?", { char .. ':' .. identifier }, function(affectedRows)
                        Notify("Spieler ist entbannt")
                    end)
                else
                    Notify("Dieser Spieler hat keinen Ban")
                end
            else
                Notify("Ungültiger Identifier-Format")
            end
        end)
    end

    if PlayerID == 0 then
        UnbanPlayer(identifier)
    else 
        if CheckGroup(PlayerID, true) then
            UnbanPlayer(identifier)
        end
    end
end)

function CanPlayerGetBanned(PlayerID)
    local xPlayer = ESX.GetPlayerFromId(PlayerID)
    local Group = xPlayer.getGroup()

    for k, v in pairs(SVConfig.NotBannedRoles) do
        if Group then
            return true
        end
    end

    return false
end