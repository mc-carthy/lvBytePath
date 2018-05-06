Stage = Object:extend()

function Stage:new()
    self.timer = Timer()
    self.area = Area()
    self.mainCanvas = love.graphics.newCanvas(gw, gh)
end

function Stage:update(dt)
    self.timer:update(dt)
    self.area:update(dt)
end

function Stage:draw()
    love.graphics.setCanvas(self.mainCanvas)
    love.graphics.clear()
        self.area:draw(dt)
        love.graphics.circle('line', gw / 2, gh / 2, 100)
    love.graphics.setCanvas()

    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.setBlendMode('alpha', 'premultiplied')
    love.graphics.draw(self.mainCanvas, 0, 0, 0, sx, sy)
    love.graphics.setBlendMode('alpha')
end