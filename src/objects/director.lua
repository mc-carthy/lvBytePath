Director = Object:extend()

function Director:new(stage)
    self.stage = stage
    self.timer = Timer()
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
    self.enemySpawnChance = {
        [1] = ChanceList({ 'Rock', 1 }),
        [2] = ChanceList({ 'Rock', 1 }),
        [3] = ChanceList({ 'Rock', 1 }),
        [4] = ChanceList({ 'Rock', 1 }),
        -- [2] = ChanceList({ 'Rock', 8 }, { 'Shooter', 4 }),
        -- [3] = ChanceList({ 'Rock', 8 }, { 'Shooter', 8 }),
        -- [4] = ChanceList({ 'Rock', 4 }, { 'Shooter', 8 }),
    }
    for i = 5, 1024 do
        self.enemySpawnChance[i] = ChanceList(
      	    { 'Rock', love.math.random(2, 12) }
      	    -- { 'Shooter', love.math.random(2, 12) }
    	)
    end

    self:setEnemySpawnForThisRound()
    self.stage.area:addGameObject('Attack', Random(0, gw), Random(0, gh)) 
end

function Director:setEnemySpawnForThisRound()
    local points = self.difficultyToPoints[self.difficulty]

    local enemyList = {}
    while points > 0 do
        local enemy = self.enemySpawnChance[self.difficulty]:next()
        points = points - self.enemyToPoints[enemy]
        table.insert(enemyList, enemy)
    end

    local enemySpawnTime = {}
    for i = 1, #enemyList do
        enemySpawnTime[i] = Random(0, self.roundTime)
    end
    table.sort(enemySpawnTime, function(a, b) return a < b end)

    for i = 1, #enemyList do
        self.timer:after(enemySpawnTime[i], function() 
            self.stage.area:addGameObject(enemyList[i])
        end)
    end
end

function Director:update(dt)
    self.timer:update(dt)
    self.roundTimer = self.roundTimer + dt
    if self.roundTimer > self.roundTime then
        self.difficulty = self.difficulty + 1
        self.roundTimer = 0
        self:setEnemySpawnForThisRound()
    end
end