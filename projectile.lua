PVL = 100
PRR = 5

function newProjectile(x, y, a)
    return {
        x = x,
        y = y,
        a = a,
        vvx = math.sin(a)*PVL,
        vvy = -math.cos(a)*PVL,
        move = function(self, dt)
            x = x + vvx*dt
            y = y + vvy*dt
        end,
        draw = function(self)
            love.graphics.circle("fill", self.x, self.y, PRR)
        end,
        check = function(self, blue, red)
            
        end
    }
end