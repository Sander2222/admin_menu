local noclip = false
local ped = cache.ped

function OpenSelfMenu()
    lib.registerContext({
        id = 'SelfMenu',
        title = Locals.Self.SelfMenu,
        options = {
            {
                title = Locals.Self.ReviveMe,
                description = Locals.Self.SelfMenu,
                icon = 'notes-medical',
                onSelect = function()
                    if CanUseFunction('revive') then
                        TriggerEvent('esx_ambulancejob:revive')
                        Config.ClientNotify(Locals.Self.RevivedSelf)
                        TriggerServerEvent('admin_menu:server:SendWebhook', Locals.Self.Webhooks.RevivedSelf, 'self')
                    end
                end,
            },
            {
                title = Locals.Self.HealMe,
                description = Locals.Self.SelfMenu,
                icon = 'star-of-life',
                onSelect = function()
                    if CanUseFunction('heal') then
                        SetEntityHealth(ped, 200)
                        Config.ClientNotify(Locals.Self.HealSelf)
                        TriggerServerEvent('admin_menu:server:SendWebhook', Locals.Self.Webhooks.HealedSelf, 'self')
                    end
                end,
            },
            {
                title = Locals.Self.ArmorMe,
                description = Locals.Self.SelfMenu,
                icon = 'shield-halved',
                onSelect = function()
                    if CanUseFunction('armor') then
                        SetPedArmour(ped, 100)
                        Config.ClientNotify(Locals.Self.ArmorSelf)
                        TriggerServerEvent('admin_menu:server:SendWebhook', Locals.Self.Webhooks.ArmorSelf, 'self')
                    end
                end,
            },
            {
                title = Locals.Self.KillMe,
                description = Locals.Self.SelfMenu,
                icon = 'skull',
                onSelect = function()
                    if CanUseFunction('kill') then
                        SetEntityHealth(ped, 0)
                        Config.ClientNotify(Locals.Self.KillSelf)
                        TriggerServerEvent('admin_menu:server:SendWebhook', Locals.Self.Webhooks.KilledSelf, 'self')
                    end
                end,
            },
            {
                title = Locals.Self.WeaponMe,
                description = Locals.Self.SelfMenu,
                icon = 'gun',
                arrow = true,
                onSelect = function()
                    if CanUseFunction('weapon') then
                        OpenGunMenu()
                    end
                end,
            },
            {
                title = Locals.Self.ItemMe,
                description = Locals.Self.SelfMenu,
                icon = 'gavel',
                arrow = true,
                onSelect = function()
                    if CanUseFunction('item') then
                        OpenItemMenu()
                    end
                end,
            },
            {
                title = Locals.Self.MoneyMe,
                description = Locals.Self.SelfMenu,
                icon = 'money-bill-wave',
                arrow = true,
                onSelect = function()
                    if CanUseFunction('money') then
                        OpenMoneyMenu()
                    end
                end,
            },
        }
    })

    lib.showContext('SelfMenu')
end

function OpenMoneyMenu()
    lib.registerContext({
        id = 'MoneyMenu',
        title =  Locals.Self.SelfMenu,
        options = {
            {
                title = Locals.Self.MoneyMe,
                description = Locals.Self.SelfMenu,
                icon = 'money-bill',
                onSelect = function()
                    GiveMoney('Hand')
                end,
            },
            {
                title = Locals.Self.MoneyMeBank,
                description = Locals.Self.SelfMenu,
                icon = 'money-check',
                onSelect = function()
                    GiveMoney('Bank')
                end,
            },
        }
    })

    lib.showContext('MoneyMenu')
end

function GiveMoney(Type)
    local input = lib.inputDialog(Locals.Self.MoneyAdd, {
        {type = 'number', label = Locals.Self.Money, description = Locals.Self.MoneyMuch, icon = 'hashtag'},
    })

    if not input then return end

    local Money = tonumber(input[1])

    if Money == nil then
        Config.ClientNotify(Locals.Self.MoneyEnterNumber)

        return
    end

    TriggerServerEvent('admin_menu:server:GiveMoney', Money, Type)
end

function OpenItemMenu()
    local Items = GetAllItems()

    while #Items == 0 do
        Wait(1)
    end

    lib.registerContext({
        id = 'ItemListMenu',
        title = Locals.Self.SelfMenu,
        options = Items
    })

    lib.showContext('ItemListMenu')
end

