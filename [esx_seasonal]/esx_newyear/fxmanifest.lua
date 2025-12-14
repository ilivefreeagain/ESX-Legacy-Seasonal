fx_version 'cerulean'
game 'gta5'
lua54 'yes'
use_fxv2_oal 'yes'

name 'esx_newyear'
description 'New Year Celebration event for ESX Legacy'
author 'ESX Team'
version '1.0.0'

shared_scripts {
  '@ox_lib/init.lua',
  'config/main.lua',
  '@es_extended/imports.lua',
  '@es_extended/locale.lua',
  'locales/*.lua',
}

client_scripts {
  'client/main.lua'
  -- 'client/module/newyear/class.lua' -- TODO: Create from template
}

server_scripts {
  'server/main.lua'
  -- 'server/module/newyear/class.lua' -- TODO: Create from template
}

dependencies {
  'es_extended',
  'ox_lib'
}
