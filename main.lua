-- require('src.utils.debug')
Object = require('src.lib.classic')
Input = require('src.lib.input')
Timer = require('src.lib.enhancedTimer')
Tbl = require('src.lib.moses')
Camera = require('src.lib.camera')
Physics = require('src.lib.windfield')
Vector = require('src.lib.vector')
Draft = require('src.lib.draft')()

require('src.lib.utf8')
require('src.utils.utils')
require('src.utils.globals')

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')
    love.graphics.setLineStyle('rough')
    love.window.setMode(gw * sx, gh * sy)
    input = Input()
    input:bind('left', 'left')
    input:bind('right', 'right')
    input:bind('up', 'up')
    input:bind('down', 'down')
    camera = Camera()
    timer = Timer()
    slowAmount = 1
    flashFrames = nil
    local objectFiles = {}
    local roomFiles = {}
    loadFonts('src/assets/fonts')
    recursiveEnumerate('src/objects', objectFiles)
    recursiveEnumerate('src/rooms', roomFiles)
    recursiveEnumerate('src/assets/fonts', fonts)
    requireFiles(objectFiles)
    requireFiles(roomFiles)
    gotoRoom('Stage')
    input:bind('m', function()
        print("Before collection: " .. collectgarbage("count")/1024)
        collectgarbage()
        print("After collection: " .. collectgarbage("count")/1024)
        print("Object count: ")
        local counts = typeCount()
        for k, v in pairs(counts) do print(k, v) end
        print("-------------------------------------")
    end)
    -- input:bind('n', function()
    --     gotoRoom('Stage')
    -- end)
    sp = 0
end
    
function love.update(dt)
    timer:update(dt * slowAmount)
    camera:update(dt * slowAmount)
    if currentRoom and currentRoom.update then
        currentRoom:update(dt * slowAmount)
    end
end

function love.draw()
    if currentRoom and currentRoom.draw then
        currentRoom:draw()
    end
    if flashFrames then 
        flashFrames = flashFrames - 1
        if flashFrames == -1 then flashFrames = nil end
    end
    if flashFrames then
        love.graphics.setColor(backgroundColour)
        love.graphics.rectangle('fill', 0, 0, sx*gw, sy*gh)
        love.graphics.setColor(255, 255, 255)
    end
end

function gotoRoom(roomType, ...)
    if currentRoom and currentRoom.destroy then currentRoom:destroy() end
    currentRoom = nil
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

function slow(amount, duration)
    slowAmount = amount
    timer:tween('slow', duration, _G, {slowAmount = 1}, 'in-out-cubic')
end

function flash(frames)
    flashFrames = frames
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

function loadFonts(path)
    fonts = {}
    local fontPaths = {}
    recursiveEnumerate(path, fontPaths)
    for i = 8, 16, 1 do
        for _, fontPath in pairs(fontPaths) do
            local lastForwardSlashIndex = fontPath:find("/[^/]*$")
            local fontName = fontPath:sub(lastForwardSlashIndex+1, -5)
            local font = love.graphics.newFont(fontPath, i)
            font:setFilter('nearest', 'nearest')
            fonts[fontName .. '_' .. i] = font
        end
    end
end

---------------------------------
------- Memory management -------
---------------------------------

function countAll(f)
    local seen = {}
    local countTable
    countTable = function(t)
        if seen[t] then return end
        f(t)
	    seen[t] = true
	    for k,v in pairs(t) do
	        if type(v) == "table" then
		        countTable(v)
	        elseif type(v) == "userdata" then
		        f(v)
	        end
	    end
    end
    countTable(_G)
end

function typeCount()
    local counts = {}
    local enumerate = function (o)
        local t = typeName(o)
        counts[t] = (counts[t] or 0) + 1
    end
    countAll(enumerate)
    return counts
end

globalTypeTable = nil
function typeName(o)
    if globalTypeTable == nil then
        globalTypeTable = {}
        for k,v in pairs(_G) do
	        globalTypeTable[v] = k
	    end
	globalTypeTable[0] = "table"
    end
    return globalTypeTable[getmetatable(o) or 0] or "Unknown"
end