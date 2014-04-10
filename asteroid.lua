require 'entity'

Asteroid = {}
Asteroid.__index = Asteroid
setmetatable(Asteroid, {__index = Entity})

function Asteroid.init()
  local game = love or {} -- hack around the unit tests
  local graphics = {source = "assets/images/meteor.png"}
  local sprite = {}
  if game.graphics then
    sprite = game.graphics.newImage(graphics.source)
  end

  return function(self, game, config)
    local config = config or {}
    local newAsteroid = Entity:new(game)

    math.randomseed(os.time())
    newAsteroid.x = config.x or 800
    newAsteroid.y = config.y or math.random(0, 500)
    newAsteroid.to = config.to or {x = 0, y = math.random(0, 600)}

    newAsteroid.angle = math.atan2(newAsteroid.y - newAsteroid.to.y, newAsteroid.x - newAsteroid.to.x)
    newAsteroid.speed = config.speed or 300
    newAsteroid.dx = newAsteroid.speed * math.cos(newAsteroid.angle)
    newAsteroid.dy = newAsteroid.speed * math.sin(newAsteroid.angle)

    newAsteroid.size = config.size or {x = 70, y = 70}

    newAsteroid.graphics = graphics
    if game.graphics ~= nil and game.animation ~= nil then
      newAsteroid.graphics.sprites = sprite
      newAsteroid.yratio = (newAsteroid.graphics.sprites:getHeight() / newAsteroid.graphics.sprites:getWidth())
      newAsteroid.xratio = (newAsteroid.graphics.sprites:getWidth() / newAsteroid.graphics.sprites:getHeight())
      newAsteroid.sx = newAsteroid.size.x / newAsteroid.graphics.sprites:getWidth()
      newAsteroid.sy = newAsteroid.size.y / newAsteroid.graphics.sprites:getHeight() * newAsteroid.yratio
      newAsteroid.shape = config.shape or {
        x = newAsteroid.x,
        y = newAsteroid.y + newAsteroid.size.y*0.25,
        size = {x = newAsteroid.size.x*0.75, y = newAsteroid.size.y*0.75}
      }
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
end

Asteroid.new = Asteroid.init()

function Asteroid:update(dt)
  self.x = self.x - self.dx * dt
  self.y = self.y - self.dy * dt
  if self.shape then
    self.shape.x = self.shape.x - self.dx * dt
    self.shape.y = self.shape.y - self.dy * dt
  end
end

function Asteroid:draw()
  self.game.graphics.draw(self.graphics.sprites, self.x, self.y, 0, self.sx, self.sy)
  if DEBUG_MODE then
      self.game.graphics.rectangle("line", self.shape.x, self.shape.y, self.shape.size.x, self.shape.size.y)
  end
end
