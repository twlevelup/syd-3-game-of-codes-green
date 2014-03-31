require 'asteroid'

describe("Asteroid", function()
  describe("#update", function()
    it("should move left when its horizontal speed is positive", function()
      local asteroid = Asteroid:new({}, {x = 0, y = 0, speed = {x = 10, y = 0}})
      asteroid:update(1)
      assert.is.equal(asteroid.x, -10)
    end)

    it("should move right when its horizontal speed is negative", function()
      local asteroid = Asteroid:new({}, {x = 0, y = 0, speed = {x = -10, y = 0}})
      asteroid:update(1)
      assert.is.equal(asteroid.x, 10)
    end)

    it("should move down when its vertical speed is positive", function()
      local asteroid = Asteroid:new({}, {x = 0, y = 0, speed = {x = 0, y = 10}})
      asteroid:update(1)
      assert.is.equal(asteroid.y, -10)
    end)

    it("should move up when its vertical speed is negative", function()
      local asteroid = Asteroid:new({}, {x = 0, y = 0, speed = {x = 0, y = -10}})
      asteroid:update(1)
      assert.is.equal(asteroid.y, 10)
    end)

    it("should move left by its horizontal speed multiplied by the time that passed",
    function()
      local asteroid = Asteroid:new({}, {x = 0, y = 0, speed = {x = 10, y = 0}})
      asteroid:update(10)
      assert.is.equal(asteroid.x, -(10 * 10))
    end)

    it("should move down by its horizontal speed multiplied by the time that passed", function()
      local asteroid = Asteroid:new({}, {x = 0, y = 0, speed = {x = 0, y = 10}})
      asteroid:update(10)
      assert.is.equal(asteroid.y, -(10 * 10))
    end)
  end)
end)
