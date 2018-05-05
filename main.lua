-- require('src.utils.debug')
Object = require('src.lib.classic')
Input = require('src.lib.input')
Timer = require('src.lib.timer')

function love.load()
    local objectFiles = {}
    recursiveEnumerate('src/objects', objectFiles)
    requireFiles(objectFiles)
    input = Input()
    timer = Timer()
    rect1 = { x = 400, y = 300, w = 50, h = 200 }
    rect2 = { x = 400, y = 300, w = 200, h = 50 }
    timer:tween(1, rect1, { w = 0 }, 'in-out-cubic')
    timer:after(1, function() 
        timer:tween(1, rect2, { h = 0 }, 'in-out-cubic')
        timer:after(2, function()
            timer:tween(2, rect1, { w = 50 }, 'in-out-cubic')
            timer:tween(2, rect2, { h = 50 }, 'in-out-cubic')
        end)
    end)
    end
    
function love.update(dt)
    timer:update(dt)
end

function love.draw()
    love.graphics.rectangle('fill', rect1.x - rect1.w / 2, rect1.y - rect1.h / 2, rect1.w, rect1.h)
    love.graphics.rectangle('fill', rect2.x - rect2.w / 2, rect2.y - rect2.h / 2, rect2.w, rect2.h)
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