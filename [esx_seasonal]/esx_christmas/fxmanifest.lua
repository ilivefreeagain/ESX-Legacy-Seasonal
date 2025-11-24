fx_version 'cerulean'
game 'gta5'
lua54 'yes'
use_fxv2_oal 'yes'

name 'esx_christmas'
description 'Christmas Present Hunt event for ESX Legacy'
author 'ESX Team'
version '1.0.0'

shared_scripts {
  'config/main.lua',
  '@es_extended/imports.lua',
  '@es_extended/locale.lua',
  'locales/*.lua',
}

client_scripts {
  'client/main.lua'
}

server_scripts {
  'server/main.lua'
}

files {
  'client/module/christmas/class.lua',
  'server/module/christmas/class.lua',
  'stream/*',
}

this_is_a_map 'yes'

data_file 'DLC_ITYP_REQUEST' 'stream/sp_christmas_prop.ytyp'

dependencies {
  'es_extended'
}
