require 'entity'

Asteroid = {}
Asteroid.__index = Asteroid
setmetatable(Asteroid, {__index = Entity})

function Asteroid:new(game, config)
	local config = config or {}
  local newAsteroid = Entity:new(game)

  newAsteroid.x = config.x
  newAsteroid.y = config.y
  newAsteroid.speed = config.speed
  newAsteroid.size = config.size or {
    x = 100,
    y = 100
  }
  newAsteroid.graphics = config.graphics or {
    source = "assets/images/asteroid.png"
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
      0.03
    )
  end

  return setmetatable(newAsteroid, self)
end

function Asteroid:update(dt)
  self.x = self.x - self.speed * dt 
end
		