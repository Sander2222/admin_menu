function  OpenVehMenu()
    lib.registerContext({
        id = 'VehMenu',
        title = 'Vehicle Menu',
        onBack = function()
            OpenMenu() -- Steht in Docs geht aber nicht
        end,
        options = {
            {
                title = 'Delete Vehicle',
                description = 'Player Actions',
                icon = 'car-burst',
                onSelect = function()
                    DelNearVehicle()
                end,
            },
            {
                title = 'Delete Vehicle Radius',
                description = 'Player Actions',
                icon = 'car-burst',
                onSelect = function()
                    DelVehicleRadiusMenu()
                end,
            },
            {
                title = 'Spawn Vehicle',
                description = 'Player Actions',
                icon = 'car-on',
                onSelect = function()
                    OpenVehSpawnnMenu()
                    -- Config.ClientNotify('Du hast dir %s gespawmt')
                end,
            },
            {
                title = 'Give Player Vehicle',
                description = 'Player Actions',
                icon = 'hand-holding-heart',
                onSelect = function()
                    Config.ClientNotify('Du hast dem Spieler: &s folgendes Fahrzeug: %s gegeben')
                end,
            },
            {
                title = 'Delete Player Vehicle',
                description = 'Player Actions',
                icon = 'car-burst',
                onSelect = function()
                    Config.ClientNotify('Du hast dem Spieler: &s folgendes Fahrzeug: %s entzogen')
                end,
            },
        }
    })

    lib.showContext('VehMenu')
end

function DelNearVehicle()
    local playerCoords = GetEntityCoords(PlayerPedId()) -- Hole die Koordinaten des Spielers
    local vehicles = ESX.Game.GetVehiclesInArea(playerCoords, 10.0) -- Erhalte Fahrzeuge im Umkreis von 10 Einheiten (du kannst den Radius anpassen)
    
    for i = 1, #vehicles do 
        local vehicle = vehicles[i]
        if DoesEntityExist(vehicle) then
            DeleteEntity(vehicle)
        end
    end
    Config.ClientNotify('Du hast das Fahrzeug in deiner Nähe gelöscht')
end

function DelVehicleRadiusMenu()
    local input = lib.inputDialog('Delete Radius', {'radius'})

    if not input then return end

    local radius = tonumber(input[1])

    if radius then
        local playerCoords = GetEntityCoords(PlayerPedId())
        local vehicles = ESX.Game.GetVehiclesInArea(playerCoords, radius)

        for i = 1, #vehicles do 
            local vehicle = vehicles[i]
            if DoesEntityExist(vehicle) then
                DeleteEntity(vehicle)
            end
        end
        Config.ClientNotify(('Du hast die Fahrzeuge im Umkreis von %s gelöscht'):format(input[1]))
    end
end

function OpenVehSpawnnMenu()
    local input = lib.inputDialog('Spawn Vehicle', {
        {type = 'input', label = 'Vehicle Hash', description = 'Write here Vehicle Hash', required = true, min = 4, max = 16},
        {type = 'input', label = 'Vehicle Plate', description = 'Write here you Vehicle Plate', icon = 'hashtag'},
        {type = 'color', label = 'Vehicle Primarycolor', default = '#eb4034'},
        {type = 'color', label = 'Vehicle Secondarycolor', default = '#eb4034'},
        --  {type = 'checkbox', label = 'Save in DB'},
    })

    if not input then return end

    local vehHash = GetHashKey(input[1])

    if not IsModelInCdimage(vehHash) or not IsModelAVehicle(vehHash) then

        Config.ClientNotify('Ungültiger Fahrzeughash')
        return 
    end

    local PriR, PriG, PriB = ConvertHexToRGB(input[3])
    local SecR, SecG, SecB = ConvertHexToRGB(input[4])

    local spawnCoords = GetEntityCoords(PlayerPedId())

    local numberPlate = input[2]
    
    print(numberPlate)
    if numberPlate == '' or numberPlate == ' ' then
        numberPlate = Config.BasicPlate
    end

    ESX.Streaming.RequestModel(vehHash)

    local vehicle = CreateVehicle(vehHash, spawnCoords.x, spawnCoords.y, spawnCoords.z, 0.0, true, false)


    SetVehicleNumberPlateText(vehicle, numberPlate)

    SetVehicleCustomPrimaryColour(vehicle, PriR, PriG, PriB)
    SetVehicleCustomPrimaryColour(vehicle, SecR, SecG, SecB)
    SetPedIntoVehicle(PlayerPedId(), vehicle, -1)

    Config.ClientNotify('Fahrzeug erfolgreich gespawnt!')
end

function ConvertHexToRGB(hex)
    hex = hex:gsub("#","")
    return tonumber("0x"..hex:sub(1,2)), tonumber("0x"..hex:sub(3,4)), tonumber("0x"..hex:sub(5,6))
end