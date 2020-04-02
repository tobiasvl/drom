local CPU = require 'cpu'
local UI = require 'ui'

local conf = require "conf"
local t = {modules = {}, window = {}}
love.conf(t)
local debug = t.console

num_instructions = 0
cycles = 0

local keys_cosmac = {
    0x1,
    0x2,
    0x3,
    0xC,
    0x4,
    0x5,
    0x6,
    0xD,
    0x7,
    0x8,
    0x9,
    0xE,
    0xA,
    0x0,
    0xB,
    0xF
}

local keys_qwerty = {
    "1",
    "2",
    "3",
    "4",
    "q",
    "w",
    "e",
    "r",
    "a",
    "s",
    "d",
    "f",
    "z",
    "x",
    "c",
    "v"
}

local key_mapping = {}
local button_status = {}
for k, v in pairs(keys_cosmac) do
    key_mapping[keys_qwerty[k]] = v
    button_status[v] = false
end

local shaders = {}

local romfile

function love.load(arg)
    --min_dt = 1/60--60 --fps
    --next_time = love.timer.getTime()
    --debug.debug()

    UI:init(CPU)
    CPU:init()

    CPU.pause = true

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
        --local temp_key_status = {}
        --for k, v in pairs(button_status) do
        --    temp_key_status[k] = CPU.key_status[k]
        --    if v then
        --        CPU.key_status[k] = v
        --    end
        --end
        while cycles < 1000000 / 50 do
            cycles = cycles + CPU:cycle()
            num_instructions = num_instructions + 1
        end
        cycles = cycles - (1000000 / 50)
        CPU.drawflag = true

        --for k, v in pairs(button_status) do
        --    CPU.key_status[k] = temp_key_status[k]
        --end
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

function love.keypressed(key)
    imgui.KeyPressed(key)
    if not imgui.GetWantCaptureKeyboard() then
        if key_mapping[key] then
            CPU.key_status[key_mapping[key]] = true
        end

        if key == "space" then CPU.pause = not CPU.pause end
        if CPU.pause and key == "right" then
            --next_time = next_time + min_dt
            --cycles = cycles + CPU:execute(CPU:decode(CPU:fetch()))
            cycles = cycles + CPU:cycle()
            CPU.drawflag = true
            num_instructions = num_instructions + 1
        end
    end
end

function love.keyreleased(key)
    imgui.KeyReleased(key)
    if not imgui.GetWantCaptureKeyboard() then
        if key_mapping[key] then
            CPU.key_status[key_mapping[key]] = false
        end
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
