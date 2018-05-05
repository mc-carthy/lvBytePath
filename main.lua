-- require('src.utils.debug')
Object = require('src.lib.classic')
Input = require('src.lib.input')
Timer = require('src.lib.timer')

local function reduceRectWidth(rect, time)
    local value = 40
    if rect.w > 0 then
        rect.w = rect.w - value
        timer:tween(time, rect, {drawW = rect.w}, 'in-out-cubic')
    end
end

function love.load()
    local objectFiles = {}
    recursiveEnumerate('src/objects', objectFiles)
    requireFiles(objectFiles)
    input = Input()
    timer = Timer()
    rect1 = { x = 300, y = 300, w = 200, h = 50, drawW = 200, colour = { 191, 63, 63 } }
    rect2 = { x = 300, y = 300, w = 200, h = 50, drawW = 200, colour = { 191, 0, 0 } }
    input:bind('space', 'damage')    
end
    
function love.update(dt)
    timer:update(dt)
    if input:pressed('damage') then
        reduceRectWidth(rect1, 1)
        reduceRectWidth(rect2, 2)
    end
    if rect1.drawW < rect1.w then
        rect1.drawW = rect1.w
    end
    if rect2.drawW < rect2.w then
        rect2.drawW = rect2.w
    end
end

function love.draw()
    love.graphics.setColor(rect2.colour)
    love.graphics.rectangle('fill', rect2.x, rect2.y - rect2.h / 2, rect2.drawW, rect2.h)
    love.graphics.setColor(rect1.colour)
    love.graphics.rectangle('fill', rect1.x, rect1.y - rect1.h / 2, rect1.drawW, rect1.h)
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.print('Rect1 w: ' .. rect1.w, 20, 10)
    love.graphics.print('Rect1 drawW: ' .. string.format("%.0f", rect1.drawW), 20, 30)
    love.graphics.print('Rect2 w: ' .. rect2.w, 20, 60)
    love.graphics.print('Rect1 drawW: ' .. string.format("%.0f", rect2.drawW), 20, 80)
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