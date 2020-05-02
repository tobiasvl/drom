return function(startAddress, length, initial_value)
    local self = {
        startAddress = startAddress,
        size = length,
        memory = {},
        initialized = setmetatable({}, {
            __index = function() return false end
        })
    }
    for i = 0, length - 1 do
        self.memory[i] = initial_value or love.math.random(0, 255)
    end
    return setmetatable(self, {
        __index = self.memory,
        __newindex = function(self, address, value)
            self.memory[address] = value
            self.initialized[address] = true
        end
    })
end