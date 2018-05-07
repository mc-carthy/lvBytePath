Player = GameObject:extend()

function Player:new(area, x, y, opts)
    Player.super.new(self, area, x, y, opts)
    self.x, self.y = x, y
    self.w, self.h = 12, 12
    self.collider = self.area.world:newCircleCollider(self.x, self.y, self.w)
    self.collider:setObject(self)
    self.collider:applyAngularImpulse(5000)

    self.r = -math.pi / 2
    self.rv = 1.66*math.pi
    self.v = 0
    self.max_v = 100
    self.a = 100

    self.attack_speed = 1
    self.timer:every(5, function() self.attack_speed = Random(1, 2) end)
    self.timer:after(0.24 / self.attack_speed, function(f)
        self:shoot()
        self.timer:after(0.24 / self.attack_speed, f)
    end)
end

function Player:shoot()
    local d = 1.2 * self.w
    self.area:addGameObject(
        'ShootEffect', 
        self.x + d * math.cos(self.r), 
        self.y + d * math.sin(self.r),
        { player = self, d = d }
    )
end

function Player:update(dt)
    Player.super.update(self, dt)
    if input:down('left') then self.r = self.r - self.rv * dt end
    if input:down('right') then self.r = self.r + self.rv * dt end

    self.v = math.min(self.v + self.a * dt, self.max_v)
    self.collider:setLinearVelocity(self.v * math.cos(self.r), self.v * math.sin(self.r))
end

function Player:draw()
    -- PushRotate(self.x, self.y, math.pi)
    love.graphics.circle('line', self.x, self.y, self.w)
    -- PushRotate(self.x + self.w * math.cos(self.r), self.y + self.w * math.sin(self.r), math.pi / 2)
    -- PushRotate(self.x, self.y, math.pi / 2)
    love.graphics.line(self.x, self.y, self.x + 2*self.w*math.cos(self.r), self.y + 2*self.w*math.sin(self.r))
    -- love.graphics.pop()
end