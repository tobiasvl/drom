local memory = setmetatable({
    memory_map = {},
    ram = nil, -- TODO very ugly, just for checking initialized memory
    breakpoint = {
        address = nil,
        read = false,
        write = false
    },
    connect = function(self, startAddress, module)
        self.memory_map[{
            startAddress,
            module.size
        }] = module
        -- TODO ugly hack
        if startAddress == 0 then
            rawset(self, "ram", module)
        end
    end
}, {
    __index = function(self, address)
        if address == "initialized" then
            return self.ram.initialized
        end
        if address == self.breakpoint.address and self.breakpoint.read then
            self.cpu.pause = true
        end
        for addresses, module in pairs(self.memory_map) do
            if address >= addresses[1] and address < addresses[1] + addresses[2] then
                return module[address - addresses[1]]
            end
        end
        --print("Attempted read at unmapped address " .. string.format("%04X", address))
        return 0
    end,
    __newindex = function(self, address, newValue)
        if address == self.breakpoint.address and self.breakpoint.write then
            self.cpu.pause = true
        end
        for addresses, module in pairs(self.memory_map) do
            if address >= addresses[1] and address < addresses[1] + addresses[2] then
                module[address - addresses[1]] = newValue
                return
            end
        end
        --print("Attempted write at unmapped address " .. string.format("%04X", address) .. " with value " .. newValue)
    end,
    __len = function(self) return self.eprom.startAddress + self.eprom.size end -- LuaJIT doesn't support this? :(
})

return memory