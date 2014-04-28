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
    end)

    describe('#collide', function()
        it('should collide with bullets', function()
            local purplecow = PurpleCow:new({}, {x = 0, y = 0, size = {x = 100, y = 100}})
            local bullet = Bullet:new({}, {x = 0, y = 0, x2 = 100, y2 = 0, speed = 100})
            Runner.entities = {purplecow, bullet}
            Runner.player = {updatescore = spy.new(function(self) end)}

            purplecow:collide(bullet)
            assert.spy(Runner.player.updatescore).was.called(1)
        end)
    end)
end)
