local memory_module = setmetatable({}, {
    __call = function(self, startAddress, size)
        return setmetatable({
            startAddress = startAddress,
            size = size
        }, {
            __len = function(self) return self.size end, -- LuaJIT doesn't support this? :(
            __index = function() return 0 end -- TODO uninitialized?
        })
    end,
})

local pia = setmetatable({}, {
    __call = function(self, a, b)
        local pia_port = setmetatable({}, {
            __call = function(self, peripheral)
                return {
                    peripheral = peripheral,
                    port_mode = "ddr", -- data
                    direction_mask = 0x0,
                    port = function(self, newValue)
                        if self.port_mode == "data" then -- TODO what is self?
                            if newValue then
                                if self.peripheral then
                                    bit.band(self.peripheral(newValue), self.direction_mask)
                                end
                            else
                                self.irq1 = false
                                self.irq2 = false
                                return self.peripheral and bit.band(self.peripheral(), bit.bxor(self.direction_mask)) or 0
                            end
                        elseif self.port_mode == "ddr" then
                            if newValue then
                                self.direction_mask = newValue
                            else
                                return self.direction_mask
                            end
                        end
                    end,
                    control = function(self, bits)
                        if bits then
                            self.irq1_enabled = bit.band(bits, 0x01) ~= 0
                            --self.irq = bit.band(bits, 0x02) ~= 0
                            self.port_mode = bit.band(bits, 0x04) == 0 and "ddr" or "data"
                            --self.port_mode = bit.band(bits, 0x38) == 0 and "ddr" or "data"
                            self.irq1 = bit.band(bits, 0x40) ~= 0
                            self.irq2 = bit.band(bits, 0x80) ~= 0
                        else
                            return 1 -- TODO ?
                        end
                    end
                }
            end
        })
        return {
            a = pia_port(a),
            b = pia_port(b)
        }
    end,
})

local memory = setmetatable({
    ram = memory_module(0x0000, 0x0FFF),
    eprom = memory_module(0xC000, 0x0400),
    pia = pia(),
    breakpoint = {
        address = nil,
        read = false,
        write = false
    },
}, {
    __index = function(self, address)
        if address == self.breakpoint.address and self.breakpoint.read then
            self.cpu.pause = true
        end
        
        if address < 0x0FFF then
            return self.ram[address - self.ram.startAddress]
        elseif address == 0x8010 then
            return self.pia.a:port()
        elseif address == 0x8011 then
            return self.pia.a:control()
        elseif address == 0x8020 then
            return self.pia.b:port()
        elseif address == 0x8021 then
            return self.pia.b:control()
        elseif address >= 0xC000 and address < 0xC400 then
            return self.eprom[address - self.eprom.startAddress]
        else
            --print("Attempted read at unmapped address " .. string.format("%04X", address))
            return 0
        end
    end,
    __newindex = function(self, address, newValue)
        if address == self.breakpoint.address and self.breakpoint.write then
            self.cpu.pause = true
        end

        if address < 0x0FFF then
            rawset(self.ram, address, bit.band(newValue, 0xFF))
        elseif address == 0x8010 then
            self.pia.a:port(newValue)
        elseif address == 0x8011 then
            self.pia.a:control(newValue)
        elseif address == 0x8020 then
            self.pia.b:port(newValue)
        elseif address == 0x8021 then
            self.pia.b:control(newValue)
        elseif address >= 0xC000 and address < 0xC400 then
            print("Attempted write at ROM address " .. string.format("%04X", address) .. " with value " .. newValue)
            self.eprom[address - self.eprom.startAddress] = newValue
        else
            --print("Attempted write at unmapped address " .. string.format("%04X", address) .. " with value " .. newValue)
        end
    end,
    __len = function() return self.eprom.startAddress + self.eprom.size end -- LuaJIT doesn't support this? :(
})

return memory