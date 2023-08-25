local noclip = false
local ped = cache.ped

function OpenSelfMenu()
    lib.registerContext({
        id = 'SelfMenu',
        title = 'Self Menu',
        options = {
            {
                title = 'Revive me',
                description = 'Player Actions',
                icon = 'notes-medical',
                onSelect = function()
                    TriggerEvent('esx_ambulancejob:revive')
                    Config.ClientNotify('Du hast dich selbst wiederbelebt')
                    TriggerServerEvent('admin_menu:server:SendWebhook', 'Ein Admin hat sich selbst revived', 'self')
                end,
            },
            {
                title = 'Heal',
                description = 'Player Actions',
                icon = 'star-of-life',
                onSelect = function()
                    SetEntityHealth(ped, 200)
                    Config.ClientNotify('Du hast dich gehielt')
                    TriggerServerEvent('admin_menu:server:SendWebhook', 'Ein Admin hat sich gehealt', 'self')
                end,
            },
            {
                title = 'Give Armor',
                description = 'Player Actions',
                icon = 'shield-halved',
                onSelect = function()
                    SetPedArmour(ped, 100)
                    Config.ClientNotify('Du hast dir selbst armor gegeben')
                    TriggerServerEvent('admin_menu:server:SendWebhook', 'Ein Admin hat sich armor gegeben', 'self')
                end,
            },
            {
                title = 'Kill Self',
                description = 'Player Actions',
                icon = 'skull',
                onSelect = function()
                    SetEntityHealth(ped, 0)
                    Config.ClientNotify('Du hast dich selbst getötet')
                    TriggerServerEvent('admin_menu:server:SendWebhook', 'Ein Admin hat sich selbst getötet', 'self')
                end,
            },
            {
                title = 'Give Weapon',
                description = 'Player Actions',
                icon = 'gun',
                arrow = true,
                onSelect = function()
                    OpenGunMenu()
                end,
            },
            {
                title = 'Give Item',
                description = 'Player Actions',
                icon = 'gavel',
                arrow = true,
                onSelect = function()
                    OpenItemMenu()
                end,
            },
            {
                title = 'Give Money',
                description = 'Player Actions',
                icon = 'money-bill-wave',
                arrow = true,
                onSelect = function()
                    OpenMoneyMenu()
                end,
            },
            {
                title = 'Noclip',
                description = 'Player Actions',
                icon = 'skull',
                onSelect = function()
                    Noclip()
                end,
            },
        }
    })

    lib.showContext('SelfMenu')
end

function OpenMoneyMenu()
    lib.registerContext({
        id = 'MoneyMenu',
        title = 'Money Menu',
        options = {
            {
                title = 'Give Money',
                description = 'Player Actions',
                icon = 'money-bill',
                onSelect = function()
                    GiveMoney('Hand')
                end,
            },
            {
                title = 'Give Bank Money',
                description = 'Player Actions',
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
    local input = lib.inputDialog('Add Money', {
        {type = 'number', label = 'Money', description = 'Wie viel Geld', icon = 'hashtag'},
    })

    if not input then return end

    local Money = tonumber(input[1])

    TriggerServerEvent('admin_menu:server:GiveMoney', Money, Type)
end

function OpenItemMenu()
    local Items = GetAllItems()

    -- Wait weil die Funktione GetAllItems ist Async
    while #Items == 0 do
        Wait(1)
    end

    lib.registerContext({
        id = 'ItemListMenu',
        title = 'Self Menu',
        options = Items
    })

    lib.showContext('ItemListMenu')
end

function GetAllItems()
    local ItemList = {}
    
    ESX.TriggerServerCallback('admin_menu:callback:GetAllitems', function(Items)

        local SpeedMenu =  {
            title = 'Schnellauswahl',
            description = 'Schnell Item geben',
            icon = 'gun',
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
                description = 'Spawnname: ' .. itemName,
                icon = 'bread-slice',
                onSelect = function()
                    GiveItem(itemName)
                end,
                metadata = {
                    {label = 'Weight', value = itemData.weight},
                    {label = 'Can Remove', value = itemData.canRemove}
                },
            }


            table.insert(ItemList, TmpTable)
        end
    end)

    return ItemList
end

function SearchForItem()
    local input = lib.inputDialog('Add Item', {
        {type = 'input', label = 'Spawnname', description = 'Welches item', required = true, min = 1, max = 600},
        {type = 'number', label = 'Counter', description = 'Wie viele Items', icon = 'hashtag'},
    })

    if not input then return end

    local ItemName = input[1]
    local Count = tonumber(input[2])

    TriggerServerEvent('admin_menu:server:GiveItem', string.lower(ItemName), Count)
end

function GiveItem(ItemName)
    local input = lib.inputDialog('Add Count: ' .. ItemName, {
        {type = 'input', label = 'Count', description = 'Wie Viele', default= 1, required = true, min = 1, max = 600}
    })

    if not input then return end

    local Count = tonumber(input[1])

    TriggerServerEvent('admin_menu:server:GiveItem', string.lower(ItemName), Count)
end

function OpenGunMenu()
    lib.registerContext({
        id = 'WeaponListMenu',
        title = 'Self Menu',
        options = GetAllGuns()
    })

    lib.showContext('WeaponListMenu')
end

function SearchForWeapon()
    local input = lib.inputDialog('Add Weapon', {
        {type = 'input', label = 'Spawnname', description = 'Welche Waffe', required = true, min = 1, max = 600},
        {type = 'number', label = 'Ammu', description = 'Wie viel Munition', icon = 'hashtag'},
    })

    if not input then return end

    local WeaponName = input[1]
    local Count = tonumber(input[2])

    TriggerServerEvent('admin_menu:server:GiveWeapon', WeaponName, Count)
end

function GetAllGuns()
    local Guns = {}

    local SpeedMenu =  {
        title = 'Schnellauswahl',
        description = 'Schnell Waffe geben',
        icon = 'gun',
        onSelect = function()
            SearchForWeapon()
        end,
    }

    table.insert(Guns, SpeedMenu)
    table.insert(Guns, AddPlaceHolder())

    for k, WeaponData in ipairs(Config.WeaponList) do
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

function GiveGun(GunName, GunLabel)
    local input = lib.inputDialog('Weapon Info: ' .. GunLabel, {
        {type = 'input', label = 'Ammunation', description = 'Anzahl von der Munition', default= 250, required = true, min = 1, max = 600},
        {type = 'checkbox', label = 'Not with ESX?'},
    })

    if not input then return end

    local Ammo = tonumber(input[1])
    local WithESX = input[2]

    -- Check if gives Weapon with ESX or not
    if WithESX then
        --  Without ESX
        GiveWeaponToPed(ped, GunName, Ammo, false, false)
    else
        TriggerServerEvent('admin_menu:server:GiveWeapon', GunName, Ammo)
    end
end






-- Brauchst seine eigene Notify ESX NOCLIP TRIGGER xPlayer.triggerEvent('esx:noclip')
function Noclip()
    ESX.TriggerServerCallback("esx:isUserAdmin", function(admin)
		if admin then
    local player = PlayerId()

    local msg = "disabled"
	if(noclip == false)then
		noclip_pos = GetEntityCoords(ESX.PlayerData.ped, false)
	end

	noclip = not noclip

	if(noclip)then
		msg = "enabled"
	end

	TriggerEvent("chatMessage", "Noclip has been ^2^*" .. msg)
	end
	end)
end