require 'entity'

Asteroid = {}
Asteroid.__index = Asteroid
setmetatable(Asteroid, {__index = Entity})

function Asteroid:new(game, config)
  local config = config or {}
  local newAsteroid = Entity:new(game)

  math.randomseed(os.time())
  newAsteroid.x = config.x or 800
  newAsteroid.y = config.y or math.random(0, 500)
  newAsteroid.to = config.to or {x = 0, y = math.random(0, 500)}

  newAsteroid.angle = math.atan2(newAsteroid.y - newAsteroid.to.y, newAsteroid.x - newAsteroid.to.x)
  newAsteroid.speed = config.speed or 300
  newAsteroid.dx = newAsteroid.speed * math.cos(newAsteroid.angle)
  newAsteroid.dy = newAsteroid.speed * math.sin(newAsteroid.angle)

  newAsteroid.size = config.size or {x = 100, y = 100}

  newAsteroid.shape = config.shape or {
    x = newAsteroid.x + newAsteroid.size.x/10 - newAsteroid.size.x/2 * newAsteroid.angle,
    y = newAsteroid.y + newAsteroid.size.y/4 + newAsteroid.size.y/4 * newAsteroid.angle,
    size = {x = newAsteroid.size.x/2, y = newAsteroid.size.y/2}
  }

  newAsteroid.graphics = config.graphics or {source = "assets/images/meteor.png"}
  if game.graphics ~= nil and game.animation ~= nil then
    newAsteroid.graphics.sprites = game.graphics.newImage(newAsteroid.graphics.source)
    newAsteroid.sx = 100 / newAsteroid.graphics.sprites:getWidth()
    newAsteroid.sy = 100 / newAsteroid.graphics.sprites:getHeight()
    newAsteroid.graphics.grid = game.animation.newGrid(
      newAsteroid.size.x, newAsteroid.size.y,
      newAsteroid.graphics.sprites:getWidth(),
      newAsteroid.graphics.sprites:getHeight()
    )
    newAsteroid.graphics.animation = game.animation.newAnimation(
      newAsteroid.graphics.grid("1-1", 1),
      0.05
    )
  end

  newAsteroid.type = 'asteroid'

  return setmetatable(newAsteroid, self)
end

function Asteroid:update(dt)
  self.x = self.x - self.dx * dt
  self.y = self.y - self.dy * dt
  self.shape.x = self.shape.x - self.dx * dt
  self.shape.y = self.shape.y - self.dy * dt
end

function Asteroid:draw()
  self.game.graphics.draw(self.graphics.sprites, self.x, self.y, self.angle, self.sx, self.sy)
  if DEBUG_MODE then
      self.game.graphics.rectangle("line", self.shape.x, self.shape.y, self.shape.size.x, self.shape.size.y)
  end
end
