--local meta = {_index = GrundyAI_Node}
GrundyAI_Node = { }

function GrundyAI_Node:new(elementRef)
    --local node = { }
    elementRef = elementRef or {values = {}, value_Min = nil, value_Max = 0, isMIN = false, score = 0, linkedNodes = {}, selectionPairs = {} }
    setmetatable( elementRef, self)
    self.__index = self
    return elementRef
end

function GrundyAI_Node:EmptyNodeRecord()
    while self.values[1] ~= nil do
        table.remove(self.values)
    end

    while GrundyAI_Node.linkedNodes[1] ~= nil do
        table.remove(self.values)
    end

    self.isMIN = false
    self.score = 0
      --print("1st value is:",GrundyGame[1])
end

function GrundyAI_Node:AddValue( _inValue)

    table.insert(self.values, _inValue)
end

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

function GrundyAI_Node:CheckIfLeafNode()
    for key, value in ipairs(self.values) do
        if value > 2 then
            return false
          end
    end
    return true
end

function GrundyAI_Node:UpdateScore()
    if self.linkedNodes[1] ~= nil then
        local nodeCumulativeScore = 0;
        for key,node in ipairs(self.linkedNodes) do
            nodeCumulativeScore = nodeCumulativeScore + node:GetScore()
        end
        self.score = nodeCumulativeScore
    end
end

function GrundyAI_Node:GetScore()
    return self.score
end

return GrundyAI_Node