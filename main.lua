local CPU = require 'cpu'
local UI = require 'ui'
local keypad = require 'keypad'
local util = require 'util'

local conf = require "conf"
local t = {modules = {}, window = {}}
love.conf(t)
local debug = t.console

num_instructions = 0
cycles = 0

function love.load(arg)
    --min_dt = 1/60--60 --fps
    --next_time = love.timer.getTime()
    --debug.debug()

    local memory = require 'memory'
    CPU:init(memory)

    local ram = require 'ram'(0x0FFF)
    memory:connect(0x0000, ram)

    local pia = require 'pia'
    memory:connect(0x8010, pia.a)
    memory:connect(0x8012, pia.b)

    keypad:connect(pia.a)

    local rom = util.read_file("Dream6800Rom.bin")
    local eprom = require 'eprom'(rom)
    for address = 0xC000, 0xFFFF - rom.size + 1, rom.size do
        memory:connect(address, eprom)
    end

    UI:init(CPU, keypad)
    UI.ram = ram
end

function love.filedropped(file)
    util.read_file(file) -- TODO
end

function love.update(dt)
    if not CPU.pause then
        while cycles < 1000000 / 50 and not CPU.pause do
            cycles = cycles + CPU:cycle()
            num_instructions = num_instructions + 1
        end
        if cycles >= 1000000 / 50 then
            cycles = cycles - (1000000 / 50)
            --PIA should check its own interrupt flag and send IRQ til MPU...
            CPU.irq = true
        end
        for k, v in pairs(keypad.button_status) do
            if v then
                keypad:keyreleased(keypad.keys_qwerty[k])
            end
        end

        CPU.drawflag = true

    end
end

function love.draw()
    UI:draw()
    if debug then
        love.graphics.setColor(1, 0, 0, 1)
        love.graphics.print(string.format("FPS: %d", love.timer.getFPS()), 0, love.graphics.getHeight() - 20)
        love.graphics.setColor(1, 1, 1, 1)
    end
end

function love.keypressed(key, scancode)
    UI.KeyPressed(key)
    if not UI.GetWantCaptureKeyboard() then
        keypad:keypressed(key, scancode)
        if key == "space" then
            CPU.pause = not CPU.pause
        elseif key == "escape" then
            CPU.reset = true
        end

        if CPU.pause and key == "right" then
            --next_time = next_time + min_dt
            --cycles = cycles + CPU:execute(CPU:decode(CPU:fetch()))
            cycles = cycles + CPU:cycle()
            CPU.drawflag = true
            num_instructions = num_instructions + 1
            if cycles >= 1000000 / 50 then
                cycles = cycles - (1000000 / 50)
                CPU.irq = true
            end
        end
    end
end

function love.keyreleased(key, scancode)
    UI.KeyReleased(key)
    if not UI.GetWantCaptureKeyboard() then
        keypad:keyreleased(key, scancode)
    end
end