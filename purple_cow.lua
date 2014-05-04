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
      new_purple_cow.bboxes = BoundingBoxes:new(new_purple_cow, {
        {
          left = 177,
          top = 64,
          right = 819,
          bottom = 678
        }
      })
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
  if self.bboxes then
      self.bboxes:update()
  end
  if self.x < 0 - self.size.x then
      Runner:remove(self)
  end
end

function PurpleCow:collide(other)
  if other.type == 'bullet' then
    Runner.player:updatescore(500)
    Runner:remove(self)
    Runner:remove(other)
  end
end

function PurpleCow:draw()
  self.game.graphics.draw(self.graphics.sprites, self.x, self.y, 0, self.sx, self.sy)
  if DEBUG_MODE then
      for i = 1, #self.bboxes.boxes do
          local box = self.bboxes.boxes[i]
          self.game.graphics.rectangle('line', box.x, box.y, box.size.x, box.size.y)
      end
  end
end
