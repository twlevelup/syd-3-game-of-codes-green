Stage = {}
Stage.__index = Stage

function Stage:new(game)

    stage = {
        backgroundImage = game.graphics.newImage("assets/images/space.jpg"),
        game = game,
        x = 0,
        y = 0,
        speed = 100,
        screenWidth = game.graphics:getWidth()
    }
    return setmetatable(stage, self)
end

function Stage:update(dt)
    self.x = self.x - dt * self.speed
    if self.x < -self.backgroundImage:getWidth() then
        self.x = self.screenWidth
    end
end

function Stage:draw()
   self.game.graphics.draw(self.backgroundImage, self.x, self.y)
end

