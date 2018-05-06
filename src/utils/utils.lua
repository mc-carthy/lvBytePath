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