fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'Supernoob Indonesia'
description 'Waypoint-based autopilot with selectable driving modes and on-screen controls.'
version '2.1.0'

shared_scripts {
    '@ox_lib/init.lua'
}

client_scripts {
    'client.lua'
}

dependencies {
    'ox_lib'
}
