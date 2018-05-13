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
    self.moveSpeedMultiplier = Stat(1)
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
    self.cycleCooldownSpeedMultiplier = Stat(1)
    self.trailColour = skillPointColour

    self.attackSpeed = 1
    self.shootTimer = 0
    self.shootCooldown = 0.24
    self:setAttack('Neutral')
    self.timer:every(5, function() self.attackSpeed = Random(1, 2) end)
    
    self.baseAttackSpeedMultiplier = 1
    self.attackSpeedMultiplier = Stat(1)
    self.baseProjectileSpeedMultiplier = 200
    self.projectileSpeedMultiplier = Stat(1)
    self.hpMultiplier = 1
    self.flatHp = 0
    self.ammoMultiplier = 1
    self.flatAmmo = 0
    self.flatAmmoGain = 0
    self.boostMultiplier = 1
    self.flatBoost = 0

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
    
    self.luckMultiplier = 1

    self.enemySpawnRateMultiplier = 1
    self.resourceSpawnRateMultiplier = 1
    self.attackSpawnRateMultiplier = 1

    self.turnRateMultiplier = 1
    self.boostEffectivenessMultiplier = 1
    self.projectileSizeMultiplier = 1
    self.boostRechargeRateMultiplier = 1
    self.invincibilityDurationMultiplier = 1
    self.ammoConsumptionMultiplier = 5
    self.sizeMultiplier = 0 -- TODO: Implement this
    self.statBoostDurationMultiplier = 0 -- TODO: Implement this

    self.hpSpawnChanceMultiplier = 1
    self.spSpawnChanceMultiplier = 1
    self.boostSpawnChanceMultiplier = 1
    self.doubleHpSpawnChance = 0
    self.doubleSpSpawnChance = 0
    self.doubleBoostSpawnChance = 0

    self.attackTwiceOnShootChance = 0

    self.launchHomingProjectileOnAmmoPickupChance = 0
    self.regainHpOnAmmoPickupChance = 0
    self.regainHpOnSpPickupChance = 0
    self.spawnHasteAreaOnSpPickupChance = 0
    self.spawnHasteAreaOnHpPickupChance = 0
    
    self.spawnSpOnCycleChance = 0
    self.spawnHpOnCycleChance = 0
    self.regainHpOnCycleChance = 0
    self.regainFullAmmoOnCycleChance = 0
    self.changeAttackOnCycleChance = 0
    self.spawnHasteAreaOnCycleChance = 0
    self.barrageOnCycleChance = 0
    self.launchHomingProjectileOnCycleChance = 0
    self.gainMoveSpeedBoostOnCycleChance = 0
    self.gainProjectileSpeedBoostOnCycleChance = 0
    self.loseProjectileSpeedBoostOnCycleChance = 0
    
    self.barrageOnKillChance = 0
    self.regainAmmoOnKillChance = 0
    self.spawnDoubleAmmoOnKillChance = 0
    self.launchHomingProjectileOnKillChance = 0
    self.regainBoostOnKillChance = 0
    self.spawnBoostOnKillChance = 0
    self.gainAttackSpeedBoostOnKillChance = 0

    self.launchHomingProjectileWhileBoostingChance = 0
    self.increasedCycleSpeedWhileBoosting = false
    self.invincibleWhileBoosting = false
    self.increasedLuckWhileBoosting = false


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
    self:generateChances()
end

function Player:setStats()
    self.maxHp = (self.maxHp + self.flatHp) * self.hpMultiplier
    self.hp = self.maxHp
    self.maxAmmo = (self.maxAmmo + self.flatAmmo) * self.ammoMultiplier
    self.ammo = self.maxAmmo
    self.maxBoost = (self.maxBoost + self.flatBoost) * self.boostMultiplier
    self.boost = self.maxBoost
end

