Shooter = GameObject:extend()

function Shooter:new(area, x, y, opts)
    Shooter.super.new(self, area, x, y, opts)

    local direction = RandomFromTable({-1, 1})
    self.x = gw / 2 + direction * (gw / 2 + 48)
    self.y = Random(16, gh - 16)
    self.w, self.h = 12, 6
    self.collider = self.area.world:newPolygonCollider({
        self.w, 0, -self.w / 2, self.h, -self.w, 0, -self.w / 2, -self.h
    })
    self.collider:setPosition(self.x, self.y)
    self.collider:setObject(self)
    self.collider:setCollisionClass('Enemy')
    self.collider:setFixedRotation(false)
    self.collider:setAngle(direction == 1 and math.pi or 0)
    self.collider:setFixedRotation(true)
    self.v = -direction * Random(20, 40)
    self.collider:setLinearVelocity(self.v, 0)
    self.collider:applyAngularImpulse(Random(-100, 100))
    self.hp = 100
    self.hitFlash = false
end

function Shooter:hit(damage)
    local damage = damage or 100
    self.hp = self.hp - damage
    if self.hp <= 0 then
        self:die()
    else
        self.hitFlash = true
        timer:after(0.2, function() self.hitFlash = false end)
    end
end

function Shooter:die()
    self.area:addGameObject('EnemyDeathEffect', self.x, self.y, { colour = hpColour, w = 3 * self.w, h = 3 * self.h })
    self.area:addGameObject('Ammo', self.x, self.y)
    self.dead = true
end

function Shooter:update(dt)
    Shooter.super.update(self, dt)
    self.collider:setLinearVelocity(self.v, 0) 
end

function Shooter:draw()
    if self.hitFlash then
        love.graphics.setColor(defaultColour)
    else
        love.graphics.setColor(hpColour)
    end
    local points = {self.collider:getWorldPoints(self.collider.shapes.main:getPoints())}
    love.graphics.polygon('line', points)
    love.graphics.setColor(defaultColour)
end