GrundyGame = {7}

function GrundyGame:new(startStack)
   GrundyGame[1] = startStack 
end

function GrundyGame.CheckIfGameEnd()
  local gameEnd = false;
  for key,value in ipairs(GrundyGame) do
    if value <= 2 then
      gameEnd = true
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

  currentDivisions.FindPossibleDivisions(valueToDivide)
  currentDivisions.PrintDivisions()

  print("Input the number corresponding to howw you want to split ",valueToDivide)
  local chosenIndex = io.read("*n")

  print("Chosen Index was ", chosenIndex)
  
end