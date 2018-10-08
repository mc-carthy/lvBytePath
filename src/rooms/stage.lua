Stage = Object:extend()

function Stage:new()
    self.timer = Timer()
    self.area = Area()
    self.area:addPhysicsWorld()
    self.area.world:addCollisionClass('Enemy')
    self.area.world:addCollisionClass('Player')
    self.area.world:addCollisionClass('Projectile', { ingores = { 'Projectile', 'Player' }})
    self.area.world:addCollisionClass('Collectable', { ignores = { 'Projectile', 'Collectable', 'Enemy' }})
    self.area.world:addCollisionClass('EnemyProjectile', { ignores = { 'Projectile', 'EnemyProjectile', 'Enemy', 'Collectable' }})
    self.mainCanvas = love.graphics.newCanvas(gw, gh)
    self.player = self.area:addGameObject('Player', gw/2, gh/2)
    self.director = Director(self)
    self.font = fonts.m5x7_16
    self.score = 0
    input:bind('x', function() 
        self.player:die()
    end)
    input:bind('a', function() 
        self.area:addGameObject('HasteArea', Random(0, gw), Random(0, gh)) 
    end)
    input:bind('b', function() 
        self.area:addGameObject('Boost', Random(0, gw), Random(0, gh)) 
    end)
    input:bind('h', function() 
        self.area:addGameObject('Health', Random(0, gw), Random(0, gh)) 
    end)
    input:bind('s', function() 
        self.area:addGameObject('SkillPoint', Random(0, gw), Random(0, gh)) 
    end)
    input:bind('1', function() 
        self.area:addGameObject('Attack', Random(0, gw), Random(0, gh)) 
    end)
    input:bind('r', function() 
        self.area:addGameObject('Rock', Random(0, gw), Random(0, gh)) 
    end)
    input:bind('z', function() 
        self.timer:after(1, function()
            gotoRoom('Stage')
        end)
    end)
end

function Stage:finish()
    self.timer:after(1, function()
        gotoRoom('Stage')
    end)
end

function Stage:update(dt)
    self.director:update(dt)
    self.timer:update(dt)
    camera.smoother = Camera.smooth.damped(5)
    camera:lockPosition(dt, gw, gh)
    if self.area then
        self.area:update(dt)
    end
end

function Stage:draw()
    love.graphics.setCanvas(self.mainCanvas)
    love.graphics.clear()
        camera:attach(0, 0, gw * 2, gh * 2)
        self.area:draw()
        camera:detach()

        love.graphics.setFont(self.font)
        -- Score
        love.graphics.setColor(defaultColour)
        love.graphics.print(
            self.score, 
            gw - 40, 10, 
            0, 1, 1,
            math.floor(self.font:getWidth(self.score) / 2), self.font:getHeight() / 2
        )

        -- Skill point
        love.graphics.setColor(skillPointColour)
        love.graphics.print(
            sp .. ' SP', 
            40, 10, 
            0, 1, 1,
            math.floor(self.font:getWidth(sp .. ' SP') / 2), self.font:getHeight() / 2
        )

        -- HP
        local r, g, b = unpack(hpColour)
        local hp, maxHp = self.player.hp, self.player.maxHp
        love.graphics.setColor(r, g, b)
        love.graphics.rectangle('fill', gw / 2 - 52, gh - 16, 48 * (hp / maxHp), 4)
        love.graphics.setColor(r - 32 / 255, g - 32 / 255, b - 32 / 255)
        love.graphics.rectangle('line', gw / 2 - 52, gh - 16, 48, 4)
        love.graphics.print(
            'HP', 
            gw / 2 - 52 + 24, gh - 24, 
            0, 1, 1,
            math.floor(self.font:getWidth('HP') / 2), math.floor(self.font:getHeight() / 2)
        )
        love.graphics.print(
            hp .. '/' .. maxHp, 
            gw / 2 - 52 + 24, gh - 6, 
            0, 1, 1,
    	    math.floor(self.font:getWidth(hp .. '/' .. maxHp) / 2), math.floor(self.font:getHeight() / 2)
        )

        -- Ammo
        local r, g, b = unpack(ammoColour)
        local ammo, maxAmmo = math.floor(self.player.ammo), self.player.maxAmmo
        love.graphics.setColor(r, g, b)
        love.graphics.rectangle('fill', gw / 2 - 52, 16, 48 * (ammo / maxAmmo), 4)
        love.graphics.setColor(r - 32 / 255, g - 32 / 255, b - 32 / 255)
        love.graphics.rectangle('line', gw / 2 - 52, 16, 48, 4)
        love.graphics.print(
            'AMMO', 
            gw / 2 - 52 + 24, 26, 
            0, 1, 1,
            math.floor(self.font:getWidth('AMMO') / 2), math.floor(self.font:getHeight() / 2)
        )
        love.graphics.print(
            ammo .. '/' .. maxAmmo, 
            gw / 2 - 52 + 24, 6, 
            0, 1, 1,
    	    math.floor(self.font:getWidth(ammo .. '/' .. maxAmmo) / 2), math.floor(self.font:getHeight() / 2)
        )
        
        -- Boost
        local r, g, b = unpack(boostColour)
        local boost, maxBoost = self.player.boost, self.player.maxBoost
        love.graphics.setColor(r, g, b)
        love.graphics.rectangle('fill', gw / 2 + 4, 16, 48 * (boost / maxBoost), 4)
        love.graphics.setColor(r - 32 / 255, g - 32 / 255, b - 32 / 255)
        love.graphics.rectangle('line', gw / 2 + 4, 16, 48, 4)
        love.graphics.print(
            'BOOST', 
            gw / 2 + 4 + 24, 26, 
            0, 1, 1,
            math.floor(self.font:getWidth('BOOST') / 2), math.floor(self.font:getHeight() / 2)
        )
        love.graphics.print(
            math.floor(boost) .. '/' .. math.floor(maxBoost), 
            gw / 2 + 4 + 24, 6, 
            0, 1, 1,
    	    math.floor(self.font:getWidth(math.floor(boost) .. '/' .. math.floor(maxBoost)) / 2), math.floor(self.font:getHeight() / 2)
        )

        -- Cycle
        local r, g, b = unpack(defaultColour)
        local cycle, cycleCooldown = self.player.cycleTimer, self.player.cycleCooldown
        love.graphics.setColor(r, g, b)
        love.graphics.rectangle('fill', gw / 2 + 4, gh - 16, 48 * (cycle / cycleCooldown), 4)
        love.graphics.setColor(r - 32 / 255, g - 32 / 255, b - 32 / 255)
        love.graphics.rectangle('line', gw / 2 + 4, gh - 16, 48, 4)
        love.graphics.print(
            'CYCLE', 
            gw / 2 + 4 + 24, gh - 26, 
            0, 1, 1,
            math.floor(self.font:getWidth('CYCLE') / 2), math.floor(self.font:getHeight() / 2)
        )

        love.graphics.setColor(255 / 255, 255 / 255, 255 / 255)
    love.graphics.setCanvas()
    
    -- love.graphics.setColor(0, 0, 0, 255 / 255)
    -- love.graphics.rectangle("fill", 0, 0, gw * sx, gw * sy)

    love.graphics.setColor(255 / 255, 255 / 255, 255 / 255, 255 / 255)
    love.graphics.setBlendMode('alpha', 'premultiplied')
    love.graphics.draw(self.mainCanvas, 0, 0, 0, sx, sy)
    love.graphics.setBlendMode('alpha')
end

function Stage:destroy()
    self.area:destroy()
    self.area = nil
    self.player = nil
end