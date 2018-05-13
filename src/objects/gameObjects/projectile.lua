Projectile = GameObject:extend()

function Projectile:new(area, x, y, opts)
    Projectile.super.new(self, area, x, y, opts)
    self.colour = opts.colour or attacks[self.attack].colour
    self.damage = opts.damage or 100
    self.s = opts.s or 2.5
    self.v = (opts.v or 200) * currentRoom.player.projectileSpeedMultiplier.value

    self.collider = self.area.world:newCircleCollider(self.x, self.y, self.s)
    self.collider:setObject(self)
    self.collider:setCollisionClass('Projectile')

    if self.attack == 'Homing' then
        self.timer:every(0.02, function()
            local r = Vector(self.collider:getLinearVelocity()):angle()
            self.area:addGameObject(
                'TrailParticle', 
                self.x - 1.0 * self.s * math.cos(r), 
                self.y - 1.0 * self.s * math.sin(r), 
                { parent = self, r = Random(1, 3), d = Random(0.1, 0.15), colour = skillPointColour }) 
        end)
    end
end

function Projectile:update(dt)
    Projectile.super.update(self, dt)
    
    
    if self.x < 0 or self.x > gw or self.y < 0 or self.y > gh then self:die() end
    
    if self.collider:enter('Enemy') then
        local collisionData = self.collider:getEnterCollisionData('Enemy')
        local object = collisionData.collider:getObject()
        if object then
            if object:is(Rock) then
                currentRoom.score = currentRoom.score + 100
            elseif object:is(Shooter) then
                currentRoom.score = currentRoom.score + 150
            end
            object:hit(self.damage)
            if object.hp and object.hp <= 0 then
                currentRoom.player:onKill(object)
            end
            self:die()
        end
    end
    
    if self.attack == 'Homing' then
        if self.target and not self.target.dead then
            local heading = Vector(self.collider:getLinearVelocity()):normalized()
            local angle = math.atan2(self.target.y - self.y, self.target.x - self.x)
            local toTargetHeading = Vector(math.cos(angle), math.sin(angle)):normalized()
            local finalHeading = (heading + 0.1 * toTargetHeading):normalized()
            self.collider:setLinearVelocity(self.v * finalHeading.x, self.v * finalHeading.y)
        else
            local targets = self.area:getGameObjects(function(e) 
                for _, enemy in ipairs(enemies) do
                    if e:is(_G[enemy]) and Distance({ x = e.x, y = e.y }, { x = self.x, y = self.y }) < 400 then
                        return true
                    end
                end
            end)
            self.target = table.remove(targets, love.math.random(1, #targets))
        end
    else
        self.collider:setLinearVelocity(self.v * math.cos(self.r), self.v * math.sin(self.r))
    end
end

function Projectile:die()
    self.dead = true
    self.area:addGameObject('ProjectileDeathEffect', self.x, self.y, { colour = hpColour, w = 3 * self.s })
end

function Projectile:draw()
    -- love.graphics.circle('line', self.x, self.y, self.s)
    -- love.graphics.setColor(defaultColour)
    
    PushRotate(self.x, self.y, Vector(self.collider:getLinearVelocity()):angle()) 
    if self.attack == 'Homing' then
        love.graphics.setColor(self.colour)
        love.graphics.polygon('fill', self.x - 2 * self.s, self.y, self.x, self.y - 1.5 * self.s, self.x, self.y + 1.5 * self.s)
        love.graphics.setColor(defaultColour)
        love.graphics.polygon('fill', self.x, self.y - 1.5 * self.s, self.x, self.y + 1.5 * self.s, self.x + 1.5 * self.s, self.y)
    else
        love.graphics.setLineWidth(self.s - self.s / 4)
        love.graphics.line(self.x - 2 * self.s, self.y, self.x, self.y)
        love.graphics.setColor(self.colour) -- change half the projectile line to another color
        love.graphics.line(self.x, self.y, self.x + 2 * self.s, self.y)
        love.graphics.setLineWidth(1)
    end
    love.graphics.pop()
    love.graphics.setColor(defaultColour)
end

function Projectile:destroy()
    Projectile.super.destroy(self)
end