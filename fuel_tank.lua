require 'input'
require 'entity'

Fuel_tank = {}
Fuel_tank.__index = Fuel_tank
setmetatable(Fuel_tank, {__index = Entity})

function Fuel_tank:new(love, config)
    local config = config or {}
    local new_fuel_tank = Entity:new(love)
    new_fuel_tank.max_fuel = 30
    new_fuel_tank.fuel = config.fuel or new_fuel_tank.max_fuel
    new_fuel_tank.x = config.x or 20
    new_fuel_tank.y = config.y or 10
    new_fuel_tank.size = config.size or {
        x = 500,
        y = 15
    }


    return setmetatable(new_fuel_tank, self)
end

function Fuel_tank:get_fuel()
    return self.fuel
end

function Fuel_tank:is_empty()
    if self.fuel > 0 then
        return false
    else 
        return true
    end
end

function Fuel_tank:update(dt)
    if self.fuel > 0 then
        self.fuel = self.fuel - dt
    else
        self.fuel = 0
    end

    if self:is_empty() then
        game:gameover()
    end
end

function Fuel_tank:draw()
    love.graphics.rectangle("line", self.x, self.y, self.size.x, self.size.y)
    love.graphics.rectangle("fill", self.x, self.y, self.size.x * (self.fuel / self.max_fuel), self.size.y)
end