local HEADING_OFFSET = 25
local LINE_OFFSET = 10
local LINE_LIMIT = 400

function drawPauseMessage()
  pauseMessageX = love.window.getWidth() * 0.2
  pauseMessageY = love.window.getHeight() * 0.1 
  pauseMessageWidth = love.window.getWidth() * 0.6
  pauseMessageHeight = love.window.getHeight() * 0.8
  love.graphics.setColor(56,57,59)
  love.graphics.rectangle("fill", pauseMessageX, pauseMessageY, pauseMessageWidth, pauseMessageHeight)
  love.graphics.setColor(255,255,255)
  love.graphics.printf("Pausing ......... \nPress \"Space\" to continue", love.window.getWidth() * 0.25, pauseMessageY + HEADING_OFFSET, LINE_LIMIT, "center", 0, 1, 1.5)  
end