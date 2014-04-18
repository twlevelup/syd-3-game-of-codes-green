require 'entity'
require 'fuel_tank'

describe("Fuel Tank", function()
    mock_graphics = function()
          local graphics_spy = {
              rectangle = spy.new(function() end)
          }
          return graphics_spy
    end

    before_each(function()
      fuel_tank = Fuel_tank:new()
    end)

    describe("#update", function()
      before_each(function()
        Runner.gameover = spy.new(function() end)
      end)

      describe("fuel consumption", function()
            it("should start full tank of fuel", function()

              assert.is.equal(30, fuel_tank:get_fuel())

            end)

            it("should drain fuel", function()
              fuel_tank:update(1)

              assert.is.equal(29, fuel_tank:get_fuel())
            end)

            it("should run out of fuel", function()
              assert.is.equal(false, fuel_tank:is_empty())

              fuel_tank:update(30)

              assert.is.equal(true, fuel_tank:is_empty())
            end)

            it("should end the game when fuel reach 0", function()
              fuel_tank.fuel = 1

              fuel_tank:update(1)

              assert.spy(Runner.gameover).was.called(1)
              assert.is.equal(true, fuel_tank:is_empty())
            end)

            it("should not drop below 0", function()
              fuel_tank.fuel = 0

              fuel_tank:update(1)

              assert.is.equal(0, fuel_tank:get_fuel())
              assert.is.equal(true, fuel_tank:is_empty())
            end)
        end)
    end)

    describe("#draw", function()

      describe("fuel tank display", function()
            it("should draw a rectangle", function()
              love.graphics = mock_graphics()

              fuel_tank:draw()

              assert.spy(love.graphics.rectangle).was.called(2)

            end)
        end)
    end)
end)
