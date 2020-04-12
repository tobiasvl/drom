local bit = bit or require "bit32"

local instructions = {}

-- Addressing
function instructions.inh()
    return function() end
end

function instructions:acc(acc)
    return function(newValue)
        if newValue then
            self.cpu.registers[acc](newValue)
        else
            return self.cpu.registers[acc]()
        end
    end
end

function instructions:imm()
    local pc = self.cpu.registers.pc()
    self.cpu.registers.pc(pc + 1)
    return function()
        return self.cpu.memory[pc]
    end
end

function instructions:imm16()
    local pc = self.cpu.registers.pc()
    self.cpu.registers.pc(pc + 2)
    return function()
        return bit.bor(bit.lshift(self.cpu.memory[pc], 8), self.cpu.memory[pc + 1])
    end
end

function instructions:dir()
    local pc = self.cpu.registers.pc()
    self.cpu.registers.pc(pc + 1)
    return function(newValue)
        if newValue then
            self.cpu.memory[self.cpu.memory[pc]] = bit.band(newValue, 0xFF)
        else
            return self.cpu.memory[self.cpu.memory[pc]]
        end
    end
end

function instructions:dir16()
    local pc = self.cpu.registers.pc()
    self.cpu.registers.pc(pc + 1)
    return function(newValue)
        if newValue then
            self.cpu.memory[self.cpu.memory[pc]], self.cpu.memory[self.cpu.memory[pc] + 1] = bit.rshift(bit.band(newValue, 0xFFFF), 8), bit.band(newValue, 0xFF)
        else
            return bit.bor(bit.lshift(self.cpu.memory[self.cpu.memory[pc]], 8), self.cpu.memory[self.cpu.memory[pc] + 1])
        end
    end
end

function instructions:ext()
    local pc = self.cpu.registers.pc()
    self.cpu.registers.pc(pc + 2)
    return function(newValue)
        if newValue then
            self.cpu.memory[bit.bor(bit.lshift(self.cpu.memory[pc], 8), self.cpu.memory[pc + 1])] = bit.band(newValue, 0xFF)
        else
            return self.cpu.memory[bit.bor(bit.lshift(self.cpu.memory[pc], 8), self.cpu.memory[pc + 1])]
        end
    end
end

function instructions:ext16()
    local pc = self.cpu.registers.pc()
    self.cpu.registers.pc(pc + 2)
    return function(newValue)
        if newValue then
            self.cpu.memory[self.cpu.memory[pc]], self.cpu.memory[self.cpu.memory[pc + 1]] = bit.rshift(bit.band(newValue, 0xFFFF), 8), bit.band(newValue, 0xFF)
        else
            return bit.bor(bit.lshift(self.cpu.memory[self.cpu.memory[pc]], 8), self.cpu.memory[self.cpu.memory[pc + 1]])
        end
    end
end

function instructions:idx()
    local pc = self.cpu.registers.pc()
    self.cpu.registers.pc(pc + 1)
    return function(newValue)
        if newValue then
            self.cpu.memory[self.cpu.registers.ix() + self.cpu.memory[pc]] = bit.band(newValue, 0xFF)
        else
            return self.cpu.memory[self.cpu.registers.ix() + self.cpu.memory[pc]]
        end
    end
end

function instructions:immx()
    local pc = self.cpu.registers.pc()
    self.cpu.registers.pc(pc + 1)
    return function()
        return self.cpu.registers.ix() + self.cpu.memory[pc]
    end
end

function instructions:idx16()
    local pc = self.cpu.registers.pc()
    self.cpu.registers.pc(pc + 1)
    return function(newValue)
        if newValue then
            self.cpu.memory[self.cpu.registers.ix() + self.cpu.memory[pc]], self.cpu.memory[self.cpu.registers.ix() + self.cpu.memory[pc] + 1] = bit.rshift(bit.band(newValue, 0xFFFF), 8), bit.band(newValue, 0xFF)
        else
            return bit.bor(bit.lshift(self.cpu.memory[self.cpu.registers.ix() + self.cpu.memory[pc]], 8), self.cpu.memory[self.cpu.registers.ix() + self.cpu.memory[pc] + 1])
        end
    end
