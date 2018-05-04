-- require('src.utils.debug')
Object = require('src.lib.classic')
Input = require('src.lib.input')

function love.load()
    local objectFiles = {}
    recursiveEnumerate('src/objects', objectFiles)
    requireFiles(objectFiles)
    input = Input()
    input:bind('mouse1', 'test')
    input:bind('a', 'add')
    sum = 0
    hyperCircle = HyperCircle(400, 300, 50, 10, 120)
end

function love.update(dt)
    -- if input:pressed('test') then print('pressed') end
    -- if input:released('test') then print('released') end
    -- if input:down('test') then print('down') end
    if input:down('test', 0.5) then print('test event') end
    if input:down('add', 0.25) then
        sum = sum + 1
        print(sum)
    end
end

function love.draw()
    hyperCircle:draw()
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