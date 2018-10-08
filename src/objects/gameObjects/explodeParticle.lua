ExplodeParticle = GameObject:extend()

function ExplodeParticle:new(area, x, y, opts)
    ExplodeParticle.super.new(self, area, x, y, opts)

    self.colour = opts.colour or defaultColour
    self.r = Random(0, 2 * math.pi)
    self.s = opts.s or Random(2, 3)
    self.v = opts.v or Random(75, 150)
    self.lineWidth = 2
    self.timer:tween(opts.d or Random(0.3, 0.5), self, {s = 0, v = 0, lineWidth = 0}, 'linear', function() 
        self.dead = true
    end)
end

function ExplodeParticle:update(dt)
    ExplodeParticle.super.update(self, dt)
    self.x = self.x + self.v*math.cos(self.r)*dt
    self.y = self.y + self.v*math.sin(self.r)*dt
end

function ExplodeParticle:draw()
    PushRotate(self.x, self.y, self.r)
    love.graphics.setLineWidth(self.lineWidth)
    love.graphics.setColor(self.colour)
    love.graphics.line(self.x - self.s, self.y, self.x + self.s, self.y)
    love.graphics.setColor(255 / 255, 255 / 255, 255 / 255)
    love.graphics.setLineWidth(1)
    love.graphics.pop()
end

function ExplodeParticle:destroy()
    ExplodeParticle.super.destroy(self)
end