ESX.RegisterServerCallback('admin_menu:callback:CheckGroup', function(src, cb)

    if CheckGroup(src, false) then
        cb(true)
    else 
        cb(false)
    end
end)

ESX.RegisterServerCallback('admin_menu:callback:GetAllitems', function(src, cb)

    if CheckGroup(src, true) then
        cb(ESX.Items)
    end
end)

ESX.RegisterServerCallback('admin_menu:callback:GetAllPlayer', function(src, cb)

    if CheckGroup(src, true) then
        local AllPLayers = ESX.GetExtendedPlayers()
        
        for k, v in pairs(AllPLayers) do
            v.steam = GetPlayerName(v.playerId)
        end

        cb(AllPLayers)
    end
end)

ESX.RegisterServerCallback('admin_menu:callback:GetAllRessources', function(source, cb)
    local resourceList = {}

    if GetNumResources() == 0 then
        cb(false)
    end

    for i = 0, GetNumResources(), 1 do
        local resource_name = GetResourceByFindIndex(i)
        if resource_name and GetResourceState(resource_name) == "started" then
            table.insert(resourceList, resource_name)
        end
        cb(resourceList)
    end

    cb(false)
end)