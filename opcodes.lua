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
