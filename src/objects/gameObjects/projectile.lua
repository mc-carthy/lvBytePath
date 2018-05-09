Projectile = GameObject:extend()

function Projectile:new(area, x, y, opts)
    Projectile.super.new(self, area, x, y, opts)
    self.s = opts.s or 2.5
    self.v = opts.v or 200
    self.colour = opts.colour or attacks[self.attack].colour

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
    -- love.graphics.circle('line', self.x, self.y, self.s)
    love.graphics.setColor(defaultColour)
    
    PushRotate(self.x, self.y, Vector(self.collider:getLinearVelocity()):angle()) 
    love.graphics.setLineWidth(self.s - self.s / 4)
    love.graphics.line(self.x - 2 * self.s, self.y, self.x, self.y)
    love.graphics.setColor(self.colour) -- change half the projectile line to another color
    love.graphics.line(self.x, self.y, self.x + 2 * self.s, self.y)
    love.graphics.setLineWidth(1)
    love.graphics.pop()
    love.graphics.setColor(defaultColour)
end

function Projectile:destroy()
    Projectile.super.destroy(self)
end