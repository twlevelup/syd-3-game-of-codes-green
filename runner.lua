Runner = {}

function Runner:enter()
    -- create entitites
    self.entities = {}

    -- create a player
    self.player = Player:new(love, {
        x = love.window.getHeight() * 0.01,
        min_y = 0,
        max_y = love.window.getHeight(),
        min_x = 0,
        max_x = love.window.getWidth()
    })

    -- set location of player????
    self.player.y = (love.window.getHeight() - self.player.size.y) / 2

    -- create new fuel
    self.fuel_tank = Fuel_tank:new(love)

    -- create new stage
    self.stage = Stage:new(love, {x = 0, y = 0, backgroundImage = "assets/images/space.jpg"})

    -- create table for ??
    table.insert(self.entities, self.player)
    table.insert(self.entities, self.asteroid)
    table.insert(self.entities, self.purple_cow)
    table.insert(self.entities, self.green_cow)
    table.insert(self.entities, self.fuel_tank)

    -- add the Asteroids
    self.timer = timer.new()
    self.timer:addPeriodic(1, function()
        table.insert(self.entities, Asteroid:new(love))
    end)

    self.timer:addPeriodic(5, function()
      table.insert(self.entities, PurpleCow:new(love))
    end)

    self.timer:addPeriodic(30, function()
      table.insert(self.entities, GreenCow:new(love))
    end)

    self.timer:addPeriodic(0.02, function()
        self.player:updatescore(1)
    end)

    -- play background music
    -- Runner:playmusic("assets/sounds/Game_Background.mp3")
end

function Runner:playmusic(song)
    bgm = love.audio.newSource(song)
    bgm:setLooping(true)
    bgm:play()
end

function Runner:update(dt)
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
    self.timer:update(dt)
end

function Runner:draw()
    self.stage:draw()
    for _, e in pairs(self.entities) do
        e:draw()
    end
    love.graphics.printf("--Press \"Space\" to Pause--", love.window.getWidth() * 0.25, love.window.getHeight() * 0.95, 400, "center", 0, 1, 1.5)

    if DEBUG_MODE then
        love.graphics.print("FPS: "..love.timer.getFPS(), 10, love.window.getHeight() - 20)
        love.graphics.print(string.format("Time per frame: %.3f ms", 1000 * love.timer.getAverageDelta()), 10, love.window.getHeight() - 40)
    end
end

function Runner:keyreleased(key)
    if key == ' ' then
        love.state.push(Pause)
    end
end

function Runner:leave()
    love.audio.stop()
    self.timer:clear()
end

function Runner:gameover()
    love.state.switch(Scoreboard, self.player.score)
end
