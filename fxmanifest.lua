fx_version 'adamant'
game 'gta5'

author 'GMD_Scripts'
name 'free_adminBlips'
version '0.0.1'
description 'performant admin command to see al Players in sync'

server_script {
	'server/server.lua'
}

client_scripts {
	'client/client.lua'
}

shared_scripts {
	'config.lua'
}


dependencies {
	'es_extended'
}