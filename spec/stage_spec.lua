require 'stage'

describe("stage", function()
    stage = nil

    local game = {
        graphics = {
            newImage = function(image) return image end        
        }
    }

    before_each(function()
        stage = Stage:new(game, {screenWidth = 640, bgWidth = 640, screenHeight = 640, bgHeight = 640})
    end)

    describe ("moving", function()
        it("should be moving left when updating", function() 
            stage.x = 0
            stage.speed = 1
            stage:update(1) 
            assert.is.equal(stage.x, -1)
        end)

        it("should not move up or down when updating", function() 
            stage.y = 0
            local orig_y = stage.y
            stage.speed = 1
            stage:update(1) 
            assert.is.equal(stage.y, orig_y)
        end)    

    end)
    describe ("scaling factor", function()
        it("should be screen width divided by image width", function()
          stage = Stage:new(game, {screenWidth = 640, bgWidth = 320, screenHeight = 320, bgHeight = 320})
          assert.is.equal(2, stage.sx)
        end)

        it("should be screen height divided by image height", function()
          stage = Stage:new(game, {screenHeight = 640, bgHeight = 320, screenWidth = 640, bgWidth = 320})
          assert.is.equal(2, stage.sy)
        end)
    end)
end)
