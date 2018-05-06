Rectangle = GameObject:extend()

function Rectangle:new(area, x, y, opts)
    Rectangle.super.new(self, area, x, y, opts)
    self.w = opts.w
    self.h = opts.h
end
function Rectangle:update(dt)
    Rectangle.super.update(self, dt)
end

function Rectangle:draw()
    love.graphics.rectangle('fill', self.x, self.y, self.w, self.h)
end