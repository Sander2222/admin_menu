local ped = cache.ped

function  OpenVehMenu()
    lib.registerContext({
        id = 'VehMenu',
        title = Locals.Vehicle.Menu,
        options = {
            {
                title = Locals.Vehicle.DelOne,
                description = Locals.Vehicle.Menu,
                icon = 'car-burst',
                onSelect = function()
                    if CanUseFunction('delveh') then
                        DelNearVehicle()
                    end
                end,
            },
            {
                title = Locals.Vehicle.DelRadius,
                description = Locals.Vehicle.Menu,
                icon = 'car-burst',
                onSelect = function()
                    if CanUseFunction('delradiusveh') then
                        OpenDelVehicleRadiusDialog()
                    end
                end,
            },
            {
                title = Locals.Vehicle.Spawn,
                description = Locals.Vehicle.Menu,
                icon = 'car-on',
                arrow = true,
                onSelect = function()
                    if CanUseFunction('spawnveh') then
                        OpenVehSpawnnMenu()
                    end
                end,
            },
            {
                title = Locals.Vehicle.GivePlayer,
                description = Locals.Vehicle.Menu,
                icon = 'hand-holding-heart',
                arrow = true,
                onSelect = function()
                    if CanUseFunction('giveveh') then
                        OpenGiveVehicleToPlayerDialog()
                    end
                end,
            },
            {
                title = Locals.Vehicle.DelPlayer,
                description = Locals.Vehicle.Menu,
                icon = 'car-burst',
                arrow = true,
                onSelect = function()
                    if CanUseFunction('delplayerveh') then
                        OpenDeleteVehicleDialog()
                    end
                end,
            },
        }
    })

    lib.showContext('VehMenu')
end

function OpenDeleteVehicleDialog()
    local input = lib.inputDialog('Fahrzeug löschen', {
        {type = 'input', label = 'Kennzeichen', description = 'Das Plate von dem Fahrzeug', required = true, min = 1, max = 1000},
        {type = 'checkbox', label = 'Fahrzeug direkt löschen'},
    })

    if not input then return end

    TriggerServerEvent('admin_menu:server:DeletePlayerVehicle', input[1], input[2])
end

function OpenGiveVehicleToPlayerDialog()
    local input = lib.inputDialog('Fahrzeug geben', {
        {type = 'input', label = 'Spieler ID', description = 'Gebe hier ein Steamnamen, ID oder den Namen von einem Spieler ein', required = true, min = 1, max = 1000}
    })

    if not input then return end
    
    OpenVehSpawnnMenu(tonumber(input[1]))
end

function DelNearVehicle()
    local playerCoords = GetEntityCoords(ped)
    local vehicles = ESX.Game.GetVehiclesInArea(playerCoords, 5.0)
    local FirstVehicle = vehicles[1]
    local VehiclePedIsIn = GetVehiclePedIsIn(ped, false)

    if VehiclePedIsIn ~= 0 then
        DeleteEntity(VehiclePedIsIn)
        Config.ClientNotify('Du hast das Fahrzeug in deiner Nähe gelöscht')
    else
        if DoesEntityExist(FirstVehicle) then
            DeleteEntity(FirstVehicle)
            Config.ClientNotify('Du hast das Fahrzeug in deiner Nähe gelöscht')
        else
            Config.ClientNotify('Es ist kein Fahrzeug in der nähe')
        end 
    end

end

function OpenDelVehicleRadiusDialog()
    local input = lib.inputDialog('Delete Vehicle in Radius', {
        {type = 'number', label = 'Radius', description = 'In wie vielen Metern sollen alle Fahrzeuge entfernt werden', required = true, default = 5, icon = 'hashtag'},
    })

    if not input then return end  

    local Radius = tonumber(input[1]) / 1.0

    if Radius then
        local playerCoords = GetEntityCoords(ped)
        local vehicles = ESX.Game.GetVehiclesInArea(playerCoords, Radius)

        for i = 1, #vehicles do
            local vehicle = vehicles[i]
            if DoesEntityExist(vehicle) then
                DeleteEntity(vehicle)
            end
        end

        Config.ClientNotify(('Du hast die Fahrzeuge im Umkreis von %s gelöscht'):format(Radius))
    end
end

function OpenVehSpawnnMenu(PlayerID)
    local input = lib.inputDialog('Spawn Vehicle', {
        {type = 'input', label = 'Vehicle Hash', description = 'Write here Vehicle Hash', required = true, min = 4, max = 16},
        {type = 'input', label = 'Vehicle Plate', description = 'Write here you Vehicle Plate', icon = 'hashtag'},
        {type = 'checkbox', label = 'Random Plate'},
        {type = 'color', label = 'Vehicle Primarycolor', default = '#000000'},
        {type = 'color', label = 'Vehicle Secondarycolor', default = '#000000'},
        {type = 'checkbox', label = 'Save in DB'}
    })

    if not input then return end

    local VehicleSpawnName = string.lower(input[1])
    local vehHash = GetHashKey(input[1])
    local numberPlate = input[2]
    local RandomPlate = input[3]
    local PriR, PriG, PriB = ConvertHexToRGB(input[4])
    local SecR, SecG, SecB = ConvertHexToRGB(input[5])
    local InsertInDB = input[6]

    if not IsModelInCdimage(vehHash) or not IsModelAVehicle(vehHash) then

        Config.ClientNotify('Ungültiger Fahrzeughash oder spawnname existiert nicht')
        return 
    end
    
    if RandomPlate then
        numberPlate = GenerateRandomString(8)
    else 
        if numberPlate == '' or numberPlate == ' ' then
            numberPlate = Config.BasicPlate
        end
    end


    ESX.Game.SpawnVehicle(VehicleSpawnName, GetEntityCoords(ped), 100.0, function(vehicle)
        SetVehicleNumberPlateText(vehicle, numberPlate)

        SetVehicleCustomPrimaryColour(vehicle, PriR, PriG, PriB)
        SetVehicleCustomPrimaryColour(vehicle, SecR, SecG, SecB)
        SetPedIntoVehicle(ped, vehicle, -1)

        if InsertInDB or PlayerID then
            TriggerServerEvent('admin_menu:server:AddVehicleToPlayer', ESX.Game.GetVehicleProperties(vehicle), PlayerID)
        end

        if PlayerID then
            DeleteEntity(vehicle)
        end
    end)
end

function GenerateRandomString(length)
    local chars = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
    local randomString = ""
    for _ = 1, length do
        local randomIndex = math.random(#chars)
        randomString = randomString .. string.sub(chars, randomIndex, randomIndex)
    end
    return randomString
end