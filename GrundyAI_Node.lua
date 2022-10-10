--Module fore creating a Grundy specific tree node
GrundyAI_Node = { }

--returns the ref to the itself
function GrundyAI_Node:new(elementRef)
    elementRef = elementRef or {values = {}, value_Min = nil, value_Max = 0, isMIN = false, score = 0, linkedNodes = {}, selectionPairs = {} }
    setmetatable( elementRef, self)
    self.__index = self
    return elementRef
end

--Function to clear all the values and the nodes in the
--linkedNodes
function GrundyAI_Node:EmptyNodeRecord()
    while self.values[1] ~= nil do
        table.remove(self.values)
    end

    while GrundyAI_Node.linkedNodes[1] ~= nil do
        table.remove(self.values)
    end

    self.isMIN = false
    self.score = 0
end

--Add a value( or a stack) in the node
function GrundyAI_Node:AddValue( _inValue)
    table.insert(self.values, _inValue)
end

--Sort the values or stacks stored in this node
function GrundyAI_Node:SortValues()
    local tempTable = {};

    for key,value in ipairs(GrundyAI_Node.values) do
      table.insert(tempTable, value)
    end
  
    table.sort(tempTable)
  
    local index = 0
    for key, value in ipairs(tempTable) do
      index = index + 1
      self.values[index] = tempTable[index]
    end
end

--Compare the values in the node with the given values. Returns false
--if even one value is different. Otherwise it returns true.
--e.g: {1,2,4} and {1,1,2} would return false because the 2nd value
--in both sets are different
function GrundyAI_Node:CompareWith( _inValues)
    for key, value in ipairs(_inValues) do
        if  _inValues[key] == nil or self.values[key] == nil then
            --print("Comparing value sets with different number of values")
            return false
        elseif _inValues[key] ~= self.values[key] then
            --print("Found unequal values. These 2 sets are different")
            return false
        end
    end
    return true
end

--Check all the values in the node to determine if it is a leaf node,
--i.e. cannot be expanded further. If all values are 1 or 2, then it returns true
function GrundyAI_Node:CheckIfLeafNode()
    for key, value in ipairs(self.values) do
        if value > 2 then
            return false
          end
    end
    return true
end

--Updates the node's score by summing the scores of all the nodes in itself
--linkedNodes table
function GrundyAI_Node:UpdateScore()
    if self.linkedNodes[1] ~= nil then
        local nodeCumulativeScore = 0;
        for key,node in ipairs(self.linkedNodes) do
            nodeCumulativeScore = nodeCumulativeScore + node:GetScore()
        end
        self.score = nodeCumulativeScore
    end
end

--Returns the node's score
function GrundyAI_Node:GetScore()
    return self.score
end

return GrundyAI_Node