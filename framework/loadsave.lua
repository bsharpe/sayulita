--[[ ########## Saving and Loading ########## ]--

:: SAVING EXAMPLE ::

    local myData     = {}
    myData.bestScore = 500
    myData.volume    = .8

    Save(myData)

:: LOADING EXAMPLE ::

    local myData = Load()
    print(myData.bestScore) <== 500
    print(myData.volume)    <== .8

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
