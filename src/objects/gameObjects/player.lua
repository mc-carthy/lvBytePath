Player = GameObject:extend()

function Player:new(area, x, y, opts)
    Player.super.new(self, area, x, y, opts)
    self.x, self.y = x, y
    self.w, self.h = 12, 12
    self.collider = self.area.world:newCircleCollider(self.x, self.y, self.w)
    self.collider:setObject(self)
    self.collider:setCollisionClass('Player')
    self.collider:applyAngularImpulse(5000)

    self.r = -math.pi / 2
    self.rv = 1.66*math.pi
    self.v = 0
    self.baseMaxV = 100
    self.maxV = self.baseMaxV
    self.a = 100
    self.maxHp = 100
    self.hp = self.maxHp
    self.invincible = false
    self.invisible = false
    self.maxAmmo = 100
    self.ammo = self.maxAmmo
    self.maxBoost = 100
    self.boost = self.maxBoost
    self.boostGainRate = 10
    self.boostUseRate = 50
    self.canBoost = true
    self.boostTimer = 0
    self.boostCooldown = 2
    self.cycleTimer = 0
    self.cycleCooldown = 5
    self.trailColour = skillPointColour

    self.attackSpeed = 1
    self.shootTimer = 0
    self.shootCooldown = 0.24
    self:setAttack('Neutral')
    self.timer:every(5, function() self.attackSpeed = Random(1, 2) end)
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

    self.hpMultiplier = 1
    self.flatHp = 0
    self.ammoMultiplier = 1
    self.flatAmmo = 0
    self.flatAmmoGain = 0
    self.boostMultiplier = 1
    self.flatBoost = 0

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

    self:setStats()
end

function Player:setStats()
    self.maxHp = (self.maxHp + self.flatHp) * self.hpMultiplier
    self.hp = self.maxHp
    self.maxAmmo = (self.maxAmmo + self.flatAmmo) * self.ammoMultiplier
    self.ammo = self.maxAmmo
    self.maxBoost = (self.maxBoost + self.flatBoost) * self.boostMultiplier
    self.boost = self.maxBoost
end

function Player:setAttack(attack)
    self.attack = attack
    self.shootCooldown = attacks[attack].cooldown
    self.ammo = self.maxAmmo
end

function Player:shoot()
    local d = 1.2 * self.w
    self.area:addGameObject(
        'ShootEffect', 
        self.x + d * math.cos(self.r),
        self.y + d * math.sin(self.r),
        { player = self, d = d }
    )
    if self.attack == 'Neutral' or self.attack == 'Rapid' then
        self.ammo = self.ammo - attacks[self.attack].ammo
        self.area:addGameObject(
            'Projectile', 
            self.x + d * math.cos(self.r),
            self.y + d * math.sin(self.r),
            { r = self.r, attack = self.attack }
        )
    elseif self.attack == 'Double' then
        self.ammo = self.ammo - attacks[self.attack].ammo
        self.area:addGameObject(
            'Projectile', 
            self.x + 1.5 * d * math.cos(self.r + math.pi / 12),
            self.y + 1.5 * d * math.sin(self.r + math.pi / 12),
            { r = self.r + math.pi / 12, attack = self.attack }
        )
        self.area:addGameObject(
            'Projectile', 
            self.x + 1.5 * d * math.cos(self.r - math.pi / 12),
            self.y + 1.5 * d * math.sin(self.r - math.pi / 12),
            { r = self.r - math.pi / 12, attack = self.attack }
        )
    elseif self.attack == 'Triple' then
        self.ammo = self.ammo - attacks[self.attack].ammo
        self.area:addGameObject(
            'Projectile', 
            self.x + d * math.cos(self.r),
            self.y + d * math.sin(self.r),
            { r = self.r + math.pi / 12, attack = self.attack }
        )
        self.area:addGameObject(
            'Projectile', 
            self.x + d * math.cos(self.r),
            self.y + d * math.sin(self.r),
            { r = self.r - math.pi / 12, attack = self.attack }
        )
        self.area:addGameObject(
            'Projectile', 
            self.x + d * math.cos(self.r),
            self.y + d * math.sin(self.r),
            { r = self.r, attack = self.attack }
        )
    elseif self.attack == 'Spread' then
        self.ammo = self.ammo - attacks[self.attack].ammo
        local colour = self.ammo % 2 == 0 and defaultColour or RandomFromTable(allColours)
        self.area:addGameObject(
            'Projectile', 
            self.x + d * math.cos(self.r),
            self.y + d * math.sin(self.r),
            { r = self.r + Random(-math.pi / 8, math.pi / 8), attack = self.attack, colour = colour }
        )
    elseif self.attack == 'Back' then
        self.ammo = self.ammo - attacks[self.attack].ammo
        self.area:addGameObject(
            'Projectile', 
            self.x + d * math.cos(self.r),
            self.y + d * math.sin(self.r),
            { r = self.r, attack = self.attack}
        )
        self.area:addGameObject(
            'Projectile', 
            self.x + 1.5 * d * math.cos(self.r - math.pi),
            self.y + 1.5 * d * math.sin(self.r - math.pi),
            { r = self.r - math.pi, attack = self.attack}
        )
    elseif self.attack == 'Side' then
        self.ammo = self.ammo - attacks[self.attack].ammo
        self.area:addGameObject(
            'Projectile', 
            self.x + d * math.cos(self.r),
            self.y + d * math.sin(self.r),
            { r = self.r, attack = self.attack}
        )
        self.area:addGameObject(
            'Projectile', 
            self.x + 1.5 * d * math.cos(self.r - math.pi / 2),
            self.y + 1.5 * d * math.sin(self.r - math.pi / 2),
            { r = self.r - math.pi / 2, attack = self.attack}
        )
        self.area:addGameObject(
            'Projectile', 
            self.x + 1.5 * d * math.cos(self.r + math.pi / 2),
            self.y + 1.5 * d * math.sin(self.r + math.pi / 2),
            { r = self.r + math.pi / 2, attack = self.attack}
        )
    end
    if self.ammo <= 0 then
        self:setAttack('Neutral')
        self.ammo = self.maxAmmo
    end
