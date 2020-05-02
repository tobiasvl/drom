return function(file)
    local self = {}
    local address = 0
    while (not file:isEOF()) do 
        local byte, len = file:read(1)
        -- Dropped files don't seem to report EOF
        if len ~= 1 or not string.byte(byte) then
            break
        end
        self[address] = string.byte(byte)
        address = address + 1
    end
    self.size = address
    return setmetatable(self, {
        __newindex = function(_, address, newValue)
            print("Attempted write at ROM address " .. string.format("%04X", address) .. " with value " .. newValue)
            --return
        end
    })
end