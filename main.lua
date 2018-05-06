-- require('src.utils.debug')
Object = require('src.lib.classic')
Input = require('src.lib.input')
Timer = require('src.lib.timer')
Tbl = require('src.lib.moses')
Camera = require('src.lib.camera')
require('src.utils.utils')

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')
    love.graphics.setLineStyle('rough')
    love.window.setMode(gw * sx, gh * sy)
    input = Input()
    camera = Camera()
    local objectFiles = {}
    local roomFiles = {}
    recursiveEnumerate('src/objects', objectFiles)
    recursiveEnumerate('src/rooms', roomFiles)
    requireFiles(objectFiles)
    requireFiles(roomFiles)
    gotoRoom('Stage')
    input:bind('s', function() camera:shake(4, 60, 1) end)
end
    
function love.update(dt)
    camera:update(dt)
    if currentRoom and currentRoom.update then
        currentRoom:update(dt)
    end
end

function love.draw()
    if currentRoom and currentRoom.draw then
        currentRoom:draw()
    end
end

function gotoRoom(roomType, ...)
    currentRoom = _G[roomType](...)
end

function resize(s)
    love.window.setMode(s*gw, s*gh) 
    sx, sy = s, s
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
    end
end