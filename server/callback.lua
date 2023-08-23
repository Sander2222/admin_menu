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
        cb(ESX.GetExtendedPlayers())
    end
end)