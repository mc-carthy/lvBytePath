-- require('src.utils.debug')
Object = require('src.lib.classic')
Input = require('src.lib.input')
Timer = require('src.lib.timer')

function love.load()
    local objectFiles = {}
    recursiveEnumerate('src/objects', objectFiles)
    requireFiles(objectFiles)
    input = Input()
    timer = Timer.new()
    timer:every(1, function() print(love.math.random()) end, 5)
    circle = { radius = 24 }
    timer:after(2, function()
        timer:tween(6, circle, {radius = 96}, 'in-out-cubic', function()
            timer:tween(2, circle, {radius = 24}, 'in-out-cubic')
        end)
    end)    
    hyperCircle = HyperCircle(400, 300, 50, 10, 120)
end

function love.update(dt)
    timer:update(dt)
end

function love.draw()
    -- hyperCircle:draw()
    love.graphics.circle('fill', love.graphics.getWidth() / 2, love.graphics.getHeight() / 2, circle.radius, 32)
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
end

function recursiveEnumerate(folder, fileList)
    local items = love.filesystem.getDirectoryItems(folder)
    for _, item in pairs(items) do
        local file = folder .. '/' .. item
        if love.filesystem.isFile(file) then
            table.insert(fileList, file)
        elseif love.filesystem.isDirectory(file) then
            recursiveEnumerate(file, fileList)
        end
    end
end

function requireFiles(files)
    for _, file in pairs(files) do
        local file = file:sub(1, -5)
        require(file)
         
        -- local last_forward_slash_index = file:find("/[^/]*$")
        -- local class_name = file:sub(last_forward_slash_index+1, #file)
        -- _G[class_name] = require(file)
    end
end