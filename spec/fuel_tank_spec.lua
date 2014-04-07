require 'entity'
require 'fuel_tank'

describe("Fuel Tank", function()

    describe("#update", function()
      mock_gameover = function()
            local gameover_spy = spy.new(function() end)
            return gameover_spy
      end

      describe("fuel consumption", function()
            it("should start full tank of fuel", function()
              local fuel_tank = Fuel_tank:new()

              assert.is.equal(60, fuel_tank:get_fuel())

            end)

            it("should drain fuel", function()
              local fuel_tank = Fuel_tank:new()

              fuel_tank:update(1)

              assert.is.equal(59, fuel_tank:get_fuel())
            end)

            it("should run out of fuel", function()
              local fuel_tank = Fuel_tank:new()

              assert.is.equal(false, fuel_tank:is_empty())

              fuel_tank:update(60)

              assert.is.equal(true, fuel_tank:is_empty())
            end)

            it("should end the game when fuel reach 0", function()
              local fuel_tank = Fuel_tank:new()
              fuel_tank.fuel = 1
              gameover = mock_gameover()

              fuel_tank:update(1)

              assert.spy(gameover).was.called(1)
              assert.is.equal(true, fuel_tank:is_empty())
            end)

            it("should not drop below 0", function()
              local fuel_tank = Fuel_tank:new()
              fuel_tank.fuel = 0

              fuel_tank:update(1)

              assert.is.equal(0, fuel_tank:get_fuel())
              assert.is.equal(true, fuel_tank:is_empty())
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

              assert.spy(fuel_tank.game.graphics.rectangle).was.called(2)

            end)
        end)
    end)
end)