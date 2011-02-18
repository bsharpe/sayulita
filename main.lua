--[[
  Sayulita Main.lua
  
  This is the first file that your app runs when you start it.
  
  We use the Director class (by Ricardo Rauber Pereira) to manage movement between scenes.
]]


display.setStatusBar( display.HiddenStatusBar ) 

-- Import director class
local director = require("director")

local ms = require("xtra")

-- Create a main group
local mainGroup = display.newGroup()

-- Main function
local function main()
	
	-- Add the group from director class
	mainGroup:insert(director.directorView)
	
	-- Some global game variables to pass to other modules
	
	director:changeScene( "game" )
	
	return true
end

-- Begin
main()