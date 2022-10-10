--module that manages the GrundyGame
GrundyGame = {}

--Sets up GrundyGame for a new session
function GrundyGame.NewGame(startStack)
  while GrundyGame[2] ~= nil do
    table.remove(GrundyGame)
  end
  GrundyGame[1] = startStack
end

--Checks all the stacks to see if the game can no longer
--proceed and thus has ended
function GrundyGame.CheckIfGameEnd()
  for key,value in ipairs(GrundyGame) do
    if value > 2 then
      return false
    end
  end
  return true
end

--Starts process of getting player input to decide how to split
--the stack chosen by the player
function GrundyGame:StartSplitting( index )
  local currentDivisions = require("Grundy_Divisions")
  local chosenIndex = nil;

  --Retrieves the value to be split and checks if it is valid
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
  --Determine the possible divisions using the Grundy_Divisions module
  currentDivisions:FindPossibleDivisions(valueToDivide)
  currentDivisions:PrintElements()

  --Get player input that corresponds to split they chosen
  while chosenIndex == nil do
    print("Input the number corresponding to how you want to split",valueToDivide)
    chosenIndex = tonumber(io.read())
    if not GrundyGame.CheckInput(chosenIndex, 0) then
      chosenIndex = nil
    end
  end
  print("Chosen Index was ", chosenIndex)
  if currentDivisions[chosenIndex] == nil then
    print("No data at that index")
    return false
  end
  --The stack is split by changing its value to the second value of the
  --split that the player selected. Then a new value is inserted
  --at the same position but this time using the first value of the split
  GrundyGame[index] = currentDivisions[chosenIndex][2]
  table.insert(GrundyGame,index,currentDivisions[chosenIndex][1])

  --Sort the values for compatibility with GrundyAI_MinMax module
  GrundyGame:SortValues()

  currentDivisions:ClearTable()
  return true
end

--Sort the stacks by its value
function GrundyGame:SortValues()
  local tempTable = {};
  for key,value in ipairs(GrundyGame) do
    table.insert(tempTable, value)
  end
  table.sort(tempTable)  
  for key, value in ipairs(tempTable) do
    GrundyGame[key] = value
  end
end

--Print the stacks
function GrundyGame.PrintStacks()
  local stringToPrint = ""
  local size = 0
  for key,value in ipairs(GrundyGame) do
    stringToPrint = stringToPrint .. "[Stack" .. key .. " : " .. value .. "],"
    size = key
  end

  print(stringToPrint)
  return size
end

--Easy AI that makes decisions at random
--Everytime it needs to make an input, it chooses a random number
--repeats if the number is invalid (possibly because the stack can't be split)
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

--AI that creates a full decision tree at the start and makes decisions based on that
--Uses the current set of stacks to determine which node it's currently and what decisions
--it needs to make
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

--Check input
function GrundyGame.CheckInput(_input, _limit)
  if _input == nil or _input<1 or (_limit > 0 and _input > _limit) then
    print("Invalid input")
    print("")
    print("")
    return false
  end
  return true
end

return GrundyGame