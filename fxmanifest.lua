fx_version 'cerulean'
games {'gta5'}

shared_scripts { "shared/*.lua" }

client_scripts {
    "client/*.lua",
}

server_scripts {
    "@mysql-async/lib/MySQL.lua",
    "server/*.lua",
}

ui_page {
	"html/ui.html",
}

files {
	"html/ui.html",
	"html/CSS/*.css",
	"html/JS/*.js",
	"html/IMG/*.png",
}

--- Xed#1188 | https://discord.gg/HvfAsbgVpM