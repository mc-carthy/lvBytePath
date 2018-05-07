function UUID()
    local fn = function(x)
        local r = love.math.random(16) - 1
        r = (x == "x") and (r + 1) or (r % 4) + 9
        return ("0123456789abcdef"):sub(r, r)
    end
    return (("xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx"):gsub("[xy]", fn))
end

function Random(a, b)
    b = b or 0
    local min, max = a, b
    if a ~= b then
        if a > b then
            max, min = min, max
        end
        return love.math.random() * (max - min) + min
    else
        return a
    end
end

function Distance(a, b)
    return math.sqrt(math.pow(a.x - b.x, 2) + math.pow(a.y - b.y, 2))
end

function PrintAll(...)
    local args = {...}
    for k, v in pairs(args) do
        print(v)
    end
end

function PrintText(...)
    local args = {...}
    local str = ''
    for k, v in pairs(args) do
        str = str .. v
    end
    print(str)
end

function PushRotate(x, y, r, sx, sy)
    love.graphics.push()
    love.graphics.translate(x, y)
    love.graphics.rotate(r or 0)
    love.graphics.scale(sx or 1, sy or sx or 1)
    love.graphics.translate(-x, -y)
end

function RandomFromTable(t)
    return t[love.math.random(1, #t)]
end

function AreRectanglesOverlapping(a, b)
    return not (
        a.x + a.w < b.x or
        a.x > b.x + b.w or
        a.y + a.h < b.y or
        a.y > b.y + b.h
    )
end