end

function instructions:rel()
    local offset = self.cpu.memory[self.cpu.registers.pc()]
    self.cpu.registers.pc(self.cpu.registers.pc() + 1)
    return function()
        if bit.band(0x80, offset) == 0 then
            return self.cpu.registers.pc() + offset
        else
            return self.cpu.registers.pc() - bit.band(bit.bnot(offset) + 1, 0xFF)
        end
    end
end

function instructions:init(cpu)
    self.cpu = cpu
    self.opcodes = require "opcodes"
end

-- NOP
function instructions.nop()
    return
end

-- ABA
function instructions:aba()
    local result = self.cpu.registers.a() + self.cpu.registers.b()
    self.cpu.registers.status.z = bit.band(result, 0xFF) == 0
    self.cpu.registers.status.n = bit.band(result, 0x80) ~= 0
    self.cpu.registers.status.c = result > 0xFF
    --self.cpu.registers.status.v
    --self.cpu.registers.status.h
    self.cpu.registers.a(result)
end

-- ADC
function instructions:adc(addr_mode, acc)
    local result = self.cpu.registers[acc]() + addr_mode() + (self.cpu.registers.status.c and 1 or 0)
    self.cpu.registers.status.z = bit.band(result, 0xFF) == 0
    self.cpu.registers.status.n = bit.band(result, 0x80) ~= 0
    self.cpu.registers.status.c = result > 0xFF
    --self.cpu.registers.status.v
    --self.cpu.registers.status.h
    self.cpu.registers[acc](result)
end

-- ADD
function instructions:add(addr_mode, acc)
    local result = self.cpu.registers[acc]() + addr_mode()
    self.cpu.registers.status.z = bit.band(result, 0xFF) == 0
    self.cpu.registers.status.n = bit.band(result, 0x80) ~= 0
    self.cpu.registers.status.c = result > 0xFF
    --self.cpu.registers.status.v
    --self.cpu.registers.status.h
    self.cpu.registers[acc](result)
end

-- AND
instructions["and"] = function(self, addr_mode, acc)
    local result = bit.band(self.cpu.registers[acc](), addr_mode())
    self.cpu.registers.status.z = bit.band(result, 0xFF) == 0
    self.cpu.registers.status.n = bit.band(result, 0x80) ~= 0
    self.cpu.registers.status.v = false
    self.cpu.registers[acc](result)
end

-- ASL
function instructions:asl(addr_mode)
    local result = bit.lshift(addr_mode(), 1)
    self.cpu.registers.status.n = bit.band(result, 0x80) ~= 0
    self.cpu.registers.status.z = bit.band(result, 0xFF) == 0
    self.cpu.registers.status.c = result > 0xFF
    self.cpu.registers.status.v = self.cpu.registers.status.c ~= self.cpu.registers.status.n
    addr_mode(result)
end

-- ASR
function instructions:asr(addr_mode)
    local result = bit.bor(bit.rshift(addr_mode(), 1), 0x80)
    self.cpu.registers.status.n = bit.band(result, 0x80) ~= 0
    self.cpu.registers.status.z = bit.band(result, 0xFF) == 0
    self.cpu.registers.status.c = bit.band(addr_mode(), 0x01) == 1
    self.cpu.registers.status.v = self.cpu.registers.status.c ~= self.cpu.registers.status.n
    addr_mode(result)
end

-- BCC
function instructions:bcc(addr_mode)
    if not self.cpu.registers.status.c then
        self.cpu.registers.pc(addr_mode())
    end
end

-- BCS
function instructions:bcs(addr_mode)
    if self.cpu.registers.status.c then
        self.cpu.registers.pc(addr_mode())
    end
end

-- BEQ
function instructions:beq(addr_mode)
    if self.cpu.registers.status.z then
        self.cpu.registers.pc(addr_mode())
    end
end

-- BGE
function instructions:bge(addr_mode)
    if self.cpu.registers.status.n == self.cpu.registers.status.v then
        self.cpu.registers.pc(addr_mode())
    end
