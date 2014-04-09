love.state = require 'vendor/gamestate'
require 'vendor/json'

Scoreboard = {}

local HEADING_OFFSET = 25
local LINE_OFFSET = 10
local LINE_LIMIT = 400

local player_score = 10
local default_score = {
  20,9,8,7,6,5,4,3,2,1
}

function Scoreboard:enter()
  Scoreboard.x = love.window.getWidth() * 0.2
  Scoreboard.y = love.window.getHeight() * 0.1 
  Scoreboard.width = love.window.getWidth() * 0.6
  Scoreboard.height = love.window.getHeight() * 0.8
  Scoreboard.message = "Game Over" .. "\nPress \"Space\" to start again" .. "\n Press \"Esc\" to exit the game"

  if love.filesystem.exists("score.txt") == false then
      love.filesystem.write("score.txt", json.encode(default_score))
  end
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
    local pos = 0

    if key == ' ' then
      love.state.switch(game)
    elseif key == "escape" then
      love.event.quit()
    end

    o = json.decode(love.filesystem.read("score.txt"))

    table.foreach(o, function(_index)
      print ("before", _index, o[_index])
    end)

end
