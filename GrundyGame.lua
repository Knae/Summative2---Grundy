GrundyGame = {}

function GrundyGame.NewGame(startStack)
  while GrundyGame[2] ~= nil do
    table.remove(GrundyGame)
  end
  GrundyGame[1] = startStack
  --print("1st value is:",GrundyGame[1])
end

function GrundyGame.CheckIfGameEnd()
  --local gameEnd = true;
  for key,value in ipairs(GrundyGame) do
    --print(value[1],value[2],value[3])
    if value > 2 then
      return false
    end
  end
  return true
end

function GrundyGame:StartSplitting( index )
  local currentDivisions = require("Grundy_Divisions")
  local valueToDivide = GrundyGame[index]

  if valueToDivide == nil then
    print("No value at that index")
    return false
  else if valueToDivide <= 2 then
      print("Stack cannot be splits")
      return false
    end
  end

  print("Splitting", valueToDivide )
  print("=========================")
  print("Possible split outcomes" )
  print("=========================")
  currentDivisions:FindPossibleDivisions(valueToDivide)
  currentDivisions:PrintElements()

  print("Input the number corresponding to how you want to split",valueToDivide)
  local chosenIndex = io.read("*n")

  print("Chosen Index was ", chosenIndex)
  
  if currentDivisions[chosenIndex] == nil then
    print("No data at that index")
    return false
  end
  
  GrundyGame[index] = currentDivisions[chosenIndex][2]
  table.insert(GrundyGame,index,currentDivisions[chosenIndex][1])

  GrundyGame:SortValues()

  currentDivisions:ClearTable()
  return true
end

function GrundyGame:SortValues()
  --GrundyGame.PrintStacks()

  local tempTable = {};

  for key,value in ipairs(GrundyGame) do
    table.insert(tempTable, value)
  end

  table.sort(tempTable)

  --local index = 0
  for key, value in ipairs(tempTable) do
    -- index = index + 1
    -- GrundyGame[index] = tempTable[index]
    GrundyGame[key] = value
  end

  --GrundyGame.PrintStacks()
end

function GrundyGame.PrintStacks()
  local stringToPrint = ""
  local size = 0

  for key,value in ipairs(GrundyGame) do
    stringToPrint = stringToPrint .. "[Stack" .. key .. ": " .. value .. "],"
    size = key
  end

  print(stringToPrint)
  return size
end

function GrundyGame.AI_Easy()
  print("AI(Easy) is thinking.....")
  print("=========================")
  local maxIndex = GrundyGame.PrintStacks()
  local currentDivisions = require("Grundy_Divisions")
  local chosenStack = math.random(maxIndex)
  local valueToDivide = GrundyGame[chosenStack]
  
  print("AI chose stack no:", chosenStack)
  print("==============================")
  if valueToDivide > 2 then
    currentDivisions:FindPossibleDivisions(valueToDivide)
    print("AI had these possible options:")
    print("==============================")
    local maxDivisons = currentDivisions:PrintElements()
  
    print("========= ")
    local chosenIndex = math.random(maxDivisons)
    print("AI chose:",chosenIndex)
    
    GrundyGame[chosenStack] = currentDivisions[chosenIndex][2]
    table.insert(GrundyGame,chosenStack,currentDivisions[chosenIndex][1])

    GrundyGame:SortValues()

    currentDivisions:ClearTable()
    return true
  else
    print("AI chose invalid stack no:", chosenStack)
    print("==============================")
    return false
  end
end

function GrundyGame.AI_InputSelection(_inStackChoice, _inDiviChoice)
  print("AI is thinking.....")
  print("===================")

  local currentDivisions = require("Grundy_Divisions")
  local valueToDivide = GrundyGame[_inStackChoice]

  currentDivisions:FindPossibleDivisions(valueToDivide)

  GrundyGame[_inStackChoice] = currentDivisions[_inDiviChoice][2]
  table.insert(GrundyGame,_inStackChoice,currentDivisions[_inDiviChoice][1])

  print("AI chose stack no:", _inStackChoice)
  print("AI chose split it to: " .. currentDivisions[_inDiviChoice][1] .. "&" .. currentDivisions[_inDiviChoice][2])
  print("==============================")

  GrundyGame:SortValues()

  currentDivisions:ClearTable()
end

return GrundyGame