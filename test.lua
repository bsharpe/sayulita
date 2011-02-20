require('framework/extensions')

local tbl = { 
  bob = nil, 
  roberts = nil, 
  test = 1, 
  volume = 1, 
  sfx = false, 
  name = "something", 
  numbers = {1,3,4,5}, 
  testing = {'a','b','c'},
  nothing = { 
      something = 1,
      anything = 2
    },
  3,
  wonder = {
    ful = {
      some = {
        thing = {
          beautiful = {
            nothing = 0,
          }
        }
      }
    }
  }
 }

print(table.print(tbl))
local result = table.serialize(tbl)

print(result)
print("-----")
--local result = stringify.encode(tbl)
--print(result)

local new_result = table.deserialize(result)
print(table.print(new_result))
local end_result = table.serialize(new_result)
print(end_result)

