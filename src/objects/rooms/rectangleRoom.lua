RectangleRoom = Object:extend()

function RectangleRoom:new()

end

function RectangleRoom:update(dt)

end

function RectangleRoom:draw()
    love.graphics.rectangle('fill', love.graphics.getWidth() / 2 - 200, love.graphics.getHeight() / 2 - 100, 400, 200)
end