function OpenServerMenu()
    lib.registerContext({
        id = 'ServMenu',
        title = 'Server Menu',
        options = {
            {
                title = 'Send Announce',
                description = 'Player Actions',
                icon = 'bullhorn',
                arrow = true,
                onSelect = function()
        
                end,
            },
            {
                title = 'Revive All',
                description = 'Player Actions',
                icon = 'laptop-medical',
                onSelect = function()
                    
                end,
            },
            {
                title = 'Blackout',
                description = 'Player Actions',
                icon = 'bolt',
                arrow = true,
                onSelect = function()
                OpenBlackMenu()
                end,
            },
            {
                title = 'Detele all Vehicle',
                description = 'Player Actions',
                icon = 'car-burst',
                arrow = true,
                onSelect = function()
                   
                end,
            },
            {
                title = 'Resource Monitor',
                description = 'Player Actions',
                icon = 'list-check',
                arrow = true,
                onSelect = function()

                end,
            },
        }
    })

    lib.showContext('ServMenu')
end