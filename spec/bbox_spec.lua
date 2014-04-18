require 'bbox'

describe("Bbox", function()
    local dt = 1

    before_each(function()
        e1 = Entity:new({})
        e1.x, e1.y, e1.size = 0, 0, {x = 10, y = 10}
        e2 = Entity:new({})
        e2.x, e2.y, e2.size = 0, 0, {x = 10, y = 10}
    end)

    describe('#new', function()
        it('should have one box with its position relative to the entity', function()
            local bboxes = BoundingBoxes:new(e1, {{left = 10, bottom = 20, top = 10, right = 20}})

            assert.is.equal(10, bboxes.boxes[1].x)
            assert.is.equal(10, bboxes.boxes[1].y)
        end)

        it('should have multiple boxes with their position relative to an entity', function()
            local bboxes = BoundingBoxes:new(e1, {
                {left = 10, bottom = 20, top = 10, right = 20},
                {left = 10, bottom = 20, top = 10, right = 20}
            })

            for i = 1, #bboxes do
                assert.is.equal(10, bboxes.boxes[i].x)
                assert.is.equal(10, bboxes.boxes[i].y)
            end
        end)
    end)

    describe('#collidingWith', function()
        it('should collide with another entity without a bounding box', function()
            e1.bboxes = BoundingBoxes:new(e1, {{left = 0, bottom = 10, top = 0, right = 10}})

            assert.is_true(e1:collidingWith(e2))
        end)

        it('should collide with another entity with a bounding box', function()
            e1.bboxes = BoundingBoxes:new(e1, {{left = 0, bottom = 10, top = 0, right = 10}})
            e2.bboxes = BoundingBoxes:new(e2, {{left = 0, bottom = 10, top = 0, right = 10}})

            assert.is_true(e1:collidingWith(e2))
        end)

        it('should have all its boundings boxes collide with another entity without a bounding box', function()
            e1.bboxes = BoundingBoxes:new(e1, {
                {left = 2.5, bottom = 7.5, top = 2.5, right = 7.5},
                {left = 0, bottom = 10, top = 0, right = 10}
            })

            assert.is_true(e1:collidingWith(e2))
        end)

        it('should have all its boundings boxes collide with another entity with one bounding box', function()
            e1.bboxes = BoundingBoxes:new(e1, {
                {left = 2.5, bottom = 7.5, top = 2.5, right = 7.5},
                {left = 0, bottom = 10, top = 0, right = 10}
            })

            e2.bboxes = BoundingBoxes:new(e2, {
                {left = 0, bottom = 10, top = 0, right = 10}
            })

            assert.is_true(e1:collidingWith(e2))
        end)

        it('should have all its boundings boxes collide with another entity with multiple bounding box', function()
            e1.bboxes = BoundingBoxes:new(e1, {
                {left = 2.5, bottom = 7.5, top = 2.5, right = 7.5},
                {left = 0, bottom = 10, top = 0, right = 10}
            })

            e2.bboxes = BoundingBoxes:new(e2, {
                {left = 2.5, bottom = 7.5, top = 2.5, right = 7.5},
                {left = 0, bottom = 10, top = 0, right = 10}
            })

            assert.is_true(e1:collidingWith(e2))
        end)
    end)

    describe('#update', function()
        it('should move a box with its entity', function()
            local bboxes = BoundingBoxes:new(e1, {{left = 10, bottom = 20, top = 10, right = 20}})
            local origx = bboxes.boxes[1].x
            local origy = bboxes.boxes[1].y

            e1.x = 10
            e1.y = 10
            bboxes:update()

            assert.is.equal(20, bboxes.boxes[1].x)
            assert.is.equal(20, bboxes.boxes[1].y)
        end)


        it('should move all its boxes with its entity', function()
            local bboxes = BoundingBoxes:new(e1, {
                {left = 10, bottom = 20, top = 10, right = 20},
                {left = 10, bottom = 20, top = 10, right = 20}
            })

            local origx, origy = {}, {}
            for i = 1, #bboxes do
                origx[i] = bboxes.boxes[i].x
                origy[i] = bboxes.boxes[i].y
            end

            e1.x = 10
            e1.y = 10
            bboxes:update()

            for i = 1, #bboxes do
                assert.is.equal(20, bboxes.boxes[i].x)
                assert.is.equal(20, bboxes.boxes[i].y)
            end
        end)
    end)
end)
