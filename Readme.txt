GD2S03 - Summative 2 - Chuang Kee
IDE used:
Replit , Visual Studio Code

Controls:
-Inputs are based around numbers
-Entering letters or numbers outside expected values will cause the the program to register and error and request another input

Lua features used:
-Modules
-local variables
-OOP implementation : GrundyAI_Node
  -using self, using ':' instead if '.' where needed
-Functions
  -function with multiple results: GrundyAI_MinMax:GetAIMove()
-String concatenation ( "abc" .. "def") : GrundyGame.line90
-for..in ipairs

AI;
-2 modes:
  -Easy: makes decisions at random
    --Picks a random valid number until Grundy accepts it and passes the turn to the next player
  -Medium: Makes decisions based on a MinMax tree it populates at the start
    --Will populate the whole table before the game can continue. aftert every player turn, tries to determine the current game state and the decisions it needs to make to move to a more favourable sate
    
Limits:
-MinMax will attempt to populate the tree with all possible game states. This means it can take a long while before it finishes. Initial stack values of more than 15 may take a while for the AI to finish setting up. Input for initial stack is limited to between 3 and 18