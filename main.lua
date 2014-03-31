require 'input'
require 'player'
require 'fuel_tank'
require 'obstacle'
require 'stage'
require 'version'
require 'asteroid'

love.animation = require 'vendor/anim8'

local entities = {}
local player = Player:new(love, {
    x = love.window.getHeight() * 0.01, 
    min_y = 0, 
    max_y = love.window.getHeight()
})
player.y = (love.window.getHeight() - player.size.y) / 2
local obstacle = Obstacle:new(love, {x = 200, y = 200})
local stage = Stage:new(love)
local asteroid = Asteroid:new(love)
local fuel_tank = Fuel_tank:new(love)

function love.load()
    print("Version: " .. version)

    table.insert(entities, player)
    table.insert(entities, asteroid)
    table.insert(entities, fuel_tank)

    love.input.bind('up', 'up')
    love.input.bind('left', 'left')
    love.input.bind('right', 'right')
    love.input.bind('down', 'down')
end

function love.update(dt)
    for _, entity in pairs(entities) do
        entity:update(dt)
        stage:update(dt)
        for _, other in pairs(entities) do
            if other ~= entity then
                if entity:collidingWith(other) then
                    entity:collide(other)
                end
            end
        end
    end
end

function love.draw()
    stage:draw()
    for _, e in pairs(entities) do
        e:draw()
    end
end
