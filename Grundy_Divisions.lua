--This module is for determine the possible divisions a stack can be split into
Grundy_Divisions = {}

--returns the ref to the itself
function Grundy_Divisions:new(ref)
  ref = ref or {}
  setmetatable(ref,self)
  self.__index = self
  return ref
end

--Prints all the possible split pairs
function Grundy_Divisions:PrintElements()
  local index = 0
  for val1, val2 in ipairs(self) do
    index = index+1
    print("Stack " ,index, ":", val2[1], "&", val2[2])
  end
  return index
end

--Determine all the possible divisions the stack( or specifically its value)
--can be split into
function Grundy_Divisions:FindPossibleDivisions( value)
  --Do avoid duplicate pairs, continue until reaching half of the value being split
  local halfValue = math.floor(value/2)
  for index = 1,halfValue do
    --keep adding every possible division into the table
    self[index] = { index, value-index }
  end
end

--clear the table by repeatedly removing the last element in the table until
--the first element is nil
function Grundy_Divisions:ClearTable()
  while self[1] ~= nil do
    table.remove(self)
  end
end

return Grundy_Divisions