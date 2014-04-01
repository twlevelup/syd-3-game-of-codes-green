require 'entity'
require 'fuel_tank'

describe("Fuel Tank", function()

    describe("#update", function()
      describe("fuel consumption", function()
            it("should start full tank of fuel", function()
              local fuel_tank = Fuel_tank:new()

              assert.is.equal(fuel_tank:get_fuel(), 100)

            end)

            it("should drain fuel", function()
              local fuel_tank = Fuel_tank:new()

              fuel_tank:update(1)

              assert.is.equal(fuel_tank:get_fuel(), 99)
            end)

            it("should run out of fuel", function()
              local fuel_tank = Fuel_tank:new()

              assert.is.equal(fuel_tank:is_empty(), false)

              fuel_tank:update(100)

              assert.is.equal(fuel_tank:is_empty(), true)
            end)

        end)

    end)

    describe("#draw", function()

      mock_graphics = function()
            local graphics_spy = {
                rectangle = spy.new(function() end)
            }
            return graphics_spy
      end

      describe("fuel tank display", function()
            it("should draw a rectangle", function()
              local fuel_tank = Fuel_tank:new({})

              fuel_tank.game.graphics = mock_graphics()

              fuel_tank:draw()

              assert.spy(fuel_tank.game.graphics.rectangle).was.called(1)

            end)
        end)
    end)
end)