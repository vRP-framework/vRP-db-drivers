local DBDriver = class("oxmysql", vRP.DBDriver)

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
  self.API = exports["oxmysql"]
  return self.API ~= nil
end

function DBDriver:onPrepare(name, query)
  self.queries[name] = query
end

function DBDriver:onQuery(name, params, mode)
  local query = self.queries[name]

  local _params = { _ = true }

  for k,v in pairs(params) do
    _params["@"..k] = v
  end

  if mode == "execute" then
    return self.API:updateSync(query, _params)
  elseif mode == "scalar" then
    return self.API:scalarSync(query, _params)
  else
    local result = self.API:executeSync(query, _params)

    -- last insert id backwards compatibility
    if query:find(";.-SELECT.+LAST_INSERT_ID%(%)") then
      return { { id = result[1].insertId } }, result[1].affectedRows
    end

    for _,row in pairs(result) do
      for k,v in pairs(row) do
        if type(v) == "table" then
          row[k] = blob2string(v)
        end
      end
    end

    return result, #result
  end
end

async(function()
  vRP:registerDBDriver(DBDriver)
end)
