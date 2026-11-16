fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'Supernoob Indonesia'
description 'Waypoint-based autopilot system with on-screen mode selector and W-tap controls.'
version '2.0.0'

shared_scripts {
    '@ox_lib/init.lua'
}

client_scripts {
    'client.lua'
}

server_script 'server.lua'

dependencies {
    'ox_lib'
}
