
description "vRP GHMattiMySQL db driver bridge"

dependencies{
  "vrp",
  "GHMattiMySQL"
}

-- server scripts
server_scripts{ 
  "@vrp/lib/utils.lua",
  "init.lua",
  "init_vrp.lua"
}
