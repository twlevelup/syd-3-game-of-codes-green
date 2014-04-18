require 'purple_cow'

describe("Purple Cow", function()
  describe("#update", function()
    it("should move left when its destination is to its left", function()
      local cow = PurpleCow:new({}, {x = 0, y = 0, to = {x = -100, y = 0}, speed = 10})
      cow:update(1)
      assert.is.equal(cow.x, -10)
    end)

    it("should move right when its destination is to its right", function()
      local cow = PurpleCow:new({}, {x = 0, y = 0, to = {x = 100, y = 0}, speed = 10})
      cow:update(1)
      assert.is.equal(cow.x, 10)
    end)

    it("should move vertically according to cosine pattern", function()
      local cow = PurpleCow:new({}, {x = 0, y = 0, to = {x = 0, y = -100}, speed = 10})
      cow:update(1)
      assert.is.equal(cow.y, 0 - cow.dy * 1 + math.cos(cow.x/100) * 4)
    end)


    it("should move its bbox the same amount as it moves", function()
      local cow = PurpleCow:new({})
      cow.bbox = {
        x = cow.x,
        y = cow.y,
        size = {
          x = cow.size.x,
          y = cow.size.y
        }
      }
      local orig = {x = cow.x, y = cow.y}
      orig.bbox = {x = cow.bbox.x, y = cow.bbox.y}

      cow:update(1)

      -- floating-point numbers can look equal but aren't equal
      local epsilon = 1e-10
      local diffx = math.abs((orig.x - cow.x) - (orig.bbox.x - cow.bbox.x))
      local diffy = math.abs((orig.y - cow.y) - (orig.bbox.y - cow.bbox.y))
      assert.is_true(diffx <= epsilon)
      assert.is_true(diffy <= epsilon)
    end)
  end)
end)
