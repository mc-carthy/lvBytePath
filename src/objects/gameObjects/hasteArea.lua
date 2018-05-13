HasteArea = GameObject:extend()

function HasteArea:new(area, x, y, opts)
    HasteArea.super.new(self, area, x, y, opts)

    self.r = opts.r or Random(64, 96)
    self.timer:after(4, function()
        self.timer:tween(0.25, self, { r = 0 }, 'in-out-cubic', function() self.dead = true end)
    end)
end

function HasteArea:update(dt)
    HasteArea.super.update(self, dt)

    local player = currentRoom.player
    if not player then return end
    local d = Distance({ x = self.x, y = self.y }, { x = player.x, y = player.y })
    player.insideHasteArea = d < self.r and true or false
end

function HasteArea:draw()
    love.graphics.setColor(ammoColour)
    love.graphics.circle('line', self.x, self.y, self.r + Random(-2, 2))
    love.graphics.setColor(defaultColour)
end