end

-- BGT
function instructions:bgt(addr_mode)
    if (not self.cpu.registers.status.z) or (self.cpu.registers.status.n == self.cpu.registers.status.v) then
        self.cpu.registers.pc(addr_mode())
    end
end

-- BHI
function instructions:bhi(addr_mode)
    if self.cpu.registers.status.c or self.cpu.registers.status.z then
        self.cpu.registers.pc(addr_mode())
    end
end

-- BIT
function instructions:bit(addr_mode, acc)
    local result = bit.band(self.cpu.registers[acc](), addr_mode())
    self.cpu.registers.status.z = bit.band(result, 0xFF) == 0
    self.cpu.registers.status.n = result > 0xFF
    self.cpu.registers.status.v = false
end

-- BLE
function instructions:ble(addr_mode)
    if self.cpu.registers.status.z or (self.cpu.registers.status.n ~= self.cpu.registers.status.v) then
        self.cpu.registers.pc(addr_mode())
    end
end

-- BLS
function instructions:bls(addr_mode)
    if self.cpu.registers.status.c or self.cpu.registers.status.z then
        self.cpu.registers.pc(addr_mode())
    end
end

-- BLT
function instructions:blt(addr_mode)
    if self.cpu.registers.status.n ~= self.cpu.registers.status.v then
        self.cpu.registers.pc(addr_mode())
    end
end

-- BMI
function instructions:bmi(addr_mode)
    if self.cpu.registers.status.n then
        self.cpu.registers.pc(addr_mode())
    end
end

-- BNE
function instructions:bne(addr_mode)
    if not self.cpu.registers.status.z then
        self.cpu.registers.pc(addr_mode())
    end
end

-- BPL
function instructions:bpl(addr_mode)
    if not self.cpu.registers.status.n then
        self.cpu.registers.pc(addr_mode())
    end
end

-- BRA
function instructions:bra(addr_mode)
    self.cpu.registers.pc(addr_mode())
end

-- BSR
function instructions:bsr(addr_mode)
    local subroutine = addr_mode() -- the new PC should be pushed to the stack
    self.cpu.memory[self.cpu.registers.sp()] = bit.band(self.cpu.registers.pc(), 0xFF)
    self.cpu.memory[self.cpu.registers.sp() - 1] = bit.rshift(self.cpu.registers.pc(), 8)
    self.cpu.registers.sp(self.cpu.registers.sp() - 2)
    self.cpu.registers.pc(subroutine)
end

-- BVC
function instructions:bvc(addr_mode)
    if not self.cpu.registers.status.v then
        self.cpu.registers.pc(addr_mode())
    end
end

-- BVS
function instructions:bvs(addr_mode)
    if self.cpu.registers.status.v then
        self.cpu.registers.pc(addr_mode())
    end
end

-- CBA
function instructions:cba()
    local result = self.cpu.registers.a() - self.cpu.registers.b()
    self.cpu.registers.status.n = bit.band(result, 0x80) ~= 0
    self.cpu.registers.status.z = bit.band(result, 0xFF) == 0
    --self.cpu.registers.status.v -- TODO
    --self.cpu.registers.status.c -- TODO
end

-- CLC
function instructions:clc()
    self.cpu.registers.status.c = false
end

-- CLI
function instructions:cli()
    self.cpu.registers.status.i = false
end

-- CLR
function instructions:clr(addr_mode)
    addr_mode(0)
    self.cpu.registers.status.n = false
    self.cpu.registers.status.z = true
    self.cpu.registers.status.v = false
    self.cpu.registers.status.c = false
end

-- CLV
function instructions:clv()
    self.cpu.registers.status.v = false
end

-- CMP
function instructions:cmp(addr_mode, acc)
    local result = self.cpu.registers[acc]() - addr_mode()
    self.cpu.registers.status.n = bit.band(result, 0x80) ~= 0
    self.cpu.registers.status.z = bit.band(result, 0xFF) == 0
    --self.cpu.registers.status.v -- TODO
    self.cpu.registers.status.c = result > 0xFF -- TODO incorrect
