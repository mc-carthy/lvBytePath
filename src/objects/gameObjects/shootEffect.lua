ShootEffect = GameObject:extend()

function ShootEffect:new(area, x, y, opts)
    ShootEffect.super.new(self, area, x, y, opts)
    self.x, self.y = x, y
    self.w = 8
    self.timer:tween(0.1, self, {w = 0}, 'in-out-cubic', function() self.dead = true end)
end

function ShootEffect:update(dt)
    self.timer:update(dt)
    if self.player then
        self.x = self.player.x + self.d*math.cos(self.player.r)
    	self.y = self.player.y + self.d*math.sin(self.player.r)
    end
end

function ShootEffect:draw()
    PushRotate(self.player.x, self.player.y, math.pi / 2)
    PushRotate(self.x, self.y, self.player.r + math.pi / 4)
    love.graphics.setColor(defaultColour)
    love.graphics.rectangle('fill', self.x - self.w / 2, self.y - self.w / 2, self.w, self.w)
    love.graphics.pop()
    love.graphics.pop()
end
