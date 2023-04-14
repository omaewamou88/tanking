function genVertices(positions, centerX, centerY, ao)
    local vertices = {}
    local x = 0
    local y = 0
    local a = 0
    local l = 0
    for i, v in pairs(positions) do
        if i%2==1 then
            x = v
        else
            y = v
            a = atf(x, y)
            l = math.sqrt(x*x+y*y)
            table.insert(vertices, centerX+math.sin(a+ao)*l)
            table.insert(vertices, centerY-math.cos(a+ao)*l)
        end
    end

    return vertices
end

function atf(x, y)
    local tan = 0
    if x > 0 and y < 0 then
        tan = math.atan(x/y)
        tan = math.abs(tan)
    elseif x > 0 and y > 0 then
        tan = math.atan(y/x)
        tan = math.abs(tan)
        tan = tan + math.rad(90)
    elseif x < 0 and y > 0 then
        tan = math.atan(x/y)
        tan = math.abs(tan)
        tan = tan + math.rad(180)
    elseif x < 0 and y < 0 then
        tan = math.atan(y/x)
        tan = math.abs(tan)
        tan = tan + math.rad(270)
    elseif x == 0 then
        if y <= 0 then
            tan = 0
        else
            tan = math.rad(180)
        end
    elseif y == 0 then
        if x < 0 then
            tan = math.rad(270)
        else
            tan = math.rad(90)
        end
    end

    return tan
end

function newPolygon(positions, x, y)
    return {
        positions = positions,
        x = x,
        y = y,
        angle = 0,
        vertices = genVertices(positions, x, y, 0),
        refresh = function(self)
            self.vertices = genVertices(self.positions, self.x, self.y, self.angle)
        end,
        draw = function(self)
            love.graphics.polygon("line", self.vertices)
        end
    }
end

function sat(r1, r2)
    local p1 = r1
    local p2 = r2
    local overlap = 1000000 --[[STATIC]]
    for shape = 1, 2 do
        if shape == 2 then
            p1 = r2
            p2 = r1
        end

        for a = 1, table.getn(p1.vertices)/2 do
            local b = a + 1
            if b > table.getn(p1.vertices)/2 then
                b = 1
            end

            local axisProj = {x = -(p1.vertices[b*2] - p1.vertices[a*2]), y = p1.vertices[b*2-1] - p1.vertices[a*2-1]}
            local d = math.sqrt(axisProj.x*axisProj.x+axisProj.y*axisProj.y)
            axisProj.x = axisProj.x / d
            axisProj.y = axisProj.y / d

            local minR1 = 1000000
            local maxR1 = -1000000
            for p = 1, table.getn(p1.vertices)/2 do
                local q = p1.vertices[p*2-1] * axisProj.x + p1.vertices[p*2] * axisProj.y
                minR1 = math.min(minR1, q)
                maxR1 = math.max(maxR1, q)
            end

            local minR2 = 1000000
            local maxR2 = -1000000
            for p = 1, table.getn(p2.vertices)/2 do
                local q = p2.vertices[p*2-1] * axisProj.x + p2.vertices[p*2] * axisProj.y
                minR2 = math.min(minR2, q)
                maxR2 = math.max(maxR2, q)
            end

            overlap = math.min(math.min(maxR1, maxR2) - math.max(minR1, minR2), overlap) --[[STATIC]]

            if not (maxR2 >= minR1 and maxR1 >= minR2) then
                return false
            end
        end
    end

    local d = {x = r2.x - r1.x, y = r2.y - r1.y}
    local s = math.sqrt(d.x*d.x+d.y*d.y)
    r1.x = r1.x - overlap * d.x / s
    r1.y = r1.y - overlap * d.y / s
    return true
end

function direction(a, b, c)
    v = (b.y-a.y)*(c.x-b.x)-(b.x-a.x)*(c.y-b.y)
    if v == 0 then
        return 0
    elseif v < 0 then
        return 2
    else
        return 1
    end
end

function isOnLine(p1, p2, p3)
    if p3.x <= math.max(p1.x, p2.x)
    and p3.x >= math.min(p1.x, p2.x)
    and p3.y <= math.max(p1.y, p2.y)
    and p3.y >= math.min(p1.y, p2.y) 
    then
        return true
    else
        return false
    end
end

function lineIntersection(p1, p2, p3, p4)
    local d1 = direction(p1, p2, p3)
    local d2 = direction(p1, p2, p4)
    local d3 = direction(p3, p4, p1)
    local d4 = direction(p3, p4, p2)
    if (not (d1 == d2)) and (not (d3 == d4)) then
        return true
    end
    if d1 == 0 and isOnLine(p1, p2, p3) then
        return true
    end
    if d2 == 0 and isOnLine(p1, p2, p4) then
        return true
    end
    if d3 == 0 and isOnLine(p3, p4, p1) then
        return true
    end
    if d4 == 0 and isOnLine(p3, p4, p2) then
        return true
    end
    return false
end

function pointPolygonIntersection(polygon, point)
    local n = table.getn(polygon.vertices)/2
    local e1 = point
    local e2 = {x = 10000, y = point.y}
    local count = 0
    local i = 1
    local h = 2
    repeat
        s1 = {x = polygon.vertices[i*2-1], y = polygon.vertices[i*2]}
        h = i + 1
        if h > n then
            h = 1
        end
        s2 = {x = polygon.vertices[h*2-1], y = polygon.vertices[h*2]}

        if lineIntersection(e1, e2, s1, s2) then
            if direction(s1, point, s2) == 0 then
                print("sth")
                return isOnLine(s1, s2, point)
            end
            count = count + 1
        end

        i = i + 1
        if i > n then
            i = 1
        end
    until i == 1

    if count%2 == 1 then
        return true
    else
        return false
    end
end