function GetAllItems()
    local ItemList = {}
    
    ESX.TriggerServerCallback('admin_menu:callback:GetAllitems', function(Items)

        local SpeedMenu =  {
            title = Locals.Self.ItemQuickSelection,
            description = Locals.Self.ItemDesc,
            icon = 'bread-slice',
            arrow = true,
            onSelect = function()
                SearchForItem()
            end,
        }

        table.insert(ItemList, SpeedMenu)
        table.insert(ItemList, AddPlaceHolder())

        for itemName, itemData in pairs(Items) do

            local TmpTable =
            {
                title = itemData.label,
                description = Locals.Self.ItemName .. ': ' .. itemName,
                icon = 'bread-slice',
                onSelect = function()
                    GiveItem(itemName)
                end,
                metadata = {
                    {label = Locals.Self.ItemWeight, value = itemData.weight},
                    {label = Locals.Self.ItemCanRemove, value = itemData.canRemove}
                },
            }


            table.insert(ItemList, TmpTable)
        end
    end)

    return ItemList
end

function SearchForItem()
    local input = lib.inputDialog(Locals.Self.ItemAdd, {
        {type = 'input', label = Locals.Self.ItemName, description = Locals.Self.ItemWhich, required = true, min = 1, max = 600},
        {type = 'number', label = Locals.Self.ItemCount, description = Locals.Self.ItemMuch, icon = 'hashtag'},
    })

    if not input then return end

    local ItemName = input[1]
    local Count = tonumber(input[2])

    if Count == nil then
        Config.ClientNotify(Locals.Self.ItemEnterNumber)

        return
    end

    TriggerServerEvent('admin_menu:server:GiveItem', string.lower(ItemName), Count)
end

function GiveItem(ItemName)
    local input = lib.inputDialog(Locals.Self.ItemAddCount .. ': ' .. ItemName, {
        {type = 'input', label = Locals.Self.ItemCount, description = Locals.Self.ItemMuch, Locals.Self.ItemMuch, default= 1, required = true, min = 1, max = 600}
    })

    if not input then return end

    local Count = tonumber(input[1])

    if Count == nil then
        Config.ClientNotify(Locals.Self.ItemEnterNumber)

        return
    end

    TriggerServerEvent('admin_menu:server:GiveItem', string.lower(ItemName), Count)
end

function OpenGunMenu()
    lib.registerContext({
        id = 'WeaponListMenu',
        title = Locals.Self.SelfMenu,
        options = GetAllGuns()
    })

    lib.showContext('WeaponListMenu')
end

function GetAllGuns()
    local Guns = {}

    local SpeedMenu =  {
        title = Locals.Self.WeaponQuickSelection,
        description = Locals.Self.WeaponDsec,
        icon = 'gun',
        arrow = true,
        onSelect = function()
            SearchForWeapon()
        end,
    }

    table.insert(Guns, SpeedMenu)
    table.insert(Guns, AddPlaceHolder())

    for k, WeaponData in ipairs(ESX.GetWeaponList()) do
        local TmpTable =
            {
                title = WeaponData.label,
                description = WeaponData.name,
                icon = 'gun',
                onSelect = function()
                    GiveGun(WeaponData.name, WeaponData.label)
                end,
            }

            table.insert(Guns, TmpTable)
    end
    return Guns
end

function SearchForWeapon()
    local input = lib.inputDialog(Locals.Self.WeaponAdd, {
        {type = 'input', label = Locals.Self.WeaponName, description = Locals.Self.WeaponWhich, required = true, min = 1, max = 600},
        {type = 'number', label = Locals.Self.WeaponAmmu, description = Locals.Self.WeaponAmmuDesc, icon = 'hashtag'},
    })

    if not input then return end

    local WeaponName = input[1]
    local Count = tonumber(input[2])

    if Count == nil then
        Config.ClientNotify(Locals.Self.WeaponEnterNumber)

        return
    end

    TriggerServerEvent('admin_menu:server:GiveWeapon', WeaponName, Count)
end

function GiveGun(GunName, GunLabel)
    local input = lib.inputDialog(Locals.Self.WeaponInfo .. ': ' .. GunLabel, {
        {type = 'input', label = Locals.Self.WeaponAmmu, description = Locals.Self.WeaponAmmuDesc, default= 250, required = true, min = 1, max = 600},
        {type = 'checkbox', label = Locals.Self.WeaponWithESX},
    })

    if not input then return end

    local Ammo = tonumber(input[1])
    local WithESX = input[2]

    if Ammo == nil then
        Config.ClientNotify(Locals.Self.WeaponEnterNumber)

        return
    end

    if WithESX then
        GiveWeaponToPed(ped, GunName, Ammo, false, false)
    else
        TriggerServerEvent('admin_menu:server:GiveWeapon', GunName, Ammo)
    end
end