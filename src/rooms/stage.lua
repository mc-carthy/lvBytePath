Stage = Object:extend()

function Stage:new()
    self.timer = Timer()
    self.area = Area()
    self.mainCanvas = love.graphics.newCanvas(gw, gh)
end

function Stage:update(dt)
    self.timer:update(dt)
    camera.smoother = Camera.smooth.damped(5)
    camera:lockPosition(dt, gw, gh)
    self.area:update(dt)
end

function Stage:draw()
    love.graphics.setCanvas(self.mainCanvas)
    love.graphics.clear()
        camera:attach(0, 0, gw * sx, gh * sy)
        love.graphics.circle('line', gw / 2, gh / 2, 50)
        self.area:draw()
        camera:detach()
    love.graphics.setCanvas()

    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.setBlendMode('alpha', 'premultiplied')
    love.graphics.draw(self.mainCanvas, 0, 0, 0, sx, sy)
    love.graphics.setBlendMode('alpha')
end