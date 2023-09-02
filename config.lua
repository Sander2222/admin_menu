Config = {}

Config.UseOpenKey = true 
Config.DefaultOpenKey = 'F5'
Config.UseAceSystem = false
Config.ESXGroups = {
    'admin',
    'mod',
    'sup'
}

Config.ClientNotify = function(msg)
    ESX.ShowNotification(msg)
end

Config.ServerNotify = function(src, msg)
    TriggerClientEvent('ox_lib:notify', src, {
        title = 'Admin Tool',
        description  = msg
    })
end

Config.PermaBanTime = {
    day = 7,
    hours = 24,
    minutes = 60,
    seconds = 60
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
    sec = 60
}