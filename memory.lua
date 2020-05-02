
local memory = setmetatable({
    ram = require "ram"(0x0000, 0x0FFF),
    eprom = require "eprom",
    pia = require "pia",
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

        -- TODO make this prettier
        if address == "initialized" then
            return self.ram.initialized
        elseif address < 0x0FFF then
            return self.ram[address - self.ram.startAddress]
        elseif address == 0x8010 then
            return self.pia.a.data
        elseif address == 0x8011 then
            return self.pia.a.control
        elseif address == 0x8012 then
            return self.pia.b.data
        elseif address == 0x8013 then
            return self.pia.b.control
        elseif address >= 0xC000 and address < 0xC400 then
            return self.eprom[address - self.eprom.startAddress]
        else
            print("Attempted read at unmapped address " .. string.format("%04X", address))
            return 0
        end
    end,
    __newindex = function(self, address, newValue)
        if address == self.breakpoint.address and self.breakpoint.write then
            self.cpu.pause = true
        end

        if address < 0x0FFF then
            self.ram[address] = bit.band(newValue, 0xFF)
        elseif address == 0x8010 then
            self.pia.a.data = newValue
        elseif address == 0x8011 then
            self.pia.a.control = newValue
        elseif address == 0x8012 then
            self.pia.b.data = newValue
        elseif address == 0x8013 then
            self.pia.b.control = newValue
        elseif address >= 0xC000 and address < 0xC400 then
            self.eprom[address - self.eprom.startAddress] = newValue
        else
            print("Attempted write at unmapped address " .. string.format("%04X", address) .. " with value " .. newValue)
        end
    end,
    __len = function(self) return self.eprom.startAddress + self.eprom.size end -- LuaJIT doesn't support this? :(
})

return memory