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
    for i = 1, 10 do
        timer:after(0.5 * i, function() 
            print(love.math.random())
        end)
    end
    hyperCircle = HyperCircle(400, 300, 50, 10, 120)
end

function love.update(dt)
    timer:update(dt)
end

function love.draw()
    -- hyperCircle:draw()
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