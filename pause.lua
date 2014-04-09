local HEADING_OFFSET = 25
local LINE_OFFSET = 10
local LINE_LIMIT = 400

Pause = {}

function Pause:enter(from)
    self.from = from
end

function Pause:draw()
    local W, H = love.graphics.getWidth(), love.graphics.getHeight()
    -- draw previous screen
    self.from:draw()
    -- overlay with pause message
    love.graphics.setColor(0,0,0, 100)
    love.graphics.rectangle('fill', 0, 0, W, H)
    love.graphics.setColor(255, 255, 255)
    love.graphics.printf('PAUSED', 0, H/2, W, 'center')
end

function Pause:keyreleased(key)
    if key == ' ' then
        love.state.pop()
    end
end
