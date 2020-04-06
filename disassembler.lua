local opcodes = require "opcodes"

local disassembler = {}

disassembler.memory = {}

function disassembler:disassemble(memory)
    local address = 0
    while address <= 0xFFFF do
        local op = opcodes[memory[address]]
        if op.instruction then
            local op_address = address
            local s = op.instruction
            if op.acc then
                s = s .. " " .. op.acc
            end
            if op.addr_mode == "imm" then
                s = s .. " #$" .. string.format("%02X", memory[address + 1])
                address = address + 1
            elseif op.addr_mode == "imm16" then
                s = s .. " #$" .. string.format("%02X", memory[address + 1]) .. string.format("%02X", memory[address + 2])
                address = address + 2
            elseif op.addr_mode == "dir" then
                s = s .. " ($" .. string.format("%02X", memory[address + 1]) .. ")"
                address = address + 1
            elseif op.addr_mode == "dir16" then
                s = s .. " ($" .. string.format("%02X", memory[address + 1]) .. ")"
                address = address + 1
            elseif op.addr_mode == "ext" then
                s = s .. " ($" .. string.format("%02X", memory[address + 1]) .. string.format("%02X", memory[address + 2]) .. ")"
                address = address + 2
            elseif op.addr_mode == "ext16" then
                s = s .. " ($" .. string.format("%02X", memory[address + 1]) .. string.format("%02X", memory[address + 2]) .. ")"
                address = address + 2
            elseif op.addr_mode == "idx" or op.addr_mode == "idx16" then
                s = s .. " ($" .. string.format("%02X", memory[address + 1]) .. "+X)"
                address = address + 1
            elseif op.addr_mode == "immx" then
                s = s .. " #$" .. string.format("%02X", memory[address + 1]) .. "+X"
                address = address + 1
            elseif op.addr_mode == "rel" then
                local offset = memory[address + 1]
                if bit.band(0x80, offset) == 0 then
                    s = s .. " " .. offset
                else
                    s = s .. " -" .. bit.band(bit.bnot(offset) + 1, 0xFF)
                end
                address = address + 1
            end
            self.memory[op_address] = s
        end
        address = address + 1
    end
end

return disassembler