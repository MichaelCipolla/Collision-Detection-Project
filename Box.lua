Box = Class{}

function Box:init(x, y, width, height, color)
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    self.angle = 0
    self.v0 = {['x'] = self.x + self.width/2, ['y'] = self.y + self.height/2}
    self.v1 = {['x'] = self.x, ['y'] = self.y}
    self.v2 = {['x'] = self.x + self.width, ['y'] = self.y}
    self.v3 = {['x'] = self.x + self.width, ['y'] = self.y + self.height}
    self.v4 = {['x'] = self.x, ['y'] = self.y + self.height}
    self.color = color
end

function math.mag(x1,y1, x2,y2) return ((x2-x1)^2+(y2-y1)^2)^0.5 end

--[[
    This function is called on all box items every frame.
    
    We will use this function to update the vertex positions upon
    changing the angles as well as preventing the Box from moving
    offscreen.
]]
function Box:update(dt)
    -- Determine new coordinates based on angle. NOTE: Because of the inverted coordinate system, we need to
    -- subtract angles in order to add them to our vectors.
    -- top left corner
    self.v1.x = self.x
    self.v1.y = self.y
    
    -- top right corner
    self.v2.x = self.x + self.width
    self.v2.y = self.y

    vec = {
        ['x'] = 0,
        ['y'] = 0,
    }

    magV = math.mag(self.x, self.y, self.v2.x, self.v2.y)
    vec['x'] = self.v2.x - self.x
    vec['y'] = self.v2.y - self.y

    self.v2.x = magV * math.cos(self.angle) + self.x
    self.v2.y = magV * math.sin(self.angle) + self.y
    -- bottom right corner
    self.v3.x = self.x + self.width
    self.v3.y = self.y + self.height

    magV = math.mag(self.x, self.y, self.v3.x, self.v3.y)
    vec['x'] = self.v3.x - self.x
    vec['y'] = self.v3.y - self.y

    self.v3.x = magV * math.cos(self.angle - (7/4) * math.pi) + self.x
    self.v3.y = magV * math.sin(self.angle - (7/4) * math.pi) + self.y

    --bottom left corner
    self.v4.x = self.x
    self.v4.y = self.y + self.height

    magV = math.mag(self.x, self.y, self.v4.x, self.v4.y)
    vec['x'] = self.v4.x - self.x
    vec['y'] = self.v4.y - self.y

    self.v4.x = magV * math.cos(self.angle - (3/2) * math.pi) + self.x
    self.v4.y = magV * math.sin(self.angle - (3/2) * math.pi) + self.y


    self['side0'] = sub(self.v2, self.v1)
    self['side1'] = sub(self.v3, self.v2)
    self['side2'] = sub(self.v4, self.v3)
    self['side3'] = sub(self.v1, self.v4)
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

function Box:render()
    love.graphics.setColor(self.color.R, self.color.G, self.color.B)
    drawRotatedRectangle('fill', self.x, self.y, self.width, self.height, self.angle)
end