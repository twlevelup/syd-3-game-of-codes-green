require 'entity'

PurpleCow = {}
PurpleCow.__index = PurpleCow
setmetatable(PurpleCow, {__index = Entity})

function PurpleCow.init()
  local game = love or {} -- hack around the unit tests
  local graphics = {source = "assets/images/PurpleCow.png"}
  local sprite = {}
  if game.graphics then
    sprite = game.graphics.newImage(graphics.source)
  end

  return function(self, game, config)
    local config = config or {}
    local new_purple_cow = Entity:new(game)

    new_purple_cow.x = config.x or 800
    new_purple_cow.y = config.y or math.random(0, 500)
    new_purple_cow.to = config.to or {x = 0, y = math.random(0, 600)}

    new_purple_cow.angle = math.atan2(new_purple_cow.y - new_purple_cow.to.y, new_purple_cow.x - new_purple_cow.to.x)
    new_purple_cow.speed = config.speed or 300
    new_purple_cow.dx = new_purple_cow.speed * math.cos(new_purple_cow.angle)
    new_purple_cow.dy = new_purple_cow.speed * math.sin(new_purple_cow.angle)

    new_purple_cow.size = config.size or {x = 70, y = 70}

    new_purple_cow.graphics = graphics
    if game.graphics ~= nil and game.animation ~= nil then
      new_purple_cow.graphics.sprites = sprite
      new_purple_cow.yratio = (new_purple_cow.graphics.sprites:getHeight() / new_purple_cow.graphics.sprites:getWidth())
      new_purple_cow.xratio = (new_purple_cow.graphics.sprites:getWidth() / new_purple_cow.graphics.sprites:getHeight())
      new_purple_cow.sx = new_purple_cow.size.x / new_purple_cow.graphics.sprites:getWidth()
      new_purple_cow.sy = new_purple_cow.size.y / new_purple_cow.graphics.sprites:getHeight() * new_purple_cow.yratio
      new_purple_cow.shape = config.shape or {
        x = new_purple_cow.x,
        y = new_purple_cow.y + new_purple_cow.size.y*0.25,
        size = {x = new_purple_cow.size.x*0.75, y = new_purple_cow.size.y*0.75}
      }
      new_purple_cow.graphics.grid = game.animation.newGrid(
        new_purple_cow.size.x, new_purple_cow.size.y,
        new_purple_cow.graphics.sprites:getWidth(),
        new_purple_cow.graphics.sprites:getHeight()
        )
      new_purple_cow.graphics.animation = game.animation.newAnimation(
      new_purple_cow.graphics.grid("1-1", 1),
      0.05
      )
    end

    new_purple_cow.type = 'purple_cow'

    return setmetatable(new_purple_cow, self)
  end
end

PurpleCow.new = PurpleCow.init()

function PurpleCow:update(dt)
  self.x = self.x - self.dx * dt
  self.y = self.y - self.dy * dt + 4 * math.cos(self.x / 100)
  if self.shape then
    self.shape.x = self.shape.x - self.dx * dt
    self.shape.y = self.shape.y - self.dy * dt + 4 * math.cos(self.x / 100)
  end
end

function PurpleCow:draw()
  self.game.graphics.draw(self.graphics.sprites, self.x, self.y, 0, self.sx, self.sy)
  if DEBUG_MODE then
      self.game.graphics.rectangle("line", self.shape.x, self.shape.y, self.shape.size.x, self.shape.size.y)
  end
end