end

-- COM
function instructions:com(addr_mode)
    local result = 0xFF - addr_mode() -- TODO?
    self.cpu.registers.status.c = true
    self.cpu.registers.status.n = bit.band(result, 0x80) ~= 0
    self.cpu.registers.status.z = bit.band(result, 0xFF) == 0
    self.cpu.registers.status.v = false
    addr_mode(result)
end

-- CPX
function instructions:cpx(addr_mode)
    local result = self.cpu.registers.ix() - addr_mode()
    -- TODO should set N and V, although they're not intended for use in branching
    self.cpu.registers.status.z = bit.band(result, 0xFFFF) == 0
end

-- DAA
function instructions:daa()
    -- TODO
end

-- DEC
function instructions:dec(addr_mode)
    local result = addr_mode() - 1
    self.cpu.registers.status.n = bit.band(result, 0x80) ~= 0
    self.cpu.registers.status.z = bit.band(result, 0xFF) == 0
    self.cpu.registers.status.v = addr_mode() == 0x80
    addr_mode(result)
end

-- DES
function instructions:des()
    self.cpu.registers.sp(self.cpu.registers.sp() - 1)
end

-- DEX
function instructions:dex()
    local result = self.cpu.registers.ix() - 1
    self.cpu.registers.status.z = bit.band(result, 0xFFFF) == 0
    self.cpu.registers.ix(result)
end

-- EOR
function instructions:eor(addr_mode, acc)
    local result = bit.bxor(self.cpu.registers[acc](), addr_mode())
    self.cpu.registers.status.n = bit.band(result, 0x80) ~= 0
    self.cpu.registers.status.z = bit.band(result, 0xFF) == 0
    self.cpu.registers.status.v = false
    self.cpu.registers[acc](result)
end

-- INC
function instructions:inc(addr_mode)
    local result = addr_mode() + 1
    self.cpu.registers.status.n = bit.band(result, 0x80) ~= 0
    self.cpu.registers.status.z = bit.band(result, 0xFF) == 0
    self.cpu.registers.status.v = addr_mode() == 0x7F
    -- manual says C not affected, but lists it as equivalent to Z; probable error
    self.cpu.registers.status.c = self.cpu.registers.status.z
    addr_mode(result)
end

-- INS
function instructions:ins()
    self.cpu.registers.sp(self.cpu.registers.sp() + 1)
end

-- INX
function instructions:inx()
    local result = self.cpu.registers.ix() + 1
    self.cpu.registers.status.z = bit.band(result, 0xFFFF) == 0
    self.cpu.registers.ix(result)
end

-- JMP
function instructions:jmp(addr_mode)
    self.cpu.registers.pc(addr_mode())
end

-- JSR
function instructions:jsr(addr_mode)
    local subroutine = addr_mode() -- the new PC should be pushed to the stack
    self.cpu.memory[self.cpu.registers.sp()] = bit.band(self.cpu.registers.pc(), 0xFF)
    self.cpu.memory[self.cpu.registers.sp() - 1] = bit.rshift(self.cpu.registers.pc(), 8)
    self.cpu.registers.sp(self.cpu.registers.sp() - 2)
    self.cpu.registers.pc(subroutine)
end

-- LDA
function instructions:lda(addr_mode, acc)
    local result = addr_mode()
    self.cpu.registers.status.n = bit.band(result, 0x80) ~= 0
    self.cpu.registers.status.z = bit.band(result, 0xFF) == 0
    self.cpu.registers.status.v = false
    self.cpu.registers[acc](result)
end

-- LDS
function instructions:lds(addr_mode)
    self.cpu.registers.sp(addr_mode())
    self.cpu.registers.status.v = false
end

-- LDX
function instructions:ldx(addr_mode)
    local result = addr_mode()
    self.cpu.registers.status.n = bit.band(result, 0x8000) == 0x8000
    self.cpu.registers.status.z = bit.band(result, 0xFFFF) == 0
    self.cpu.registers.status.v = false
    self.cpu.registers.ix(result)
