Area = Object:extend()

function Area:new(room)
    self.room = room
    self.gameObjects = {}
end

function Area:addPhysicsWorld()
    self.world = Physics.newWorld(0, 100, true)
end

function Area:addGameObject(gameObjectType, x, y, opts)
    local opts = opts or {}
    local gameObject = _G[gameObjectType](self, x, y, opts)
    gameObject.class = gameObjectType
    table.insert(self.gameObjects, gameObject)
    return gameObject
end

function Area:getGameObjects(filter)
    local objects = {}
    for _, v in pairs(self.gameObjects) do
        if filter(v) == true then
            table.insert(objects, v)
        end
    end
    return objects
end

function Area:queryCircleArea(x, y, rad, targets)
    local objects = {}
    for _, v in pairs(self.gameObjects) do
        for _, target in pairs(targets) do
            if target ==  v.class then
                local a = {x = x, y = y}
                if Distance(a, v) < rad then
                    table.insert(objects, v)
                end
            end
        end
    end
    return objects
end

function Area:getClosestObject(x, y, rad, targets)
    local objects = self:queryCircleArea(x, y, rad, targets)
    table.sort(objects, function(a, b)
        local da = Distance({ x = x, y = y }, a)
        local db = Distance({ x = x, y = y }, b)
        return da < db
    end)
    return objects[1]
end

function Area:update(dt)
    if self.world then self.world:update(dt) end
    for i = #self.gameObjects, 1, -1 do
        local object = self.gameObjects[i]
        if object.update then object:update(dt) end
        if object.dead then
            object:destroy()
            table.remove(self.gameObjects, i) 
        end
    end
end

function Area:draw()
    if self.world then self.world:draw() end
    for _, object in pairs(self.gameObjects) do
        if object.draw then object:draw() end
    end
end

function Area:destroy()
    for i = #self.gameObjects, 1, -1 do
        local object = self.gameObjects[i]
        object:destroy()
        table.remove(self.gameObjects, i)
    end
    self.gameObjects = {}

    if self.world then
        self.world:destroy()
        self.world = nil
    end
end