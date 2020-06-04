resource_manifest_version "44febabe-d386-4d18-afbe-5e627f4af937"

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
