local Proxy = module("vrp", "lib/Proxy")

local DBDriver = class("ghmattimysql", vRP.DBDriver)

function DBDriver:onInit(cfg)
  self.proxy = Proxy.getInterface("vrp_ghmattimysql")
  return true
end

function DBDriver:onPrepare(...)
  self.proxy.onPrepare(...)
end

function DBDriver:onQuery(...)
  return self.proxy.onQuery(...)
end

vRP:registerDBDriver(DBDriver)
