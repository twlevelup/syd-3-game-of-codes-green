love = {}

require 'entity'
require 'scoreboard'

describe("Scorboard", function()

    setup(function()
        love.window = {
          getWidth = spy.new(function() return 800 end),
          getHeight = spy.new(function() return 600 end)
        }
        
        love.graphics = {
          setColor = spy.new(function() end),
          rectangle = spy.new(function() end),
          printf = spy.new(function() end)
        }
    end)

    describe("#update", function()
    end)

    describe("#draw", function()
      describe("Scoreboard", function()

        before_each(function()
          Scoreboard:enter()
        end)

        it("should draw basic scoreboard", function()

          Scoreboard:draw()

          assert.spy(love.graphics.setColor).was.called(2)
          assert.spy(love.graphics.rectangle).was.called(1)
          assert.spy(love.graphics.printf).was.called(1)
        end)
      end)
    end)

    describe("#keyreleased", function()
      before_each(function()
        love.state = {
          switch = spy.new(function() end)
        }
      end)

      it("pressing a key", function()
        Scoreboard:keyreleased('a')

        assert.spy(love.state.switch).was.called(0)
      end)

      it("pressing space key", function()
        Scoreboard:keyreleased(' ')

        assert.spy(love.state.switch).was.called(1)
      end)
    end)
end)