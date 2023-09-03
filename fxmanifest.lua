fx_version 'adamant'
game 'gta5'

author 'GMD_Scripts, SA_Scripts'
name 'free_adminmenu'
version '0.0.1'
description 'performant adminmenu'

server_script {
	'server/*.lua',
	'svconfig.lua',
	'@oxmysql/lib/MySQL.lua'
}

client_scripts {
	'client/*.lua'
}

shared_scripts {
	'config.lua',
	'@es_extended/imports.lua',
	'@ox_lib/init.lua',
	'locals.lua'
}


dependencies {
	'es_extended',
	'ox_lib'
}

lua54 'yes'