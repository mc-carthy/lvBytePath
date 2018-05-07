Health = GameObject:extend()

function Health:new(area, x, y, opts)
    Health.super.new(self, area, x, y, opts)

    local direction = RandomFromTable({-1, 1})
    self.x = gw / 2 + direction * (gw / 2 + 48)
    self.y = Random(48, gh - 48)
    self.w, self.h = 18, 18
    self.collider = self.area.world:newRectangleCollider(self.x, self.y, self.w, self.h)
    self.collider:setObject(self)
    self.collider:setCollisionClass('Collectable')
    self.collider:setFixedRotation(false)
    self.v = -direction * Random(20, 40)
    self.collider:setLinearVelocity(self.v, 0)
    self.collider:applyAngularImpulse(Random(-24, 24))
end

function Health:update(dt)
    Health.super.update(self, dt)
end

function Health:die()
    self.dead = true
    self.area:addGameObject('HealthEffect', self.x + self.w / 2, self.y + self.h / 2, { colour = hpColour, w = self.w, h = self.h })
    self.area:addGameObject('InfoText', self.x + RandomFromTable({-1, 1}) * self.w, self.y + RandomFromTable({-1, 1}) * self.h, { text = '+HP', colour = hpColour })
    for i = 1, love.math.random(4, 8) do 
    	self.area:addGameObject('ExplodeParticle', self.x, self.y, { s = 3, colour = hpColour })
    end
end

function Health:draw()
    love.graphics.setColor(hpColour)
    PushRotate(self.x + self.w / 2, self.y + self.h / 2, self.collider:getAngle())
        love.graphics.rectangle('fill', self.x + self.w / 3, self.y, self.w / 3, self.h)
        love.graphics.rectangle('fill', self.x, self.y + self.h / 3, self.w, self.h / 3)
        love.graphics.setColor(defaultColour)
        love.graphics.circle('line', self.x + self.w / 2, self.y + self.h / 2, math.max(self.w, self.h) * 0.75, 32)
    love.graphics.pop()
end