Ammo = GameObject:extend()

function Ammo:new(area, x, y, opts)
    Ammo.super.new(self, area, x, y, opts)

    self.w, self.h = 8, 8
    self.collider = self.area.world:newRectangleCollider(self.x, self.y, self.w, self.h)
    self.collider:setObject(self)
    self.collider:setCollisionClass('Collectable')
    self.collider:setFixedRotation(false)
    self.r = Random(0, 2 * math.pi)
    self.v = Random(10, 20)
    self.collider:setLinearVelocity(self.v * math.cos(self.r), self.v * math.sin(self.r))
    self.collider:applyAngularImpulse(Random(-24, 24))
end

function Ammo:update(dt)
    Ammo.super.update(self, dt)
    local target = currentRoom.player
    if target then
        local projectileHeading = Vector(self.collider:getLinearVelocity()):normalized()
        local angle = math.atan2(target.y - self.y, target.x - self.x)
        local toTargetHeading = Vector(math.cos(angle), math.sin(angle)):normalized()
        local finalHeading = (projectileHeading + 0.1 * toTargetHeading):normalized()
        self.collider:setLinearVelocity(self.v * finalHeading.x, self.v * finalHeading.y)
    else 
        self.collider:setLinearVelocity(self.v * math.cos(self.r), self.v * math.sin(self.r)) 
    end
end

function Ammo:die()
    self.dead = true
    self.area:addGameObject('AmmoEffect', self.x, self.y, { colour = ammoColour, w = self.w, h = self.h })
    for i = 1, love.math.random(4, 8) do 
    	self.area:addGameObject('ExplodeParticle', self.x, self.y, {s = 3, colour = ammoColour}) 
    end
end

function Ammo:draw()
    love.graphics.setColor(ammoColour)
    PushRotate(self.x, self.y, self.collider:getAngle())
    Draft:rhombus(self.x, self.y, self.w, self.h, 'line')
    love.graphics.pop()
    love.graphics.setColor(defaultColour)
end