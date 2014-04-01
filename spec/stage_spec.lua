require 'stage'

describe("stage", function()
    local stage

    local game = {
        graphics = {
            newImage = function(image) return image end        
        }
    }

    before_each(function()
        stage = Stage:new(game, {screenWidth = 640, bgWidth = 640})
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
end)
