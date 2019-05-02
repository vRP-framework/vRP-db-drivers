local DBDriver = class("ghmattimysql", vRP.DBDriver)

-- STATIC

local function blob2string(blob)
  for i,c in pairs(blob) do
    blob[i] = string.char(c)
  end

  return table.concat(blob)
end

-- METHODS

function DBDriver:onInit(cfg)
  self.queries = {}
  self.API = exports["GHMattiMySQL"]
  if self.API then
    self.API:Query("SELECT 1") -- multiple Buffer issue fix
  end
  return self.API ~= nil
end

function DBDriver:onPrepare(name, query)
  self.queries[name] = query
end

function DBDriver:onQuery(name, params, mode)
  local query = self.queries[name]

  local _params = {}
  _params._ = true -- force as dictionary

  for k,v in pairs(params) do
    _params["@"..k] = v
  end

  local r = async()

  if mode == "execute" then
    self.API:QueryAsync(query, _params, function(affected)
      r(affected or 0)
    end)
  elseif mode == "scalar" then
    self.API:QueryScalarAsync(query, _params, function(scalar)
      r(scalar)
    end)
  else
    self.API:QueryResultAsync(query, _params, function(rows)
      for _,row in pairs(rows) do
        for k,v in pairs(row) do
          if type(v) == "table" then
            row[k] = blob2string(v)
          end
        end
      end

      r(rows, #rows)
    end)
  end

  return r:wait()
end

async(function()
  vRP:registerDBDriver(DBDriver)
end)
