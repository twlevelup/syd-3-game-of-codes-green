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
    newPlayer.size = config.size or {
        x = 98,
        y = 60
    }

    newPlayer.speed = config.speed or 5

    newPlayer.keys = config.keys or {
        up = "up",
        down = "down",
        left = "left",
        right = "right"
    }

    newPlayer.graphics = config.graphics or {
        source = "assets/images/nyancat-sprites.png",
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

    return setmetatable(newPlayer, self)
end

function Player:collide(other)
    self.x = self.lastPosition.x
    self.y = self.lastPosition.y
end

function Player:update(dt)
    local dy = 0

    local canMoveUp = function()
      return self.y >= self.min_y + self.speed
    end

    local canMoveDown = function()
      return self.y <= self.max_y - self.size.y - self.speed
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

    self.lastPosition = {
        x = self.x,
        y = self.y
    }

    self.y = self.y + dy

    if self.graphics.animation ~= nil then
        if dy ~= 0 then
            self.graphics.animation:update(dt)
        else
            self.graphics.animation:gotoFrame(1)
        end
    end

    if self.sound.moving.sample ~= nil then
        if dy ~= 0 then
            self.sound.moving.sample:play()
        else
            self.sound.moving.sample:stop()
        end
    end
end
