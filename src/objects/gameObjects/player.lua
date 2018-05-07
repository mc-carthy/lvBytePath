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
    self.maxHp = 100
    self.Hp = self.maxHp
    self.maxAmmo = 100
    self.ammo = self.maxAmmo
    self.maxBoost = 100
    self.boost = self.maxBoost
    self.boostGainRate = 10
    self.boostUseRate = 50
    self.canBoost = true
    self.boostTimer = 0
    self.boostCooldown = 2

    self.trailColour = skillPointColour

    self.attackSpeed = 1
    self.timer:every(5, function() self.attackSpeed = Random(1, 2) end)
    self.timer:every(5, function() self:tick() end)
    self.timer:every(0.01, function()
        if self.ship == 'Fighter' then
            self.area:addGameObject(
                'TrailParticle', 
                self.x - 0.9 * self.w * math.cos(self.r) + 0.2 * self.w * math.cos(self.r - math.pi / 2),
                self.y - 0.9 * self.w * math.sin(self.r) + 0.2 * self.w * math.sin(self.r - math.pi / 2),
                { parent = self, r = Random(2, 4), d = Random(0.15, 0.25), colour = self.trailColour}
            ) 
            self.area:addGameObject(
                'TrailParticle', 
                self.x - 0.9 * self.w * math.cos(self.r) + 0.2 * self.w * math.cos(self.r + math.pi / 2),
                self.y - 0.9 * self.w * math.sin(self.r) + 0.2 * self.w * math.sin(self.r + math.pi / 2),
                { parent = self, r = Random(2, 4), d = Random(0.15, 0.25), colour = self.trailColour}
            ) 
        end
    end)
    self.timer:after(0.24 / self.attackSpeed, function(f)
        self:shoot()
        self.timer:after(0.24 / self.attackSpeed, f)
    end)


    self.ship = 'Fighter'
    self.polygons = {}
    if self.ship == 'Fighter' then
        self.polygons[1] = {
            self.w, 0,
            self.w / 2, -self.w / 2,
            -self.w / 2, -self.w / 2,
            -self.w, 0,
            -self.w / 2, self.w / 2,
            self.w / 2, self.w / 2,
        }
        
        self.polygons[2] = {
            self.w / 2, -self.w / 2,
            0, -self.w,
            -self.w - self.w / 2, -self.w,
            -3 * self.w / 4, -self.w / 4,
            -self.w / 2, -self.w / 2,
        }
        
        self.polygons[3] = {
            self.w / 2, self.w / 2,
            -self.w / 2, self.w / 2,
            -3 * self.w / 4, self.w / 4,
            -self.w - self.w / 2, self.w,
            0, self.w,
        }
    end
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


    self.boost = math.min(self.boost + self.boostGainRate * dt, self.maxBoost)
    self.maxV = self.baseMaxV
    self.boostTimer = self.boostTimer + dt
    if self.boostTimer > self.boostCooldown then self.canBoost = true end
    self.boosting = false
    if input:down('up') and self.boost > 1 and self.canBoost then 
        self.maxV = 1.5 * self.baseMaxV
        self.boosting = true
        self.boost = self.boost - self.boostUseRate * dt
        if self.boost <= 1 then
            self.boosting = false
            self.canBoost = false
            self.boostTimer = 0
        end
    end
    if input:down('down') and self.boost > 1 and self.canBoost then
        self.maxV = 0.5 * self.baseMaxV
        self.boosting = true
        self.boost = self.boost - self.boostUseRate * dt
        if self.boost <= 1 then
            self.boosting = false
            self.canBoost = false
            self.boostTimer = 0
        end
    end
    self.trailColour = self.boosting and boostColour or skillPointColour
    self.v = math.min(self.v + self.a * dt, self.maxV)
    self.collider:setLinearVelocity(self.v * math.cos(self.r), self.v * math.sin(self.r))

    if self.x < 0 or self.x > gw or self.y < 0 or self.y > gh then self:die() end
end

function Player:draw()
    -- love.graphics.circle('line', self.x, self.y, self.w)
    -- love.graphics.line(self.x, self.y, self.x + 2*self.w*math.cos(self.r), self.y + 2*self.w*math.sin(self.r))
    PushRotate(self.x, self.y, self.r)
        love.graphics.setColor(defaultColour)
        for _, v in pairs(self.polygons) do
            local points = Tbl.map(v, function(k, v)
                if k % 2 == 1 then
                    return self.x + v + Random(-1, 1)
                else
                    return self.y + v + Random(-1, 1)
                end
            end)
            love.graphics.polygon('line', points)
        end
    love.graphics.pop()
end

function Player:destroy()
    Player.super.destroy(self)
end