return function(length, initial_value)
    local self = {
        size = length,
        memory = {},
        initialized = setmetatable({}, {
            __index = function() return false end
        }),
        set_uninitialized_value = function(self, initial_value)
            self.uninitialized_random = not initial_value
            for i = 0, length - 1 do
                if not self.initialized[i] then
                    self.memory[i] = initial_value or love.math.random(0, 255)
                end
            end
        end
    }
    self:set_uninitialized_value(initial_value)
    return setmetatable(self, {
        __index = self.memory,
        __newindex = function(self, address, value)
            self.memory[address] = value
            self.initialized[address] = true
        end
    })
end