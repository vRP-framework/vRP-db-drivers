fx_version "adamant"
games {"gta5"}

description "vRP GHMattiMySQL (JS) db driver bridge"

dependencies{
  "vrp",
  "ghmattimysql"
}

-- server scripts
server_scripts{ 
  "@vrp/lib/utils.lua",
  "init.lua"
}
