module(..., package.seeall)

--[[ ########## Global Screen Dimensions ########## ]--
from crawlspace.lua
  https://github.com/AdamBuchweitz/CrawlSpaceLib


Use these global variables to position your elements. They are dynamic
to all resolutions. Android devices are usually taller, so use screenY to
set the position where you expect 0 to be. The iPad is wider than iPhones,
so use screenY. Also the width and height need to factor these differences
in as well, so use screenWidth and screenHeight. Lastly, centerX and cetnerY
are simply global remaps of display.contentCenterX and Y.

:: USAGE ::

    myObject.x, myObject.y = screenX + 10, screenY + 10 -- Position 10 pixels from the top left corner on all devices

    display.newText("centered text", centerX, centerY, 36) -- Center the text

    display.newRect(screenX, screenY, screenWidth, screenHeight) -- Cover the screen, no matter what size

:: NOTES :: 
   I broke out the multiple assignments for easier reading by newcomers. - bsharpe
]]
local centerX = display.contentCenterX
local centerY = display.contentCenterY
local screenX = display.screenOriginX
local screenY = display.screenOriginY
local screenW = display.contentWidth  - screenX * 2
local screenH = display.contentHeight - screenY * 2
_G.centerX = centerX
_G.centerY = centerY
_G.screenX = screenX
_G.screenY = screenY
_G.screenW = screenW
_G.screenH = screenH
display.contentWidth  = screenW
display.contentHeight = screenH

--[[ ########## Reference Point Shorthand ########## ]--

All this block does it set shorthand notations for all reference points.
The main purpose of this is for passing short values into display objects.

:: EXAMPLE 1 ::

    myObject:setReferencePoint(display.tl)

]]

display.tl = display.TopLeftReferencePoint
display.tc = display.TopCenterReferencePoint
display.tr = display.TopRightReferencePoint
display.cl = display.CenterLeftReferencePoint
display.c  = display.CenterReferencePoint
display.cr = display.CenterRightReferencePoint
display.bl = display.BottomLeftReferencePoint
display.bc = display.BottomCenterReferencePoint
display.br = display.BottomRightReferencePoint


--[[
from crawlspace.lua
  https://github.com/AdamBuchweitz/CrawlSpaceLib

Checks the content scaling and sets a global var "scale". In addition,
if you use sprite sheets and was retina support, append the global "suffix"
variable when calling your datasheet, and it will pull the hi-res version
when it's needed. On the topic of devices and scales, when in the simulator,
the global variable "simulator" is set to true.

]]

local scale  = display.contentScaleX
local suffix = ""
if scale < 1 then suffix = "@2x" end
_G.scale  = scale
_G.suffix = suffix

if system.getInfo("environment") == "simulator" then _G.simulator = true end
