require 'input'
require 'player'
require 'obstacle'
require 'version'
require 'asteroid'

love.animation = require 'vendor/anim8'

local entities = {}
local player = Player:new(love, {x = 100, y = 100})
local asteroid = Asteroid:new(love)

function love.load()
    print("Version: " .. version)

    table.insert(entities, player)
    table.insert(entities, asteroid)

    love.input.bind('up', 'up')
    love.input.bind('left', 'left')
    love.input.bind('right', 'right')
    love.input.bind('down', 'down')
end

function love.update(dt)
    for _, entity in pairs(entities) do
        entity:update(dt)

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
    for _, e in pairs(entities) do
        e:draw()
    end
end
