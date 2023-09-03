-- CreateThread(function()
--     MySQL.query("SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'users' AND COLUMN_NAME = 'admin_ban';", {}, function(response)
--         if next(response) == nil then
--             local SQLStatemant = [[
--                 ALTER TABLE users
--                 ADD COLUMN admin_ban TINYINT(1) DEFAULT 0,
--                 ADD COLUMN ban_duration TIMESTAMP NULL DEFAULT NULL;
--             ]]
--             MySQL.query(SQLStatemant, {}, function(response)
--             end)
--         end
--     end)
-- end)

RegisterNetEvent('admin_menu:server:AddPlayerBan')
AddEventHandler('admin_menu:server:AddPlayerBan',function(Timestamp, Reason, Type)
    local xPlayer = ESX.GetPlayerFromId(source)
    
    local entryDuration
    local formattedDate

    print(os.time())

    if Type == 'normal' then
        -- Add Day to ban the player to the next day 
        entryDuration = Timestamp + Config.Times.day
        formattedDate = os.date("%Y-%m-%d %H:%M:%S", entryDuration)
    elseif Type == 'custom' then
        if Config.Times.per == Timestamp then
            entryDuration = Timestamp
            formattedDate = os.date("%Y-%m-%d %H:%M:%S", entryDuration)

            MySQL.insert('UPDATE users SET bantime = ?, banreason = ? WHERE identifier = ?', { formattedDate, Reason, xPlayer.getIdentifier() }, function(id)
                xPlayer.kick(('Du wurdest permanent von dem Server gebannt. \n Grund: %s\n\n den Support findest du hier: %s'):format(Reason, 'discord.gg/ssio'))
            end)

            return
        else 
            entryDuration = os.time() + Timestamp
            formattedDate = os.date("%Y-%m-%d %H:%M:%S", entryDuration)
        end
    end

    MySQL.insert('UPDATE users SET bantime = ?, banreason = ? WHERE identifier = ?', { formattedDate, Reason, xPlayer.getIdentifier() }, function(id)
        local Date = os.date("%d.%m.%Y", entryDuration)
        local Time = os.date("%H:%M:%S", entryDuration)
        xPlayer.kick(('Du wurdest von diesem Server gebannt. \n Grund: %s\n\n Datum: %s\n Zeit: %s \n\n den Support findest du hier: %s'):format(Reason,  Date, Time, 'discord.gg/ssio'))
    end)
end)

AddEventHandler('playerConnecting', function(playerName, setKickReason, deferrals)
    local source = source
    local license = GetPlayerIdentifierByType(source, 'license')
    license = string.gsub(license, "license:", "")

    MySQL.query("SELECT bantime, banreason FROM users WHERE SUBSTRING_INDEX(`identifier`, ':', -1) = ? LIMIT 1", { license }, function(result)
        deferrals.defer()
        Wait(1000)
        deferrals.update('Ban wird geprüft :)')
        
        if #result == 0 then            
            deferrals.done()
        else 

            local DBTime = result[1].bantime
            local Reason = result[1].banreason
            if tonumber(DBTime) ~= 0 then

                -- Check if permanet
                if Config.Times.per == (DBTime / 1000) then

                    deferrals.done(('\nDu bist permanent von diesem Server gebannt\nGrund: %s\n\nSupport findest du hier: %s'):format(Reason, 'https:/discord.gg/ssio'))
                end

                deferrals.update('Ban wird geprüft')
                local Time = DBTime / 1000
                local NowTime = os.time()
                
                local timedif = Time - NowTime
                local future_time = os.date("%d.%m.%Y %H:%M", NowTime + timedif)
                
                if timedif <= 0 then
                    deferrals.update('Dein Ban ist ausgelaufen und du wurdest entbannt')
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
                
                    deferrals.done(('\nDu bist noch gebannt bis: %s\nVerbleibende Zeit: %d Jahre, %d Monate, %d Tage, %d Stunden, %d Minuten, %d Sekunden\n\nGrund: %s'):format(future_time, years, months, days, hours, minutes, seconds, Reason))
                end
            else
                deferrals.done()
            end
        end
    end)
end)