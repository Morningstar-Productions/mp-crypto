fx_version 'cerulean'
game 'gta5'

description ''
author ''
version '0.0.0'

client_scripts {
    '@PolyZone/client.lua',
    '@PolyZone/BoxZone.lua',
    '@PolyZone/EntityZone.lua',
    '@PolyZone/CircleZone.lua',
    '@PolyZone/ComboZone.lua',
    'client/**/*'
}

server_scripts {
    'server/**/*'
}

shared_scripts {
    '@qb-core/shared/locale.lua',
    'locales/en.lua',
    'locales/*.lua',
    'shared/**/*',
    '@ox_lib/init.lua'
}

lua54 'yes'