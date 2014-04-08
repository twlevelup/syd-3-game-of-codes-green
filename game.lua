love.state = require 'vendor/gamestate'

game = love.state.new()

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
    self.purple_cow = Purple_Cow:new(love)

    table.insert(self.entities, self.player)
    table.insert(self.entities, self.asteroid)
    table.insert(self.entities, self.fuel_tank)
    table.insert(self.entities, self.purple_cow)

    timer.addPeriodic(1, function()
        table.insert(self.entities, Asteroid:new(love, {to = {x = 0, y = math.random(0, 600)}}))
    end)
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

function game:gameover()
    love.state.switch(Scoreboard)
end