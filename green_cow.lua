require 'entity'

GreenCow = {}
GreenCow.__index = GreenCow
setmetatable(GreenCow, {__index = Entity})

function GreenCow.init()
  local game = love or {} -- hack around the unit tests
  local graphics = {source = "assets/images/GreenCow.png"}
  local bang = {source = "assets/sounds/bang-cow.wav"}
  local sprite = {}
  if game.audio then
      bang = {sample = game.audio.newSource(bang.source)}
  end
  if game.graphics then
    sprite = game.graphics.newImage(graphics.source)
  end

  return function(self, game, config)
    local config = config or {}
    local new_green_cow = Entity:new(game)

    new_green_cow.x = config.x or 800
    new_green_cow.y = config.y or math.random(0, 600)
    new_green_cow.to = config.to or {x = 0, y = math.random(0, 600)}

    new_green_cow.angle = math.atan2(new_green_cow.y - new_green_cow.to.y, new_green_cow.x - new_green_cow.to.x)
    new_green_cow.speed = config.speed or 300
    new_green_cow.dx = new_green_cow.speed * math.cos(new_green_cow.angle)
    new_green_cow.dy = new_green_cow.speed * math.sin(new_green_cow.angle)

    new_green_cow.size = config.size or {x = 70, y = 70}

    new_green_cow.graphics = graphics
    if game.graphics ~= nil and game.animation ~= nil then
      new_green_cow.graphics.sprites = sprite
      new_green_cow.yratio = (new_green_cow.graphics.sprites:getHeight() / new_green_cow.graphics.sprites:getWidth())
      new_green_cow.xratio = (new_green_cow.graphics.sprites:getWidth() / new_green_cow.graphics.sprites:getHeight())
      new_green_cow.sx = new_green_cow.size.x / new_green_cow.graphics.sprites:getWidth()
      new_green_cow.sy = new_green_cow.size.y / new_green_cow.graphics.sprites:getHeight() * new_green_cow.yratio
      new_green_cow.bboxes = BoundingBoxes:new(new_green_cow, {
        {
          left = 177,
          top = 64,
          right = 819,
          bottom = 678
        }
      })
      new_green_cow.graphics.grid = game.animation.newGrid(
        new_green_cow.size.x, new_green_cow.size.y,
        new_green_cow.graphics.sprites:getWidth(),
        new_green_cow.graphics.sprites:getHeight()
        )
      new_green_cow.graphics.animation = game.animation.newAnimation(
      new_green_cow.graphics.grid("1-1", 1),
      0.05
      )
    end

    new_green_cow.sound = {bang = {bang.source}}
    if game.audio ~= nil then
        new_green_cow.sound.bang.sample = bang.sample
    end

    new_green_cow.type = 'green_cow'

    return setmetatable(new_green_cow, self)
  end
end

GreenCow.new = GreenCow.init()

function GreenCow:update(dt)
  self.x = self.x - self.dx * dt
  self.y = self.y - self.dy * dt + 4 * math.sin(self.x / 100)
  if self.bboxes then
      self.bboxes:update()
  end
  if self.x < 0 - self.size.x then
      Runner:remove(self)
  end
end

function GreenCow:collide(other)
  if other.type == 'bullet' then
    Runner.player:updatescore(-1000)
    if self.sound.bang then
        self.sound.bang.sample:play()
    end
    Runner:remove(self)
  end
end

function GreenCow:draw()
  self.game.graphics.draw(self.graphics.sprites, self.x, self.y, 0, self.sx, self.sy)
  if DEBUG_MODE then
      for i = 1, #self.bboxes.boxes do
          local box = self.bboxes.boxes[i]
          self.game.graphics.rectangle('line', box.x, box.y, box.size.x, box.size.y)
      end
  end
end
