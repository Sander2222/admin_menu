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
    TriggerEvent('chat:addMessage', {
        color = { 255, 0, 0 },
        multiline = true,
        args = { "Server", msg }
    })
end

Config.ServerNotify = function(src, msg)
    TriggerClientEvent('ox_lib:notify', src, {
        title = 'Admin Tool',
        description  = msg
    })
end

Config.WeaponList = {
    {
        name = 'WEAPON_PISTOL',
        label = 'Pistol'
    }
}

Config.PermaBanTime = {
    day = 7,
    hours = 24,
    minutes = 60,
    seconds = 60
}

Config.BasicPlate = 'Test'
Config.UnemployedJob = 'unemployed'
Config.UnemployedJobGrade = 0