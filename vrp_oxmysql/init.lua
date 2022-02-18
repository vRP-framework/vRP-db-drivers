local Proxy = module("vrp", "lib/Proxy")
local vRP = Proxy.getInterface("vRP")

async(function()
  vRP.loadScript("oxmysql", "lib/MySQL")
  vRP.loadScript("vrp_oxmysql", "init_vrp")
end)
