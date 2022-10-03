GrundyGame = {}

function GrundyGame:new(startStack)
   GrundyGame[1] = startStack 
end

function GrundyGame.NewGame(startStack)
  while GrundyGame[2] ~= nil do
    table.remove(GrundyGame)
  end
  GrundyGame[1] = startStack
end

function GrundyGame.CheckIfGameEnd()
  local gameEnd = true;
  for key,value in ipairs(GrundyGame) do
    --print(value[1],value[2],value[3])
    if value > 2 then
      gameEnd = false
    end
  end
  return gameEnd
end

function GrundyGame.StartSplitting( index )
  local currentDivisions = require("GrundyDivisions")
  local valueToDivide = GrundyGame[index]

  if valueToDivide == nil then
    print("No value at that index")
    return false
  end

  print("Splitting", valueToDivide )
  currentDivisions:FindPossibleDivisions(valueToDivide)
  currentDivisions:PrintDivisions()

  print("Input the number corresponding to how you want to split",valueToDivide)
  local chosenIndex = io.read("*n")

  print("Chosen Index was ", chosenIndex)
  
  if currentDivisions[chosenIndex] == nil then
    print("No data at that index")
    return false
  end
  
  GrundyGame[index] = currentDivisions[chosenIndex][2]
  table.insert(GrundyGame,index,currentDivisions[chosenIndex][1])

  currentDivisions.ClearTable()
  return true
end

function GrundyGame.PrintStacks()
  local stringToPrint = ""
  local index = 0
  print("Current Stacks:")
  for key,value in ipairs(GrundyGame) do
    index = index + 1
    stringToPrint = stringToPrint .. "[" .. value .. "]"
  end
  print(stringToPrint)
  return index
end

function GrundyGame.AI_Easy()
  print("AI(Easy) is thinking.....")
  local maxIndex = GrundyGame.PrintStacks()
  local currentDivisions = require("GrundyDivisions")
  local chosenStack = math.random(maxIndex)
  local valueToDivide = GrundyGame[chosenStack]
  
  print("AI chose stack no:", chosenStack)
  print("==============================")
  currentDivisions:FindPossibleDivisions(valueToDivide)
  print("AI had these possible options:")
  print("==============================")
  local maxDivisons = currentDivisions:PrintDivisions()

  print("========= ")
  local chosenIndex = math.random(maxDivisons)
  print("AI chose:",chosenIndex)
  
  GrundyGame[chosenStack] = currentDivisions[chosenIndex][2]
  table.insert(GrundyGame,chosenStack,currentDivisions[chosenIndex][1])

  currentDivisions.ClearTable()
  return true
end
return GrundyGame