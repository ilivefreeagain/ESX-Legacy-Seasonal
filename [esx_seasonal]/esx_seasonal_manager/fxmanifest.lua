fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'esx_seasonal_manager'
description 'Master manager for all ESX seasonal events'
author 'ESX Team'
version '1.0.0'

shared_scripts {
  'config.lua'
}

server_scripts {
  'server/main.lua'
}

dependencies {
  'esx_christmas',
  'esx_halloween',
  'esx_easter',
  'esx_newyear',
  'esx_valentine',
  'esx_independence'
}
