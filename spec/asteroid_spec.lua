require 'asteroid'

describe("Asteroid", function()
  describe("#update", function()
    it("should move left when its destination is to its left", function()
      local asteroid = Asteroid:new({}, {x = 0, y = 0, to = {x = -100, y = 0}, speed = 10})
      asteroid:update(1)
      assert.is.equal(asteroid.x, -10)
    end)

    it("should move right when its destination is to its right", function()
      local asteroid = Asteroid:new({}, {x = 0, y = 0, to = {x = 100, y = 0}, speed = 10})
      asteroid:update(1)
      assert.is.equal(asteroid.x, 10)
    end)

    it("should move up when its destination is above it", function()
      local asteroid = Asteroid:new({}, {x = 0, y = 0, to = {x = 0, y = -100}, speed = 10})
      asteroid:update(1)
      assert.is.equal(asteroid.y, -10)
    end)

    it("should move down when its destination is below it", function()
      local asteroid = Asteroid:new({}, {x = 0, y = 0, to = {x = 0, y = 100}, speed = 10})
      asteroid:update(1)
      assert.is.equal(asteroid.y, 10)
    end)
  end)
end)
