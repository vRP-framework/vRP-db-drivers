
local Proxy = module("vrp", "lib/Proxy")
local vRP = Proxy.getInterface("vRP")

local interface = {}
Proxy.addInterface("vrp_ghmattimysql", interface)

local API = exports["GHMattiMySQL"]

local queries = {}

function interface.onPrepare(name, query)
  queries[name] = query
end

function interface.onQuery(name, params, mode)
  local query = queries[name]

  local _params = {}
  _params._ = true -- force as dictionary

  for k,v in pairs(params) do
    _params["@"..k] = v
  end

  local r = async()

  if mode == "execute" then
    API:QueryAsync(query, _params, function(affected)
      r(affected or 0)
    end)
  elseif mode == "scalar" then
    API:QueryScalarAsync(query, _params, function(scalar)
      r(scalar)
    end)
  else
    API:QueryResultAsync(query, _params, function(rows)
      r(rows, #rows)
    end)
  end

  return r:wait()
end

async(function()
  API:Query("SELECT 1") -- multiple Buffer issue fix
  vRP.loadScript("vrp_ghmattimysql", "init_vrp")
end)
