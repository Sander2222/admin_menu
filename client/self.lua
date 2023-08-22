local noclip = false

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
                    SetEntityHealth(PlayerPedId(), 200)
                    Config.ClientNotify('Du hast dich gehielt')
                    TriggerServerEvent('admin_menu:server:SendWebhook', 'Ein Admin hat sich gehealt', 'self')
                end,
            },
            {
                title = 'Give Armor',
                description = 'Player Actions',
                icon = 'shield-halved',
                onSelect = function()
                    SetPedArmour(PlayerPedId(), 100)
                    Config.ClientNotify('Du hast dir selbst armor gegeben')
                    TriggerServerEvent('admin_menu:server:SendWebhook', 'Ein Admin hat sich armor gegeben', 'self')
                end,
            },
            {
                title = 'Kill Self',
                description = 'Player Actions',
                icon = 'skull',
                onSelect = function()
                    SetEntityHealth(PlayerPedId(), 0)
                    Config.ClientNotify('Du hast dich selbst getötet')
                    TriggerServerEvent('admin_menu:server:SendWebhook', 'Ein Admin hat sich selbst getötet', 'self')
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
            {
                title = 'Give Weapon',
                description = 'Player Actions',
                icon = 'gun',
                onSelect = function()
                    OpenGunMenu()
                end,
            },
        }
    })

    lib.showContext('SelfMenu')
end

function OpenGunMenu()
    lib.registerContext({
        id = 'WeaponListMenu',
        title = 'Self Menu',
        options = GetAllGuns()
    })

    lib.showContext('WeaponListMenu')
end

function GetAllGuns()
    local Guns = {}

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
        GiveWeaponToPed(PlayerPedId(), GunName, Ammo, false, false)
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
