math.randomseed(os.time())
local game = require("GrundyGame")
local player1Turn = true;
local aiPlayer = true
local selectedMode = nil
local userInput = nil
local aiModule = require("GrundyAI_MinMax")

print("Select Mode:")
print("1: 2 player hot-seat")
print("2: vs Easy AI")
print("3: vs Medium AI")
print("4: vs Hard AI")
selectedMode = io.read("*n")

if selectedMode == 1 then
  aiPlayer = false;
else
  aiPlayer = true
  --Switch AI difficulty here
end

userInput = nil
print("Input the initial stack")
userInput = io.read("*n")

game.NewGame(userInput)
game:PrintStacks()

if(selectedMode > 2) then
  aiModule:NewTree(userInput)
end

while(not game:CheckIfGameEnd()) do
  print("========")
  if player1Turn then
    print("[Player 1]")
  else
    if aiPlayer then
      print("[Player 2(AI)]")
    else
      print("[Player 2]")
    end

  end
 
  if(aiPlayer and not player1Turn) then
    if(selectedMode > 2) then
      local stackIndex,diviIndex = aiModule:GetAIMove(game)
      GrundyGame.AI_InputSelection(stackIndex, diviIndex)
      player1Turn = not player1Turn
    elseif game:AI_Easy() then
      player1Turn = not player1Turn
    end
  else
    print("==========")
    print("Current Game State")
    game:PrintStacks()
    print("==========")

    userInput = nil
    print("Input the stack split:")
    userInput = io.read("*n")

    if game:StartSplitting(userInput) then
      player1Turn = not player1Turn
    end
  end

  print("==========")
  print("Updated Game State")
  game:PrintStacks()
  print("==========")

end

print("Game has ended")
--Check whose turn it would be now. Cause they lost
if player1Turn then
  if aiPlayer then
    print("The AI has won")
  else
    print("Player 2 has won")
  end
else
  print("Player 1 has won")
end

print("Final state of stacks:")
game:PrintStacks()