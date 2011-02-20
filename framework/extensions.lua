--[[ 

extensions.lua v0.1  FEB-29-2011
  Copyright (c) 2011 Ben Sharpe
  
stringify can save table to a string and restore them from that string.
anything having a 'nil' value is not stored.

the format of the string is 1 line per element
each element has 6 parts separated by pipes

1|2|3|4|5|6

part 1 - is always 't' for table (i suppose this could be removed since it's always a 't')
part 2 - is the table index (1 is the master table, subsequent numbers are sub-tables)
part 3 - is either ['s','n'] for string or numeric table key
part 4 - is the value of the table key
part 5 - is the type of the value ['s','n','b','t'] for String, Numeric, Boolean or Table
part 6 - is the value for this table element.   If the type is 't' this is the index to the subtable.

e.g.
require('stringify')

table:serialize({1,2,3,4}) -> produces
  --0.1
  t|1|n|1|n|1
  t|1|n|2|n|2
  t|1|n|3|n|3
  t|1|n|4|n|4
  
table:serialize({ test = { a = 1, b = 2, c = 3}, volume = 1, sfx = true }) -> produces
  --0.1
  t|2|s|a|n|1
  t|2|s|c|n|3
  t|2|s|b|n|2
  t|1|s|test|t|2
  t|1|s|sfx|b|true
  t|1|s|volume|n|1
  
Inspired by serializion code posted by Tony Finch, Wed, 11 Nov 2009 to the lua-users usenet group

Permission is hereby granted, free of charge, to any person
obtaining a copy of this software and associated documentation
files (the "Software"), to deal in the Software without
restriction, including without limitation the rights to use,
copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following
conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.
]]

-----------------------------------------------------------------------------
-- Module declaration
-----------------------------------------------------------------------------
module("extensions", package.seeall)

--
-- split a string into a table using the seperater
function string.split(self, sep)
  local sep = sep or ":"
  local fields = {}
  local pattern = string.format("([^%s]+)", sep)
  self:gsub(pattern, function(c) fields[#fields+1] = c end)
  return fields
end


local str_funcs = {}

local function szstr(s) return "s|" .. ('"%s"'):format(s:gsub("[^ !#-~]", char)) end
local function szany(...) return str_funcs[type(...)](...) end
local function sztbl(t,code,var,index)
  for k,v in pairs(t) do
    if (type(v) ~= "function" and string.sub(tostring(k),1,2) ~= '__') then
      local ks = szany(k,code,var)
      local vs = szany(v,code,var)
      code[#code+1] = ("t|%d|%s|%s"):format(index,ks,vs)
    end
  end
  return '' -- "t|"
end

local function memo(sz)
  return function(d,code,var)
    if var[d] == nil then
      var[1] = var[1] + 1
      var[d] = ("%d"):format(var[1])
      sz(d,code,var,var[d])
    end
    return "t|" .. var[d]
  end
end

local function simple(val)
  return string.sub(type(val),1,1) .. "|" .. tostring(val)
end

local function skip(val)
  return ''
end

str_funcs["boolean"]  = simple
str_funcs["number"]   = simple
str_funcs["string"]   = simple
str_funcs["table"]    = memo(sztbl)
str_funcs["nil"]      = simple

function table.serialize(tbl)
  local code = { "--0.1" }
  local value = szany(tbl,code,{0})
  if #code == 2 then 
    return code[2]
  else 
    return table.concat(code, "\n")
  end
end

function table.deserialize(stringdata)
  local results = {{}}
  for line in stringdata:gmatch("[^\r\n]+") do 
    parts = line:split('|')
    if (#parts == 6) then
      local key, value
      local table_index = tonumber(parts[2])
      results[table_index] = results[table_index] or {}
      if (parts[3] == 's') then
        key = parts[4]
      else
        key = tonumber(parts[4])
      end
      if (parts[5] == 'n') then
        value = tonumber(parts[6])
      elseif (parts[5] == 'b') then
        value = (parts[6] == 'true')
      elseif (parts[5] == 't') then
        value = results[tonumber(parts[6])]
      else
        value = parts[6]
      end
      results[table_index][key] = value
    end
  end
  return results[1]
end

function table.print(tt, indent, done)
  done = done or {}
  indent = indent or 0
  if type(tt) == "table" then
    local sb = {}
    for key, value in pairs (tt) do
      table.insert(sb, string.rep (" ", indent)) -- indent it
      if type (value) == "table" and not done [value] then
        done [value] = true
        table.insert(sb, string.format("%s = {\n", tostring(key)));
        table.insert(sb, table.print (value, indent + 2, done))
        table.insert(sb, string.rep (" ", indent)) -- indent it
        table.insert(sb, "}\n");
      elseif "number" == type(key) then
        table.insert(sb, string.format("%s = %s\n",tostring(key), tostring(value)))
      else
        local tmp = tostring(value)
        if (type(value) == 'string') then
          tmp = "\"" .. value .. "\""
        end
        table.insert(sb,string.format("%s = %s\n", tostring(key), tmp))
      end
    end
    return table.concat(sb)
  else
    return tostring(tt) .. "\n"
  end
end

function table.tostring( tbl )
    if  "nil"       == type( tbl ) then
        return tostring(nil)
    elseif  "table" == type( tbl ) then
        return table.print(tbl)
    elseif  "string" == type( tbl ) then
        return tbl
    else
        return tostring(tbl)
    end
end