end

function Player:hit(damage)
    if self.invincible then return end
    local damage = damage or 10
    local flashTime = 0.04
    local invincibilityTime = 2
    self:addHp(-damage)

    for i = 1, love.math.random(4, 8) do
        self.area:addGameObject('ExplodeParticle', self.x, self.y)
    end

    if damage >= 30 then
        self.invincible = true
        self.timer:after(invincibilityTime, function() self.invincible = false end)
        for i = 1, math.floor(invincibilityTime / flashTime) do
            self.timer:after((i - 1) * flashTime, function() 
                self.invisible = not self.invisible 
            end)
            if i >= math.floor(invincibilityTime / flashTime) then
                self.invisible = false
            end
        end
        camera:shake(6, 0.2, 0.4)
        flash(3)
        slow(0.25, 0.5)
    else
        camera:shake(6, 0.1, 0.4)
        flash(2)
        slow(0.75, 0.25)
    end
end

function Player:die()
    for i = 1, love.math.random(8, 12) do
        self.area:addGameObject('ExplodeParticle', self.x, self.y)
    end
    slow(0.15, 1)
    flash(10)
    camera:shake(6, 60, 0.4)
    self.dead = true
    currentRoom:finish()
end

function Player:cycle()
    self.area:addGameObject('TickEffect', self.x, self.y, { parent = self })
end

function Player:addAmmo(amount)
    self.ammo = math.min(self.ammo + amount + self.flatAmmoGain, self.maxAmmo)
end

function Player:addBoost(amount)
    self.boost = math.min(self.boost + amount, self.maxBoost)
end

function Player:addHp(amount)
    self.hp = math.min(self.hp + amount, self.maxHp)
    if self.hp <= 0 then
        self:die()
    end
end

function Player:addSp(amount)
    sp = sp + amount
end

function Player:update(dt)
    Player.super.update(self, dt)
    
    self.cycleTimer = self.cycleTimer + dt
    if self.cycleTimer > self.cycleCooldown then
        self:cycle()
        self.cycleTimer = 0
    end
    
    if input:down('left') then self.r = self.r - self.rv * dt end
    if input:down('right') then self.r = self.r + self.rv * dt end

    self.shootTimer = self.shootTimer + dt
    if self.shootTimer > self.shootCooldown then
        self.shootTimer = 0
        self:shoot()
    end

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

    if self.collider:enter('Collectable') then
        local collisionData = self.collider:getEnterCollisionData('Collectable')
        local object = collisionData.collider:getObject()
        if object:is(Ammo) then
            object:die()
            self:addAmmo(5)
            currentRoom.score = currentRoom.score + 50
        end
        if object:is(Boost) then
            object:die()
            self:addBoost(25)
            currentRoom.score = currentRoom.score + 150
        end
        if object:is(Health) then
            object:die()
            self:addHp(25)
        end
        if object:is(SkillPoint) then
            object:die()
            self:addSp(1)
            currentRoom.score = currentRoom.score + 250
        end
        if object:is(Attack) then
            self:setAttack(object.attack)
            object:die()
            currentRoom.score = currentRoom.score + 500
        end
    end
    if self.collider:enter('Enemy') then
        local collisionData = self.collider:getEnterCollisionData('Enemy')
        local object = collisionData.collider:getObject()
        if object then
            self:hit(30)
        end
    end
end

function Player:draw()
    -- love.graphics.circle('line', self.x, self.y, self.w)
    -- love.graphics.line(self.x, self.y, self.x + 2*self.w*math.cos(self.r), self.y + 2*self.w*math.sin(self.r))
    if self.invisible then return end
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