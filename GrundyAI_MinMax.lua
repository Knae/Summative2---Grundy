--Module implementing an AI player using a 
GrundyAI_MinMax = { nodes = {}, nodePrototype = require("GrundyAI_Node"), divisionPrototype = require("Grundy_Divisions"), MinMode = true}

--expand the node to branch nodes corresponding to different possible stack states ,
--and then expand the branch nodes as well. Continue recursively until a node can't be 
--split
function GrundyAI_MinMax:ExpandNode(_inNode)
    --For each value( or stack) in the node, that is more than 2
    --determine the possible division
    for valueKey,value in ipairs(_inNode.values) do
        --If the value is 1 or 2, just ignore it. 
        if( value > 2) then
            --Else, get the possible divisions and
            --attempt to create create new nodes from each of them
            local divisions  = Grundy_Divisions:new()
            divisions:FindPossibleDivisions(value)

             for divKey,pair in ipairs(divisions) do
                local nodeValues = {}
                table.insert(nodeValues, pair[1])
                table.insert(nodeValues, pair[2])

                if valueKey > 1 then
                    table.insert(nodeValues,_inNode.values[1])
                end

                --Add the values before and after the one we are splitting, then sort them
                local indexIncrement = 1
                while _inNode.values[valueKey + indexIncrement]~=nil do
                    table.insert(nodeValues,_inNode.values[valueKey + indexIncrement])
                    indexIncrement = indexIncrement + 1
                end
                indexIncrement = 1
                while (valueKey - indexIncrement) > 1 do
                    table.insert(nodeValues,_inNode.values[valueKey - indexIncrement])
                    indexIncrement = indexIncrement + 1
                end
                table.sort(nodeValues)

                --Attempt to add a new node using the values. If a node with these values
                --already exists, then we shuld now have a reference to the existing node
                --Marked the node as Min or Max depending on what the expanded node is.
                local resultantNode = GrundyAI_MinMax:AddNewNode(nodeValues)
                resultantNode.isMIN = not _inNode.isMIN

                --check if the resultantNode already exists as a linked node. If not, add
                --it to the array of linked nodes for the node being expanded
                local linkedNodeExists = false
                for key,node in ipairs(_inNode.linkedNodes) do
                    if(node:CompareWith(resultantNode.values)) then
                        linkedNodeExists = true
                    end
                end
                if(not linkedNodeExists) then
                    table.insert(_inNode.linkedNodes, resultantNode)
                    table.insert(_inNode.selectionPairs, {valueKey, divKey})
                end
                --Check if the resultant node is a leaf node or a dead end.
                --If so don't expand it, but set the score based on whether the node
                --is a Min (set to 1) or Max node (set to -1)
                if resultantNode:CheckIfLeafNode() then
                    if(resultantNode.isMIN) then
                        resultantNode.score = 1
                    else
                        resultantNode.score = -1
                    end
                else
                    GrundyAI_MinMax:ExpandNode(resultantNode)
                end

                --Once resultantNode is completely expanded, update is score
                resultantNode:UpdateScore()
            end
        end
    end
end

function GrundyAI_MinMax:SetMaxDepth( _inDepth)
    GrundyAI_MinMax.MaxDepth = _inDepth
end
--Clear all the existing nodes and create a new initial node
--and expand it
function GrundyAI_MinMax:NewTree(startStack)
    while GrundyAI_MinMax.nodes[1] ~= nil do
      table.remove(GrundyAI_MinMax.nodes)
    end
    local resultantNode = GrundyAI_MinMax:AddNewNode({startStack})
    resultantNode.isMIN = false
    GrundyAI_MinMax:ExpandNode(resultantNode)
end
--Check if a node with the given stack values already exists. If it does
--return true and the table index corresponding to the node
function GrundyAI_MinMax:CheckIfNodeExists(_inValues)
    for key, table in ipairs(GrundyAI_MinMax.nodes) do
        if table:CompareWith(_inValues) then
            return true, key
        end
    end
    return false, 0
end
--Attempt to create a new node with the given stack values. If unsuccessful
--return a reference to the existing node that already has those value
--If successful, return a reference to the new node
function GrundyAI_MinMax:AddNewNode(_inValues)
    local check,nodeIndex = GrundyAI_MinMax:CheckIfNodeExists(_inValues)
    if not check then
        local newNode = GrundyAI_Node:new()

        for index,value in ipairs(_inValues) do
            newNode:AddValue(value)
        end

        table.insert(GrundyAI_MinMax.nodes, newNode)
        return newNode
    else
        return GrundyAI_MinMax.nodes[nodeIndex]
    end
end
--Uses the given table of stacks to determine the current game state, and from the current
--game state determine what inputs it needs to make to reach a preferable game state
function GrundyAI_MinMax:GetAIMove(_inCurrentStacks)
    local exists,stateKey = GrundyAI_MinMax:CheckIfNodeExists(_inCurrentStacks)
    if(exists) then
        local currentNode = GrundyAI_MinMax.nodes[stateKey]
        --Find the node AI will attempt to reach, depends on if the AI is Min mode or Max mode
        local targetNode = nil
        local targetKeyPair = nil
        if(GrundyAI_MinMax.MinMode) then
            --If in Min mode, then go through all the nodes in the current node's linked node
            --table and find the one with the lowest score and the pair of input values that
            --should change the current game state to that node
            for key,node in ipairs(currentNode.linkedNodes) do
                if (targetNode == nil or targetNode.score > node.score) then
                targetNode = node
                targetKeyPair = currentNode.selectionPairs[key]
                end
            end
        else
            --Find the highest score instead if in Max mode
            for key,node in ipairs(currentNode.linkedNodes) do
                if (targetNode == nil or targetNode.score < node.score) then
                targetNode = node
                targetKeyPair = currentNode.selectionPairs[key]
                end
            end
        end
        --Print the game state the AI is aiming to reach and the score that node had
        print("AI is aiming to form this stack state:")
        local stringToPrint = ""
        for key,value in ipairs(targetNode.values) do
          stringToPrint = stringToPrint .. "[Stack" .. key .. ": " .. value .. "],"
        end
        print(stringToPrint)
        print("This target had a score of " .. targetNode.score)

        --return the inputs the AI will make in the game
        return targetKeyPair[1], targetKeyPair[2]
    else
        print("ERR: AI did not predict this state")
        return 1,1
    end
end
return GrundyAI_MinMax