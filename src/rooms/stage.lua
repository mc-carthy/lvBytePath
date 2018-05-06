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
    PrintAll(unpack(self.area:queryCircleArea(400, 300, 100, {'Rectangle'})))
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
end