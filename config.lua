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