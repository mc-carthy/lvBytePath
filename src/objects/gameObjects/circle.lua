Circle = GameObject:extend()

function Circle:new(x, y, opts)
    Circle.super.new(self, x, y, opts)
    self.timer:after(Random(2, 4), function() self.dead = true end)
end
function Circle:update(dt)
    Circle.super.update(self, dt)
end

function Circle:draw()
    love.graphics.circle('fill', self.x, self.y, 100)
end