end

-- LSR
function instructions:lsr(addr_mode)
    local result = bit.rshift(addr_mode(), 1)
    self.cpu.registers.status.n = false
    self.cpu.registers.status.z = bit.band(result, 0xFF) == 0
    self.cpu.registers.status.c = bit.band(addr_mode(), 0x01) == 1
    self.cpu.registers.status.v = self.cpu.registers.status.n ~= self.cpu.registers.status.c
    addr_mode(result)
end

-- NEG
function instructions:neg(addr_mode)
    local result = 0 - addr_mode() -- TODO?
    self.cpu.registers.status.n = bit.band(result, 0x80) ~= 0
    self.cpu.registers.status.z = bit.band(result, 0xFF) == 0
    self.cpu.registers.status.v = addr_mode() == 0x80
    self.cpu.registers.status.c = addr_mode() ~= 0x00
    addr_mode(0 - addr_mode())
end

-- ORA
function instructions:ora(addr_mode, acc)
    local result = bit.bor(self.cpu.registers[acc](), addr_mode())
    self.cpu.registers.status.n = bit.band(result, 0x80) ~= 0
    self.cpu.registers.status.z = bit.band(result, 0xFF) == 0
    self.cpu.registers[acc](result)
end

-- PSH
function instructions:psh(addr_mode)
    self.cpu.memory[self.cpu.registers.sp()] = addr_mode()
    self.cpu.registers.sp(self.cpu.registers.sp() - 1)
end

-- PUL
function instructions:pul(addr_mode)
    self.cpu.registers.sp(self.cpu.registers.sp() + 1)
    addr_mode(self.cpu.memory[self.cpu.registers.sp()])
end

-- ROL
function instructions:rol(addr_mode)
    local result = bit.bor(bit.lshift(addr_mode(), 1), self.cpu.registers.status.c and 1 or 0)
    self.cpu.registers.status.n = bit.band(result, 0x80) ~= 0
    self.cpu.registers.status.z = bit.band(result, 0xFF) == 0
    self.cpu.registers.status.c = result > 0xFF
    self.cpu.registers.status.v = self.cpu.registers.status.n ~= self.cpu.registers.status.c
    addr_mode(result)
end
-- F6 -> 3C
-- DF -> 3E

-- ED 11101101
-- 3C 00111100

-- ROR
function instructions:ror(addr_mode)
    local result = bit.bor(bit.rshift(addr_mode(), 1), self.cpu.registers.status.c and 0x80 or 0)
    self.cpu.registers.status.n = bit.band(result, 0x80) ~= 0
    self.cpu.registers.status.z = bit.band(result, 0xFF) == 0
    self.cpu.registers.status.c = bit.band(addr_mode(), 0x01) == 1
    self.cpu.registers.status.v = self.cpu.registers.status.n ~= self.cpu.registers.status.c
    addr_mode(result)
end

-- RTI
function instructions:rti()
    self.cpu:restoreFromStack()
end

-- RTS
function instructions:rts()
    -- TODO check this logic
    self.cpu.registers.pc(bit.bor(bit.lshift(self.cpu.memory[self.cpu.registers.sp() + 1], 8), self.cpu.memory[self.cpu.registers.sp() + 2]))
    self.cpu.registers.sp(self.cpu.registers.sp() + 2)
end

-- SBA
function instructions:sba()
    local result = self.cpu.registers.a() - self.cpu.registers.b()
    self.cpu.registers.status.n = bit.band(result, 0x80) ~= 0
    self.cpu.registers.status.z = bit.band(result, 0xFF) == 0
    -- TODO flags
    self.cpu.registers.a(result)
end

-- SBC
function instructions:sbc(addr_mode, acc)
    local result = self.cpu.registers[acc]() - addr_mode() - (self.cpu.registers.status.c and 1 or 0)
    self.cpu.registers.status.n = bit.band(result, 0x80) ~= 0
    self.cpu.registers.status.z = bit.band(result, 0xFF) == 0
    -- TODO flags
    self.cpu.registers[acc](result)
end

