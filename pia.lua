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

--local function pia(a, b)
    return {
        a = pia_port(a),
        b = pia_port(b)
    }
--end