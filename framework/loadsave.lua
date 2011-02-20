--[[
loadsave.lua
v0.1 -- FEB-18-2011

:: SAVING EXAMPLE ::

    Save(myData)

:: LOADING EXAMPLE ::

    local myData = Load()
    print(myData.bestScore) <== 500
    print(myData.volume)    <== .8

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


module(..., package.seeall)

local saveData = function(fileName, data)
  assert(fileName)
  assert(data)
  local filePath = system.pathForFile( fileName, system.DocumentsDirectory )
  local file = io.open( filePath, "w" )
  file:write(data)
  io.close(file)
end
_G.Save = saveData

local loadData = function(fileName)
  assert(fileName)
  local filePath = system.pathForFile( fileName, system.DocumentsDirectory )
  local file = io.open( filePath, "r" )
  local result = nil
  local error = nil
  if file then
    result = file:read("*all")
    --print("Loading: " .. result)
  else
    error = "File(" .. filename .. ") not found"
    print(error)
  end
  io.close(file)
  return result, error
end
_G.Load = loadData
