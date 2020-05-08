return function(rom)
    return setmetatable({}, {
        __index = rom,
        __newindex = function(_, address, newValue)
            print("Attempted write at ROM address " .. string.format("%04X", address) .. " with value " .. newValue)
        end
    })
end