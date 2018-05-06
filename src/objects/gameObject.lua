GameObject = Object:extend()

function GameObject:new(area, x, y, opts)
    local opts = opts
    if opts then
        for k, v in pairs(opts) do
            self.k = v
        end
    end

    self.area = area
    self.x, self.y = x or 0, y or 0
    self.id = UUID()
    self.dead = false
    self.timer = Timer()
end

function GameObject:update(dt)
    if self.timer then self.timer:update(dt) end
end

function GameObject:draw()

end