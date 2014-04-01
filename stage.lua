Stage = {}
Stage.__index = Stage

function Stage:new(game, config)
    local stage = {}
    stage.backgroundImage = game.graphics.newImage(config.backgroundImage) or game.graphics.newImage("assets/images/space.jpg")
    stage.game = game
    stage.x = config.x or 0
    stage.y = config.y or 0
    stage.speed = config.speed or 200
    stage.screenWidth = config.screenWidth or game.graphics:getWidth()
    stage.bgWidth = config.bgWidth or stage.backgroundImage:getWidth()
    return setmetatable(stage, self)
end

function Stage:update(dt)
    self.x = self.x - dt * self.speed
    if self.x < -self.bgWidth then
        self.x = self.screenWidth
    end
end

function Stage:draw()
   self.game.graphics.draw(self.backgroundImage, self.x, self.y)
end

