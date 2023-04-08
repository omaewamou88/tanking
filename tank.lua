function setVertices(vertices, positions, x, y, r, a)
    for i, p in pairs(positions) do
        table.insert(vertices, x + r * math.sin(a+math.rad(p)))
        table.insert(vertices, y - r * math.cos(a+math.rad(p)))
    end
end

function newTank(colour)
    colour = colour or "blue"
    return {
        transform = {
            x = 500,
            y = 500,
            r = 50,
            a = 0
        },
        movement = {
            x = 0,
            y = 0
        },
        acceleration = {
            x = 0,
            y = 0
        },
        update = function(self, dt)
            if love.keyboard.isDown('q') then
                self.transform.a = self.transform.a - 1 * dt
            elseif love.keyboard.isDown('e') then
                self.transform.a = self.transform.a + 1 * dt
            end

            if love.keyboard.isDown('w') then
                self.acceleration.x = 100 * math.sin(self.transform.a)
                self.acceleration.y = 100 * -math.cos(self.transform.a)
            elseif love.keyboard.isDown('s') then
                self.acceleration.x = 100 * -math.sin(self.transform.a)
                self.acceleration.y = 100 * math.cos(self.transform.a)
            else
                self.acceleration.x = 0
                self.acceleration.y = 0
            end

            self.movement.x = self.movement.x + self.acceleration.x*dt
            self.movement.y = self.movement.y + self.acceleration.y*dt
            self.transform.x = self.transform.x + self.movement.x*dt
            self.transform.y = self.transform.y + self.movement.y*dt
        end,
        draw = function(self)
            local vertices = {}
            local positions = {330, 30, 150, 210}
            setVertices(vertices, positions, self.transform.x, self.transform.y, self.transform.r, self.transform.a)
            love.graphics.setColor(0, 1, 1, 1)
            love.graphics.polygon("line", vertices)
        end
    }
end