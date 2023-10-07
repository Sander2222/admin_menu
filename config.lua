Config = {}

Config.UseOpenKey = true 
Config.DefaultOpenKey = 'F5'
Config.UseBanMenu = true

Config.ClientNotify = function(msg)
    ESX.ShowNotification(msg)
end

Config.ServerNotify = function(src, msg)
    TriggerClientEvent('ox_lib:notify', src, {
        title = 'Admin Tool',
        description  = msg
    })
end

Config.SendAnnounce = function(Player, Message)
    TriggerClientEvent('ox_lib:notify', -1, {
        id = 'some_identifier',
        title = 'Announce',
        description = Message,
        position = 'top',
        style = {
            backgroundColor = '#141517',
            color = '#C1C2C5',
            ['.description'] = {
              color = '#909296'
            }
        },
        icon = 'ban',
        iconColor = '#C53030'
    })
end

Config.Groups = {
    ['admin'] = {

        -- Menus
        ['self'] = true,
        ['player'] = true,
        ['vehicle'] = true,
        ['server'] = true,

        -- Self
        ['revive'] = true,
        ['heal'] = true,
        ['armor'] = true,
        ['kill'] = true,
        ['weapon'] = true,
        ['item'] = true,
        ['money'] = true,
        ['noclip'] = true,

        -- Player
        ['ban'] = true,
        ['banperm'] = true,
        ['inventory'] = true,
        ['pWeapon'] = true,
        ['job'] = true,
        ['msg'] = true,
        ['kick'] = true,
        ['pkill'] = true,
        ['parmor'] = true,
        ['pmoney'] = true,
        ['screenshot'] = true,

        -- Vehicle
        ['delveh'] = true,
        ['delradiusveh'] = true,
        ['spawnveh'] = true,
        ['giveveh'] = true,
        ['delplayerveh'] = true,

        -- Server 
        ['announce'] = true,
        ['reviveall'] = true,
        ['delallveh'] = true,
        ['banlist'] = true,
    },

    ['mod'] = {

        -- Menus
        ['self'] = true,
        ['player'] = true,
        ['vehicle'] = true,
        ['server'] = false,

        -- Self
        ['revive'] = true,
        ['heal'] = true,
        ['armor'] = true,
        ['kill'] = true,
        ['weapon'] = true,
        ['item'] = true,
        ['money'] = true,
        ['noclip'] = true,

        -- Player
        ['ban'] = true,
        ['banperm'] = false,
        ['inventory'] = true,
        ['pWeapon'] = true,
        ['job'] = true,
        ['msg'] = true,
        ['kick'] = true,
        ['pkill'] = true,
        ['parmor'] = true,
        ['pmoney'] = true,

        -- Vehicle
        ['delveh'] = true,
        ['delradiusveh'] = true,
        ['spawnveh'] = true,
        ['giveveh'] = true,
        ['delplayerveh'] = true,

        -- Server 
        ['announce'] = true,
        ['reviveall'] = true,
        ['delallveh'] = true
    },
}

Config.BasicPlate = 'Test'
Config.UnemployedJob = 'unemployed'
Config.UnemployedJobGrade = 0

Config.Times = {
    year = 31536000,
    month = 2592000,
    day = 86400,
    hour = 3600,
    minute = 60,
    sec = 60,
    per = 2052757800
}