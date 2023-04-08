--TANKING 0.0.1
require "tank"

function love.load()
    tank = newTank("blue")
    offset = {x = 0, y = 0}
    angle = math.rad(90)
end

function love.update(dt)
    tank:update(dt)
end

function love.draw()
    tank:draw()
end