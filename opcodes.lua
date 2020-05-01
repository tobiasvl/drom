-- Opcode table

    -- set accumulator
    --if (nibble2 < 0xD and nibble1 > 0x7) or (nibble1 == 0x4 or nibble1 == 0x5) then
    --    if nibble1 > 0xB or nibble1 == 0x5 then
    --        accumulator = "b"
    --    elseif nibble1 > 0x7 or nibble1 == 0x4 then
    --        accumulator = "a"
    --    end
    --end

    ---- set instruction
    --if nibble2 == 0 then
    --    if nibble1 == 0 then
    --        -- undefined opcode
    --    elseif nibble1 == 1 then
    --        instruction = instructions.sba
    --    elseif nibble1 == 2 then
    --        instruction = instructions.bra
    --    elseif nibble1 == 3 then
    --        instruction = instructions.tsx
    --    elseif nibble1 < 0x8 then
    --        instruction = instructions.neg
    --    else
    --        instruction = instructions.sub
    --    end
    --elseif nibble2 == 1 then
    --    if nibble1 == 0 then
    --        instruction = instructions.nop
    --    elseif nibble1 == 1 then
    --        instruction = instructions.cba
    --    elseif nibble1 == 2 then
    --        -- undefined opcode
    --    elseif nibble1 == 3 then
    --        instruction = instructions.ins
    --    elseif nibble1 > 0x7 then
    --        instruction = instructions.cmp
    --    else
    --        -- undefined opcodes
    --    end
    --elseif nibble2 == 2 then
    --    if nibble1 == 2 then
    --        instruction = instructions.bhi
    --    elseif nibble1 == 3 then
    --        addr_mode = acc("a")
    --        instruction = instructions.pul
    --    elseif nibble1 > 0x7 then
    --        instruction = instructions.sbc
    --    else
    --        -- undefined opcodes
    --    end
    --elseif nibble2 == 3 then
    --    if nibble1 == 0 or nibble1 == 1 then
    --        -- undefined opcodes
    --    elseif nibble1 == 2 then
    --        instruction = instructions.bls
    --    elseif nibble1 == 3 then
    --        addr_mode = acc("a")
    --        instruction = instructions.pul
    --    elseif nibble1 < 8 then
    --        instruction = instructions.neg
    --    end
    --elseif nibble2 == 4 then
    --    if nibble1 == 0 or nibble1 == 1 then
    --        -- undefined opcodes
    --    elseif nibble1 == 2 then
    --        instruction = instructions.bcc
    --    elseif nibble1 == 3 then
    --        instruction = instructions.des
    --    elseif nibble1 < 8 then
    --        instruction = instructions.lsr
    --    elseif nibble1 > 7 then
    --        instruction = instructions.AND
    --    end
    --elseif nibble2 == 5 then
    --    if nibble1 == 2 then
    --        instruction = instructions.bcs
    --    elseif nibble1 == 3 then
    --        instruction = instructions.txs
    --    elseif nibble1 > 7 then
    --        instruction = instructions.bit
    --    end
    --elseif nibble2 == 6 then
    --    if nibble1 == 0 then
    --        instruction = instructions.tap
    --    elseif nibble1 == 1 then
    --        instruction = instructions.tab
    --    elseif nibble1 == 2 then
    --        instruction = instructions.bne
    --    elseif nibble1 == 3 then
    --        instruction = instructions.psh
    --    elseif nibble1 < 8 then
    --        instruction = instructions.ror
    --    elseif nibble1 > 7 then
    --        instruction = instructions.lda
    --    end
    --elseif nibble2 == 7 then
    --    if nibble1 == 0 then
    --        instruction = instructions.tpa
    --    elseif nibble1 == 1 then
    --        instruction = instructions.tba
    --    elseif nibble1 == 2 then
    --        instruction = instructions.beq
    --    elseif nibble1 == 3 then
    --        instruction = instructions.psh
    --    elseif nibble1 < 8 then
    --        instruction = instructions.asr
    --    elseif nibble1 == 8 or nibble1 == 0xC then
    --        -- undefined opcode
    --    elseif nibble1 > 7 then
    --        instruction = instructions.sta
    --    end
    --elseif nibble2 == 8 then
    --    if nibble1 == 0 then
    --        instruction = instructions.inx
    --    elseif nibble1 == 1 or nibble1 == 3 then
    --        -- undefined opcode
    --    elseif nibble1 == 2 then
    --        instruction = instructions.bvc
    --    elseif nibble1 < 8 then
    --        instruction = instructions.asl
    --    elseif nibble1 > 7 then
    --        instruction = instructions.eor
    --    end
    --elseif nibble2 == 9 then
    --    if nibble1 == 0 then
    --        instruction = instructions.dex
    --    elseif nibble1 == 1 then
    --        instruction = instructions.daa
    --    elseif nibble1 == 2 then
    --        instruction = instructions.bvs
    --    elseif nibble1 == 3 then
    --        instruction = instructions.rts
    --    elseif nibble1 < 8 then
    --        instruction = instructions.rol
    --    elseif nibble1 > 7 then
    --        instruction = instructions.adc
    --    end
    --elseif nibble2 == 0xA then
    --    if nibble1 == 0 then
    --        instruction = instructions.clv
    --    elseif nibble1 == 1 or nibble1 == 3 then
    --        -- undefined opcode
    --    elseif nibble1 == 2 then
    --        instruction = instructions.bpl
    --    elseif nibble1 < 8 then
    --        instruction = instructions.dec
    --    elseif nibble1 > 7 then
    --        instruction = instructions.ora
    --    end
    --elseif nibble2 == 0xB then
    --    if nibble1 == 0 then
    --        instruction = instructions.sev
    --    elseif nibble1 == 1 then
    --        instruction = instructions.aba
    --    elseif nibble1 == 2 then
    --        instruction = instructions.bmi
    --    elseif nibble1 == 3 then
    --        instruction = instructions.rti
    --    elseif nibble1 > 7 then
    --        instruction = instructions.add
    --    end
    --elseif nibble2 == 0xC then
    --    if nibble1 == 0 then
    --        instruction = instructions.clc
    --    elseif nibble1 == 1 or nibble1 == 3 then
    --        -- undefined opcode
    --    elseif nibble1 == 2 then
    --        instruction = instructions.bge
    --    elseif nibble1 < 8 then
    --        instruction = instructions.inc
    --    elseif nibble1 > 7 and nibble1 < 0xC then
    --        instruction = instructions.cpx
    --        if nibble1 == 8 then
    --            addr_mode = imm16()
    --        elseif nibble1 == 9 then
    --            addr_mode = dir16()
    --        elseif nibble1 == 0xA then
    --            addr_mode = idx16()
    --        end
    --    end
    --elseif nibble2 == 0xD then
    --    if nibble1 == 0 then
    --        instruction = instructions.sec
    --    elseif nibble1 == 1 or nibble1 == 3 then
    --        -- undefined opcode
    --    elseif nibble1 == 2 then
    --        instruction = instructions.blt
    --    elseif nibble1 < 8 then
    --        instruction = instructions.tst
    --    elseif nibble1 == 8 then
    --        instruction = instructions.bsr
    --    elseif nibble1 == 0xA or nibble1 == 0xB then
    --        instruction = instructions.jsr
    --    end
    --elseif nibble2 == 0xE then
    --    if nibble1 == 0 then
    --        instruction = instructions.cli
    --    elseif nibble1 == 1 or nibble1 == 3 then
    --        -- undefined opcode
    --    elseif nibble1 == 2 then
    --        instruction = instructions.bgt
    --    elseif nibble1 == 3 then
    --        instruction = instructions.wai
    --    elseif nibble1 == 6 or nibble1 == 7 then
    --        instruction = instructions.jmp
    --    elseif nibble1 > 7 and nibble1 < 0xC then
    --        instruction = instructions.lds
    --        if nibble1 == 8 then
    --            addr_mode = imm16()
    --        elseif nibble1 == 9 then
    --            addr_mode = dir16()
    --        elseif nibble1 == 0xA then
    --            addr_mode = idx16()
    --        end
    --    elseif nibble1 > 0xB then
    --        instruction = instructions.ldx
    --        if nibble1 == 0xC then
    --            addr_mode = imm16()
    --        elseif nibble1 == 0xD then
    --            addr_mode = dir16()
    --        elseif nibble1 == 0xE then
    --            addr_mode = idx16()
    --        end
    --    end
    --elseif nibble2 == 0xF then
    --    if nibble1 == 0 then
    --        instruction = instructions.sei
    --    elseif nibble1 == 1 or nibble1 == 8 or nibble1 == 0xC then
    --        -- undefined opcode
    --    elseif nibble1 == 2 then
    --        instruction = instructions.ble
    --    elseif nibble1 == 3 then
    --        instruction = instructions.swi
    --    elseif nibble1 < 8 then
    --        instruction = instructions.clr
    --    elseif nibble1 > 8 and nibble1 < 0xC then
    --        instruction = instructions.sts
    --        if nibble1 == 9 then
    --            addr_mode = dir16()
    --        elseif nibble1 == 0xA then
    --            addr_mode = idx16()
    --        end
    --    elseif nibble1 > 0xC then
    --        instruction = instructions.stx
    --        if nibble1 == 0xD then
    --            addr_mode = dir16()
    --        elseif nibble1 == 0xE then
    --            addr_mode = idx16()
    --        end
    --    end
    --end

    ---- set addressing mode
    --if not addr_mode then
    --    if nibble1 == 0x2 or opcode == 0x8D then
    --        addr_mode = rel()
    --    elseif nibble1 == 0x4 or opcode == 0x32 or opcode == 0x36 then
    --        addr_mode = acc("a")
    --    elseif nibble1 == 0x5 or opcode == 0x33 or opcode == 0x37 then
    --        addr_mode = acc("b")
    --    elseif nibble1 == 0x6 or nibble1 == 0xA or nibble1 == 0xE then
    --        addr_mode = idx()
    --    elseif nibble1 == 0x7 or nibble1 == 0xB or nibble1 == 0xF then
    --        addr_mode = ext()
    --    elseif nibble1 == 0x8 or nibble1 == 0xC then
    --        addr_mode = imm()
    --    elseif nibble1 == 0x9 or nibble1 == 0xD then
    --        addr_mode = dir()
    --    end
    --end

