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
        projectiles = {},
        pt = 0.0,
        hp = 10,
        update = function(self, dt, another)
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
                if self.pt > 2 then
                    table.insert(self.projectiles, 
                    newProjectile(self.x + math.sin(self.turretAngle)*70, self.y - math.cos(self.turretAngle)*70, self.turretAngle))
                    self.pt = 0.0
                end
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

            for i, v in pairs(self.projectiles) do
                v:move(dt)
                if v:check(another) then
                    table.remove(self.projectiles, i)
                    another.hp = another.hp - 1
                end
            end

            self.pt = self.pt + dt
        end,
        draw = function(self)
            if self.hp == 0 then
                love.event.quit()
                return 'dead'
            end
            love.graphics.setColor(self.red, self.green, 1, 1)
            self.hull:draw()
            self.turret:draw()
            self.cannon:draw()
            for i, v in pairs(self.projectiles) do
                v:draw()
            end
            love.graphics.rectangle("line", self.x - 60, self.y + 50, 100, 5)
            love.graphics.rectangle("fill", self.x - 60, self.y + 50, 10*self.hp, 5)
        end
    }
end