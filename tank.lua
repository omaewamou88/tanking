ACC = 100
TRT = 1
VLL = 250

function newTank(color, px, py)
    local red
    local green
    local ks
    
    if color == "blue" then
        red = 0
        green = 1
        ks = {'w', 's', 'a', 'd', 'x', 'q', 'e'}
    elseif color == "red" then
        red = 1
        green = 0
        ks = {'i', 'k', 'j', 'l', ',', 'u', 'o'}
    end

    return {
        x = px,
        y = py,
        angle = 0,
        turretAngle = 0,
        red = red,
        green = green,
        keyset = ks,
        hull = newPolygon({-25, -50, 25, -50, 25, 50, -25, 50}, px, py),
        turret = newPolygon({-15, -20, 15, -20, 15, 20, -15, 20}, px, py),
        cannon = newPolygon({-5, -20, 5, -20, 5, -70, -5, -70}, px, py),
        velocity = 0,
        update = function(self, dt)
            if love.keyboard.isDown(self.keyset[1]) then
                self.velocity = self.velocity + ACC*dt
            end
            if love.keyboard.isDown(self.keyset[2]) then
                self.velocity = self.velocity - ACC*dt
            end
            if love.keyboard.isDown(self.keyset[3]) then
                self.angle = self.angle - TRT*dt
            end
            if love.keyboard.isDown(self.keyset[4]) then
                self.angle = self.angle + TRT*dt
            end
            if love.keyboard.isDown(self.keyset[5]) then
                
            end
            if love.keyboard.isDown(self.keyset[6]) then
                self.turretAngle = self.turretAngle - TRT*dt
            end
            if love.keyboard.isDown(self.keyset[7]) then
                self.turretAngle = self.turretAngle + TRT*dt
            end
            self.x = self.x + math.sin(self.angle) * dt * self.velocity
            self.y = self.y - math.cos(self.angle) * dt * self.velocity
            self.velocity = self.velocity - self.velocity*0.4*dt
            if self.velocity > VLL then
                self.velocity = VLL
            end
            self.hull.x = self.x
            self.hull.y = self.y
            self.hull.angle = self.angle
            self.hull:refresh()
            self.turret.x = self.x
            self.turret.y = self.y
            self.turret.angle = self.turretAngle
            self.turret:refresh()
            self.cannon.x = self.x
            self.cannon.y = self.y
            self.cannon.angle = self.turretAngle
            self.cannon:refresh()
        end,
        draw = function(self)
            love.graphics.setColor(self.red, self.green, 1, 1)
            self.hull:draw()
            self.turret:draw()
            self.cannon:draw()
        end
    }
end