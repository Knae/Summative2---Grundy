GrundyAI_MinMax = { nodes = {}, nodePrototype = require("GrundyAI_Node"), divisionPrototype = require("Grundy_Divisions"), MinMode = true}

function GrundyAI_MinMax:ExpandNode(_inNode)
    --For each value( or stack) in the node, that is more than 2
    --determine the possible division
    for valueKey,value in ipairs(_inNode.values) do
        --If the value is 1 or 2, just ignore it. 
        if( value > 2) then
            --Else, get the possible divisions and
            --attempt to create create new nodes from those divisions
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

                local resultantNode = GrundyAI_MinMax:AddNewNode(nodeValues)
                resultantNode.isMIN = not _inNode.isMIN

                local bLinkedNodeExists = false
                for key,node in ipairs(_inNode.linkedNodes) do
                    if(node:CompareWith(resultantNode.values)) then
                        --print("This node is already linked")
                        bLinkedNodeExists = true
                    end
                end

                if(not bLinkedNodeExists) then
                    table.insert(_inNode.linkedNodes, resultantNode)
                    table.insert(_inNode.selectionPairs, {valueKey, divKey})
                end

                if resultantNode:CheckIfLeafNode() then
                    if(resultantNode.isMIN) then
                        resultantNode.score = 1
                    else
                        resultantNode.score = -1
                    end
                else
                    GrundyAI_MinMax:ExpandNode(resultantNode)
                end
                resultantNode:UpdateScore()
            end
        end
    end
end

function GrundyAI_MinMax:SetMaxDepth( _inDepth)
    GrundyAI_MinMax.MaxDepth = _inDepth
end

function GrundyAI_MinMax:NewTree(startStack)
    while GrundyAI_MinMax.nodes[1] ~= nil do
      table.remove(GrundyAI_MinMax.nodes)
    end
    -- GrundyAI_MinMax:SetMaxDepth(0)
    local resultantNode = GrundyAI_MinMax:AddNewNode({startStack})
    resultantNode.isMIN = false
    GrundyAI_MinMax:ExpandNode(resultantNode)
    --GrundyAI_MinMax.isMIN = false
    --print("1st value is:",GrundyGame[1])
end

function GrundyAI_MinMax:CheckIfNodeExists(_inValues)
    for key, table in ipairs(GrundyAI_MinMax.nodes) do
        if table:CompareWith(_inValues) then
            return true, key
        end
    end
    return false, 0
end

function GrundyAI_MinMax:AddNewNode(_inValues)

    local check,nodeIndex = GrundyAI_MinMax:CheckIfNodeExists(_inValues)
    if not check then
        local newNode = GrundyAI_Node:new()
        --newNode.EmptyNodeRecord()

        for index,value in ipairs(_inValues) do
            newNode:AddValue(value)
        end

        table.insert(GrundyAI_MinMax.nodes, newNode)
        return newNode
    else
        return GrundyAI_MinMax.nodes[nodeIndex]
    end
end 

function GrundyAI_MinMax:GetAIMove(_inCurrentStacks)
    local exists,stateKey = GrundyAI_MinMax:CheckIfNodeExists(_inCurrentStacks)
    if(exists) then
        local currentNode = GrundyAI_MinMax.nodes[stateKey]

        --Find the node AI will attempt to reach, depends on if the AI is Min mode or Max mode
        local targetNode = nil
        local targetKeyPair = nil
        if(GrundyAI_MinMax.MinMode) then
            for key,node in ipairs(currentNode.linkedNodes) do
                if (targetNode == nil or targetNode.score > node.score) then
                targetNode = node 
                targetKeyPair = currentNode.selectionPairs[key]
                end
            end
        else
            for key,node in ipairs(currentNode.linkedNodes) do
                if (targetNode == nil or targetNode.score < node.score) then
                targetNode = node
                targetKeyPair = currentNode.selectionPairs[key]
                end
            end
        end
        
        print("AI is aiming to form this stack state:")
        local stringToPrint = ""
      
        for key,value in ipairs(targetNode.values) do
          stringToPrint = stringToPrint .. "[Stack" .. key .. ": " .. value .. "],"
        end
        print(stringToPrint)
        print("This target had a score of " .. targetNode.score)

        return targetKeyPair[1], targetKeyPair[2]
    else
        print("ERR: AI did not predict this state")
        return 1,1
    end
end
return GrundyAI_MinMax