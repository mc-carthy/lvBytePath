AmmoEffect = GameObject:extend()

function AmmoEffect:new(area, x, y, opts)
    AmmoEffect.super.new(self, area, x, y, opts)
    self.depth = 75

    self.w = 1.5 * self.w
    self.h = self.w

    self.currentColour = defaultColour
    self.timer:after(0.1, function() 
        self.currentColour = self.colour 
        self.timer:after(0.15, function()
            self.dead = true
        end)
    end)
end

function AmmoEffect:update(dt)
    AmmoEffect.super.update(self, dt)
end

function AmmoEffect:draw()
    love.graphics.setColor(self.currentColour)
    Draft:rhombus(self.x, self.y, self.w, self.h, 'fill')
    love.graphics.setColor(defaultColour)
end

function AmmoEffect:destroy()
    ProjectileDeathEffect.super.destroy(self)
end