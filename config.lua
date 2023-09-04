Config = {}

Config.UseOpenKey = true 
Config.DefaultOpenKey = 'F5'

Config.ClientNotify = function(msg)
    ESX.ShowNotification(msg)
end

Config.ServerNotify = function(src, msg)
    TriggerClientEvent('ox_lib:notify', src, {
        title = 'Admin Tool',
        description  = msg
    })
end

Config.Groups = {
    ['admin'] = {

        -- Menus
        ['self'] = true,
        ['player'] = true,
        ['vehicle'] = true,
        ['server'] = true,


        ['revive'] = true,
        ['heal'] = true,
        ['armor'] = true,
        ['kill'] = true,
        ['weapon'] = true,
        ['item'] = true,
        ['money'] = true,
        ['noclip'] = true
    }
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