divisions = {}

function divisions.PrintDivisions()
  local index = 0
  for val1, val2 in ipairs(divisions) do
    index = index+1
    print(index, ". ", val1, " & ", val2)    
  end
end

function divisions.FindPossibleDivisions( value)
  for index = 1, (value//2) do
    divisions[index] = { index, value-index }
  end
end