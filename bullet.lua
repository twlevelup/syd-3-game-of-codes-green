require 'entity'

Bullet = {}
Bullet.__index = Bullet
setmetatable(Bullet, {__index = Entity})

function Bullet:new(game, config)
  local config = config or {}
  local newBullet = Entity:new(game)

  math.randomseed(os.time())
  newBullet.x = config.x or 400
  newBullet.y = config.y or 300

  newBullet.x2 = config.x2 or 500
  newBullet.y2 = config.y2 or 400

  newBullet.speed = config.speed or 1000

  newBullet.size = {x = newBullet.x2 - newBullet.x, y = 1}

  newBullet.type = 'bullet'

  return setmetatable(newBullet, self)
end

function Bullet:update(dt)
  self.x = self.x + self.speed * dt
  self.x2 = self.x2 + self.speed * dt
  if self.game.graphics and self.x > self.game.graphics:getWidth() then
      Runner:remove(self)
  end
end

function Bullet:draw()
  self.game.graphics.line(self.x, self.y, self.x2, self.y2)
end
