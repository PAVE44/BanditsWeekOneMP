UIText = ISPanel:derive("UIText")

local FONT_HGT_SMALL = getTextManager():getFontHeight(UIFont.Small)
local FONT_HGT_MEDIUM = getTextManager():getFontHeight(UIFont.Medium)
local PADDING = 10

function UIText:initialise()
    ISPanel.initialise(self)
end

function UIText:prerender()
    ISPanel.prerender(self)

    local tx = isoToScreenX(self.playerNum, self.isox, self.isoy, self.isoz)
    local ty = isoToScreenY(self.playerNum, self.isox, self.isoy, self.isoz)

    self:setX(tx - self.width / 2)
    self:setY(ty - self.height / 2)


    self:drawText(self.text, 10, 10, 1, 1, 1, 1, UIFont.Small)
end

function UIText:setData(isox, isoy, isoz, text)
    self.isox = isox
    self.isoy = isoy
    self.isoz = isoz
    self.text = text
end

function UIText:new(playerNum, isox, isoy, isoz, text)
    local textWidth = getTextManager():MeasureStringX(UIFont.Small, text)
    local width = textWidth + PADDING * 2
    local height = FONT_HGT_SMALL + PADDING * 2

    local tx = isoToScreenX(playerNum, isox, isoy, isoz)
    local ty = isoToScreenY(playerNum, isox, isoy, isoz)

    local o = {}
    o = ISPanel:new(tx - width / 2, ty - height / 2, width, height)
    setmetatable(o, self)
    self.__index = self
    o.borderColor = {r=0, g=0, b=0, a=0}
    o.backgroundColor = {r=0, g=0, b=0, a=0.3}
    o.isox = isox
    o.isoy = isoy
    o.isoz = isoz
    o.text = text
    o.width = width
    o.height = height
    o.moveWithMouse = true
    o.playerNum = playerNum
    UIText.instance = o
    return o
end
