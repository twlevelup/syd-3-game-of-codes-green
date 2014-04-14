require 'version'
require 'input'
require 'player'
require 'fuel_tank'
require 'stage'
require 'asteroid'
require 'purple_cow'
require 'bullet'

love.animation = require 'vendor/anim8'
love.state = require 'vendor/gamestate'
timer = require 'vendor/timer'

-- Game States
require 'runner'
require 'scoreboard'
require 'pause'

function love.load()
    print("Version: " .. version)

    love.input.bind('up', 'up')
    love.input.bind('left', 'left')
    love.input.bind('right', 'right')
    love.input.bind('down', 'down')
    love.input.bind('z','z')

    love.state.registerEvents()
    love.state.switch(Runner)
end

function love.update(dt)
end

function love.draw()
end
