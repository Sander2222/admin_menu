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

Config.WeaponList = {
    {
        name = 'WEAPON_PISTOL',
        label = 'Pistol'
    }
}