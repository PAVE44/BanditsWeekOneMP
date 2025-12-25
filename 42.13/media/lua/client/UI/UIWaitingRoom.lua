UIWaitingRoom = ISPanel:derive("UIWaitingRoom")

local FONT_HGT_SMALL = getTextManager():getFontHeight(UIFont.Small)
local FONT_HGT_MEDIUM = getTextManager():getFontHeight(UIFont.Medium)
local UI_BORDER_SPACING = 10
local PADDING = 12
local BUTTON_HGT = FONT_HGT_SMALL + 6

function UIWaitingRoom:initialise()
    ISPanel.initialise(self)

    local top = PADDING + FONT_HGT_MEDIUM + PADDING 
    self.playerListBox = ISScrollingListBox:new(PADDING, top, self:getWidth() - (2 * PADDING), 800)
    self.playerListBox.itemheight = FONT_HGT_MEDIUM + PADDING
    self.playerListBox.backgroundColor.a = 0
    self.playerListBox.borderColor = {r=1, g=0, b=0, a=1}
    self:addChild(self.playerListBox)
    
end

function UIWaitingRoom:onRightClick(button)
end

function UIWaitingRoom:update()
    ISPanel.update(self)

    self.playerListBox:clear()

    local gmd = BWOGMD.Get()
    local players = gmd.players

    for id, player in pairs(players) do
        self.playerListBox:addItem(id, { index = id, id = id, status = player.status, online = player.online})
    end

    self.maxWidth = 0
    self.playerListBox.doDrawItem = function(list, y, item, alt)
        local h = list.itemheight

        if (list.mouseoverselected == item.index) and list:isMouseOver() and not list:isMouseOverScrollBar() then
            list:drawMouseOverHighlight(0, y, list:getWidth(), item.height-1);
            list.realSelected = item.item.id
            list.realStatus = item.item.status
            list.realOnline = item.item.online
        end
        
        local width = getTextManager():MeasureStringX(UIFont.Medium, item.item.id)
        self.maxWidth = math.max(width, self.maxWidth)

        local c
        if item.item.online then
            if item.item.status then
                c = {r=0, g=1, b=0}
            else
                c = {r=1, g=0, b=0}
            end
        else
            c = {r=0.3, g=0.3, b=0.3}
        end

        list:drawText(item.item.id, 4, y + 6, c.r, c.g, c.b, 1, UIFont.Medium)
        list:drawRect(0, y + h - 1, list:getWidth(), 1, 1, 0.4, 0.4, 0.4)
        
        return y + h
    end

    self.playerListBox.onMouseUp = function(listBox, x, y)
        local id = listBox.realSelected
        local status = listBox.realStatus
        local online = listBox.realOnline
        local isMe = getSpecificPlayer(0):getUsername() == id

        if online then
            if isDebugEnabled() or isAdmin() or isMe then
                local args = {
                    id = id,
                    status = not status
                }
                sendClientCommand(getSpecificPlayer(0), "EventManager", "SetPlayerStatus", args)
            end
        end

    end
end

function UIWaitingRoom:prerender()
    ISPanel.prerender(self)
    self:drawText("Waiting Room", 10, 10, 1, 1, 1, 1, UIFont.Medium);
end

function UIWaitingRoom:new(x, y, width, height)
    local o = {}
    o = ISPanel:new(x, y, width, height)
    setmetatable(o, self)
    self.__index = self
    o.borderColor = {r=0, g=0, b=0, a=0}
    o.backgroundColor = {r=0, g=0, b=0, a=0.3}
    o.width = width
    o.height = height
    o.moveWithMouse = true
    UIWaitingRoom.instance = o
    ISDebugMenu.RegisterClass(self)
    return o
end
