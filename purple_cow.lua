require 'entity'

Purple_Cow = {}
Purple_Cow.__index = Purple_Cow
setmetatable(Purple_Cow, {__index = Entity})

function Purple_Cow:new(game, config)
  local config = config or {}
  local newPurple_Cow = Entity:new(game)

  math.randomseed(os.time())
  newPurple_Cow.x = config.x or 400
  newPurple_Cow.y = config.y or 300

   newPurple_Cow.size = config.size or {x = 100, y = 100}

  newPurple_Cow.graphics = config.graphics or {source = "assets/images/PurpleCow.png"}
  if game.graphics ~= nil and game.animation ~= nil then
    newPurple_Cow.graphics.sprites = game.graphics.newImage(newPurple_Cow.graphics.source)
    newPurple_Cow.sx = 100 / newPurple_Cow.graphics.sprites:getWidth()
    newPurple_Cow.sy = 100 / newPurple_Cow.graphics.sprites:getHeight()
    newPurple_Cow.graphics.grid = game.animation.newGrid(
      newPurple_Cow.size.x, newPurple_Cow.size.y,
      newPurple_Cow.graphics.sprites:getWidth(),
      newPurple_Cow.graphics.sprites:getHeight()
    )
    newPurple_Cow.graphics.animation = game.animation.newAnimation(
      newPurple_Cow.graphics.grid("1-1", 1),
      0.05
    )
  end

  newPurple_Cow.type = 'Purple_Cow'

  return setmetatable(newPurple_Cow, self)
end

function Purple_Cow:update(dt)
  
  -- body
end

function Purple_Cow:draw()
  self.game.graphics.draw(self.graphics.sprites, self.x, self.y, self.angle, self.sx, self.sy)
  if DEBUG_MODE then
      self.game.graphics.rectangle("line", self.x, self.y, self.size.x, self.size.y)
  end
end
