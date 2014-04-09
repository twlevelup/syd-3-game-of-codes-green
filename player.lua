require 'input'
require 'entity'

Player = {}
Player.__index = Player
setmetatable(Player, {__index = Entity})

function Player:new(game, config)
    local config = config or {}

    local newPlayer = Entity:new(game)
    newPlayer.type = "player"
    newPlayer.x = config.x or 400
    newPlayer.y = config.y or 300
    newPlayer.min_y = config.min_y or 0
    newPlayer.max_y = config.max_y or 600
    newPlayer.min_x = config.min_x or 0
    newPlayer.max_x = config.max_x or 600
    newPlayer.score = config.score or 0
    newPlayer.size = config.size or {
        x = 150,
        y = 120
    }

    newPlayer.speed = config.speed or 5

    newPlayer.keys = config.keys or {
        up = "up",
        down = "down",
        left = "left",
        right = "right",
        shoot = "z"
    }

    newPlayer.graphics = config.graphics or {
        source = "assets/images/SpaceCowboy.png",
        facing = "right"
    }

    newPlayer.sound = config.sound or {
        moving = {
            source = "assets/sounds/move.wav"
        }
    }

    newPlayer.lastPosition = {
        x = nil,
        y = nil
    }

    if game.audio ~= nil then
        newPlayer.sound.moving.sample = game.audio.newSource(newPlayer.sound.moving.source)
        newPlayer.sound.moving.sample:setLooping(true)
    end

    if game.graphics ~= nil and game.animation ~= nil then
        newPlayer.graphics.sprites = game.graphics.newImage(newPlayer.graphics.source)
        newPlayer.sx = newPlayer.size.x / newPlayer.graphics.sprites:getWidth()
        newPlayer.sy = newPlayer.size.y / newPlayer.graphics.sprites:getHeight()
        newPlayer.graphics.grid = game.animation.newGrid(
            newPlayer.size.x, newPlayer.size.y,
            newPlayer.graphics.sprites:getWidth(),
            newPlayer.graphics.sprites:getHeight()
        )
        newPlayer.graphics.animation = game.animation.newAnimation(
            newPlayer.graphics.grid("1-6", 1),
            0.05
        )
    end

    newPlayer.type = 'player'

    return setmetatable(newPlayer, self)
end

function Player:updatescore(points)
    self.score = self.score + points
end

function Player:collide(other)
    if other.type == 'asteroid' then
        game:gameover()
    end
end

function collideBetween(object1, object2)
    local my_left_overlaps_their_right = object1.left <= object2.right and object1.right >= object2.right
    local my_right_overlaps_their_left = object1.right >= object2.left and object1.left <= object2.left

    local my_top_overlaps_their_bottom = object1.top <= object2.bottom and object1.bottom >= object2.bottom
    local my_bottom_overlaps_their_top = object1.bottom >= object2.top and object1.top <= object2.top

    return (my_left_overlaps_their_right or my_right_overlaps_their_left) and
             (my_top_overlaps_their_bottom or my_bottom_overlaps_their_top)
end

function Player:collidingWith(other)
    local bounds = self:bounds()
    local other = other:bounds()
    local safetyZone1 = { left = self.x, right = self.x + self.size.x*0.26, top = self.y, bottom = self.y + self.size.y*0.47 }
    local safetyZone2 = { left = self.x + self.size.x*0.26, right = self.x + self.size.x*0.26 + self.size.x*0.1, top = self.y, bottom = self.y + self.size.y*0.2 }
    local safetyZone3 = { left = self.x + self.size.x*0.36, right = self.x + self.size.x*0.36 + self.size.x*0.22, top = self.y, bottom = self.y + self.size.y*0.28 }
    local safetyZone4 = { left = self.x, right = self.x + self.size.x*0.18, top = self.y + self.size.y - self.size.y*0.15, bottom = self.y + self.size.y}
    local safetyZone5 = { left = self.x + self.size.x - self.size.x*0.25, right = self.x + self.size.x, top = self.y + self.size.y - self.size.y*0.21, bottom = self.y + self.size.y}
    local safetyZone6 = { left = self.x + self.size.x - self.size.x*0.29, right = self.x + self.size.x, top = self.y, bottom = self.y + self.size.y*0.5}

    return collideBetween(bounds,other) and not collideBetween(safetyZone1,other)
        and not collideBetween(safetyZone2,other) and not collideBetween(safetyZone3,other)
        and not collideBetween(safetyZone4,other) and not collideBetween(safetyZone5,other)
        and not collideBetween(safetyZone6,other)
end

function Player:update(dt)
    local dy = 0
    local dx = 0

    local canMoveUp = function()
      return self.y >= self.min_y + self.speed
    end

    local canMoveDown = function()
      return self.y <= self.max_y - self.size.y - self.speed
    end

    local canMoveLeft = function()
      return self.x >= self.min_x + self.speed
    end

    local canMoveRight = function()
      return self.x <= self.max_x - self.size.x - self.speed
    end

    if self.game.input.pressed(self.keys.up) then
        if (canMoveUp()) then
          dy = dy - self.speed
        end
    end

    if self.game.input.pressed(self.keys.down) then
        if (canMoveDown()) then
          dy = dy + self.speed
        end
    end

    if self.game.input.pressed(self.keys.shoot) then
        self.shoot()
    end

    self.lastPosition = {
        x = self.x,
        y = self.y
    }

    self.y = self.y + dy
    self.x = self.x + dx
    if self.shape then
      self.shape.y = self.shape.y + dy
      self.shape.x = self.shape.x + dx
    end



    if self.graphics.animation ~= nil then
        if dy ~= 0 or dx ~= 0  then
            self.graphics.animation:update(dt)
        else
            self.graphics.animation:gotoFrame(1)
        end
    end

    if self.sound.moving.sample ~= nil then
        if dy ~= 0 or dx ~= 0  then
            self.sound.moving.sample:play()
        else
            self.sound.moving.sample:stop()
        end
    end

end

function Player:shoot()
end

function Player:draw()
  self.game.graphics.draw(self.graphics.sprites, self.x, self.y, self.angle, self.sx, self.sy)
  if DEBUG_MODE then
      self.game.graphics.rectangle("line", self.x, self.y, self.size.x, self.size.y)
      self.game.graphics.rectangle("line", self.x, self.y, self.size.x*0.26, self.size.y*0.47)
      self.game.graphics.rectangle("line", self.x + self.size.x*0.26, self.y, self.size.x*0.1, self.size.y*0.2)
      self.game.graphics.rectangle("line", self.x + self.size.x*0.36, self.y, self.size.x*0.22, self.size.y*0.28)
      self.game.graphics.rectangle("line", self.x, self.y + self.size.y - self.size.y*0.15, self.size.x*0.18, self.size.y*0.15)
      self.game.graphics.rectangle("line", self.x + self.size.x - self.size.x*0.25, self.y + self.size.y - self.size.y*0.21, self.size.x*0.25, self.size.y*0.21)
      self.game.graphics.rectangle("line", self.x + self.size.x - self.size.x*0.29, self.y, self.size.x*0.29, self.size.y*0.5)
  end
  love.graphics.printf("Score: " .. self.score, love.window.getWidth() * 0.80, love.window.getHeight() * 0.015, 400, "left", 0, 1, 1.5)
end
