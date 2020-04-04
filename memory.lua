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
        return {
            a = {
                peripheral = a,
                port_mode = "ddr",
                data = 0,
                ddr = 0x0,
                port = function(self, newValue)
                    if self.port_mode == "data" then
                        if newValue then
                            if self.peripheral then
                                self.data = bit.band(self.peripheral(newValue), self.direction_mask)
                            end
                        else
                            self.irq1 = false
                            self.irq2 = false
                            return bit.band(self.data, bit.bxor(self.ddr, 0xFF)) or 0
                        end
                    elseif self.port_mode == "ddr" then
                        if newValue then
                            self.ddr = newValue
                        else
                            return self.ddr
                        end
                    end
                end,
                control = function(self, bits)
                    if bits then
                        self.irq1_enabled = bit.band(bits, 0x01) ~= 0
                        --self.irq = bit.band(bits, 0x02) ~= 0
                        self.port_mode = bit.band(bits, 0x04) == 0 and "ddr" or "data"
                        --self.port_mode = bit.band(bits, 0x38) == 0 and "ddr" or "data"
                        --self.irq2 = bit.band(bits, 0x40) ~= 0
                        self.irq1 = bit.band(bits, 0x80) ~= 0
                    else
                        local control = self.irq1 and 1 or 0
                        control = bit.lshift(control, 1)
                        control = bit.bor(control, self.irq2 and 1 or 0)
                        control = bit.lshift(control, 3)
                        --control = bit.bor(control, self.port_mode == "data" and 1 or 0)
                        control = bit.lshift(control, 1)
                        control = bit.bor(control, self.port_mode == "data" and 1 or 0)
                        control = bit.lshift(control, 1)
                        control = bit.bor(control, self.irq1_invert and 1 or 0)
                        control = bit.lshift(control, 1)
                        control = bit.bor(control, self.irq1_enabled and 1 or 0)
                        return control
                    end
                end
            },
            b = {
                peripheral = b,
                port_mode = "ddr",
                data = 0,
                ddr = 0x0,
                port = function(self, newValue)
                    if self.port_mode == "data" then
                        if newValue then
                            if self.peripheral then
                                self.data = bit.band(self.peripheral(newValue), self.direction_mask)
                            end
                        else
                            self.irq1 = false
                            self.irq2 = false
                            return bit.band(self.data, bit.bxor(self.ddr, 0xFF)) or 0
                        end
                    elseif self.port_mode == "ddr" then
                        if newValue then
                            self.ddr = newValue
                        else
                            return self.ddr
                        end
                    end
                end,
                control = function(self, bits)
                    if bits then
                        self.irq1_enabled = bit.band(bits, 0x01) ~= 0
                        --self.irq = bit.band(bits, 0x02) ~= 0
                        self.port_mode = bit.band(bits, 0x04) == 0 and "ddr" or "data"
                        --self.port_mode = bit.band(bits, 0x38) == 0 and "ddr" or "data"
                        --self.irq2 = bit.band(bits, 0x40) ~= 0
                        self.irq1 = bit.band(bits, 0x80) ~= 0
                    else
                        local control = 1--self.irq1 and 1 or 0
                        control = bit.lshift(control, 1)
                        control = bit.bor(control, self.irq2 and 1 or 0)
                        control = bit.lshift(control, 3)
                        --control = bit.bor(control, self.port_mode == "data" and 1 or 0)
                        control = bit.lshift(control, 1)
                        control = bit.bor(control, self.port_mode == "data" and 1 or 0)
                        control = bit.lshift(control, 1)
                        control = bit.bor(control, self.irq1_invert and 1 or 0)
                        control = bit.lshift(control, 1)
                        control = bit.bor(control, self.irq1_enabled and 1 or 0)
                        return control
                    end
                end
            }
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
        elseif address == 0x8012 then
            return self.pia.b:port()
        elseif address == 0x8013 then
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
        elseif address == 0x8012 then
            self.pia.b:port(newValue)
        elseif address == 0x8013 then
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
