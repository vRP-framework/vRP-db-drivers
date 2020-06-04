local Proxy = module("vrp", "lib/Proxy")
local vRP = Proxy.getInterface("vRP")

async(function()
  vRP.loadScript("vrp_ghmattimysql-js", "init_vrp")
end)
