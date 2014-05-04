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
    newAsteroid.speed = config.speed or 400
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

      newAsteroid.bboxes = BoundingBoxes:new(newAsteroid, {
          {
              left = 3,
              right = 346,
              top = 84,
              bottom = 453
          }
      })

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
  if self.bboxes then
      self.bboxes:update()
  end
  if self.x < 0 - self.size.x then
      Runner:remove(self)
  end
end

function Asteroid:draw()
  self.game.graphics.draw(self.graphics.sprites, self.x, self.y, 0, self.sx, self.sy)
  if DEBUG_MODE then
      for i = 1, #self.bboxes.boxes do
          local box = self.bboxes.boxes[i]
          self.game.graphics.rectangle("line", box.x, box.y, box.size.x, box.size.y)
      end
  end
end
