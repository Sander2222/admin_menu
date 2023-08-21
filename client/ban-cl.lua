function  OpenBanMenu()
    lib.registerContext({
        id = 'BanMenu',
        title = 'Player Ban Menu',
        options = {
            {
                title = 'Ban Player permanet',
                description = 'Player Actions',
                icon = 'car-burst',
                onSelect = function()
                    OpenBanPermaMenu()
                end,
            },
            {
                title = 'Ban Player',
                description = 'Player Actions',
                icon = 'car-burst',
                onSelect = function()
                    OpenBanPlayerMenu()
                end,
            },
            {
                title = 'Warn Player',
                description = 'Player Actions',
                icon = 'car-on',
                onSelect = function()
                    OpenWarnPlayerMenu()
                    -- Config.ClientNotify('Du hast dir %s gespawmt')
                end,
            },
            {
                title = 'Kick Player',
                description = 'Player Actions',
                icon = 'car-on',
                onSelect = function()
                    OpenKickPlayerMenu()
                    -- Config.ClientNotify('Du hast dir %s gespawmt')
                end,
            },
        }
    })

    lib.showContext('BanMenu')
end

function OpenBanPermaMenu()
 -- hier liste mit allen spielern?
end

function OpenBanPlayerMenu()
    -- hier liste mit allen spielern?
end

function OpenWarnPlayerMenu()
    -- hier liste mit allen spielern?
end

function OpenKickPlayerMenu()
    -- hier liste mit allen spielern?
end