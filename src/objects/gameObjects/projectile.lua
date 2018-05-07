Projectile = GameObject:extend()

function Projectile:new(area, x, y, opts)
    Projectile.super.new(self, area, x, y, opts)
    self.s = opts.s or 2.5
    self.v = opts.v or 200

    self.collider = self.area.world:newCircleCollider(self.x, self.y, self.s)
    self.collider:setObject(self)
    self.collider:setCollisionClass('Projectile')
    self.collider:setLinearVelocity(self.v * math.cos(self.r), self.v * math.sin(self.r))
end

function Projectile:update(dt)
    Projectile.super.update(self, dt)
    self.timer:update(dt)

    if self.x < 0 or self.x > gw or self.y < 0 or self.y > gh then self:die() end
end

function Projectile:die()
    self.dead = true
    self.area:addGameObject('ProjectileDeathEffect', self.x, self.y, { colour = hpColour, w = 3 * self.s })
end

function Projectile:draw()
    love.graphics.circle('line', self.x, self.y, self.s)
end

function Projectile:destroy()
    Projectile.super.destroy(self)
end