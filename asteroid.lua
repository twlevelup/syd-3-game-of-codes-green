require 'entity'

Asteroid = {}
Asteroid.__index = Asteroid
setmetatable(Asteroid, {__index = Entity})

function Asteroid:new(game, config)
  local config = config or {}
  local newAsteroid = Entity:new(game)

  math.randomseed(os.time())
  newAsteroid.x = config.x or 800
  newAsteroid.y = config.y or math.random(100, 500)
  newAsteroid.speed = config.speed or {
    x = 250,
    y = math.random(-100, 100)
  }
  newAsteroid.size = config.size or {
    x = 100,
    y = 100
  }
  newAsteroid.graphics = config.graphics or {
    source = "assets/images/meteor.png"
  }


  if game.graphics ~= nil and game.animation ~= nil then
    newAsteroid.graphics.sprites = game.graphics.newImage(newAsteroid.graphics.source)
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

  newAsteroid.sx = 99 / newAsteroid.graphics.sprites:getWidth()
  newAsteroid.sy = 99 / newAsteroid.graphics.sprites:getHeight()

  return setmetatable(newAsteroid, self)
end

function Asteroid:update(dt)
  self.x = self.x - self.speed.x * dt
  self.y = self.y - self.speed.y * dt
end

function Asteroid:draw()
  self.game.graphics.draw(self.graphics.sprites, self.x, self.y, 0, self.sx, self.sy)
end
