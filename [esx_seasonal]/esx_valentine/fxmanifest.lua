fx_version 'cerulean'
game 'gta5'
lua54 'yes'
use_fxv2_oal 'yes'

name 'esx_valentine'
description 'Valentines Day Love Letter Hunt for ESX Legacy'
author 'ESX Team'
version '1.0.0'

shared_scripts {
  '@ox_lib/init.lua',
  'config/main.lua',
  '@es_extended/imports.lua',
  '@es_extended/locale.lua',
  'locales/*.lua',
}

-- TODO: Create client/main.lua and server/main.lua
-- client_scripts {
--   'client/main.lua',
--   'client/module/valentine/class.lua'
-- }

-- server_scripts {
--   'server/main.lua',
--   'server/module/valentine/class.lua'
-- }

dependencies {
  'es_extended',
  'ox_lib'
}
