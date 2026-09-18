UINavBuilder = ISBuildingObject:derive("UINavBuilder")

local LAYER = "pavement"

function UINavBuilder:getNearNav(radius)
    local gmd = BWOGMD.Get()
    local nav = gmd.nav
    local navLocal = {}
    local px, py = self.character:getX(), self.character:getY()
    for id, n in pairs(nav) do
        if (n.v and LAYER == "road") or (not n.v and LAYER == "pavement") then

            local dist = BanditUtils.DistToManhattan(n.x, n.y, px, py)
            if dist < radius then
                navLocal[id] = n
            end
        end
    end
    return navLocal
end

function UINavBuilder:create(x, y)
    local gmd = BWOGMD.Get()
    local nav = gmd.nav
    local id = x .. "-" .. y

    if self.mode == "select" then
        UINavBuilder.last = id
    elseif self.mode == "addNode" then
        nav[id] = {
            x = x, 
            y = y, 
            v = LAYER == "road" and true or nil,
            links = {}
        }

    elseif self.mode == "removeNode" then
        -- remove links first
        for _, n in pairs(nav) do
            if n.links then
                n.links[id] = nil
            end
        end
        nav[id] = nil
        if UINavBuilder.last == id then
            UINavBuilder.last = nil
        end
    elseif self.mode == "addLink" then
        if UINavBuilder.last then
            local lastNode = nav[UINavBuilder.last]
            if lastNode then
                local cost = BanditUtils.DistTo(lastNode.x, lastNode.y, x, y)
                if cost >=1 then
                    lastNode.links[id] = cost
                    if not nav[id].links then
                        nav[id].links = {}
                    end
                    nav[id].links[UINavBuilder.last] = cost
                end
            end
        end
    end
end

function UINavBuilder:walkTo(x, y, z)
    return true
end

function UINavBuilder:isValid(square)
    return square:TreatAsSolidFloor() and square:isFree(false)
end

function UINavBuilder:render(x, y, z, square)
    local gmd = BWOGMD.Get()
    local nav = gmd.nav

    if not UINavBuilder.floorSprite then
        UINavBuilder.floorSprite = IsoSprite.new()
        UINavBuilder.floorSprite:LoadFramesNoDirPageSimple('media/ui/FloorTileCursor.png')
    end

    self.mode = "addNode"
    local colors = {r=0, g=1, b=0}
    if LAYER == "road" then
        colors = {r=1, g=0, b=0}
    end

    local nav = self:getNearNav(100)
    for id, gp in pairs(nav) do
        
        alfa = 0.05
        
        local colors = {r=0, g=1, b=0}
        if gp.v then
            colors = {r=1, g=0, b=0}
        end

        if UINavBuilder.last then
            local lastNode = nav[UINavBuilder.last]
            if lastNode and gp.x == lastNode.x and gp.y == lastNode.y then
                colors = {r=1, g=1, b=1}
            end
        end
    
        if gp.x == x and gp.y == y then
            if isShiftKeyDown() then
                self.mode = "addLink"
                colors = {r=0, g=0, b=1}
                
                local linkedNode = nav[UINavBuilder.last]
                if linkedNode then
                    renderIsoLine(gp.x + 0.5, gp.y + 0.5, 0, linkedNode.x + 0.5, linkedNode.y + 0.5, 0, 2, 0, 0, 1, 0.5)
                end

            elseif isKeyDown(Keyboard.KEY_LMENU) then
                self.mode = "removeNode"
                colors = {r=1, g=0.5, b=0}
            else
                self.mode = "select"
                colors = {r=1, g=1, b=1}
            end
        end

        UINavBuilder.floorSprite:RenderGhostTileColor(gp.x, gp.y, 0, colors.r, colors.g, colors.b, alfa)

        for linkId, cost in pairs(gp.links) do
            local linkedNode = nav[linkId]
            if linkedNode then
                renderIsoLine(gp.x + 0.5, gp.y + 0.5, 0, linkedNode.x + 0.5, linkedNode.y + 0.5, 0, 2, colors.r, colors.g, colors.b, 0.5)
            end
        end
    end

    if not self:isValid(square) then
        colors = {r=1, g=0, b=0}
    end

    if self.mode == "addNode" then
        UINavBuilder.floorSprite:RenderGhostTileColor(x, y, z, colors.r, colors.g, colors.b, 0.8)
    end
    
end

function UINavBuilder:new(sprite, northSprite, character)
    local o = {}
    setmetatable(o, self)
    self.__index = self
    o:init()
    o:setSprite(sprite)
    o:setNorthSprite(northSprite)
    o.character = character
    o.player = character:getPlayerNum()
    o.noNeedHammer = true
    o.skipBuildAction = true
    return o
end

local function onKeyPressed(keynum)
    if keynum == BanditCompatibility.GetGuardpostKey() then
        if LAYER == "pavement" then LAYER = "road" else LAYER = "pavement" end
        local playerObj = getSpecificPlayer(0)
        local bo = UINavBuilder:new("", "", playerObj)
        getCell():setDrag(bo, playerObj:getPlayerNum())
    end
end

Events.OnKeyPressed.Add(onKeyPressed)
