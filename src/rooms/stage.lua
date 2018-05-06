Stage = Object:extend()

local function populateRectangles(self)
    for i = 1, 10 do
        local w, h = Random(40, 200), Random(10, 80)
        self.area:addGameObject('Rectangle', Random(0, love.graphics.getWidth() - w), Random(0, love.graphics.getHeight() - h), { w = w, h = h})
    end
end

local function removeRectangle(self)
    table.remove(self.area.gameObjects, love.math.random(1, #self.area.gameObjects))
end

function Stage:new()
    input:bind('d', 'destroy')
    self.area = Area()
    self.timer = Timer()
    populateRectangles(self)
    closest = self.area:getClosestObject(400, 300, 300, {'Rectangle'})
    if closest then
        print(closest.x .. '-' .. closest.y)
    end
end

function Stage:update(dt)
    if input:pressed('destroy') then
        removeRectangle(self)
        if #self.area.gameObjects <= 0 then
            populateRectangles(self)
        end
    end
    self.timer:update(dt)
    self.area:update(dt)
end

function Stage:draw()
    self.area:draw(dt)
    love.graphics.circle('line',400, 300, 300)
    if closest then
        love.graphics.line(0, closest.y, love.graphics.getWidth(), closest.y)
        love.graphics.line(closest.x, 0, closest.x, love.graphics.getHeight())
    end
end