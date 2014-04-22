BoundingBoxes = {}
BoundingBoxes.__index = BoundingBoxes

function BoundingBoxes:new(entity, config)
    local newBboxes = {}

    newBboxes.boxes = {}
    newBboxes.entity = entity
    newBboxes.sx = entity.sx or 1
    newBboxes.sy = entity.sy or 1
    for i = 1, #config do
        newBboxes.boxes[i] = Entity:new()
        newBboxes.boxes[i].left = config[i].left * newBboxes.sx
        newBboxes.boxes[i].right = config[i].right * newBboxes.sx
        newBboxes.boxes[i].top = config[i].top * newBboxes.sy
        newBboxes.boxes[i].bottom = config[i].bottom * newBboxes.sy
        newBboxes.boxes[i].x = entity.x + config[i].left
        newBboxes.boxes[i].y = entity.y + config[i].top
        newBboxes.boxes[i].size = {
            x = newBboxes.boxes[i].right - newBboxes.boxes[i].left,
            y = newBboxes.boxes[i].bottom - newBboxes.boxes[i].top
        }
    end

    entity.bounds = function(self)
        bounds = {}

        for i = 1, #self.bboxes.boxes do
            bounds[i] = self.bboxes.boxes[i]:bounds()
        end

        return bounds
    end

    return setmetatable(newBboxes, self)
end

function BoundingBoxes:update()
    for i = 1, #self.boxes do
        self.boxes[i].x = self.entity.x + self.boxes[i].left
        self.boxes[i].y = self.entity.y + self.boxes[i].top
    end
end
