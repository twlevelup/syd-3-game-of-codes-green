Scoreboard = {}

local HEADING_OFFSET = 25
local LINE_OFFSET = 10
local LINE_LIMIT = 400

function Scoreboard:enter()
  Scoreboard.x = love.window.getWidth() * 0.2
  Scoreboard.y = love.window.getHeight() * 0.1 
  Scoreboard.width = love.window.getWidth() * 0.6
  Scoreboard.height = love.window.getHeight() * 0.8
  Scoreboard.message = "Game Over" .. "\nPress \"Space\" to start again" .. "\n Press \"Esc\" to exit the game"
end

function Scoreboard:update(dt)

end

function Scoreboard:draw()
  love.graphics.setColor(56,57,59)
  love.graphics.rectangle("fill", Scoreboard.x, Scoreboard.y, Scoreboard.width, Scoreboard.height)
  love.graphics.setColor(255,255,255)
  love.graphics.printf(Scoreboard.message, love.window.getWidth() * 0.25, Scoreboard.y + HEADING_OFFSET, LINE_LIMIT, "center", 0, 1, 1.5)  
end

function Scoreboard:keyreleased(key)
    if key == ' ' then
      love.state.switch(game)
    elseif key == "escape" then
      love.event.quit()
    end
end
