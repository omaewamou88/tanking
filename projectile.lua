PVL = 500
PRR = 3

function newProjectile(x, y, a)
    return {
        x = x,
        y = y,
        a = a,
        vvx = math.sin(a)*PVL,
        vvy = -math.cos(a)*PVL,
        move = function(self, dt)
            self.x = self.x + self.vvx*dt
            self.y = self.y + self.vvy*dt
        end,
        draw = function(self)
            love.graphics.circle("fill", self.x, self.y, PRR)
        end,
        check = function(self, another)
            return pointPolygonIntersection(another.hull, {x = self.x, y = self.y})
        end
    }
end