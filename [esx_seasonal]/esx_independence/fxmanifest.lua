fx_version 'cerulean'
game 'gta5'
lua54 'yes'
use_fxv2_oal 'yes'

name 'esx_independence'
description 'Independence Day Fireworks Collection for ESX Legacy'
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
--   'client/module/independence/class.lua'
-- }

-- server_scripts {
--   'server/main.lua',
--   'server/module/independence/class.lua'
-- }

dependencies {
  'es_extended',
  'ox_lib'
}
