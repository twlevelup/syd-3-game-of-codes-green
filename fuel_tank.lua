require 'input'
require 'entity'

Fuel_tank = {}
Fuel_tank.__index = Fuel_tank
setmetatable(Fuel_tank, {__index = Entity})

function Fuel_tank:new(game, config)
    local config = config or {}
    local new_fuel_tank = Entity:new(game)
    new_fuel_tank.fuel = config.fuel or 100
    new_fuel_tank.size = config.size or {
        x = 600,
        y = 60
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
    self.fuel = self.fuel - dt
end

function Fuel_tank:draw()
    self.game.graphics.rectangle("line", self.x, self.y, self.size.x, self.size.y)
end