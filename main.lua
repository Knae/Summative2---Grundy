math.randomseed(os.time())
local game = require("GrundyGame")
local player1Turn = true;
local aiPlayer = true

print("Input the initial stack")
local stackValue = io.read("*n")

game.NewGame(stackValue)
while(not game.CheckIfGameEnd()) do
  print("========")
  if player1Turn then
    print("[Turn 1]")
  else
    print("[Turn 2]")
  end
  print("========")

  if(aiPlayer and not player1Turn) then
    game.AI_Easy()
  else
    game.PrintStacks()

    print("Input the stack split:")
    stackValue = io.read("*n")

    if game.StartSplitting(stackValue) then
     player1Turn = not player1Turn
    end
  end
end

print("Game has ended")
print("Final state of stacts:")
game.PrintStacks()