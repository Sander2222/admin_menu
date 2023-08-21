CreateThread(function()
    MySQL.query("SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'users' AND COLUMN_NAME = 'admin_ban';", {}, function(response)
        if next(response) == nil then
            local SQLStatemant = [[
                ALTER TABLE users
                ADD COLUMN admin_ban TINYINT(1) DEFAULT 0,
                ADD COLUMN ban_duration TIMESTAMP NULL DEFAULT NULL;
            ]]
            MySQL.query(SQLStatemant, {}, function(response)
            end)
        end
    end)
end)

RegisterServerEvent('admin_menu:kickPlayer')
AddEventHandler('admin_menu:kickPlayerr', function(BanDuration)
    DropPlayer(source, (Config.Language[Config.Local]['ban_field']))
    local xPlayer = ESX.GetPlayerFromId(source)
    local entryDuration = BanDuration
    local formattedDate = os.date("%Y-%m-%d %H:%M:%S", entryDuration)

    MySQL.update.await('UPDATE users SET entry_ban = @entry_ban, entry_duration = @entry_duration WHERE identifier = @identifier',
	{
        ['@entry_ban'] = 1,
        ['@entry_duration'] = formattedDate,
        ['@identifier'] = xPlayer.getIdentifier()
	})
end)

AddEventHandler('playerConnecting', function(playerName, setKickReason, deferrals)
    local source = source
    local license = GetPlayerIdentifierByType(source, 'license')
    license = string.gsub(license, "license:", "")
    MySQL.query("SELECT `admin_ban`, `ban_duration` FROM `users` WHERE SUBSTRING_INDEX(`identifier`, ':', -1) = ? LIMIT 1", { license }, function(result)
        if Config.DebugMode then
        print(ESX.DumpTable(result))
        end
        if #result == 0 then
            deferrals.update((Config.Language[Config.Local]['check_ban_state']))
            Wait(1500)
            deferrals.done()
        else
            local row = result[1]
                if row.admin_ban == true then
                    deferrals.defer()
                    deferrals.update((Config.Language[Config.Local]['check_ban_state']))
                    Wait(1500)
                    local given_timestamp = row.ban_duration / 1000
                    local current_timestamp = os.time()
                    local time_difference = os.difftime(current_timestamp, given_timestamp)
                    local ban_duration = -- Hier aus der DB die länge abfragen
                    Wait(1000)
                    if time_difference >= ban_duration then
                        MySQL.execute("UPDATE `users` SET `admin_ban` = 0, `ban_duration` = NULL WHERE SUBSTRING_INDEX(`identifier`, ':', -1) = ?", { license }, function()end)
                        deferrals.defer()
                        deferrals.update((Config.Language[Config.Local]['set_unban_msg']))
                        Wait(1500)
                        deferrals.done()
                    else
                        local remaining_seconds = ban_duration - time_difference
                        local remaining_days = math.floor(remaining_seconds / (24 * 60 * 60))
                        local remaining_hours = math.floor((remaining_seconds % (24 * 60 * 60)) / (60 * 60))
                        local remaining_minutes = math.floor((remaining_seconds % (60 * 60)) / 60)
                        remaining_seconds = math.floor(remaining_seconds % 60)
                        deferrals.done((Config.Language[Config.Local]['fail_entry_ban']):format(remaining_days, remaining_hours, remaining_minutes, remaining_seconds))
                    end
                end
            deferrals.done()
        end
    end)
end)