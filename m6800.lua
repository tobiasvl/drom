-- master object for the computer
-- knows about CPU, memory, everything else
-- plus cycle count, instruction count, etc
-- and each object receives a pointer to the objects it needs to know about.
-- CPU gets memory
-- memory does not get CPU!!
-- they all get Debug?
-- what about debug callbacks maybe?
-- and they all get UI

-- the CPU shouldn't read_rom wtf

-- clean up yo mess!!

local m6800 = {}

cpu = require "cpu"

eprom
ram

memory = require "memory"
pia = require "pia"

cpu:init()

keypad = require "keypad"

pia.a(keypad)
pia.b(tape_deck)

return m6800