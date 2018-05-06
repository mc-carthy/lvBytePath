Area = Object:extend()

function Area:new(room)
    self.room = room
    self.gameObjects = {}
end

function Area:addGameObject(gameObjectType, x, y, opts)
    local opts = opts or {}
    local gameObject = _G[gameObjectType](self, x, y, opts)
    table.insert(self.gameObjects, gameObject)
    return gameObject
end

function Area:update(dt)
    for i = #self.gameObjects, 1, -1 do
        local object = self.gameObjects[i]
        if object.update then object:update(dt) end
        if object.dead then table.remove(self.gameObjects, i) end
    end
end

function Area:draw()
    for _, object in pairs(self.gameObjects) do
        if object.draw then object:draw() end
    end
end