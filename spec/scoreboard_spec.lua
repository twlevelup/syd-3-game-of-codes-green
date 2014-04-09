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
          printf = spy.new(function() end),
          print = spy.new(function() end)
        }

        love.filesystem = {
          read = spy.new(function() end),
          write = spy.new(function() end),
          exists = spy.new(function() end)
        }

        top_scores = {
          30,20,10,7,6,5,4,3,2,2
        }
    end)

    describe("#comparescore", function()
      it("should return 10 scores", function()
        local result = comparescore(top_scores, 0)

        assert.is.equal(10, #result)
      end)

      it("should should put 40 at 1st place", function()
        local result = comparescore(top_scores, 40)

        assert.is.equal(40, result[1])
      end)

      it("should should put 10 at 4th place", function()
        local result = comparescore(top_scores, 10)

        assert.is.equal(10, result[4])
      end)

      it("should should not put 1 in top scores", function()
        local result = comparescore(top_scores, 1)

        assert.are.same(top_scores, result)
      end)
    end)

    describe("#update", function()
    end)

    describe("#draw", function()
      describe("Scoreboard", function()

        before_each(function()
          stub(json, "decode")
          comparescore = spy.new(function() end)
          Scoreboard:enter()
        end)

        it("should draw basic scoreboard", function()
          top_scores = {
            30,20,10,7,6,5,4,3,2,2
          }

          Scoreboard:draw()

          assert.spy(json.decode).was.called(1)
          assert.spy(love.filesystem.write).was.called(1)
          assert.spy(love.graphics.setColor).was.called(2)
          assert.spy(love.graphics.rectangle).was.called(1)
          assert.spy(love.graphics.printf).was.called(3)
          assert.spy(love.graphics.print).was.called(10)
        end)
      end)
    end)

    describe("#keyreleased", function()
      before_each(function()
        love.state = {
          switch = spy.new(function() end)
        }
      end)

      it("should do nothing by pressing a", function()
        Scoreboard:keyreleased('a')

        assert.spy(love.state.switch).was.called(0)
      end)

      it("should restart game by pressing space key", function()
        Scoreboard:keyreleased(' ')

        assert.spy(love.state.switch).was.called(1)
      end)
    end)
end)
