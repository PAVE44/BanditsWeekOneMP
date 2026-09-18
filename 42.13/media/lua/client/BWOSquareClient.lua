local function processSquare(square)
    local area = BWOAreas.Find(square)
    if area then
        BWOItems.ShouldRescan(area.id, square:getX(), square:getY(), square:getZ())
    end
end

Events.LoadGridsquare.Remove(processSquare)
Events.LoadGridsquare.Add(processSquare)

