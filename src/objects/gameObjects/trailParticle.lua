TrailParticle = GameObject:extend()

function TrailParticle:new(area, x, y, opts)
    TrailParticle.super.new(self, area, x, y, opts)
    self.x, self.y = x, y
    self.r = opts.r or Random(4, 6)
    self.timer:tween(opts.d or Random(0.3, 0.5), self, {r = 0}, 'linear', function() self.dead = true end)
end

function TrailParticle:update(dt)
    self.timer:update(dt)
    if self.player then
        self.x = self.player.x + self.d*math.cos(self.player.r)
    	self.y = self.player.y + self.d*math.sin(self.player.r)
    end
end

function TrailParticle:draw()
    love.graphics.setColor(self.colour)
    love.graphics.circle('fill', self.x, self.y, self.r)
    love.graphics.setColor(255, 255, 255, 255)
end

function TrailParticle:destroy()
    TrailParticle.super.destroy(self)
end