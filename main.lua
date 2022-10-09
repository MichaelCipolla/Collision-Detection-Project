require 'math'

Class = require 'class'

require 'Box'

WINDOW_WIDTH = 1920 / 1.3
WINDOW_HEIGHT = 1080 / 1.3

function love.load () 
    -- love.graphics.setColor(79/255, 157/255, 202/255)
    love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)  
end

color = {
    ['R'] = 70/255,
    ['G'] =  205/255,
    ['B'] =  43/255
}
playerRectangle = Box(0,0,200,200, color)

color = {
    ['R'] = 255/255,
    ['G'] =  255/255,
    ['B'] =  0/255
}
obstacleRectangle = Box(1150,500,200,200, color)

speed = 400

-- Returns the distance between two points.
function math.mag(x1,y1, x2,y2) return ((x2-x1)^2+(y2-y1)^2)^0.5 end

function norm(v)
    vecNorm = {
        ['x'] = -v.y,
        ['y'] = v.x
    }
    return vecNorm
end

function magnitude(vector)
    return (vector.x^2 + vector.y^2)^0.5
end


function dot(v1, v2)
    return (v1.x * v2.x + v1.y * v2.y)
end

function project(v1, v2)
    magV2 = magnitude(v2)
    dotProd = dot(v1, v2)

    direction = {
        ['x'] = v2.x / magV2,
        ['y'] = v2.y / magV2,
    }
    direction.x = direction.x * (dotProd / magV2)
    direction.y = direction.y * (dotProd / magV2)
    return direction
end

function sub(v1, v2)
    newVect = {
        ['x'] = v1.x - v2.x,
        ['y'] = v1.y - v2.y
    }
    return newVect
end

function determineCollision(rect1, rect2)
    collision = true
    for i = 0, 7 do
        vNorm = ''

        if i < 4 then
            vNorm = norm(rect1['side' .. (i)])
            
        else
            vNorm = norm(rect2['side' .. (i - 4)])
        end
            
        cNorm = 'side' .. i

        maxMag1 = -1
        maxMag2 = -1
        
        minMag1 = 100000
        minMag2 = 100000

        maxProj1 = ''
        maxProj2 = ''

        minProj1 = ''
        minProj2 = ''
        for j = 1, 4 do
            vProj1 = project(rect1['v' .. j], vNorm)
            vProj2 = project(rect2['v' .. j], vNorm)

            vMag1 = magnitude(vProj1)
            vMag2 = magnitude(vProj2)

            if vMag1 > maxMag1 then
                maxMag1 = vMag1
                maxProj1 = vProj1
            end

            if vMag1 < minMag1 then
                minMag1 = vMag1
                minProj1 = vProj1
            end

            if vMag2 > maxMag2 then
                maxMag2 = vMag2
                maxProj2 = vProj2
            end

            if vMag2 < minMag2 then
                minMag2 = vMag2
                minProj2 = vProj2
            end
        end

        if (magnitude(maxProj2) < magnitude(minProj1)) or (magnitude(maxProj1) < magnitude(minProj2)) then
            collision = false
        end
    end
    if collision == true then
        rect1.color.R = 1
        rect1.color.G = 0
        rect1.color.B = 0
    else
        rect1.color.R = 0
        rect1.color.G = 1
        rect1.color.B = 0
    end
end

function announceCornerCoordinates(element)
    love.graphics.setColor(0, 1, 0, 1)
    love.graphics.print('Top Left: x:' .. tostring(element.x) .. '\ty: ' .. tostring(element.y), 950, 10)
    love.graphics.print('Top Right: x:' .. tostring(element.v2.x) .. '\ty: ' .. tostring(element.v2.y), 1300, 10)
    love.graphics.print('Bot Left: x:' .. tostring(element.v4.x) .. '\ty: ' .. tostring(element.v4.y), 950, 50)
    love.graphics.print('Bot Right: x:' .. tostring(element.v3.x) .. '\ty: ' .. tostring(element.v3.y), 1300, 50)
    love.graphics.print('Angle: ' .. tostring(element.angle), 1300, 100)
end

function love.draw() 
    love.graphics.clear(40/255, 45/255, 52/255, 255/255)
    -- love.graphics.setColor(70/255, 205/255, 43/255)
    -- drawRotatedRectangle('fill', playerRectangle.x, playerRectangle.y, playerRectangle.width, playerRectangle.height, playerRectangle.angle)
    -- love.graphics.setColor(255/255, 255/255, 0/255)
    -- drawRotatedRectangle('fill', obstacleRectangle.x, obstacleRectangle.y, obstacleRectangle.width, obstacleRectangle.height, obstacleRectangle.angle)

    playerRectangle:render()
    obstacleRectangle:render()
    announceCornerCoordinates(playerRectangle)
end

function love.keypressed(key)
    -- `key` will be whatever key this callback detected as pressed
    if key == 'escape' then
        -- the function LÖVE2D uses to quit the application
        love.event.quit()
    end
end

function love.update(dt)
    if love.keyboard.isDown('w') then
        playerRectangle.y = playerRectangle.y - speed * dt
    elseif love.keyboard.isDown('s') then
        playerRectangle.y = playerRectangle.y + speed * dt
    end
    
    if love.keyboard.isDown('a') then
        playerRectangle.x = playerRectangle.x - speed * dt
    elseif love.keyboard.isDown('d') then
        playerRectangle.x = playerRectangle.x + speed * dt
    end
    
    if love.keyboard.isDown('q') then
        playerRectangle.angle = playerRectangle.angle - 1 * dt
    elseif love.keyboard.isDown('e') then
        playerRectangle.angle = playerRectangle.angle + 1 * dt
    end

    playerRectangle:update(dt)
    obstacleRectangle:update(dt)

    determineCollision(playerRectangle, obstacleRectangle)
end
