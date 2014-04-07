require 'player'
require 'entity'

describe("Player", function()
    local dt = 1

    describe("#update", function()
        mock_input = function(action)
            return {
                input = {
                    pressed = function(a)
                        if a == action then
                            return true
                        else
                            return false
                        end
                    end
                }
            }
        end

        mock_animation = function()
            local animation_spy = {
                update = spy.new(function(dt) end),
                flipH = spy.new(function() end),
                gotoFrame = spy.new(function() end)
            }

            return animation_spy
        end

        mock_sound = function()
            local sound_spy = {
                play = spy.new(function() end),
                stop = spy.new(function() end)
            }

            return sound_spy
        end

        isVisible = function(player)
          return player.y <= player.max_y - player.size.y
        end

        describe("playing the movement sound", function()
            it("should play the movement sound when the player is moving", function()
                local player = Player:new(mock_input('up'))
                player.sound.moving.sample = mock_sound()
                player:update(dt)

                assert.spy(player.sound.moving.sample.play).was.called()
            end)

            it("should stop playing the movement sound when the player is stationary", function()
                local player = Player:new(mock_input('none'))
                player.sound.moving.sample = mock_sound()
                player:update(dt)

                assert.spy(player.sound.moving.sample.stop).was.called()
            end)
        end)

        describe("lastPosition", function()
            it("should store the last position before moving vertically", function()
                orig_x = 10
                orig_y = 10
                local player = Player:new(
                    mock_input('up'),
                    {
                        x = orig_x,
                        y = orig_y,
                        speed = 1
                    }
                )
                player:update(dt)

                assert.is.equal(player.x, 10)
                assert.is.equal(player.y, 9)
                assert.are.same(player.lastPosition, {x = orig_x, y = orig_y})
            end)
        end)

        describe("animating the player", function()
            describe("the sprite direction", function()
                it("should point to the right by default", function()
                    local player = Player:new(mock_input('none'))
                    assert.is.equal(player.graphics.facing, "right")
                end)
            end)

            describe("the animation frame", function()
                it("should stop updating when the player isn't moving", function()
                    local player = Player:new(mock_input('none'))
                    player.graphics.animation = mock_animation()
                    player:update(dt)

                    assert.spy(player.graphics.animation.gotoFrame).was.called()
                    assert.spy(player.graphics.animation.update).was_not.called()
                end)

                it("should update the animation state when the player is moving", function()
                    local player = Player:new(mock_input('up'))
                    player.graphics.animation = mock_animation()

                    player:update(dt)

                    assert.spy(player.graphics.animation.update).was.called()
                end)
            end)
        end)

        describe("collide", function()
            local player, collidingEntity

            before_each(function()
                player = Player:new({})
                player.size = {
                    x = 10,
                    y = 10
                }
                player.x = 20
                player.y = 10
                player.graphics.animation = mock_animation()

                collidingEntity = Entity:new({})
                collidingEntity.x = 10
                collidingEntity.y = 10
                collidingEntity.size = {
                    x = 10,
                    y = 10
                }
            end)

            it("should end the game when colliding with an asteroid on the left side", function()
                player.lastPosition = {x = 21, y = 10}
                collidingEntity.type = 'asteroid'
                gameover = spy.new(function() end)

                player:collide(collidingEntity)

                assert.spy(gameover).was.called()
            end)

            it("should end the game when colliding with an asteroid on the right side", function()
                player.lastPosition = {x = 9, y = 10}
                collidingEntity.type = 'asteroid'
                gameover = spy.new(function() end)

                player:collide(collidingEntity)

                assert.spy(gameover).was.called()
            end)

            it("should end the game when colliding with an asteroid on the top side", function()
                player.lastPosition = {x = 10, y = 11}
                collidingEntity.type = 'asteroid'
                gameover = spy.new(function() end)

                player:collide(collidingEntity)

                assert.spy(gameover).was.called()
            end)

            it("should end the game when colliding with an asteroid on the bottom side", function()
                player.lastPosition = {x = 10, y = 9}
                collidingEntity.type = 'asteroid'
                gameover = spy.new(function() end)

                player:collide(collidingEntity)

                assert.spy(gameover).was.called()
            end)
        end)

        describe("player shooting",function()
            it("should shoot a bullet when the z key is pressed", function( )
                local player = Player:new(mock_input('z'))
                player.shoot = spy.new(function() end)

                player:update(1)
                assert.spy(player.shoot).was.called(1)
            end)
        end)

        describe("player movement", function()
            it("should decrement the player's y if the up-arrow is pressed", function()
                local player = Player:new(mock_input('up'))
                local orig_y = player.y

                player:update(dt)

                assert.is.equal(orig_y - player.speed, player.y)
            end)

            it("should increment the player's y if the down-arrow is pressed", function()
                local player = Player:new(mock_input('down'))
                local orig_y = player.y

                player:update(dt)

                assert.is.equal(orig_y + player.speed, player.y)
            end)

            it("should not decrement the player's x if the left-arrow is pressed", function()
                local player = Player:new(mock_input('left'))
                player.graphics.animation = mock_animation()
                local orig_x = player.x

                player:update(dt)

                assert.is.equal(orig_x, player.x)
            end)

            it("should not increment the player's x if the right-arrow is pressed", function()
                local player = Player:new(mock_input('right'))
                local orig_x = player.x

                player:update(dt)

                assert.is.equal(orig_x, player.x)
            end)

            it("should not run off the top of the screen", function ()
              local player = Player:new(mock_input('up'))
              player.min_y = 0
              player.y = player.min_y
              local orig_y = player.y

              player:update(dt)

              assert.is.equal(orig_y, player.y)
              assert.is_true(isVisible(player))
            end)

            it("should not run off the bottom of the screen", function ()
              local player = Player:new(mock_input('down'))
              player.max_y = 100
              player.size = {
                  y = 10
              }
              player.y = player.max_y - player.size.y
              local orig_y = player.y

              player:update(dt)

              assert.is.equal(orig_y, player.y)
              assert.is_true(isVisible(player))
            end)
        end)

        describe("Score", function()
            it("should start with 0", function()
                local player = Player:new({})

                assert.is.equal(0, player.score)
            end)
        end)
    
    end)
end)
