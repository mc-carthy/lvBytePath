Attack = GameObject:extend()

function Attack:new(area, x, y, opts)
    Attack.super.new(self, area, x, y, opts)

    local direction = RandomFromTable({-1, 1})
    self.attack = RandomFromTable({
        'Double',
        'Triple',
        'Rapid',
        'Spread',
        'Back',
        'Side',
    })
    self.x = gw / 2 + direction * (gw / 2 + 48)
    self.y = Random(48, gh - 48)
    self.w, self.h = 24, 24
    self.font = fonts.m5x7_16
    self.collider = self.area.world:newRectangleCollider(self.x, self.y, self.w, self.h)
    self.collider:setObject(self)
    self.collider:setCollisionClass('Collectable')
    self.collider:setFixedRotation(false)
    self.v = -direction * Random(20, 40)
    self.collider:setLinearVelocity(self.v, 0)
    self.collider:applyAngularImpulse(Random(-24, 24))
end

function Attack:update(dt)
    Attack.super.update(self, dt)
end

function Attack:die()
    self.dead = true
    self.area:addGameObject('AttackEffect', self.x, self.y, { colour = attacks[self.attack].colour, w = self.w, h = self.h })
    self.area:addGameObject('InfoText', self.x + RandomFromTable({-1, 1}) * self.w, self.y + RandomFromTable({-1, 1}) * self.h, { text = attacks[self.attack].abbreviation, colour = attacks[self.attack].colour })
    for i = 1, love.math.random(4, 8) do 
    	self.area:addGameObject('ExplodeParticle', self.x, self.y, { s = 3, colour = attacks[self.attack].colour })
    end
end

function Attack:draw()
    love.graphics.setColor(attacks[self.attack].colour)
    PushRotate(self.x, self.y, self.collider:getAngle())
    Draft:rhombus(self.x, self.y, 1.5 * self.w, 1.5 * self.h, 'line')
    love.graphics.print(attacks[self.attack].abbreviation, self.x, self.y, 0, 1, 1, math.floor(self.font:getWidth(attacks[self.attack].abbreviation) / 2), math.floor(self.font:getHeight() / 2))
    love.graphics.setColor(defaultColour)
    Draft:rhombus(self.x, self.y, 1.25 * self.w, 1.25 * self.h, 'line')
    love.graphics.pop()
end