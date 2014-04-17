love = {}


require 'entity'
require 'runner'

describe("Runner", function() 

  describe("#keyreleased", function()
    it("should pause the game when space is pressed", function()
      love.state.push = spy.new(function() end)

      Runner:keyreleased(' ')

      assert.spy(love.state.push).was.called(1)
    end)

  end)  

end)