return {
    [0x00] = {},
    [0x01] = {
        instruction = "nop",
        cycles = 2,
        addr_mode = "inh"
    },
    [0x02] = {},
    [0x03] = {},
    [0x04] = {},
    [0x05] = {},
    [0x06] = {
        instruction = "tap",
        cycles = 2,
        addr_mode = "inh"
    },
    [0x07] = {
        instruction = "tpa",
        cycles = 2,
        addr_mode = "inh"
    },
    [0x08] = {
        instruction = "inx",
        cycles = 4,
        addr_mode = "inh"
    },
    [0x09] = {
        instruction = "dex",
        cycles = 4,
        addr_mode = "inh"
    },
    [0x0A] = {
        instruction = "clv",
        cycles = 2,
        addr_mode = "inh"
    },
    [0x0B] = {
        instruction = "sev",
        cycles = 2,
        addr_mode = "inh"
    },
    [0x0C] = {
        instruction = "clc",
        cycles = 2,
        addr_mode = "inh"
    },
    [0x0D] = {
        instruction = "sec",
        cycles = 2,
        addr_mode = "inh"
    },
    [0x0E] = {
        instruction = "cli",
        cycles = 2,
        addr_mode = "inh"
    },
    [0x0F] = {
        instruction = "sei",
        cycles = 2,
        addr_mode = "inh"
    },
    [0x10] = {
        instruction = "sba",
        cycles = 2,
        addr_mode = "inh"
    },
    [0x11] = {
        instruction = "cba",
        cycles = 2,
        addr_mode = "inh"
    },
    [0x12] = {},
    [0x13] = {},
    [0x14] = {
        instruction = "nba",
        cycles = 2, -- TODO
        addr_mode = "inh"
    },
    [0x15] = {},
    [0x16] = {
        instruction = "tab",
        cycles = 2,
        addr_mode = "inh"
    },
    [0x17] = {
        instruction = "tba",
        cycles = 2,
        addr_mode = "inh"
    },
    [0x18] = {
    },
    [0x19] = {
        instruction = "daa",
        cycles = 2,
        addr_mode = "inh"
    },
    [0x1A] = {
    },
    [0x1B] = {
        instruction = "aba",
        cycles = 2,
        addr_mode = "inh"
    },
    [0x1C] = {
    },
    [0x1D] = {
    },
    [0x1E] = {
    },
    [0x1F] = {
    },
    [0x20] = {
        instruction = "bra",
        cycles = 4,
        addr_mode = "rel"
    },
    [0x21] = {},
    [0x22] = {
        instruction = "bhi",
        cycles = 4,
        addr_mode = "rel"
    },
    [0x23] = {
        instruction = "bls",
        cycles = 4,
        addr_mode = "rel"
    },
    [0x24] = {
        instruction = "bcc",
        cycles = 4,
        addr_mode = "rel"
    },
    [0x25] = {
        instruction = "bcs",
        cycles = 4,
        addr_mode = "rel"
    },
    [0x26] = {
        instruction = "bne",
        cycles = 4,
        addr_mode = "rel"
    },
    [0x27] = {
        instruction = "beq",
        cycles = 4,
        addr_mode = "rel"
    },
    [0x28] = {
        instruction = "bvc",
        cycles = 4,
        addr_mode = "rel"
    },
    [0x29] = {
        instruction = "bvs",
        cycles = 4,
        addr_mode = "rel"
    },
    [0x2A] = {
        instruction = "bpl",
        cycles = 4,
        addr_mode = "rel"
    },
    [0x2B] = {
        instruction = "bmi",
        cycles = 4,
        addr_mode = "rel"
    },
    [0x2C] = {
        instruction = "bge",
        cycles = 4,
        addr_mode = "rel"
    },
    [0x2D] = {
        instruction = "blt",
        cycles = 4,
        addr_mode = "rel"
    },
    [0x2E] = {
        instruction = "bgt",
        cycles = 4,
        addr_mode = "rel"
    },
    [0x2F] = {
        instruction = "ble",
        cycles = 4,
        addr_mode = "rel"
    },
    [0x30] = {
        instruction = "tsx",
        cycles = 4,
        addr_mode = "inh"
    },
    [0x31] = {
        instruction = "ins",
        cycles = 4,
        addr_mode = "inh"
    },
    [0x32] = {
        instruction = "pul",
        cycles = 4,
        addr_mode = "acc",
        acc = "a"
    },
    [0x33] = {
        instruction = "pul",
        cycles = 4,
        addr_mode = "acc",
        acc = "b"
    },
    [0x34] = {
        instruction = "des",
        cycles = 4,
        addr_mode = "inh"
    },
    [0x35] = {
        instruction = "txs",
        cycles = 4,
        addr_mode = "inh",
    },
    [0x36] = {
        instruction = "psh",
        cycles = 4,
        addr_mode = "acc",
        acc = "a"
    },
    [0x37] = {
        instruction = "psh",
        cycles = 4,
        addr_mode = "acc",
        acc = "b"
    },
    [0x38] = {},
    [0x39] = {
        instruction = "rts",
        cycles = 5,
        addr_mode = "inh"
    },
    [0x3A] = {},
    [0x3B] = {
        instruction = "rti",
        cycles = 10,
        addr_mode = "inh"
    },
    [0x3C] = {},
    [0x3D] = {},
    [0x3E] = {
        instruction = "wai",
        cycles = 9,
        addr_mode = "inh"
    },
    [0x3F] = {
        instruction = "swi",
        cycles = 12,
        addr_mode = "inh"
    },
    [0x40] = {
        instruction = "neg",
        cycles = 2,
        addr_mode = "acc",
        acc = "a"
    },
    [0x41] = {},
    [0x42] = {},
    [0x43] = {
        instruction = "com",
        cycles = 2,
        addr_mode = "acc",
        acc = "a"
    },
    [0x44] = {
        instruction = "lsr",
        cycles = 2,
        addr_mode = "acc",
        acc = "a"
    },
    [0x45] = {},
    [0x46] = {
        instruction = "ror",
        cycles = 2,
        addr_mode = "acc",
        acc = "a"
    },
    [0x47] = {
        instruction = "asr",
        cycles = 2,
        addr_mode = "acc",
        acc = "a"
    },
    [0x48] = {
        instruction = "asl",
        cycles = 2,
        addr_mode = "acc",
        acc = "a"
    },
    [0x49] = {
        instruction = "rol",
        cycles = 2,
        addr_mode = "acc",
        acc = "a"
    },
    [0x4A] = {
        instruction = "dec",
        cycles = 2,
        addr_mode = "acc",
        acc = "a"
    },
    [0x4B] = {},
    [0x4C] = {
        instruction = "inc",
        cycles = 2,
        addr_mode = "acc",
        acc = "a"
    },
    [0x4D] = {
        instruction = "tst",
        cycles = 2,
        addr_mode = "acc",
        acc = "a"
    },
    [0x4E] = {},
    [0x4F] = {
        instruction = "clr",
        cycles = 2,
        addr_mode = "acc",
        acc = "a"
    },
    [0x50] = {
        instruction = "neg",
        cycles = 2,
        addr_mode = "acc",
        acc = "b"
    },
    [0x51] = {},
    [0x52] = {},
    [0x53] = {
        instruction = "com",
        cycles = 2,
        addr_mode = "acc",
        acc = "b"
    },
    [0x54] = {
        instruction = "lsr",
        cycles = 2,
        addr_mode = "acc",
        acc = "b"
    },
    [0x55] = {},
    [0x56] = {
        instruction = "ror",
        cycles = 2,
        addr_mode = "acc",
        acc = "b"
    },
    [0x57] = {
        instruction = "asr",
        cycles = 2,
        addr_mode = "acc",
        acc = "b"
    },
    [0x58] = {
        instruction = "asl",
        cycles = 2,
        addr_mode = "acc",
        acc = "b"
    },
    [0x59] = {
        instruction = "rol",
        cycles = 2,
        addr_mode = "acc",
        acc = "b"
    },
    [0x5A] = {
        instruction = "dec",
        cycles = 2,
        addr_mode = "acc",
        acc = "b"
    },
    [0x5B] = {},
    [0x5C] = {
        instruction = "inc",
        cycles = 2,
        addr_mode = "acc",
        acc = "b"
    },
    [0x5D] = {
        instruction = "tst",
        cycles = 2,
        addr_mode = "acc",
        acc = "b"
    },
    [0x5E] = {},
    [0x5F] = {
        instruction = "clr",
        cycles = 2,
        addr_mode = "acc",
        acc = "b"
    },
    [0x60] = {
        instruction = "neg",
        cycles = 7,
        addr_mode = "idx"
    },
    [0x61] = {},
    [0x62] = {},
    [0x63] = {
        instruction = "com",
        cycles = 7,
        addr_mode = "idx"
    },
    [0x64] = {
        instruction = "lsr",
        cycles = 7,
        addr_mode = "idx"
    },
    [0x65] = {},
    [0x66] = {
        instruction = "ror",
        cycles = 7,
        addr_mode = "idx"
    },
    [0x67] = {
        instruction = "asr",
        cycles = 7,
        addr_mode = "idx"
    },
    [0x68] = {
        instruction = "asl",
        cycles = 7,
        addr_mode = "idx"
    },
    [0x69] = {
        instruction = "rol",
        cycles = 7,
        addr_mode = "idx"
    },
    [0x6A] = {
        instruction = "dec",
        cycles = 7,
        addr_mode = "idx"
    },
    [0x6B] = {},
    [0x6C] = {
        instruction = "inc",
        cycles = 7,
        addr_mode = "idx"
    },
    [0x6D] = {
        instruction = "tst",
        cycles = 7,
        addr_mode = "idx"
    },
    [0x6E] = {
        instruction = "jmp",
        cycles = 2,
        addr_mode = "immx"--"idx"
    },
    [0x6F] = {
        instruction = "clr",
        cycles = 7,
        addr_mode = "idx"
    },
    [0x70] = {
        instruction = "neg",
        cycles = 6,
        addr_mode = "ext"
    },
    [0x71] = {},
    [0x72] = {},
    [0x73] = {
        instruction = "com",
        cycles = 6,
        addr_mode = "ext"
    },
    [0x74] = {
        instruction = "lsr",
        cycles = 6,
        addr_mode = "ext"
    },
    [0x75] = {},
    [0x76] = {
        instruction = "ror",
        cycles = 6,
        addr_mode = "ext"
    },
    [0x77] = {
        instruction = "asr",
        cycles = 6,
        addr_mode = "ext"
    },
    [0x78] = {
        instruction = "asl",
        cycles = 6,
        addr_mode = "ext"
    },
    [0x79] = {
        instruction = "rol",
        cycles = 6,
        addr_mode = "ext"
    },
    [0x7A] = {
        instruction = "dec",
        cycles = 6,
        addr_mode = "ext"
    },
    [0x7B] = {},
    [0x7C] = {
        instruction = "inc",
        cycles = 6,
        addr_mode = "ext"
    },
    [0x7D] = {
        instruction = "tst",
        cycles = 6,
        addr_mode = "ext"
    },
    [0x7E] = {
        instruction = "jmp",
        cycles = 3,
        addr_mode = "imm16"--"ext"
    },
    [0x7F] = {
        instruction = "clr",
        cycles = 6,
        addr_mode = "ext"
    },
    [0x80] = {
        instruction = "sub",
        cycles = 2,
        addr_mode = "imm",
        acc = "a"
    },
    [0x81] = {
        instruction = "cmp",
        cycles = 2,
        addr_mode = "imm",
        acc = "a"
    },
    [0x82] = {
        instruction = "sbc",
        cycles = 2,
        addr_mode = "imm",
        acc = "a"
    },
    [0x83] = {},
    [0x84] = {
        instruction = "and",
        cycles = 2,
        addr_mode = "imm",
        acc = "a"
    },
    [0x85] = {
        instruction = "bit",
        cycles = 2,
        addr_mode = "imm",
        acc = "a"
    },
    [0x86] = {
        instruction = "lda",
        cycles = 2,
        addr_mode = "imm",
        acc = "a"
    },
    [0x87] = {
        -- TODO increments PC before storing!
        instruction = "sta",
        cycles = 2,
        addr_mode = "imm",
        acc = "a"
    },
    [0x88] = {
        instruction = "eor",
        cycles = 2,
        addr_mode = "imm",
        acc = "a"
    },
    [0x89] = {
        instruction = "adc",
        cycles = 2,
        addr_mode = "imm",
        acc = "a"
    },
    [0x8A] = {
        instruction = "ora",
        cycles = 2,
        addr_mode = "imm",
        acc = "a"
    },
    [0x8B] = {
        instruction = "add",
        cycles = 2,
        addr_mode = "imm",
        acc = "a"
    },
    [0x8C] = {
        instruction = "cpx",
        cycles = 3,
        addr_mode = "imm16"
    },
    [0x8D] = {
        instruction = "bsr",
        cycles = 8,
        addr_mode = "rel",
    },
    [0x8E] = {
        instruction = "lds",
        cycles = 3,
        addr_mode = "imm16",
    },
    [0x8F] = {
        -- TODO increments PC before storing!
        instruction = "sts",
        cycles = 2, -- TODO
        addr_mode = "imm16",
    },
    [0x90] = {
        instruction = "sub",
        cycles = 3,
        addr_mode = "dir",
        acc = "a"
    },
    [0x91] = {
        instruction = "cmp",
        cycles = 3,
        addr_mode = "dir",
        acc = "a"
    },
    [0x92] = {
        instruction = "sbc",
        cycles = 3,
        addr_mode = "dir",
        acc = "a"
    },
    [0x93] = {},
    [0x94] = {
        instruction = "and",
        cycles = 3,
        addr_mode = "dir",
        acc = "a"
    },
    [0x95] = {
        instruction = "bit",
        cycles = 3,
        addr_mode = "dir",
        acc = "a"
    },
    [0x96] = {
        instruction = "lda",
        cycles = 3,
        addr_mode = "dir",
        acc = "a"
    },
    [0x97] = {
        instruction = "sta",
        cycles = 4,
        addr_mode = "dir",
        acc = "a"
    },
    [0x98] = {
        instruction = "eor",
        cycles = 3,
        addr_mode = "dir",
        acc = "a"
    },
    [0x99] = {
        instruction = "adc",
        cycles = 3,
        addr_mode = "dir",
        acc = "a"
    },
    [0x9A] = {
        instruction = "ora",
        cycles = 3,
        addr_mode = "dir",
        acc = "a"
    },
    [0x9B] = {
        instruction = "add",
        cycles = 3,
        addr_mode = "dir",
        acc = "a"
    },
    [0x9C] = {
        instruction = "cpx",
        cycles = 4,
        addr_mode = "dir16"
    },
    [0x9D] = {
        instruction = "hcf",
        addr_mode = "inh"
    },
    [0x9E] = {
        instruction = "lds",
        cycles = 4,
        addr_mode = "dir16",
    },
    [0x9F] = {
        instruction = "sts",
        cycles = 5,
        addr_mode = "dir16",
    },
    [0xA0] = {
        instruction = "sub",
        cycles = 5,
        addr_mode = "idx",
        acc = "a"
    },
    [0xA1] = {
        instruction = "cmp",
        cycles = 5,
        addr_mode = "idx",
        acc = "a"
    },
    [0xA2] = {
        instruction = "sbc",
        cycles = 5,
        addr_mode = "idx",
        acc = "a"
    },
    [0xA3] = {},
    [0xA4] = {
        instruction = "and",
        cycles = 5,
        addr_mode = "idx",
        acc = "a"
    },
    [0xA5] = {
        instruction = "bit",
        cycles = 5,
        addr_mode = "idx",
        acc = "a"
    },
    [0xA6] = {
        instruction = "lda",
        cycles = 5,
        addr_mode = "idx",
        acc = "a"
    },
    [0xA7] = {
        instruction = "sta",
        cycles = 6,
        addr_mode = "idx",
        acc = "a"
    },
    [0xA8] = {
        instruction = "eor",
        cycles = 5,
        addr_mode = "idx",
        acc = "a"
    },
    [0xA9] = {
        instruction = "adc",
        cycles = 5,
        addr_mode = "idx",
        acc = "a"
    },
    [0xAA] = {
        instruction = "ora",
        cycles = 5,
        addr_mode = "idx",
        acc = "a"
    },
    [0xAB] = {
        instruction = "add",
        cycles = 5,
        addr_mode = "idx",
        acc = "a"
    },
    [0xAC] = {
        instruction = "cpx",
        cycles = 6,
        addr_mode = "idx16"
    },
    [0xAD] = {
        instruction = "jsr",
        cycles = 8,
        addr_mode = "immx"--"idx",
    },
    [0xAE] = {
        instruction = "lds",
        cycles = 6,
        addr_mode = "idx16",
    },
    [0xAF] = {
        instruction = "sts",
        cycles = 7,
        addr_mode = "idx16",
    },
    [0xB0] = {
        instruction = "sub",
        cycles = 4,
        addr_mode = "ext",
        acc = "a"
    },
    [0xB1] = {
        instruction = "cmp",
        cycles = 4,
        addr_mode = "ext",
        acc = "a"
    },
    [0xB2] = {
        instruction = "sbc",
        cycles = 4,
        addr_mode = "ext",
        acc = "a"
    },
    [0xB3] = {},
    [0xB4] = {
        instruction = "and",
        cycles = 4,
        addr_mode = "ext",
        acc = "a"
    },
    [0xB5] = {
        instruction = "bit",
        cycles = 4,
        addr_mode = "ext",
        acc = "a"
    },
    [0xB6] = {
        instruction = "lda",
        cycles = 4,
        addr_mode = "ext",
        acc = "a"
    },
    [0xB7] = {
        instruction = "sta",
        cycles = 5,
        addr_mode = "ext",
        acc = "a"
    },
    [0xB8] = {
        instruction = "eor",
        cycles = 4,
        addr_mode = "ext",
        acc = "a"
    },
    [0xB9] = {
        instruction = "adc",
        cycles = 4,
        addr_mode = "ext",
        acc = "a"
    },
    [0xBA] = {
        instruction = "ora",
        cycles = 4,
        addr_mode = "ext",
        acc = "a"
    },
    [0xBB] = {
        instruction = "add",
        cycles = 4,
        addr_mode = "ext",
        acc = "a"
    },
    [0xBC] = {
        instruction = "cpx",
        cycles = 5,
        addr_mode = "ext16"--"ext"
    },
    [0xBD] = {
        instruction = "jsr",
        cycles = 9,
        addr_mode = "imm16"--"ext",
    },
    [0xBE] = {
        instruction = "lds",
        cycles = 5,
        addr_mode = "ext16"--"ext",
    },
    [0xBF] = {
        instruction = "sts",
        cycles = 6,
        addr_mode = "ext16"--"ext",
    },
    [0xC0] = {
        instruction = "sub",
        cycles = 2,
        addr_mode = "imm",
        acc = "b"
    },
    [0xC1] = {
        instruction = "cmp",
        cycles = 2,
        addr_mode = "imm",
        acc = "b"
    },
    [0xC2] = {
        instruction = "sbc",
        cycles = 2,
        addr_mode = "imm",
        acc = "b"
    },
    [0xC3] = {},
    [0xC4] = {
        instruction = "and",
        cycles = 2,
        addr_mode = "imm",
        acc = "b"
    },
    [0xC5] = {
        instruction = "bit",
        cycles = 2,
        addr_mode = "imm",
        acc = "b"
    },
    [0xC6] = {
        instruction = "lda",
        cycles = 2,
        addr_mode = "imm",
        acc = "b"
    },
    [0xC7] = {
        -- TODO increments PC before storing!
        instruction = "sta",
        cycles = 2,
        addr_mode = "imm",
        acc = "b"
    },
    [0xC8] = {
        instruction = "eor",
        cycles = 2,
        addr_mode = "imm",
        acc = "b"
    },
    [0xC9] = {
        instruction = "adc",
        cycles = 2,
        addr_mode = "imm",
        acc = "b"
    },
    [0xCA] = {
        instruction = "ora",
        cycles = 2,
        addr_mode = "imm",
        acc = "b"
    },
    [0xCB] = {
        instruction = "add",
        cycles = 2,
        addr_mode = "imm",
        acc = "b"
    },
    [0xCC] = {},
    [0xCD] = {
        -- TODO different kind of HCF
        -- https://x86.fr/investigating-the-halt-and-catch-fire-instruction-on-motorola-6800/
        instruction = "hcf",
        addr_mode = "inh"
    },
    [0xCE] = {
        instruction = "ldx",
        cycles = 3,
        addr_mode = "imm16",
    },
    [0xCF] = {
        -- TODO increments PC before storing!
        instruction = "stx",
        cycles = 2, -- TODO
        addr_mode = "imm16",
    },
    [0xD0] = {
        instruction = "sub",
        cycles = 3,
        addr_mode = "dir",
        acc = "b"
    },
    [0xD1] = {
        instruction = "cmp",
        cycles = 3,
        addr_mode = "dir",
        acc = "b"
    },
    [0xD2] = {
        instruction = "sbc",
        cycles = 3,
        addr_mode = "dir",
        acc = "b"
    },
    [0xD3] = {},
    [0xD4] = {
        instruction = "and",
        cycles = 3,
        addr_mode = "dir",
        acc = "b"
    },
    [0xD5] = {
        instruction = "bit",
        cycles = 3,
        addr_mode = "dir",
        acc = "b"
    },
    [0xD6] = {
        instruction = "lda",
        cycles = 3,
        addr_mode = "dir",
        acc = "b"
    },
    [0xD7] = {
        instruction = "sta",
        cycles = 4,
        addr_mode = "dir",
        acc = "b"
    },
    [0xD8] = {
        instruction = "eor",
        cycles = 3,
        addr_mode = "dir",
        acc = "b"
    },
    [0xD9] = {
        instruction = "adc",
        cycles = 3,
        addr_mode = "dir",
        acc = "b"
    },
    [0xDA] = {
        instruction = "ora",
        cycles = 3,
        addr_mode = "dir",
        acc = "b"
    },
    [0xDB] = {
        instruction = "add",
        cycles = 3,
        addr_mode = "dir",
        acc = "b"
    },
    [0xDC] = {},
    [0xDD] = {
        instruction = "hcf",
        addr_mode = "inh"
    },
    [0xDE] = {
        instruction = "ldx",
        cycles = 4,
        addr_mode = "dir16",
    },
    [0xDF] = {
        instruction = "stx",
        cycles = 5,
        addr_mode = "dir16"
    },
    [0xE0] = {
        instruction = "sub",
        cycles = 5,
        addr_mode = "idx",
        acc = "b"
    },
    [0xE1] = {
        instruction = "cmp",
        cycles = 5,
        addr_mode = "idx",
        acc = "b"
    },
    [0xE2] = {
        instruction = "sbc",
        cycles = 5,
        addr_mode = "idx",
        acc = "b"
    },
    [0xE3] = {},
    [0xE4] = {
        instruction = "and",
        cycles = 5,
        addr_mode = "idx",
        acc = "b"
    },
    [0xE5] = {
        instruction = "bit",
        cycles = 5,
        addr_mode = "idx",
        acc = "b"
    },
    [0xE6] = {
        instruction = "lda",
        cycles = 5,
        addr_mode = "idx",
        acc = "b"
    },
    [0xE7] = {
        instruction = "sta",
        cycles = 6,
        addr_mode = "idx",
        acc = "b"
    },
    [0xE8] = {
        instruction = "eor",
        cycles = 5,
        addr_mode = "idx",
        acc = "b"
    },
    [0xE9] = {
        instruction = "adc",
        cycles = 5,
        addr_mode = "idx",
        acc = "b"
    },
    [0xEA] = {
        instruction = "ora",
        cycles = 5,
        addr_mode = "idx",
        acc = "b"
    },
    [0xEB] = {
        instruction = "add",
        cycles = 5,
        addr_mode = "idx",
        acc = "b"
    },
    [0xEC] = {},
    [0xED] = {
        -- TODO different kind of HCF
        -- https://x86.fr/investigating-the-halt-and-catch-fire-instruction-on-motorola-6800/
        instruction = "hcf",
        addr_mode = "inh"
    },
    [0xEE] = {
        instruction = "ldx",
        cycles = 6,
        addr_mode = "idx16",
    },
    [0xEF] = {
        instruction = "stx",
        cycles = 7,
        addr_mode = "idx16",
    },
    [0xF0] = {
        instruction = "sub",
        cycles = 4,
        addr_mode = "ext",
        acc = "b"
    },
    [0xF1] = {
        instruction = "cmp",
        cycles = 4,
        addr_mode = "ext",
        acc = "b"
    },
    [0xF2] = {
        instruction = "sbc",
        cycles = 4,
        addr_mode = "ext",
        acc = "b"
    },
    [0xF3] = {},
    [0xF4] = {
        instruction = "and",
        cycles = 4,
        addr_mode = "ext",
        acc = "b"
    },
    [0xF5] = {
        instruction = "bit",
        cycles = 4,
        addr_mode = "ext",
        acc = "b"
    },
    [0xF6] = {
        instruction = "lda",
        cycles = 4,
        addr_mode = "ext",
        acc = "b"
    },
    [0xF7] = {
        instruction = "sta",
        cycles = 5,
        addr_mode = "ext",
        acc = "b"
    },
    [0xF8] = {
        instruction = "eor",
        cycles = 4,
        addr_mode = "ext",
        acc = "b"
    },
    [0xF9] = {
        instruction = "adc",
        cycles = 4,
        addr_mode = "ext",
        acc = "b"
    },
    [0xFA] = {
        instruction = "ora",
        cycles = 4,
        addr_mode = "ext",
        acc = "b"
    },
    [0xFB] = {
        instruction = "add",
        cycles = 4,
        addr_mode = "ext",
        acc = "b"
    },
    [0xFC] = {},
    [0xFD] = {
        -- TODO slower HCF
        -- https://x86.fr/investigating-the-halt-and-catch-fire-instruction-on-motorola-6800/
        instruction = "hcf",
        addr_mode = "inh"
    },
    [0xFE] = {
        instruction = "ldx",
        cycles = 5,
        addr_mode = "ext16"--"ext",
    },
    [0xFF] = {
        instruction = "stx",
        cycles = 6,
        addr_mode = "ext16"--"ext",
    },

}
