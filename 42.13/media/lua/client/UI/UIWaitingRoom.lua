UIWaitingRoom = ISPanel:derive("UIWaitingRoom")

local FONT_HGT_SMALL = getTextManager():getFontHeight(UIFont.Small)
local FONT_HGT_MEDIUM = getTextManager():getFontHeight(UIFont.Medium)
local UI_BORDER_SPACING = 10
local PADDING = 12
local BUTTON_HGT = FONT_HGT_SMALL + 6

function UIWaitingRoom:initialise()
    ISPanel.initialise(self)

    local top = PADDING + FONT_HGT_MEDIUM + PADDING 
    self.playerListBox = ISScrollingListBox:new(PADDING, top, self:getWidth() - (2 * PADDING), self:getHeight())
    self.playerListBox.itemheight = FONT_HGT_MEDIUM + PADDING
    self.playerListBox.backgroundColor.a = 0
    self.playerListBox.borderColor = {r=1, g=0, b=0, a=1}
    self:addChild(self.playerListBox)
    self.playerListBox:clear()

    local gmd = BWOGMD.Get()
    local players = gmd.players

    for id, player in pairs(players) do
        self.playerListBox:addItem(id, { index = id, id = id, status = player.status})
    end

    self.maxWidth = 0
    self.playerListBox.doDrawItem = function(list, y, item, alt)
        local h = list.itemheight

        if (list.mouseoverselected == item.index) and list:isMouseOver() and not list:isMouseOverScrollBar() then
            list:drawMouseOverHighlight(0, y, list:getWidth(), item.height-1);
        end
        
        local width = getTextManager():MeasureStringX(UIFont.Medium, item.item.id)
        self.maxWidth = math.max(width, self.maxWidth)

        list:drawText(item.item.id, 4, y + 6, 1, 1, 1, 1, UIFont.Medium)
        list:drawRect(0, y + h - 1, list:getWidth(), 1, 1, 0.4, 0.4, 0.4)
        
        return y + h
    end

    self.playerListBox.onMouseUp = function(listBox, x, y)
        local itemText = listBox.items[listBox.selected].item.id
        BWOAChat.Say(itemText)
        self:destroy()
    end
end

function UIWaitingRoom:onRightClick(button)
end

function UIWaitingRoom:update()
    ISPanel.update(self)
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
