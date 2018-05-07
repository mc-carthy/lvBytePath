HealthEffect = GameObject:extend()

function HealthEffect:new(area, x, y, opts)
    HealthEffect.super.new(self, area, x, y, opts)
    self.depth = 75

    self.w = 1.5 * self.w
    self.h = self.w

    self.currentColour = defaultColour
    self.timer:after(0.2, function() 
        self.currentColour = self.colour 
        self.timer:after(0.35, function()
            self.dead = true
        end)
    end)

    self.visible = true
    self.timer:after(0.2, function()
        self.timer:every(0.05, function() self.visible = not self.visible end, 6)
        self.timer:after(0.35, function() self.visible = true end)
    end)

    self.sx, self.sy = 1, 1
    self.timer:tween(0.35, self, { sx = 2, sy = 2 }, 'in-out-cubic')
end

function HealthEffect:update(dt)
    HealthEffect.super.update(self, dt)
end

function HealthEffect:draw()
    if not self.visible then return end

    love.graphics.setColor(self.currentColour)
    Draft:rhombus(self.x, self.y, 1.34 * self.w, 1.34 * self.h, 'fill')
    Draft:rhombus(self.x, self.y, 2 * self.w * self.sx, 2 * self.h * self.sy, 'line')
    love.graphics.setColor(defaultColour)
end

function HealthEffect:destroy()
    HealthEffect.super.destroy(self)
end