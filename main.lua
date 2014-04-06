require 'version'
require 'input'
require 'player'
require 'fuel_tank'
require 'stage'
require 'asteroid'

love.animation = require 'vendor/anim8'
love.state = require 'vendor/gamestate'
timer = require 'vendor/timer'

game = {}

function game:enter()
    self.entities = {}
    self.player = Player:new(love, {
        x = love.window.getHeight() * 0.01,
        min_y = 0,
        max_y = love.window.getHeight()
    })
    self.player.y = (love.window.getHeight() - self.player.size.y) / 2
    self.fuel_tank = Fuel_tank:new(love)
    self.stage = Stage:new(love, {x = 0, y = 0, backgroundImage = "assets/images/space.jpg"})

    table.insert(self.entities, self.player)
    table.insert(self.entities, self.asteroid)
    table.insert(self.entities, self.fuel_tank)

    timer.addPeriodic(1, function()
        table.insert(self.entities, Asteroid:new(love, {to = {x = 0, y = self.player.y - math.random(-100, 100)}}))
    end)

    bgm = love.audio.newSource("assets/sounds/bgm.mp3")
    bgm:setLooping(true)
    bgm:play()
end

function game:update(dt)
    self.stage:update(dt)
    for _, entity in pairs(self.entities) do
        entity:update(dt)
        for _, other in pairs(self.entities) do
            if other ~= entity then
                if entity:collidingWith(other) then
                    entity:collide(other)
                end
            end
        end
    end
end

function game:draw()
    self.stage:draw()
    for _, e in pairs(self.entities) do
        e:draw()
    end
end

function game:leave()
    love.audio.stop()
    timer.clear()
end

function gameover()
    love.state.switch(game)
end

function love.load()
    print("Version: " .. version)

    love.input.bind('up', 'up')
    love.input.bind('left', 'left')
    love.input.bind('right', 'right')
    love.input.bind('down', 'down')

    love.state.switch(game)
end

function love.update(dt)
    love.state.update(dt)
    timer.update(dt)
end

function love.draw()
    game:draw()
end
