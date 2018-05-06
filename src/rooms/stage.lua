Stage = Object:extend()

function Stage:new()
    self.area = Area()
    self.timer = Timer()
    self.timer:every(2, function()
        self.area:addGameObject('Circle', Random(0, love.graphics.getWidth()), Random(0, love.graphics.getHeight()))
    end)
end

function Stage:update(dt)
    self.timer:update(dt)
    self.area:update(dt)
end

function Stage:draw()
    self.area:draw(dt)
end