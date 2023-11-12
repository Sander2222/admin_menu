BannedPlayers = {}

if Config.UseBanMenu then

    CreateThread(function()
        while true do
            LoadAllBans()
            Wait(60000)
        end
    end)

    function DeletePlayerFromTable(identifier)
        for k, v in ipairs(BannedPlayers) do
            if string.sub(v.identifier, 7) == identifier then
                table.remove(BannedPlayers, k)
            end
        end
    end

    function LoadAllBans()
        MySQL.query("SELECT identifier, bantime, banreason, firstname, lastname FROM users WHERE bantime <> 0", {},
            function(result)
                BannedPlayers = {}

                for k, v in ipairs(result) do
                    v.bantime = os.date("%Y-%m-%d %H:%M:%S", v.bantime / 1000)
                    table.insert(BannedPlayers, v)
                end
            end)
    end

    CreateThread(function()
        MySQL.query(
            "SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'users' AND COLUMN_NAME = 'banreason';",
            {}, function(response)
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
    AddEventHandler('admin_menu:server:AddPlayerBan', function(Timestamp, Reason, Type, Target)
        local source = source
        if CheckGroup(source, true) then
            local xTarget = ESX.GetPlayerFromId(Target)

            local entryDuration
            local formattedDate

            if CanPlayerGetBanned(Target) then
                if Type == 'normal' then
                    -- Add Day to ban the player to the next day
                    entryDuration = Timestamp + Config.Times.day
                    formattedDate = os.date("%Y-%m-%d %H:%M:%S", entryDuration)
                elseif Type == 'custom' then
                    if Config.Times.per == Timestamp then
                        entryDuration = Timestamp
                        formattedDate = os.date("%Y-%m-%d %H:%M:%S", entryDuration)

                        MySQL.insert('UPDATE users SET bantime = ?, banreason = ? WHERE identifier = ?',
                            { formattedDate, Reason, xTarget.getIdentifier() }, function(id)
                                xTarget.kick((Locals.Ban.Banned .. '\n ' .. Locals.Ban.Reason .. ': %s\n\n ' .. Locals.Ban.Discord .. ': %s')
                                    :format(Reason, Locals.Ban.DiscordLink))
                            end)

                            AddWebhookMessage(source, Target, Locals.Server.PlayerGotBanned, 'player', {Locals.Ban.Time .. ': ' .. formattedDate, Locals.Ban.Reason .. ': ' .. Reason})
                        return
                    else
                        entryDuration = os.time() + Timestamp
                        formattedDate = os.date("%Y-%m-%d %H:%M:%S", entryDuration)
                    end
                end

                MySQL.insert('UPDATE users SET bantime = ?, banreason = ? WHERE identifier = ?',
                    { formattedDate, Reason, xTarget.getIdentifier() }, function(id)
                        local Date = os.date("%d.%m.%Y", entryDuration)
                        local Time = os.date("%H:%M:%S", entryDuration)
                        xTarget.kick((Locals.Ban.Banned .. '\n ' .. Locals.Ban.Reason .. ': %s\n\n ' .. Locals.Ban.Date .. ': %s\n ' .. Locals.Ban.Time .. ': %s \n\n ' .. Locals.Ban.Discord .. ': %s')
                            :format(Reason, Date, Time, Locals.Ban.DiscordLink))

                        AddWebhookMessage(source, Target, Locals.Server.PlayerGotBanned, 'player', {Locals.Ban.Time .. ': ' .. formattedDate, Locals.Ban.Reason .. ': ' .. Reason})

                    end)
            else
                Config.ServerNotify(source, Locals.Ban.PlayerCantBeBanned)
            end
        end
    end)

    AddEventHandler('playerConnecting', function(playerName, setKickReason, deferrals)
        local source = source
        local license = GetPlayerIdentifierByType(source, 'license')
        license = string.gsub(license, "license:", "")

        MySQL.query(
            "SELECT bantime, banreason, identifier FROM users WHERE SUBSTRING_INDEX(`identifier`, ':', -1) = ? LIMIT 1",
            { license }, function(result)
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
                            deferrals.done(('\n' .. Locals.Ban.BannedPerma .. '\n ' .. Locals.Ban.Reason .. ': %s\n\n ' .. Locals.Ban.Discord .. ': %s \n (%s)')
                                :format(Reason, Locals.Ban.DiscordLink, result[1].identifier))
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

                            deferrals.done(('\n ' .. Locals.Ban.Banned .. ': %s\n' .. Locals.Ban.TimeRemaining .. ': %d ' .. Locals.Ban.Year .. ', %d ' .. Locals.Ban.Month .. ', %d ' .. Locals.Ban.Day .. ', %d ' .. Locals.Ban.Hour .. ', %d ' .. Locals.Ban.Min .. ', %d ' .. Locals.Ban.Sec .. '\n\n ' .. Locals.Ban.Reason .. ': %s \n (%s)')
                                :format(future_time, years, months, days, hours, minutes, seconds, Reason,
                                    result[1].identifier))
                        end
                    else
                        deferrals.done()
                    end
                end
            end)
    end)

    RegisterCommand('unban', function(source, args)
        TriggerEvent('admin_menu:server:UnbanPlayer', args[1], source)
    end)

    RegisterNetEvent('admin_menu:server:UnbanPlayer')
    AddEventHandler('admin_menu:server:UnbanPlayer', function(identifier, PlayerID)
        local IngamemenuUnban = false
        local Player

        if PlayerID == 0 then
            Player = 0
        elseif PlayerID == nil then
            IngamemenuUnban = true
            Player = source
        else
            Player = PlayerID
        end

        function Notify(MSG)
            if PlayerID == 0 then
                print(MSG)
            else
                Config.ServerNotify(Player, MSG)
            end
        end

        function UnbanPlayer(identifier)
            MySQL.query(
                "SELECT identifier, bantime, banreason FROM users WHERE SUBSTRING_INDEX(`identifier`, ':', -1) = ? LIMIT 1",
                { identifier }, function(result)
                    if #result == 0 then
                        Notify(Locals.Ban.PlayerDoenstExist)
                        return
                    end

                    local char = result[1].identifier:match("^(.-):")

                    if char then
                        if result[1].bantime ~= 0 then
                            MySQL.update("UPDATE users SET bantime = NULL, banreason = '' WHERE identifier = ?",
                                { char .. ':' .. identifier }, function(affectedRows)
                                    Notify(Locals.Ban.PlayerUnbanned)

                                    AddWebhookMessage(Player, nil, Locals.Server.PlayerGotUnbanned, 'self', {Locals.Ban.Time .. ': ' .. formattedDate, Locals.Ban.Reason .. ': ' .. Reason})

                                    if IngamemenuUnban then
                                        DeletePlayerFromTable(identifier)
                                    end
                                end)
                        else
                            Notify(Locals.Ban.PlayerNotBanned)
                        end
                    else
                        Notify(Locals.Ban.InvalidIdentifierFormat)
                    end
                end)
        end

        if PlayerID == 0 then
            UnbanPlayer(identifier)
        else
            if CheckGroup(Player, true) then
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
end