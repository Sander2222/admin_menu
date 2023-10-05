ESX.RegisterServerCallback('admin_menu:callback:CheckGroup', function(src, cb)
    local xPlayer = ESX.GetPlayerFromId(src)
    local Group = xPlayer.getGroup()

    if CheckGroup(src, false) then
        cb(true, Group)
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

ESX.RegisterServerCallback('admin_menu:callback:GetAllBannedPlayers', function(src, cb)

    if CheckGroup(src, true) then
        cb(BannedPlayers)
    end
end)