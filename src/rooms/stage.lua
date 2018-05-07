Stage = Object:extend()

function Stage:new()
    self.timer = Timer()
    self.area = Area()
    self.area:addPhysicsWorld()
    self.mainCanvas = love.graphics.newCanvas(gw, gh)
    self.player = self.area:addGameObject('Player', gw/2, gh/2)
    input:bind('x', function() 
        self.player:die()
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