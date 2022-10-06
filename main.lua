require 'math'

WINDOW_WIDTH = 1920
WINDOW_HEIGHT = 1080

function love.load () 
    -- love.graphics.setColor(79/255, 157/255, 202/255)
    love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)  
end  

playerRectangle = {
    ['x'] = 0,
    ['y'] = 0,
    ['angle'] = 0,
    ['dx'] = 0,
    ['dy'] = 0,
    ['width'] = 200,
    ['height'] = 200,
}

obstacleRectangle = {
    ['x'] = 1400,
    ['y'] = 400,
    ['angle'] = 0,
    ['dx'] = 0,
    ['dy'] = 0,
    ['width'] = 200,
    ['height'] = 200,
}

-- top right corner
playerRectangle['tr'] = {
    ['x'] = playerRectangle.x + playerRectangle.width,
    ['y'] = playerRectangle.y,
}
-- bottom right corner
playerRectangle['br'] = {
    ['x'] = playerRectangle.x + playerRectangle.width,
    ['y'] = playerRectangle.y + playerRectangle.height,
}
--bottom left corner
playerRectangle['bl'] = {
    ['x'] = playerRectangle.x,
    ['y'] = playerRectangle.y + playerRectangle.height,
}

speed = 400

-- Returns the distance between two points.
function math.mag(x1,y1, x2,y2) return ((x2-x1)^2+(y2-y1)^2)^0.5 end

function updateCornerCoordinates(rect)
    --determine new coordinates based on angle
    -- top right corner
    rect['tr']['x'] = rect.x + rect.width
    rect['tr']['y'] = rect.y

    vec = {
        ['x'] = 0,
        ['y'] = 0,
    }

    magV = math.mag(rect.x, rect.y, rect.tr.x, rect.tr.y)
    vec['x'] = rect.tr.x - rect.x
    vec['y'] = rect.tr.y - rect.y

    -- rect.tr.x = vec.x * math.cos(rect.angle)
    -- rect.tr.y = vec.y * math.sin(rect.angle)

    rect.tr.x = magV * math.cos(rect.angle) + rect.x
    rect.tr.y = magV * math.sin(rect.angle) + rect.y
    -- bottom right corner
    rect['br']['x'] = rect.x + rect.width
    rect['br']['y'] = rect.y + rect.height

    magV = math.mag(rect.x, rect.y, rect.br.x, rect.br.y)
    vec['x'] = rect.br.x - rect.x
    vec['y'] = rect.br.y - rect.y

    rect.br.x = magV * math.cos(rect.angle - (7/4) * math.pi) + rect.x
    rect.br.y = magV * math.sin(rect.angle - (7/4) * math.pi) + rect.y

    -- rect.br.x = vec.x * math.cos(rect.angle)
    -- rect.br.y = vec.y * math.sin(rect.angle)

    --bottom left corner
    rect['bl']['x'] = rect.x
    rect['bl']['y'] = rect.y + rect.height

    magV = math.mag(rect.x, rect.y, rect.bl.x, rect.bl.y)
    vec['x'] = rect.bl.x - rect.x
    vec['y'] = rect.bl.y - rect.y

    rect.bl.x = magV * math.cos(rect.angle - (3/2) * math.pi) + rect.x
    rect.bl.y = magV * math.sin(rect.angle - (3/2) * math.pi) + rect.y

    -- rect.bl.x = vec.x * math.cos(rect.angle)
    -- rect.bl.y = vec.y * math.sin(rect.angle)
end


function drawRotatedRectangle(mode, x, y, width, height, angle)
	-- We cannot rotate the rectangle directly, but we
	-- can move and rotate the coordinate system.
	love.graphics.push()
	love.graphics.translate(x, y)
	love.graphics.rotate(angle)
	love.graphics.rectangle(mode, 0, 0, width, height) -- origin in the top left corner
--	love.graphics.rectangle(mode, -width/2, -height/2, width, height) -- origin in the middle
	love.graphics.pop()
end

function announceCornerCoordinates(element)
    love.graphics.setColor(0, 1, 0, 1)
    love.graphics.print('Top Left: x:' .. tostring(element.x) .. '\ty: ' .. tostring(element.y), 950, 10)
    love.graphics.print('Top Right: x:' .. tostring(element.tr.x) .. '\ty: ' .. tostring(element.tr.y), 1300, 10)
    love.graphics.print('Bot Left: x:' .. tostring(element.bl.x) .. '\ty: ' .. tostring(element.bl.y), 950, 50)
    love.graphics.print('Bot Right: x:' .. tostring(element.br.x) .. '\ty: ' .. tostring(element.br.y), 1300, 50)
    love.graphics.print('Angle: ' .. tostring(element.angle), 1300, 100)
end

function love.draw() 
    love.graphics.clear(40/255, 45/255, 52/255, 255/255)
    love.graphics.setColor(70/255, 205/255, 43/255)
    drawRotatedRectangle('fill', playerRectangle.x, playerRectangle.y, playerRectangle.width, playerRectangle.height, playerRectangle.angle)
    love.graphics.setColor(255/255, 255/255, 0/255)
    drawRotatedRectangle('fill', obstacleRectangle.x, obstacleRectangle.y, obstacleRectangle.width, obstacleRectangle.height, obstacleRectangle.angle)

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

    updateCornerCoordinates(playerRectangle)
end
