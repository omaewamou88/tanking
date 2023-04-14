--TANKING 0.1
require "lib"
require "tank"

function love.load()
    blue = newTank("blue", 100, 100)
    red = newTank("red", 700, 700)
end

function love.update(dt)
    blue:update(dt)
    if sat(blue.hull, red.hull) then
        blue.velocity = blue.velocity - blue.velocity*0.5*dt
    end
    blue.x = blue.hull.x
    blue.y = blue.hull.y

    red:update(dt)
    if sat(red.hull, blue.hull) then
        red.velocity = red.velocity - red.velocity*0.5*dt
    end
    red.x = red.hull.x
    red.y = red.hull.y
end

function love.draw()
    blue:draw()
    red:draw()
end