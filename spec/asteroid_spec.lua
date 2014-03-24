require 'asteroid'

describe("Asteroid", function()
  describe("#update", function()
    it("should move left when it's speed is positive", function()
      local asteroid = Asteroid:new({}, {x = 0, y = 0, speed = 10})
      asteroid:update(1)
      assert.is.equal(asteroid.x, -10)
    end)

    it("should move right when it's speed is negative", function()
      local asteroid = Asteroid:new({}, {x = 0, y = 0, speed = -10})
      asteroid:update(1)
      assert.is.equal(asteroid.x, 10)
    end)

    it("should move left by it's speed times the time that passed", function()
      local asteroid = Asteroid:new({}, {x = 0, y = 0, speed = 10})
      asteroid:update(10)
      assert.is.equal(asteroid.x, -(10 * 10))
    end)
  end)
end)
