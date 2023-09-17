Locals = {

    OnlyAdmin = 'This command is for admin use only',

    Main = {
        AdminMenu = ' Admin menu',

        Actions = ' Actions',
        Self = 'Self',
        Player = 'Player',
        Vehicle = 'Vehicle',
        Server = 'Server',

        Message = 'Message',
        Empty = 'Your input is empty',
    },
    Self = {
        SelfMenu = 'Self Menu',
        ReviveMe = 'Revive me',
        RevivedSelf = 'You have revived yourself',
    
        HealMe = 'self heal',
        HealSelf = 'You have held yourself',
    
        ArmorMe = 'Give armor',
        ArmorSelf = 'You have given yourself armor',
    
        KillMe = 'Kill self',
        KillSelf = 'you killed yourself',

        WeaponMe = 'Give weapon',
        WeaponQuickSelection = 'Quick selection',
        WeaponDsec = 'Quickly give weapon',
        WeaponAdd = 'Add weapon',
        WeaponName = 'Spawn name',
        WeaponWhich = 'Which weapon',
        WeaponAmmu = 'Ammunition',
        WeaponAmmuDesc = 'How much ammunition',
        WeaponEnterNumber = 'You must enter a valid number',
        WeaponInfo = 'Weapon info',
        WeaponWithESX = 'Not with ESX?',

        ItemMe = 'Give item',
        ItemQuickSelection = 'Quick selection',
        ItemDesc = 'Quickly give item',
        ItemName = 'Spawn name',
        ItemWeight = ' Weight',
        ItemCanRemove = 'Can remove',
        ItemAdd = 'Add item',
        ItemCount = 'Count',
        ItemWhich = 'Which item',
        ItemMuch = 'How much items',
        ItemEnterNumber = 'You must enter a valid number',
        ItemAddCount = 'Add count',

        MoneyMe = 'Give money',
        MoneyMeBank ='Give money bank',
        MoneyAdd = 'Add money',
        Money = 'Money',
        MoneyMuch = 'how much money',
        MoneyEnterNumber = 'You must enter a valid number',

        NoclipMe = 'Noclip',

        Webhooks = {
            RevivedSelf = 'An admin has revived himself',
            HealedSelf = 'An admin has healed himself',
            ArmorSelf = 'An admin has given himself armor',
            KilledSelf = 'An admin killed himself',
        }
    },
    
    Player = {
        KickPlayer = 'Kick player',
        IDs = 'Steamname/ID/Name',
        EnterIDs = 'Enter a Steam name, ID or the name of a player here',

        AtLeast3 = 'you must enter at least 3 characters',
        NoPlayerFound = 'No player was found',
        PlayerFound = '%s players were found',

        Search = 'Search',
        SearchPlayer = 'Search player',
        Refresh = 'Refresh',
        RefreshList = 'Refresh list',
        ID = 'ID',
        Steam = 'Steam',
        Job = 'Job',
        Group = 'Group',

        Ban = 'Ban',
        BanPlayer = 'Ban player',
        Inventory = 'Inventory',
        PlayerInventory = 'Player Inventory',
        Weapon = 'Weapons',
        PlayerWeapons = 'Player weapons',
        TakeScreenshot = 'Take screenshot',
        PlayerScreenshot = 'Take a screenshot from a player',
        JobMenu = 'Job menu',
        PlayerJobMenu = 'Player job menu',
        SendMsg = 'Send message',
        PlayerSendMsg = 'Send player a message',
        Kick = 'Kick Player',
        PlayerKick = 'Kick a player from the server',
        Kill = 'Kill player',
        PlayerKill = 'Kill player',
        Armor = 'Give armor',
        PlayerArmor = 'Give a player armor',
        Money = 'Give money',
        PlayerMoney = 'Give a player money',

        -- Ban Menu
        BanMenu = 'Ban menu',
        SpecificBan = 'Specific ban', 
        SpecificBanDesc = 'Ban players after certain days',
        BanHour = '1 hour',
        BanHourDesc = 'for 1 hour',
        BanDay = '1 day',
        BanDayDesc = 'for 1 day',
        BanWeek = '1 week',
        BanWeekDesc = 'for 1 week',
        BanPerm = 'Ban permanent',
        BanPermDesc = 'Ban for permanent',
        Reason = 'Reason',
        ReasonDesc = 'Ban reason',
        DateInput = 'Date input',

        -- Money Menu
        MoneyMenu = 'Money menu',
        MoneyName = 'Money',
        MoneyBank ='Give money bank',
        MoneyAdd = 'Add money',
        MoneyMuch = 'how much money',
        MoneyEnterNumber = 'You must enter a valid number',

        -- Weapon
        WeaponAddPlayer = 'Add a weapon to a player',
        WeaponGive = 'Give weapon',
        WeaponDelAll = 'Delete all weapons',
        WeaponDelAllDesc = 'Delete all weapons from a player',
        WeaponAmmu = 'Ammunition',
        WeaponTintIndex = 'Tint Index',
        WeaponAdd = 'Add weapon',
        WeaponQuickSelection = 'Quick selection',
        WeaponDsec = 'Quickly give weapon',
        WeaponAmmuDesc = 'How much ammunition',
        WeaponInfo = 'Weapon info',
        WeaponEnterNumber = 'You must enter a valid number',
        WeaponDelAllSure = 'Are you sure you want to remove all the weapons from the player',
        WeaponAdjustAmmunition = 'Adjust ammunition',
        WeaponRemove = 'Remove weapon',
        WeaponRemoveDesc = 'Remove this weapon',
        WeaponAdjustComponent = 'Adjust components',
        WeaponHasComponent = 'Player has so many components',
        WeaponNoComponent = 'The player has no components',
        ComponentMenu = 'Waffen components Menu',
        WeaponComponent = 'Component',
        WeaponComponentRemove = 'Remove Component',

        -- Kick
        KickDesc = 'Message displayed on kick',

        -- Message
        SendMessage = 'Send message',
        PrivateMessage = 'Privat message',

        -- Job
        JobName = 'Job name',
        JobGrade = 'Grade',
        JobChange = 'Change job',
        JobReset = 'Reset job',
        JobResetDesc = 'Set the player job to default',

        -- Item
        Item = 'item',
        ItemAdd = 'Add item',
        ItemAddDesc = 'Add an item to a player',
        ItemName = 'Item name',
        ItemCount = 'Count',
        ItemMuch = 'How much items',
        ItemDellAll = 'Delete all items',
        ItemDellAllDesc = 'delete all items from one player',
        ItemDelAllDia = 'Sure you want to remove all items from the player?',
        ItemMax = 'Max Weight',
        ItemOnlySingle = 'Remove only single item',
        ItemOnlySingleDesc = 'remove only specific number',
        ItemRemove = 'Remove item',
    },

    Vehicle = {
        Menu = 'Vehicle Menu',
        DelOne = 'Delete one vehicle',
        DelRadius = 'Delete vehicle radius',
        Spawn = 'Spawn vehicle',
        GivePlayer = 'Give vehicle to player',
        DelPlayer = 'Delete vehicle from player',
    },

    Server = {
        
    }
}