-- SEC
function instructions:sec()
    self.cpu.registers.status.c = true
end

-- SEI
function instructions:sei()
    self.cpu.registers.status.i = true
end

-- SEV
function instructions:sev()
    self.cpu.registers.status.v = true
end

-- STA
function instructions:sta(addr_mode, acc)
    local result = self.cpu.registers[acc]()
    self.cpu.registers.status.n = bit.band(result, 0x80) ~= 0
    self.cpu.registers.status.z = bit.band(result, 0xFF) == 0
    self.cpu.registers.status.v = false
    addr_mode(result)
end

-- STS
function instructions:sts(addr_mode)
    local result = self.cpu.registers.sp()
    self.cpu.registers.status.n = bit.band(result, 0x8000) ~= 0
    self.cpu.registers.status.z = bit.band(result, 0xFFFF) == 0
    self.cpu.registers.status.v = false
    addr_mode(result)
end

-- STX
function instructions:stx(addr_mode)
    local result = self.cpu.registers.ix()
    self.cpu.registers.status.n = bit.band(result, 0x8000) ~= 0
    self.cpu.registers.status.z = bit.band(result, 0xFFFF) == 0
    self.cpu.registers.status.v = false
    addr_mode(result)
end

-- SUB
function instructions:sub(addr_mode, acc)
    local result = self.cpu.registers[acc]() - addr_mode()
    self.cpu.registers.status.n = bit.band(result, 0x80) ~= 0
    self.cpu.registers.status.z = bit.band(result, 0xFF) == 0
    --self.cpu.registers.status.v -- TODO
    --self.cpu.registers.status.c -- TODO
    self.cpu.registers[acc](result)
end

-- SWI
function instructions:swi()
    self.cpu:saveToStack()
    self.cpu.registers.status.i = true
    local n = self.cpu.memory.eprom.startAddress + self.cpu.memory.eprom.size - 1
    self.cpu.registers.pc(bit.bor(bit.lshift(self.cpu.memory[n - 5], 8), self.cpu.memory[n - 4]))
end

-- TAB
function instructions:tab()
    local result = self.cpu.registers.a()
    self.cpu.registers.status.n = bit.band(result, 0x80) ~= 0
    self.cpu.registers.status.z = bit.band(result, 0xFF) == 0
    self.cpu.registers.status.v = false
    self.cpu.registers.b(result)
end

-- TAP
function instructions:tap()
    self.cpu.registers.status(self.cpu.registers.a())
end

-- TBA
function instructions:tba()
    local result = self.cpu.registers.b()
    self.cpu.registers.status.n = bit.band(result, 0x80) ~= 0
    self.cpu.registers.status.z = bit.band(result, 0xFF) == 0
    self.cpu.registers.status.v = false
    self.cpu.registers.a(result)
end

-- TPA
function instructions:tpa()
    self.cpu.registers.a(self.cpu.registers.status())
end

-- TST
function instructions:tst(addr_mode)
    local result = addr_mode()
    self.cpu.registers.status.n = bit.band(result, 0x80) ~= 0
    self.cpu.registers.status.z = bit.band(result, 0xFF) == 0
    self.cpu.registers.status.v = false
    self.cpu.registers.status.c = false
end

-- TSX
function instructions:tsx()
    self.cpu.registers.ix(self.cpu.registers.sp() + 1)
end

-- TXS
function instructions:txs()
    self.cpu.registers.sp(self.cpu.registers.ix() - 1)
end

-- WAI
function instructions:wai()
    self.cpu:saveToStack()
    self.cpu.halt = true
end

-- Undocumented opcodes

-- HCF
function instructions:hcf()
    self.cpu.halt = true
    self.cpu.catch_fire = true
end

-- NBA
function instructions:nba()
    local result = bit.band(self.cpu.registers.a(), self.cpu.registers.b())
    self.cpu.registers.status.z = bit.band(result, 0xFF) == 0
    self.cpu.registers.status.n = bit.band(result, 0x80) ~= 0
    self.cpu.registers.status.v = false
    self.cpu.registers.a(result)
end

return instructions