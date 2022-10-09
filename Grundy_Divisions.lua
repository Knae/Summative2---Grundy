--local meta = {__index = Grundy_Divisions}
Grundy_Divisions = {}

function Grundy_Divisions:new(ref)
  ref = ref or {}
  setmetatable(ref,self)
  self.__index = self
  return ref
end

function Grundy_Divisions:PrintElements()
  local index = 0
  for val1, val2 in ipairs(self) do
    index = index+1
    print("Stack " ,index, ":", val2[1], "&", val2[2])
  end
  return index
end

function Grundy_Divisions:FindPossibleDivisions( value)
  local halfValue = math.floor(value/2)
  for index = 1,halfValue do
    self[index] = { index, value-index }
  end
end

function Grundy_Divisions:ClearTable()
  while self[1] ~= nil do
    table.remove(self)
  end
end

return Grundy_Divisions