module(..., package.seeall)

-- Globals
fps = require 'framework/fps'

-- Groups
local localGroup = display.newGroup()

-- Images

local background = display.newImage("images/background.png")

-- Audio

-- Functions

function initLevel()
  -- 
  -- Add things to the localGroup
  --
  localGroup:insert(background)
end

---------------------------------------------------------------
-- NEW
---------------------------------------------------------------

function new()
	
	-----------------------------------
	-- Initiate variables
	-----------------------------------
	
	initLevel()
	
  local fpsMeter = fps.getMeter();
  fpsMeter:setReferencePoint(display.bl)
  fpsMeter.x, fpsMeter.y = 0,  screenH;
	
	-----------------------------------
	-- MUST return a display.newGroup()
	-----------------------------------	
	return localGroup
end

---------------------------------------------------------------
-- CLEAN
---------------------------------------------------------------

function clean ( event )
  
	print("game cleaned")
end