function Player:generateChances()
    self.chances = {}
    for k, v in pairs(self) do
        if k:find('Chance') and type(v) == 'number' then
      	    self.chances[k] = ChanceList(
                { true, math.ceil(v * self.luckMultiplier) },
                { false, 100 - math.ceil(v * self.luckMultiplier) }
            )
      	end
    end
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
    if self.attack == 'Neutral' or self.attack == 'Rapid' or self.attack == 'Homing' then
        self.ammo = self.ammo - attacks[self.attack].ammo * (1 / self.ammoConsumptionMultiplier)
        self.area:addGameObject(
            'Projectile', 
            self.x + d * math.cos(self.r),
            self.y + d * math.sin(self.r),
            { r = self.r, attack = self.attack }
        )
    elseif self.attack == 'Double' then
        self.ammo = self.ammo - attacks[self.attack].ammo * (1 / self.ammoConsumptionMultiplier)
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
        self.ammo = self.ammo - attacks[self.attack].ammo * (1 / self.ammoConsumptionMultiplier)
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
        self.ammo = self.ammo - attacks[self.attack].ammo * (1 / self.ammoConsumptionMultiplier)
        local colour = self.ammo % 2 == 0 and defaultColour or RandomFromTable(allColours)
        self.area:addGameObject(
            'Projectile', 
            self.x + d * math.cos(self.r),
            self.y + d * math.sin(self.r),
            { r = self.r + Random(-math.pi / 8, math.pi / 8), attack = self.attack, colour = colour }
        )
    elseif self.attack == 'Back' then
        self.ammo = self.ammo - attacks[self.attack].ammo * (1 / self.ammoConsumptionMultiplier)
        self.area:addGameObject(
            'Projectile', 
            self.x + d * math.cos(self.r),
            self.y + d * math.sin(self.r),
            { r = self.r, attack = self.attack }
        )
        self.area:addGameObject(
            'Projectile', 
            self.x + 1.5 * d * math.cos(self.r - math.pi),
            self.y + 1.5 * d * math.sin(self.r - math.pi),
            { r = self.r - math.pi, attack = self.attack }
        )
    elseif self.attack == 'Side' then
        self.ammo = self.ammo - attacks[self.attack].ammo * (1 / self.ammoConsumptionMultiplier)
        self.area:addGameObject(
            'Projectile', 
            self.x + d * math.cos(self.r),
            self.y + d * math.sin(self.r),
            { r = self.r, attack = self.attack }
        )
        self.area:addGameObject(
            'Projectile', 
            self.x + 1.5 * d * math.cos(self.r - math.pi / 2),
            self.y + 1.5 * d * math.sin(self.r - math.pi / 2),
            { r = self.r - math.pi / 2, attack = self.attack }
        )
        self.area:addGameObject(
            'Projectile', 
            self.x + 1.5 * d * math.cos(self.r + math.pi / 2),
            self.y + 1.5 * d * math.sin(self.r + math.pi / 2),
            { r = self.r + math.pi / 2, attack = self.attack }
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
    local invincibilityTime = 2 * self.invincibilityDurationMultiplier
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
    self:onCycle()
end

function Player:onCycle()
    if self.chances.spawnSpOnCycleChance:next() then
        self.area:addGameObject('SkillPoint')
        self.area:addGameObject('InfoText', self.x, self.y, { text = 'SP Spawn!', colour = skillPointColour })
    end
    if self.chances.spawnHpOnCycleChance:next() then
        self.area:addGameObject('Health')
        self.area:addGameObject('InfoText', self.x, self.y, { text = 'HP Spawn!', colour = hpColour })
    end
    if self.chances.regainHpOnCycleChance:next() then
        self:addHp(25)
        self.area:addGameObject('InfoText', self.x, self.y, { text = 'HP Regain!', colour = hpColour })
    end
    if self.chances.regainFullAmmoOnCycleChance:next() then
        self:addAmmo(self.maxAmmo)
        self.area:addGameObject('InfoText', self.x, self.y, { text = 'Full Ammo Regain!', colour = ammoColour })
    end
    if self.chances.changeAttackOnCycleChance:next() then
        self:setRandomAttack()
        self.area:addGameObject('InfoText', self.x, self.y, { text = 'Random Attack!', colour = attacks[self.attack].colour })
    end
    if self.chances.spawnHasteAreaOnCycleChance:next() then
        self.area:addGameObject('HasteArea', self.x, self.y)
        self.area:addGameObject('InfoText', self.x, self.y, { text = 'Haste Area!', colour = ammoColour})
    end
    if self.chances.barrageOnCycleChance:next() then
        self:fireBarrage()
        self.area:addGameObject('InfoText', self.x, self.y, { text = 'Barrage!!!', colour = attacks[self.attack].colour })
    end
    if self.chances.launchHomingProjectileOnCycleChance:next() then
        self:launchHomingProjectile()
    end
    if self.chances.gainMoveSpeedBoostOnCycleChance:next() then
        self.moveSpeedMultiplierBoosting = true
        self.timer:after(4, function() self.moveSpeedMultiplierBoosting = false end)
        self.area:addGameObject('InfoText', self.x, self.y, { text = 'Speed Boost!', colour = boostColour })
    end
    if self.chances.gainProjectileSpeedBoostOnCycleChance:next() then
        self.projectileSpeedMultiplierBoosting = true
        self.timer:after(4, function() self.projectileSpeedMultiplierBoosting = false end)
        self.area:addGameObject('InfoText', self.x, self.y, { text = 'Missile Speed Boost!', colour = ammoColour })
    end
    if self.chances.loseProjectileSpeedBoostOnCycleChance:next() then
        self.projectileSpeedMultiplierInhibiting = true
        self.timer:after(4, function() self.projectileSpeedMultiplierInhibiting = false end)
        self.area:addGameObject('InfoText', self.x, self.y, { text = 'Missile Speed Reduction!', colour = ammoColour })
    end
end

function Player:onKill(object)
    if self.chances.barrageOnKillChance:next() then
        self:fireBarrage()
    end
    if self.chances.regainAmmoOnKillChance:next() then
        self:addAmmo(20)
        self.area:addGameObject('InfoText', self.x, self.y, { text = 'Ammo Regain!', colour = ammoColour })
    end
    if self.chances.launchHomingProjectileOnKillChance:next() then
        self:launchHomingProjectile()
    end
    if self.chances.regainBoostOnKillChance:next() then
        self:addBoost(40)
        self.area:addGameObject('InfoText', self.x, self.y, { text = 'Boost Regain!', colour = boostColour })
    end
    if self.chances.spawnBoostOnKillChance:next() then
        self.area:addGameObject('Boost', Random(0, gw), Random(0, gh)) 
        self.area:addGameObject('InfoText', self.x, self.y, { text = 'Boost Spawn!', colour = boostColour })
    end
    if self.chances.gainAttackSpeedBoostOnKillChance:next() then
        self.attackSpeedMultiplierBoosting = true
        self.timer:after(4, function() self.attackSpeedMultiplierBoosting = false end)
        self.area:addGameObject('InfoText', self.x, self.y, { text = 'Attack Speed Boost!', colour = ammoColour })
    end
    if self.chances.spawnDoubleAmmoOnKillChance:next() then
        self.area:addGameObject('Ammo', object.x + Random(-10, 10), object.y + Random(-10, 10)) 
        self.area:addGameObject('InfoText', object.x, object.y, { text = 'Double Ammo!', colour = ammoColour })
    end
end

function Player:onBoostStart()
    self.timer:every('launchHomingProjectileWhileBoostingChance', 0.2, function() 
        if self.chances.launchHomingProjectileWhileBoostingChance:next() then
            self:launchHomingProjectile()
        end
    end)
    if self.increasedCycleSpeedWhileBoosting then
        self.cycleBoosting = true
    end
    if self.invincibleWhileBoosting then
        self.invincible = true
        self.timer:every('invincibilityWhileBoosting', 0.04, function() self.invisible = not self.invisible end)
    end
    if self.increasedLuckWhileBoosting then
        self.luckBoosting = true
        self.luckMultiplier = self.luckMultiplier * 2
        self:generateChances()
    end
end

function Player:onBoostEnd()
    self.timer:cancel('launchHomingProjectileWhileBoostingChance')
    if self.increasedCycleSpeedWhileBoosting then
        self.cycleBoosting = false
    end
    if self.invincibleWhileBoosting then
        self.invincible = false
        self.timer:cancel('invincibilityWhileBoosting')
        self.invisible = false
    end
    if self.increasedLuckWhileBoosting and self.luckBoosting then
        self.luckBoosting = false
        self.luckMultiplier = self.luckMultiplier / 2
        self:generateChances()
    end
end

function Player:onAmmoPickup()
    if self.chances.launchHomingProjectileOnAmmoPickupChance:next() then
        self:launchHomingProjectile()
    end
    if self.chances.regainHpOnAmmoPickupChance:next() then
        self:addHp(25)
        self.area:addGameObject('InfoText', self.x, self.y, { text = 'HP Regain!', colour = hpColour })
    end
end

function Player:onSpPickup()
    if self.chances.regainHpOnSpPickupChance:next() then
        self:addHp(25)
        self.area:addGameObject('InfoText', self.x, self.y, { text = 'HP Regain!', colour = hpColour })
    end
    if self.chances.spawnHasteAreaOnSpPickupChance:next() then
        self.area:addGameObject('HasteArea', self.x, self.y)
        self.area:addGameObject('InfoText', self.x, self.y, { text = 'Haste Area!', colour = ammoColour })
    end
end

function Player:onHpPickup()
    if self.chances.spawnHasteAreaOnHpPickupChance:next() then
        self.area:addGameObject('HasteArea', self.x, self.y)
        self.area:addGameObject('InfoText', self.x, self.y, { text = 'Haste Area!', colour = ammoColour })
    end
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

function Player:setRandomAttack()
    local attack = RandomFromTable({
        'Double',
        'Triple',
        'Rapid',
        'Spread',
        'Back',
        'Side',
        'Homing'
    })

    self.attack = attack
    self.shootCooldown = attacks[self.attack].cooldown
    self.ammo = self.maxAmmo
end

function Player:fireBarrage()
    for i = 1, 8 do
        self.timer:after((i - 1) * 0.05, function()
            local angle = Random(-math.pi / 8, math.pi / 8)
            local d = 2.2 * self.w
            self.area:addGameObject(
                'Projectile', 
                self.x + d * math.cos(self.r + angle), 
                self.y + d * math.sin(self.r + angle), 
                { r = self.r + angle, attack = self.attack }
            )
        end)
    end
    self.area:addGameObject('InfoText', self.x, self.y, { text = 'Barrage!!!', colour = attacks[self.attack].colour })
end

function Player:launchHomingProjectile()
    local d = 1.2 * self.w
    self.area:addGameObject(
        'Projectile',
        self.x + d*math.cos(self.r), 
        self.y + d*math.sin(self.r), 
        { r = self.r, attack = 'Homing' })
    self.area:addGameObject('InfoText', self.x, self.y, { text = 'Homing Projectile!' })
end

function Player:update(dt)
    Player.super.update(self, dt)

    if self.cycleBoosting then self.cycleCooldownSpeedMultiplier:increase(200) end
    self.cycleCooldownSpeedMultiplier:update(dt)
    self.cycleTimer = self.cycleTimer + (dt * self.cycleCooldownSpeedMultiplier.value)
    if self.cycleTimer > self.cycleCooldown then
        self:cycle()
        self.cycleTimer = 0
    end
    
    if input:down('left') then self.r = self.r - self.rv * self.turnRateMultiplier * dt end
    if input:down('right') then self.r = self.r + self.rv * self.turnRateMultiplier * dt end

    if self.insideHasteArea then self.attackSpeedMultiplier:increase(100) end
    if self.attackSpeedMultiplierBoosting then self.attackSpeedMultiplier:increase(100) end
    self.attackSpeedMultiplier:update(dt)

    self.shootTimer = self.shootTimer + dt
    if self.shootTimer > self.shootCooldown / self.attackSpeedMultiplier.value then
        self.shootTimer = 0
        self:shoot()
        if self.chances.attackTwiceOnShootChance:next() then
            self:shoot()
            self.area:addGameObject('InfoText', self.x, self.y, { text = 'Double Shot!!!', colour = attacks[self.attack].colour })
        end
    end

    if self.moveSpeedMultiplierBoosting then self.moveSpeedMultiplier:increase(100) end
    self.moveSpeedMultiplier:update(dt)

    if self.projectileSpeedMultiplierBoosting then self.projectileSpeedMultiplier:increase(100) end
    if self.projectileSpeedMultiplierInhibiting then self.projectileSpeedMultiplier:decrease(100) end
    self.projectileSpeedMultiplier:update(dt)

    self.boost = math.min(self.boost + self.boostGainRate * self.boostRechargeRateMultiplier * dt, self.maxBoost)
    self.maxV = self.baseMaxV * self.moveSpeedMultiplier.value
    self.boostTimer = self.boostTimer + dt
    if self.boostTimer > self.boostCooldown then self.canBoost = true end
    self.boosting = false
    if input:pressed('up') and self.boost > 1 and self.canBoost then self:onBoostStart() end
    if input:released('up') then self:onBoostEnd() end
    if input:down('up') and self.boost > 1 and self.canBoost then 
        self.maxV = 1.5 * self.baseMaxV * self.boostEffectivenessMultiplier
        self.boosting = true
        self.boost = self.boost - self.boostUseRate * dt
        if self.boost <= 1 then
            self.boosting = false
            self.canBoost = false
            self.boostTimer = 0
            self:onBoostEnd()
        end
    end
    if input:pressed('down') and self.boost > 1 and self.canBoost then self:onBoostStart() end
    if input:released('down') then self:onBoostEnd() end
    if input:down('down') and self.boost > 1 and self.canBoost then
        self.maxV = 0.5 * self.baseMaxV / self.boostEffectivenessMultiplier
        self.boosting = true
        self.boost = self.boost - self.boostUseRate * dt
        if self.boost <= 1 then
            self.boosting = false
            self.canBoost = false
            self.boostTimer = 0
            self:onBoostEnd()
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
            self:onAmmoPickup()
            currentRoom.score = currentRoom.score + 50
        end
        if object:is(Boost) then
            object:die()
            self:addBoost(25)
            currentRoom.score = currentRoom.score + 150
        end
        if object:is(Health) then
            object:die()
            self:onHpPickup()
            self:addHp(25)
        end
        if object:is(SkillPoint) then
            object:die()
            self:addSp(1)
            self:onSpPickup()
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