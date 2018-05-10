Rock = GameObject:extend()

function Rock:new(area, x, y, opts)
    Rock.super.new(self, area, x, y, opts)

    local direction = RandomFromTable({-1, 1})
    self.x = gw / 2 + direction * (gw / 2 + 48)
    self.y = Random(16, gh - 16)
    self.w, self.h = 8, 8
    self.collider = self.area.world:newPolygonCollider(CreateIrregularPolygon(8))
    self.collider:setPosition(self.x, self.y)
    self.collider:setObject(self)
    self.collider:setCollisionClass('Enemy')
    self.collider:setFixedRotation(false)
    self.v = -direction * Random(20, 40)
    self.collider:setLinearVelocity(self.v, 0)
    self.collider:applyAngularImpulse(Random(-100, 100))
end

function Rock:update(dt)
    Rock.super.update(self, dt)
    self.collider:setLinearVelocity(self.v, 0) 
end

function Rock:draw()
    love.graphics.setColor(hpColour)
    local points = {self.collider:getWorldPoints(self.collider.shapes.main:getPoints())}
    love.graphics.polygon('line', points)
    love.graphics.setColor(defaultColour)
end