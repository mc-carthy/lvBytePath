HasteArea = GameObject:extend()

function HasteArea:new(area, x, y, opts)
    HasteArea.super.new(self, area, x, y, opts)
end

function HasteArea:update(dt)
    HasteArea.super.update(self, dt)

    local player = currentRoom.player
    if not player then return end
    local d = Distance({ x = self.x, y = self.y }, { x = player.x, y = player.y })
    if d < self.r and not player.insideHasteArea then
        player:enterHasteArea()
    elseif d >= self.r and player.insideHasteArea then
    	player:exitHasteArea()
    end
end

function HasteArea:draw()
    love.graphics.setColor(ammoColour)
    love.graphics.circle('line', self.x, self.y, self.r + Random(-2, 2))
    love.graphics.setColor(defaultColour)
end