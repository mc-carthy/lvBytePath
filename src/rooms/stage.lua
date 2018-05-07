Stage = Object:extend()

function Stage:new()
    self.timer = Timer()
    self.area = Area()
    self.area:addPhysicsWorld()
    self.area.world:addCollisionClass('Player')
    self.area.world:addCollisionClass('Projectile', { ingores = { 'Projectile' }})
    self.area.world:addCollisionClass('Collectable', { ignores = { 'Projectile', 'Collectable' }})
    self.mainCanvas = love.graphics.newCanvas(gw, gh)
    self.player = self.area:addGameObject('Player', gw/2, gh/2)
    input:bind('x', function() 
        self.player:die()
    end)
    input:bind('a', function() 
        self.area:addGameObject('Ammo', Random(0, gw), Random(0, gh)) 
    end)
    input:bind('b', function() 
        self.area:addGameObject('Boost', Random(0, gw), Random(0, gh)) 
    end)
    input:bind('h', function() 
        self.area:addGameObject('Health', Random(0, gw), Random(0, gh)) 
    end)
end

function Stage:update(dt)
    self.timer:update(dt)
    camera.smoother = Camera.smooth.damped(5)
    camera:lockPosition(dt, gw, gh)
    self.area:update(dt)
end

function Stage:draw()
    love.graphics.setCanvas(self.mainCanvas)
    love.graphics.clear()
        camera:attach(0, 0, gw * sx, gh * sy)
        self.area:draw()
        camera:detach()
    love.graphics.setCanvas()
    
    -- love.graphics.setColor(0, 0, 0, 255)
    -- love.graphics.rectangle("fill", 0, 0, gw * sx, gw * sy)

    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.setBlendMode('alpha', 'premultiplied')
    love.graphics.draw(self.mainCanvas, 0, 0, 0, sx, sy)
    love.graphics.setBlendMode('alpha')
end

function Stage:destroy()
    self.area:destroy()
    self.area = nil
end