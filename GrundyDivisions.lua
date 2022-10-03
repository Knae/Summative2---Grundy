GrundyDivisions = {}

function GrundyDivisions.PrintDivisions()
  local index = 0
  for val1, val2 in ipairs(GrundyDivisions) do
    index = index+1
    print(index, ":", val2[1], "&", val2[2])
  end
  return index
end

function GrundyDivisions.FindPossibleDivisions( value)
  local halfValue = math.floor(value/2)
  for index = 1,halfValue do
    GrundyDivisions[index] = { index, value-index }
  end
end

function GrundyDivisions.ClearTable()
  while GrundyDivisions[1] ~= nil do
    table.remove(GrundyDivisions)
  end
end

return GrundyDivisions