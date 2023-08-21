function  OpenVehMenu()
    lib.registerContext({
        id = 'VehMenu',
        title = 'Vehicle Menu',
        options = {
            {
                title = 'Delete Vehicle',
                description = 'Player Actions',
                icon = 'star-of-life',
                onSelect = function()
                    DelNearVehicle()
                end,
            },
            {
                title = 'Delete Vehicle Radius',
                description = 'Player Actions',
                icon = 'shield-halved',
                onSelect = function()
                    DelVehicleRadiusMenu()
                end,
            },
            {
                title = 'Spawn Vehicle',
                description = 'Player Actions',
                icon = 'notes-medical',
                onSelect = function()
                    OpenVehSpawnnMenu()
                    -- Config.ClientNotify('Du hast dir %s gespawmt')
                end,
            },
            {
                title = 'Give Player Vehicle',
                description = 'Player Actions',
                icon = 'skull',
                onSelect = function()
                    Config.ClientNotify('Du hast dem Spieler: &s folgendes Fahrzeug: %s gegeben')
                end,
            },
            {
                title = 'Delete Player Vehicle',
                description = 'Player Actions',
                icon = 'skull',
                onSelect = function()
                    Config.ClientNotify('Du hast dem Spieler: &s folgendes Fahrzeug: %s entzogen')
                end,
            },
        }
    })

    lib.showContext('VehMenu')
end

function DelNearVehicle()
    local Vehicles = ESX.Game.GetClosestVehicle(xPlayer.getCoords(true))
    -- ESX.OneSync.GetVehiclesInArea(xPlayer.getCoords(true) or 4)
    for i=1, #Vehicles do 
        local Vehicle = NetworkGetEntityFromNetworkId(Vehicles[i])
        if DoesEntityExist(Vehicle) then
            DeleteEntity(Vehicle)
        end
    end
    Config.ClientNotify('Du hast das Fahrzeug in deiner Nähe gelöscht')
end

function DelVehicleRadiusMenu()
    local input = lib.inputDialog('Delete Radius', {'radius'})

    if not input then return end

    if input[1] then
        local Vehicles = ESX.OneSync.GetVehiclesInArea(input[1])
        for i=1, #Vehicles do 
            local Vehicle = NetworkGetEntityFromNetworkId(Vehicles[i])
            if DoesEntityExist(Vehicle) then
                DeleteEntity(Vehicle)
            end
        end
        Config.ClientNotify(('Du hast die Fahrzeuge im Umkreis von %s gelöscht'):format(input[1]))
    end
end

function OpenVehSpawnnMenu()
    local input = lib.inputDialog('Spawn Vehicle', {
            {type = 'vehName', label = 'Vehicle Hash', description = 'Write here Vehicle Hash', required = true, min = 4, max = 16},
            {type = 'numberplate', label = 'Vehicle Plate', description = 'Write here you Vehicle Plate', icon = 'hashtag'},
            {type = 'checkbox', label = 'Save in DB'},
            {type = 'color', label = 'Vehgicle Color', default = '#eb4034'},
          })

    if not input then return end

    if not input[1] or input[2] or input[3] or input[4] then

    end
end