local CPU = require 'cpu'
local UI = require 'ui'
local keypad = require 'keypad'

local conf = require "conf"
local t = {modules = {}, window = {}}
love.conf(t)
local debug = t.console

num_instructions = 0
cycles = 0

local shaders = {}

local romfile


function love.load(arg)
    --min_dt = 1/60--60 --fps
    --next_time = love.timer.getTime()
    --debug.debug()

    CPU:init()
    keypad:connect(CPU.memory.pia.a)

    romfile = arg[1] or "Dream6800Rom.bin"
    local file = love.filesystem.newFile(romfile)
    local ok, err = file:open("r")
    if ok then
        CPU.rom_loaded = true
        CPU:read_rom(file, 0xC000)
    else
        print(err)
        CPU.rom_loaded = false
    end
    file:close()

    UI:init(CPU, keypad)
end

function love.filedropped(file)
    CPU:init()

    local ok, err = file:open("r")
    if ok then
        CPU:read_rom(file)
        CPU.rom_loaded = true
    else
        print(err)
        CPU.rom_loaded = false
    end
    file:close()
end

function love.update(dt)
    if not CPU.pause then
        while cycles < 1000000 / 50 and not CPU.pause do
            cycles = cycles + CPU:cycle()
            num_instructions = num_instructions + 1
        end
        if cycles >= 1000000 / 50 then
            cycles = cycles - (1000000 / 50)
            --CPU.memory[0x8013] = bit.bor(CPU.memory[0x8013], 0x80)
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

function love.quit()
    imgui.ShutDown()
end

function love.keypressed(key, scancode)
    imgui.KeyPressed(key)
    if not imgui.GetWantCaptureKeyboard() then
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
                --CPU.memory[0x8013] = bit.bor(CPU.memory[0x8013], 0x80)
                CPU.irq = true
            end
        end
    end
end

function love.keyreleased(key, scancode)
    imgui.KeyReleased(key)
    if not imgui.GetWantCaptureKeyboard() then
        keypad:keyreleased(key, scancode)
    end
end

function love.mousemoved(x, y)
    imgui.MouseMoved(x, y, true)
    if not imgui.GetWantCaptureMouse() then
        -- Pass event to the game
    end
end

function love.mousepressed(x, y, button)
    imgui.MousePressed(button)
    if not imgui.GetWantCaptureMouse() then
        -- Pass event to the game
    end
end

function love.mousereleased(x, y, button)
    imgui.MouseReleased(button)
    if not imgui.GetWantCaptureMouse() then
        -- Pass event to the game
    end
end

function love.wheelmoved(x, y)
    imgui.WheelMoved(y)
    if not imgui.GetWantCaptureMouse() then
        -- Pass event to the game
    end
end

function love.textinput(t)
    imgui.TextInput(t)
    if not imgui.GetWantCaptureKeyboard() then
        -- Pass event to the game
    end
end
