GameObject = Object:extend()

function GameObject:new(area, x, y, opts)
    local opts = opts
    if opts then 
        for k, v in pairs(opts) do 
            self[k] = v
        end 
    end

    self.creationTime = love.timer.getTime()
    self.area = area
    self.x, self.y = x or 0, y or 0
    self.id = UUID()
    self.dead = false
    self.timer = Timer()
    self.depth = 50
end

function GameObject:update(dt)
    if self.timer then self.timer:update(dt) end
    if self.collider then self.x, self.y = self.collider:getPosition() end
end

function GameObject:draw()

end

function GameObject:destroy()
    self.timer = nil
    if self.collider then self.collider:destroy() end
    self.collider = nil
end