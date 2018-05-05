PolygonRoom = Object:extend()

function PolygonRoom:new()

end

function PolygonRoom:update(dt)

end

function PolygonRoom:draw()
    local vertices = { 300, 300, 400, 300, 350, 400 }
    love.graphics.polygon('fill', vertices)
end