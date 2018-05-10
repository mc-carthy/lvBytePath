Director = Objext:extend()

function Director:new(stage)
    self.stage = stage
    self.difficulty = 1
    self.roundTime = 22
    self.roundTimer = 0
    self.difficultyToPoints = {}
    self.difficultyToPoints[1] = 16
    for i = 2, 1024, 4 do
        self.difficultyToPoints[i] = self.difficultyToPoints[i - 1] + 8
        self.difficultyToPoints[i + 1] = self.difficultyToPoints[i]
        self.difficultyToPoints[i + 2] = math.floor(self.difficultyToPoints[i + 1] / 1.5)
        self.difficultyToPoints[i + 3] = math.floor(self.difficultyToPoints[i + 2] * 2)
    end
    self.enemyToPoints = {
        ['Rock'] = 1,
        ['Shooter'] = 2,
    }
end

function Director:update(dt)
    self.roundTimer = self.roundTimer + dt
    if self.roundTimer > self.roundTime then
        self.difficulty = self.difficulty + 1
        self.roundTimer = 0
        self:setEnemySpawnForThisRound()
    end
end