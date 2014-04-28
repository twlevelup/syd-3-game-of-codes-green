require 'bullet'

describe('Bullet', function()
    describe('#update', function()
        it('should move from left to right when its speed is positive', function()
            local bullet = Bullet:new({}, {x = 0, y = 0, x2 = 100, y2 = 0, speed = 100})
            bullet:update(1)
            assert.is.equal(bullet.x, 100)
        end)

        it('should update its x and x2 the same amount', function()
            local bullet = Bullet:new({}, {x = 0, y = 0, x2 = 100, y2 = 0, speed = 100})
            local orig_x = bullet.x
            local orig_x2 = bullet.x2

            bullet:update(1)
            assert.is.equal(orig_x-bullet.x, orig_x2-bullet.x2)
        end)
    end)
end)
