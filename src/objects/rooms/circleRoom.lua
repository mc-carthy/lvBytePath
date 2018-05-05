CircleRoom = Object:extend()

function CircleRoom:new()

end

function CircleRoom:update(dt)

end

function CircleRoom:draw()
    love.graphics.circle('fill', love.graphics.getWidth() / 2, love.graphics.getHeight() / 2, 100, 64)
end