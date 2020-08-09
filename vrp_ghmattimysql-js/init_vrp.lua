local DBDriver = class("ghmattimysql-js", vRP.DBDriver)

-- STATIC

local function blob2string(blob)
  local data = {}
  for i, byte in ipairs(blob) do data[i] = string.char(byte) end
  return table.concat(data)
end

-- METHODS

function DBDriver:onInit(cfg)
  self.queries = {}
  self.API = exports["ghmattimysql"]
  return self.API ~= nil
end

function DBDriver:onPrepare(name, query)
  self.queries[name] = query
end

function DBDriver:onQuery(name, params, mode)
  local query = self.queries[name]
  local _params = {_ = true} -- force as map
  for k,v in pairs(params) do _params[k] = v end

  local r = async()
  if mode == "execute" then
    self.API:execute(query, _params, function(data)
      r(data.affectedRows or 0)
    end)
  elseif mode == "scalar" then
    self.API:scalar(query, _params, function(scalar)
      r(scalar)
    end)
  else
    self.API:execute(query, _params, function(rows)
      -- last insert id backwards compatibility
      if query:find(";.-SELECT.+LAST_INSERT_ID%(%)") then rows = rows[#rows] end

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
