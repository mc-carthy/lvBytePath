Area = Object:extend()

function Area:new(room)
    self.room = room
    self.gameObjects = {}
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
    local minDist = nil
    local closest = nil
    for _, v in pairs(objects) do
        if closest == nil then
            closest = v
            local a = {x = x, y = y}
            minDist = Distance(a, v)
        elseif Distance(closest, v) < minDist then
            closest = v
            local a = {x = x, y = y}
            minDist = Distance(a, v)
        end
    end
    return closest
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