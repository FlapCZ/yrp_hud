description 'YourRolePlay Development HUD inspirated by poggu_hud'
author 'YourRolePlay Development // discord -> https://discord.gg/uSv9sWwhE9'
version '1.0'

client_scripts {
	'config/config.lua',
	'client/client.lua'
}
server_scripts {
	'config/config.lua',
	'server/server.lua',
	'config/server_config.lua'
}

ui_page 'html/index.html'

files {
	'html/index.html',
	'html/main.js',
	'html/main.css'
}

dependencies {
	'es_extended',
	'esx_identity'
}