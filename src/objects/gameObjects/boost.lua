Boost = GameObject:extend()

function Boost:new(area, x, y, opts)
    Boost.super.new(self, area, x, y, opts)

    local direction = RandomFromTable({-1, 1})
    self.x = gw / 2 + direction * (gw / 2 + 48)
    self.y = Random(48, gh - 48)
    self.w, self.h = 12, 12
    self.collider = self.area.world:newRectangleCollider(self.x, self.y, self.w, self.h)
    self.collider:setObject(self)
    self.collider:setCollisionClass('Collectable')
    self.collider:setFixedRotation(false)
    self.v = -direction * Random(20, 40)
    self.collider:setLinearVelocity(self.v, 0)
    self.collider:applyAngularImpulse(Random(-24, 24))
end

function Boost:update(dt)
    Boost.super.update(self, dt)
end

function Boost:die()
    self.dead = true
    self.area:addGameObject('BoostEffect', self.x, self.y, { colour = boostColour, w = self.w, h = self.h })
    self.area:addGameObject('InfoText', self.x, self.y, { text = '+BOOST', colour = boostColour })
    for i = 1, love.math.random(4, 8) do 
    	self.area:addGameObject('ExplodeParticle', self.x, self.y, { s = 3, colour = boostColour })
    end
end

function Boost:draw()
    love.graphics.setColor(boostColour)
    PushRotate(self.x, self.y, self.collider:getAngle())
    Draft:rhombus(self.x, self.y, 1.5 * self.w, 1.5 * self.h, 'line')
    Draft:rhombus(self.x, self.y, 0.5 * self.w, 0.5 * self.h, 'fill')
    love.graphics.pop()
    love.graphics.setColor(defaultColour)
end