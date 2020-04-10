local keypad = {}

keypad.keys_dream = {
[0]=0x0, 0x1, 0x2, 0x3,
    0x4, 0x5, 0x6, 0x7,
    0x8, 0x9, 0xA, 0xB,
    0xC, 0xD, 0xE, 0xF
}

--keypad.keys_dream_2 = {
--[0]=0xC, 0xD, 0xE, 0xF,
--    0x8, 0x9, 0xA, 0xB,
--    0x4, 0x5, 0x6, 0x7,
--    0x0, 0x1, 0x2, 0x3
--}

keypad.keys_qwerty = {
[0]="1", "2", "3", "4",
    "q", "w", "e", "r",
    "a", "s", "d", "f",
    "z", "x", "c", "v"
}

-- The most significant nibble is inverted here from what the
-- actual DREAM keypad sends, but when the PIA A peripheral pins
-- send output to the keypad in the decoding routine, some
-- pullups in the keypad invert the signal for decoding the
-- most significant nibble.
keypad.key_bits = {
[0]=0xEE, 0xED, 0xEB, 0xE7,
    0xDE, 0xDD, 0xDB, 0xD7,
    0xBE, 0xBD, 0xBB, 0xB7,
    0x7E, 0x7D, 0x7B, 0x77
}

keypad.key_mapping = {}
keypad.key_status = {}
keypad.button_status = {}

for i = 0, 15 do
    keypad.key_mapping[keypad.keys_qwerty[i]] = keypad.keys_dream[i]
    keypad.key_status[keypad.keys_dream[i]] = false
end

function keypad:connect(pia_port)
    self.pia = pia_port
    self.pia.p = 0x0F
end

function keypad:keypressed(key)
    local hexkey = self.key_mapping[key]
    if hexkey then
        self.key_status[hexkey] = true
        self.pia.c1 = true
        self.pia.p = self.key_bits[hexkey]
    elseif key == "lshift" or key == "rshift" then
        self.pia.c2 = true
    end
end

function keypad:keyreleased(key)
    local hexkey = self.key_mapping[key]
    if hexkey then
        self.key_status[hexkey] = false
        self.pia.c1 = false
        self.pia.p = 0x0F
    elseif key == "lshift" or key == "rshift" then
        self.pia.c2 = false
    end
end

return keypad