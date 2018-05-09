SkillPoint = GameObject:extend()

function SkillPoint:new(area, x, y, opts)
    SkillPoint.super.new(self, area, x, y, opts)

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

function SkillPoint:update(dt)
    SkillPoint.super.update(self, dt)
end

function SkillPoint:die()
    self.dead = true
    self.area:addGameObject('SkillPointEffect', self.x, self.y, { colour = skillPointColour, w = self.w, h = self.h })
    self.area:addGameObject('InfoText', self.x + RandomFromTable({-1, 1}) * self.w, self.y + RandomFromTable({-1, 1}) * self.h, { text = '+ SP', colour = skillPointColour })
    for i = 1, love.math.random(4, 8) do 
    	self.area:addGameObject('ExplodeParticle', self.x, self.y, { s = 3, colour = skillPointColour })
    end
end

function SkillPoint:draw()
    love.graphics.setColor(skillPointColour)
    PushRotate(self.x, self.y, self.collider:getAngle())
    Draft:rhombus(self.x, self.y, 1.5 * self.w, 1.5 * self.h, 'line')
    Draft:rhombus(self.x, self.y, 0.5 * self.w, 0.5 * self.h, 'fill')
    love.graphics.pop()
    love.graphics.setColor(defaultColour)
end