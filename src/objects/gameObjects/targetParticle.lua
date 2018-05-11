TargetParticle = GameObject:extend()

function TargetParticle:new(area, x, y, opts)
    TargetParticle.super.new(self, area, x, y, opts)
    self.r = opts.r or Random(2, 3)
    self.timer:tween(opts.d or Random(0.1, 0.3), 
        self, 
        { r = 0, x = self.targetX, y = self.targetY},
        'in-out-cubic',
        function() 
            self.dead = true
        end
    )
end

function TargetParticle:update(dt)
    TargetParticle.super.update(self, dt)
end

function TargetParticle:draw()
    love.graphics.setColor(self.colour)
    Draft:rhombus(self.x, self.y, 2 * self.r, 2 * self.r, 'fill')
    love.graphics.setColor(defaultColour)
end