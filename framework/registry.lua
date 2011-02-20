--[[ 

## Variable Registry, or "Globals"

Some of you may choose not to use this set of functions because global
information is generally a bad idea. What I use this for is tracking data
across the entire app, that may need to be changes in any one of a myriad
different files. For me the trade off is worth it. In main.lua I register
whatever variables I will need to track, and many of those I retrieve on
applicationExit to save them for use on next launch. Other than saving data,
it's very helpful to use these to keep track of a score, or a volume leve,
whether or not to play SFX, etc.

As a side note, this library automatically registers a variable for
"volume" and "sfx", as these are going to be used in most projects.

:: USAGE ::

  require('framework/registry')
  
  -- create a new registry, optionally supplying default values for things
  -- The registry will be loaded from disk (if available) and the defaults applied
  -- to missing values.  Defaults will not override saved values.
  registry = Registry:new{ sfx = true, volume = 10, score = 0}

  registry:save() <-- writes all data to disk
  
:: EXAMPLE 1 ::

    registry.sfx = false

    print(registry.sfx) <== prints false

:: EXAMPLE 2 ::

    registry:inc("score", 1)
    registry:inc("score", 2) 

    print(registry.score) <== prints 3
    registry:dec("score", 1)
    print(registry.score) <== prints 2

    registry.score = 0

    print(registry.score) <== prints 0
    
:: NOTES :: 
  You can set the name of the file the registry is saved in by setting the member
  'registry_filename' to the name of the file.  The default filename is 'registry.txt'.
  
  e.g.
    registry.registry_filename = "test.dat"
    registry:save() <-- now saved to "test.dat"
    
  This lets you have multiple separate registries if you app needs it.
  
  e.g.
    reg1 = Registry:new{registry_filename = "reg1.dat"}
    reg2 = Registry:new{registry_filename = "reg2.dat"}
    
    reg1.score = 1
    reg2.score = 2
    
    print(reg1.score) <-- 1
    reg1:save()
    reg2:save()
    

]]
require('framework/extensions')
require('framework/loadsave')

Registry = {}
Registry.__index = Registry

module(..., package.seeall)

local registry_filename = "registry.txt"

function Registry:new(defaults)
  local filename = defaults.registry_filename or registry_filename
  local registry = Registry:load(filename)
  local defaults = defaults or {}
  for k,v in pairs(defaults) do
    -- if a value already exists the default value will not override it.
    if (registry[k] == nil) then
      --print("Setting Default: " .. tostring(k) .. ' = ' .. tostring(v))
      registry[k] = v
    else
      --print("Value exists for " .. tostring(k) .. ' = ' .. tostring(registry[k]))
    end
  end
  return registry
end

function Registry:inc( name, value )
  value = value or 1
  local errmsg = nil
  local result = self[name]
  if (type(result) == nil) then
    result = value
  elseif (type(result) == "number") then
    result = result + value
  else 
    errmsg = "Registry.inc() ERR: " .. name .. " is not a number."
    print(errmsg)
    result = nil
  end
  self[name] = result
  return result, errmsg
end

function Registry:dec( name, value )
  value = value or 1
  
  local errmsg = nil
  local result = self[name]
  if (type(result) == nil) then
    result = -value
  elseif (type(result) == "number") then
    result = result - value
  else 
    errmsg = "Registry.dec() ERR: " .. name .. " is not a number."
    print(errmsg)
    result = nil
  end
  self[name] = result
  return result, errmsg
end

function Registry:save()
  self.registry_filename = self.registry_filename or registry_filename
  _G.Save(self.registry_filename, table.serialize(self))
  print("Registry:save(" .. self.registry_filename .. ")")
end

function Registry:load(filename)
  local filename = filename or registry_filename
  local new_registry = table.deserialize(_G.Load(filename)) 
  new_registry.registry_filename = filename
  setmetatable(new_registry, Registry)
  return new_registry
end

 

