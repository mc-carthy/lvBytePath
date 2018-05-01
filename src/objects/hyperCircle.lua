HyperCircle = Circle:extend()

function HyperCircle:new(x, y, radius, lineWidth, outerRadius)
    self.super.new(self, x, y, radius)
    self.lineWidth, self.outerRadius = lineWidth, outerRadius
end

function HyperCircle:draw()
    HyperCircle.super.draw(self)
    local lw = love.graphics.getLineWidth()
    love.graphics.setLineWidth(self.lineWidth)
    love.graphics.circle('line', self.x, self.y, self.outerRadius, 32)
end