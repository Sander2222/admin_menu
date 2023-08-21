ESX.RegisterServerCallback('admin_menu:callback:CheckGroup', function(src, cb)
    if Config.UseAceSystem then
        if IsPlayerAceAllowed(src, 'adminmenu') then
            cb(true)
            return
        end
    else
        local xPlayer = ESX.GetPlayerFromId(src)

        if CheckGroup(xPlayer.getGroup()) then
            cb(true)
            return
        end
    end

    cb(false)
end)

function CheckGroup(Group)
    for k, v in ipairs(Config.ESXGroups) do
        if v == Group then
            return true
        end
    end

    return false
end
