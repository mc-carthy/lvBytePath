InfoText = GameObject:extend()

function InfoText:new(area, x, y, opts)
    InfoText.super.new(self, area, x, y, opts)
    self.depth = 80
    self.font = fonts.m5x7_16
    self.w, self.h = self.font:getWidth(self.text), self.font:getHeight()
    local allInfoTexts = self.area:getGameObjects(function(o) 
        if o:is(InfoText) and o.id ~= self.id then 
            return true 
        end 
    end)
    local function collidesWithOtherInfoText()
        for _, infoText in ipairs(allInfoTexts) do
            return AreRectanglesOverlapping(
                { x = self.x, y = self.y, w = self.w, h = self.h }, 
                { x = infoText.x, y = infoText.y, w = infoText.w, h = infoText.h }
            )
        end
    end
    while collidesWithOtherInfoText() do
        self.x = self.x + RandomFromTable({ -1, 0, 1 }) * self.w
        self.y = self.y + RandomFromTable({ -1, 0, 1 }) * self.h
    end
    self.characters = {}
    self.backgroundColours = {}
    self.foregroundColours = {}

    for i = 1, #self.text do
        table.insert(self.characters, self.text:utf8sub(i, i))
    end
    self.visible = true
    self.timer:after(0.70, function()
        self.timer:every(0.05, function() self.visible = not self.visible end, 6)
        self.timer:after(0.35, function() self.visible = true end)
        self.timer:every(0.035, function()
            local randomCharacters = '0123456789!@#$%¨&*()-=+[]^~/;?><.,|abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWYXZ'
            for i, character in ipairs(self.characters) do
                if love.math.random(1, 20) <= 1 then
                    local r = love.math.random(1, #randomCharacters)
                    self.characters[i] = randomCharacters:utf8sub(r, r)
                else
                    self.characters[i] = character
                end
                if love.math.random(1, 10) <= 1 then
                    self.backgroundColours[i] = RandomFromTable(allColours)
                else
                    self.backgroundColours[i] = nil
                end
              
                if love.math.random(1, 10) <= 2 then
                    self.foregroundColours[i] = RandomFromTable(allColours)
                else
                    self.foregroundColours[i] = nil
                end
            end
        end)
    end)
    self.timer:after(1.10, function() self.dead = true end)
end

function InfoText:update(dt)
    InfoText.super.update(self, dt)
end

function InfoText:draw()
    if not self.visible then return end

    love.graphics.setFont(self.font)
    for i = 1, #self.characters do
        local width = 0
        if i > 1 then
            for j = 1, i - 1 do
                width = width + self.font:getWidth(self.characters[j])
            end
        end

        if self.backgroundColours[i] then
            love.graphics.setColor(self.backgroundColours[i])
            love.graphics.rectangle('fill', self.x + width, self.y - self.font:getHeight() / 2,
            self.font:getWidth(self.characters[i]), self.font:getHeight())
        end
        love.graphics.setColor(self.foregroundColours[i] or self.colour or defaultColour)
        love.graphics.print(
            self.characters[i], self.x + width, self.y, 
            0, 1, 1, 0, self.font:getHeight() / 2
        )
    end
    love.graphics.setColor(defaultColour)
end