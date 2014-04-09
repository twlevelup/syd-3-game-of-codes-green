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

    it("should move its shape the same amount as it moves", function()
      local asteroid = Asteroid:new({})
      asteroid.shape = {
        x = asteroid.x,
        y = asteroid.y,
        size = {
          x = asteroid.size.x,
          y = asteroid.size.y
        }
      }
      local orig = {x = asteroid.x, y = asteroid.y}
      orig.shape = {x = asteroid.shape.x, y = asteroid.shape.y}

      asteroid:update(1)

      -- floating-point numbers can look equal but aren't equal
      local epsilon = 1e-10
      local diffx = math.abs((orig.x - asteroid.x) - (orig.shape.x - asteroid.shape.x))
      local diffy = math.abs((orig.y - asteroid.y) - (orig.shape.y - asteroid.shape.y))
      assert.is_true(diffx <= epsilon)
      assert.is_true(diffy <= epsilon)
    end)
  end)
end)
