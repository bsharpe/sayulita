--[[
  Sayulita Main.lua
  
  This is the first file that your app runs when you start it.
  
  We use the Director class (by Ricardo Rauber Pereira) to manage movement between scenes.
]]


display.setStatusBar( display.HiddenStatusBar ) 

-- Import useful frameworks


-- Requires
require('framework/shortcuts')
require('framework/extensions')
require('framework/loadsave')
require('framework/registry')

-- init the Registry with some defaults
-- it will load from disk first and then apply the defaults if they don't exist
local registry = Registry:new{
   volume = 1,
   sfx    = true,
   score  = 0,
   registry_filename = "registry.txt"
}

-- print the registry to the console
print("volume: " .. tostring(registry["volume"]))

-- set a new Registry value
registry.score   = 666
registry:inc("score", 10)
registry.volume = 10
registry:dec("volume", 1)

-- print the registry to the console
print(table.print(registry))

-- Import director class
local director = require("director")


-- Create a main group
local mainGroup = display.newGroup()

-- Main function
local function main()
	
	-- Add the group from director class
	mainGroup:insert(director.directorView)
	
	-- Some global game variables to pass to other modules
	
	director:changeScene( "app/game" )
	
	return true
end

--Handle the applicationExit event to automagically save the registry on exit
local function onSystemEvent( event )
  if( event.type == "applicationExit" ) then              
    registry:save()
  end
end
 
--setup the system listener to catch applicationExit
Runtime:addEventListener( "system", onSystemEvent )

-- Begin
main()
