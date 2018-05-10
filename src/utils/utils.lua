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

function ChanceList(...)
    return {
        chanceList = {},
        chanceDefinitions = {...},
        next = function(self)
            if #self.chanceList == 0 then
                for _, chanceDefinition in pairs(self.chanceDefinitions) do
                    for i = 1, chanceDefinition[2] do
                        table.insert(self.chanceList, chanceDefinition[1])
                    end
                end
            end
            return table.remove(self.chanceList, love.math.random(1, #self.chanceList))
        end
    }
end

function CreateIrregularPolygon(size, numPoints)
    local numPoints = numPoints or 8
    local points = {}
    for i = 1, numPoints do
        local angleInterval = 2 * math.pi / numPoints
        local distance = size + Random(-size / 4, size / 4)
        local angle = (i - 1) * angleInterval + Random(-angleInterval / 4, angleInterval / 4)
        table.insert(points, distance * math.cos(angle))
        table.insert(points, distance * math.sin(angle))
    end
    return points
end