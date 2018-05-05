-- require('src.utils.debug')
Object = require('src.lib.classic')
Input = require('src.lib.input')
Timer = require('src.lib.timer')
tbl = require('src.lib.moses')

function love.load()
    local objectFiles = {}
    recursiveEnumerate('src/objects', objectFiles)
    requireFiles(objectFiles)
    a = {1, 2, '3', 4, '5', 6, 7, true, 9, 10, 11, a = 1, b = 2, c = 3, {1, 2, 3}}
    b = {1, 1, 3, 4, 5, 6, 7, false}
    c = {'1', '2', '3', 4, 5, 6}
    d = {1, 4, 3, 4, 5, 6}


    -- tbl.each(a, print)
    
    -- print(tbl.count(b, 1))
    
    -- d = tbl.map(d, function(_, v) return v + 2 end)

    -- a = tbl.map(a, function(_, v)
    --     if type(v) == 'number' then
    --         return v * 2
    --     elseif type(v) == 'string' then
    --         return v .. 'xD'
    --     elseif type(v) == 'boolean' then
    --         return tostring(not v)
    --     elseif type(v) == 'table' then
    --         return nil
    --     end
    -- end)

    -- d = tbl.reduce(d, function(memo, v) return memo + v end)

    -- if tbl.any(b, 7) then
    --     print('Table b contains 7')
    -- end

    -- print(tbl.detect(d, 4))

    -- d = tbl.filter(d, function(_, v) return v < 5 end)

    -- c = tbl.filter(c, function(_, v) if type(v) == 'string' then return v end end)

    -- print(tbl.all(c, function(_, v) return type(v) == 'number' end))
    -- print(tbl.all(d, function(_, v) return type(v) == 'number' end))

    -- d = tbl.shuffle(d, os.time())

    -- d = tbl.reverse(d)

    -- d = tbl.pull(d, 1, 4)

    -- bcd = tbl.union(b, c, d)

    -- bd = tbl.intersection(b, d)

    -- bd = tbl.append(b, d)
end
    
function love.update(dt)

end

function love.draw()
    local i = 1
    for k, v in pairs(bd) do
        i = i + 1
        love.graphics.print(tostring(v), 10, i * 20)
    end
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