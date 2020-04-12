local function memory_module(startAddress, size)
    return setmetatable({
        startAddress = startAddress,
        size = size
    }, {
        __len = function(self) return self.size end, -- LuaJIT doesn't support this? :(
        __index = function() return 0 end -- TODO uninitialized?
    })
end

local function pia_port(peripheral)
    local self = {
        peripheral = peripheral,
        output_register = 0,
        ddr = 0x00,
        data_pins = 0,
        peripheral_pins = 0,
        input = 0,
        control = {
            irq1 = false,
            irq2 = false,
            c2 = {
                foo = false,
                bar = false,
                baz = false
            },
            ddr_access = false,
            c1 = {
                invert = false,
                enable = false
            }
        }
    }

    return setmetatable({}, {
        __index = function(_, poop)
            if poop == "irq" then
                return self.control.irq1 -- TODO choose IRQ
            elseif poop == "data" then
                if self.control.ddr_access then
                    return self.ddr
                else
                    self.control.irq1 = false
                    self.control.irq2 = false
                    --return bit.band(self.peripheral_pins, bit.band(bit.bnot(self.ddr), 0xFF)) -- TODO A?
                    return self.peripheral_pins -- TODO this is how B works?
                end
            elseif poop == "control" then
                local control = self.control.irq1 and 1 or 0
                control = bit.lshift(control, 1)
                control = bit.bor(control, self.control.irq2 and 1 or 0)
                control = bit.lshift(control, 3)
                -- TODO:
                --control = bit.bor(control, self.port_mode == "data" and 1 or 0)
                control = bit.lshift(control, 1)
                control = bit.bor(control, self.control.ddr_access and 0 or 1)
                control = bit.lshift(control, 1)
                control = bit.bor(control, self.control.c1.invert and 1 or 0)
                control = bit.lshift(control, 1)
                control = bit.bor(control, self.control.c1.enable and 1 or 0)
                return control
            end
        end,
        __newindex = function(_, poop, newValue)
            if poop == "c1" then
                if newValue then self.control.irq1 = true end
            elseif poop == "c2" then
                if newValue then self.control.irq2 = true end
            elseif poop == "control" then
                self.control.c1.enable = bit.band(newValue, 0x01) ~= 0
                self.control.c1.invert = bit.band(newValue, 0x02) ~= 0
                self.control.ddr_access = bit.band(newValue, 0x04) == 0
                -- TODO:
                --self.port_mode = bit.band(bits, 0x38) == 0 and "ddr" or "data"
            elseif poop == "p" then
                self.input = bit.band(newValue, 0xFF)
                self.peripheral_pins = bit.band(newValue, bit.band(bit.bnot(self.ddr), 0xFF))
                self.peripheral_pins = bit.bor(self.peripheral_pins, bit.band(self.output_register, self.ddr))
            elseif poop == "rs" then
                self:reset()
            elseif poop == "data" then
                if self.control.ddr_access then
                    self.ddr = bit.band(newValue, 0xFF)
                    self.peripheral_pins = bit.band(self.input, bit.band(bit.bnot(self.ddr), 0xFF))
                    self.peripheral_pins = bit.bor(self.peripheral_pins, bit.band(self.output_register, self.ddr))
                else
                    self.output_register = bit.band(newValue, 0xFF)
                    self.peripheral_pins = bit.band(self.input, bit.band(bit.bnot(self.ddr), 0xFF))
                    self.peripheral_pins = bit.bor(self.peripheral_pins, bit.band(self.output_register, self.ddr))
                end
            else
                return
            end
        end
    })
end

local function pia(a, b)
    return {
        a = pia_port(a),
        b = pia_port(b)
    }
end

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
            return self.pia.a.data -- TODO
        elseif address == 0x8011 then
            return self.pia.a.control
        elseif address == 0x8012 then
            return self.pia.b.data
        elseif address == 0x8013 then
            return self.pia.b.control
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
            self.pia.a.data = newValue
        elseif address == 0x8011 then
            self.pia.a.control = newValue
        elseif address == 0x8012 then
            self.pia.b.data = newValue
        elseif address == 0x8013 then
            self.pia.b.control = newValue
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