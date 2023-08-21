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
                    local Vehicles = ESX.OneSync.GetVehiclesInArea(xPlayer.getCoords(true) or 4)
                    for i=1, #Vehicles do 
                        local Vehicle = NetworkGetEntityFromNetworkId(Vehicles[i])
                        if DoesEntityExist(Vehicle) then
                            DeleteEntity(Vehicle)
                        end
                    end
                    Config.ClientNotify('Du hast das Fahrzeug in deiner Nähe gelöscht')
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

    lib.showContext('SelfMenu')
end

function OpenVehSpawnnMenu()

end


function DelVehicleRadiusMenu()

    

    local Vehicles = ESX.OneSync.GetVehiclesInArea(tonumber(args.radius))
    for i=1, #Vehicles do 
        local Vehicle = NetworkGetEntityFromNetworkId(Vehicles[i])
        if DoesEntityExist(Vehicle) then
            DeleteEntity(Vehicle)
        end
    end
    Config.ClientNotify('Du hast die Fahrzeuge im Umkreis von %s gelöscht')
end