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
    stage.screenHeight = config.screenHeight or game.graphics:getHeight()
    stage.bgHeight = config.bgHeight or stage.backgroundImage:getHeight()
    stage.sx = stage.screenWidth / stage.bgWidth
    stage.sy = stage.screenHeight / stage.bgHeight
    return setmetatable(stage, self)
end

function Stage:update(dt)
    self.x = self.x - dt * self.speed
    if self.x < -self.screenWidth then
        self.x = 0
    end
end

function Stage:draw()
   self.game.graphics.draw(self.backgroundImage, self.x, self.y, 0, self.sx, self.sy)
   self.game.graphics.draw(self.backgroundImage, self.x + self.screenWidth, self.y, 0, self.sx, self.sy)
end

