local Conversions

do
	local _VERSION = "0.0.1"

  Conversions = {}
	Conversions._VERSION = _VERSION
end

local function StringToText(str)
  if str:find("\n") then
    local n = 0
    if str:find("%]$") then
      n = n + 1
    end
    while str:find("%["..string.rep("=",n).."%[") or str:find("%]"..string.rep("=",n).."%]") do
      n = n + 1
    end
    return "["..string.rep("=",n).."["..str.."]"..string.rep("=",n).."]", true
  else
    return "\""..str:gsub("\\","\\\\"):gsub("\"","\\\"").."\""
  end
end

local function IterateTable(t)
  local prev
  local index = 1
  local indexMax
  local isIndexDone
  local function it()
    if not indexMax then
      local v = t[index]
      if v then
        index = index + 1
        return index-1, v, true
      else
        indexMax = index - 1
      end
    end
    local k,v = next(t,prev)
    prev = k
    while k and type(k)=="number" and k >= 1 and k <= indexMax do
      k,v = next(t,prev)
      prev = k
    end
    return k, v, false
  end
  return it
end

function Conversions:TableToText(t,e,b)
  b = b or {}
  b[t] = true
  e = e or {"{"}
  local ignoreIndex = false
  for k,v,isIndex in IterateTable(t) do
    local newline = ""
    local ignore = true
    if type(v) == "boolean" or type(v) == "number" or type(v) == "string" or type(v) == "table" then
      ignore = false
    end
    if type(v) == "table" and b[v] then
      ignore = true
    end
    if ignore then
      ignoreIndex = true
    elseif isIndex and not ignoreIndex then
    elseif type(k)=="number" then
      newline = newline .. "["..k.."]="
    elseif type(k)=="string" then
      if k:match("[A-Za-z_][A-Za-z_0-9]*") == k then
        newline = newline .. k .. "="
      else
        local kstr, ismultiline = StringToText(k)
        newline = newline .. "["..(ismultiline and " " or "")..kstr..(ismultiline and " " or "").."]="
      end
    elseif type(k)=="boolean" then
      newline = newline .. "["..(k and "true" or "false").."]="
    else
      ignore = true
    end
    if not ignore then
      local tableToExplore
      if type(v)=="number" then
        newline = newline .. v .. ","
      elseif type(v)=="string" then
        newline = newline .. StringToText(v)..","
      elseif type(v)=="boolean" then
        newline = newline ..(v and "true" or "false")..","
      elseif type(v)=="table" then
        newline = newline .."{"
        tableToExplore = v
      end
      e[#e+1] = newline
      if tableToExplore then
        Conversions:TableToText(tableToExplore,e,b)
        e[#e] = e[#e] .. ","
      end
    end
  end
  e[#e] = e[#e]:gsub(",$","")
  e[#e+1] = "}"
  return e
end

return Conversions
