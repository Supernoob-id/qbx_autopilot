fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'Supernoob Indonesia'
description 'Waypoint-based autopilot with an on-screen driving mode selector.'
version '2.0.0'

shared_scripts {
    '@ox_lib/init.lua'
}

client_scripts {
    'client.lua'
}

dependencies {
    'ox_lib'
}
