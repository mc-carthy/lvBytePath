Player = GameObject:extend()

function Player:new(area, x, y, opts)
    Player.super.new(self, area, x, y, opts)
    self.x, self.y = x, y
    self.w, self.h = 12, 12
    self.collider = self.area.world:newCircleCollider(self.x, self.y, self.w)
    self.collider:setObject(self)
    self.collider:applyAngularImpulse(5000)

    self.r = -math.pi / 2
    self.rv = 1.66*math.pi
    self.v = 0
    self.baseMaxV = 100
    self.maxV = self.baseMaxV
    self.a = 100

    self.trailColour = skillPointColour

    self.attack_speed = 1
    self.timer:every(5, function() self.attack_speed = Random(1, 2) end)
    self.timer:every(5, function() self:tick() end)
    self.timer:every(0.01, function()
        self.area:addGameObject('TrailParticle', 
        self.x - self.w * math.cos(self.r), self.y - self.h * math.sin(self.r), 
        { parent = self, r = Random(2, 4), d = Random(0.15, 0.25), colour = self.trailColour}) 
    end)
    self.timer:after(0.24 / self.attack_speed, function(f)
        self:shoot()
        self.timer:after(0.24 / self.attack_speed, f)
    end)
end

function Player:shoot()
    local d = 1.2 * self.w
    self.area:addGameObject(
        'ShootEffect', 
        self.x + d * math.cos(self.r),
        self.y + d * math.sin(self.r),
        { player = self, d = d }
    )
    self.area:addGameObject(
        'Projectile', 
        self.x + d * math.cos(self.r),
        self.y + d * math.sin(self.r),
        { r = self.r }
    )
end

function Player:die()
    for i = 1, love.math.random(8, 12) do
        self.area:addGameObject('ExplodeParticle', self.x, self.y)
    end
    slow(0.15, 1)
    flash(10)
    camera:shake(6, 60, 0.4)
    self.dead = true
end

function Player:tick()
    self.area:addGameObject('TickEffect', self.x, self.y, { parent = self })
end

function Player:update(dt)
    Player.super.update(self, dt)
    if input:down('left') then self.r = self.r - self.rv * dt end
    if input:down('right') then self.r = self.r + self.rv * dt end

    self.maxV = self.baseMaxV
    self.boosting = false
    if input:down('up') then 
        self.maxV = 1.5 * self.baseMaxV
        self.boosting = true
    end
    if input:down('down') then 
        self.maxV = 0.5 * self.baseMaxV
        self.boosting = true
    end
    self.trailColour = self.boosting and boostColour or skillPointColour
    self.v = math.min(self.v + self.a * dt, self.maxV)
    self.collider:setLinearVelocity(self.v * math.cos(self.r), self.v * math.sin(self.r))

    if self.x < 0 or self.x > gw or self.y < 0 or self.y > gh then self:die() end
end

function Player:draw()
    love.graphics.circle('line', self.x, self.y, self.w)
    -- love.graphics.line(self.x, self.y, self.x + 2*self.w*math.cos(self.r), self.y + 2*self.w*math.sin(self.r))
end

function Player:destroy()
    Player.super.destroy(self)
end