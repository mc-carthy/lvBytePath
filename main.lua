-- require('src.utils.debug')
Object = require('src.lib.classic')
Input = require('src.lib.input')
Timer = require('src.lib.timer')
Tbl = require('src.lib.moses')

function love.load()
    local objectFiles = {}
    recursiveEnumerate('src/objects', objectFiles)
    requireFiles(objectFiles)
    currentRoom = CircleRoom()
end
    
function love.update(dt)
    currentRoom:update(dt)
end

function love.draw()
    currentRoom:draw()
end

function love.keypressed(key)
    if key == '1' then
        currentRoom = CircleRoom()
    elseif key == '2' then
        currentRoom = RectangleRoom()
    elseif key == '3' then
        currentRoom = PolygonRoom()
    end
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
    end
end