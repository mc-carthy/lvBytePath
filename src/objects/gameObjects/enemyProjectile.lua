EnemyProjectile = GameObject:extend()

function EnemyProjectile:new(area, x, y, opts)
    EnemyProjectile.super.new(self, area, x, y, opts)
    self.s = opts.s or 2.5
    self.v = opts.v or 200
    self.colour = opts.colour or attacks[self.attack].colour
    self.damage = opts.damage or 10

    self.collider = self.area.world:newCircleCollider(self.x, self.y, self.s)
    self.collider:setObject(self)
    self.collider:setCollisionClass('EnemyProjectile')
    self.collider:setLinearVelocity(self.v * math.cos(self.r), self.v * math.sin(self.r))
end

function EnemyProjectile:update(dt)
    EnemyProjectile.super.update(self, dt)

    if self.x < 0 or self.x > gw or self.y < 0 or self.y > gh then self:die() end

    if self.collider:enter('Player') then
        local collisionData = self.collider:getEnterCollisionData('Player')
        local object = collisionData.collider:getObject()
        if object then
            object:hit(self.damage)
            self:die()
        end
    end
    if self.collider:enter('Projectile') then
        local collisionData = self.collider:getEnterCollisionData('Player')
        local object = collisionData.collider:getObject()
        if object then
            object:hit(self.damage)
            self:die()
        end
    end
end

function EnemyProjectile:die()
    self.dead = true
    self.area:addGameObject('ProjectileDeathEffect', self.x, self.y, { colour = hpColour, w = 3 * self.s })
end

function EnemyProjectile:draw()
    -- love.graphics.circle('line', self.x, self.y, self.s)
    love.graphics.setColor(self.colour)
    
    PushRotate(self.x, self.y, Vector(self.collider:getLinearVelocity()):angle()) 
    love.graphics.setLineWidth(self.s - self.s / 4)
    love.graphics.line(self.x - 2 * self.s, self.y, self.x, self.y)
    love.graphics.line(self.x, self.y, self.x + 2 * self.s, self.y)
    love.graphics.setLineWidth(1)
    love.graphics.pop()
    love.graphics.setColor(defaultColour)
end

function EnemyProjectile:destroy()
    EnemyProjectile.super.destroy(self)
end