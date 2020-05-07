local imgui = require "imgui"
local moonshine = require 'moonshine'
local disassembler = require "disassembler"

local lg = love.graphics

local ui = {}

local hex_input_flags = {
    "ImGuiInputTextFlags_CharsHexadecimal",
    "ImGuiInputTextFlags_CharsUppercase",
    "ImGuiInputTextFlags_EnterReturnsTrue"
}

function love.mousemoved(x, y)
    imgui.MouseMoved(x, y, true)
end

function love.mousepressed(_, _, button)
    imgui.MousePressed(button)
end

function love.mousereleased(_, _, button)
    imgui.MouseReleased(button)
end

function love.wheelmoved(_, y)
    imgui.WheelMoved(y)
end

love.textinput = imgui.TextInput
love.quit = imgui.ShutDown

ui.KeyPressed = imgui.KeyPressed
ui.KeyReleased = imgui.KeyReleased
ui.GetWantCaptureKeyboard = imgui.GetWantCaptureKeyboard

function ui:init(CPU, keypad)
    self.CPU = CPU
    self.keypad = keypad

    disassembler:disassemble(self.CPU.memory)

    self.canvases = {
        display = lg.newCanvas(64*8, 32*8),
        speaker = lg.newCanvas(60, 60),
        speaker_mute = lg.newCanvas(60, 60),
        speaker_active = lg.newCanvas(60, 60),
        speaker_mute_active = lg.newCanvas(60, 60)
    }

    self.shaders = {
        scanlines = true,
        glow = true,
        chromasep = true,
        crt = true
    }

    self.showDisplayWindow = true
    self.showKeypadWindow = true
    self.showCPUWindow = true
    self.showPIAWindow = true
    self.showInstructionsWindow = true
    self.showMemoryWindow = true
    self.showSpeakerWindow = true

    self.memoryScroll = 0
    self.memoryScrollNow = false

    self.effect = moonshine(64*8, 32*8, moonshine.effects.scanlines)
        .chain(moonshine.effects.glow)
        .chain(moonshine.effects.chromasep)
        .chain(moonshine.effects.crt)
    self.effect.chromasep.angle = 0.15
    self.effect.chromasep.radius = 2
    self.effect.scanlines.width = 1
    self.effect.crt.distortionFactor = {1.02, 1.065}
    self.effect.glow.strength = 3
    self.effect.glow.min_luma = 0.9

    self.speaker = {
        mute = false,
        volume = 1.0,
        sound = love.audio.newSource("assets/1khz.wav", "static"),
        image = lg.newImage("assets/speaker.png"),
        image_mute = lg.newImage("assets/speaker-mute.png"),
    }

    -- This is unfortunate, but I haven't figured out a way to use
    -- colors with imgui.Image (or imgui.ButtonImage), so I make lots
    -- of canvases instead...
    lg.setCanvas(self.canvases.speaker)
    lg.draw(self.speaker.image, 0, 0, 0, 0.25, 0.25)
    lg.setCanvas()

    lg.setCanvas(self.canvases.speaker_mute)
    lg.draw(self.speaker.image_mute, 0, 0, 0, 0.25, 0.25)
    lg.setCanvas()

    lg.setColor(1, 0, 0, 1)

    lg.setCanvas(self.canvases.speaker_active)
    lg.draw(self.speaker.image, 0, 0, 0, 0.25, 0.25)
    lg.setCanvas()

    lg.setCanvas(self.canvases.speaker_mute_active)
    lg.draw(self.speaker.image_mute, 0, 0, 0, 0.25, 0.25)
    lg.setCanvas()

    lg.setColor(1, 1, 1, 1)
end

function ui:update(dt)
    --local temp_key_status = {}
    --for k, v in pairs(button_status) do
    --    temp_key_status[k] = CPU.key_status[k]
    --    if v then
    --        CPU.key_status[k] = v
    --    end
    --end

    -- foo

    --for k, v in pairs(button_status) do
    --    CPU.key_status[k] = temp_key_status[k]
    --end
end

function ui:draw()
    local sound_playing = bit.band(self.CPU.memory[0x8012], 0x40) ~= 0 -- TODO read from pins, not bus

    if sound_playing and not self.speaker.mute then
        self.speaker.sound:play()
    end

    imgui.NewFrame()

    if self.showSpeakerWindow then
        imgui.SetNextWindowPos(0, 20, "ImGuiCond_FirstUseEver")
        self.showSpeakerWindow = imgui.Begin("Speaker", true, { })--, { "ImGuiWindowFlags_AlwaysAutoResize" })

        local toggle = false
        if self.speaker.mute then
            if sound_playing then
                toggle = imgui.ImageButton(self.canvases.speaker_mute_active, 60, 60)
            else
                toggle = imgui.ImageButton(self.canvases.speaker_mute, 60, 60)
            end
        else
            if sound_playing then
                toggle = imgui.ImageButton(self.canvases.speaker_active, 60, 60)
            else
                toggle = imgui.ImageButton(self.canvases.speaker, 60, 60)
            end
        end
        if toggle then self.speaker.mute = not self.speaker.mute end

        imgui.End()
    end

    if self.showDisplayWindow then
        imgui.SetNextWindowPos(0, 20, "ImGuiCond_FirstUseEver")
        self.showDisplayWindow = imgui.Begin("Display", nil, { "NoCollapse", "MenuBar" })--, { "ImGuiWindowFlags_AlwaysAutoResize" })
        if imgui.BeginMenuBar() then
            if imgui.BeginMenu("Effects") then
                for k, _ in pairs(self.shaders) do
                    if imgui.MenuItem(k, nil, self.shaders[k], true) then
                        self.shaders[k] = not self.shaders[k]
                        if self.shaders[k] then
                            self.effect.enable(k)
                        else
                            self.effect.disable(k)
                        end
                    end
                end
                imgui.EndMenu()
            end
            if imgui.BeginMenu("Tools") then
                if imgui.MenuItem("Save screenshot", nil, false, true) then
                    self.canvases.display:newImageData():encode('png', os.time() .. ".png")
                end
                imgui.EndMenu()
            end
            imgui.EndMenuBar()
        end
--        local win_x, win_y = imgui.GetWindowSize()
        if self.CPU.display and self.CPU.drawflag then
            lg.setCanvas(self.canvases.display)
            lg.clear()
            self.effect(function()
                lg.setColor(1,1,1)
                for y = 0, 31 do
                    for x = 0, 7 do
                        local byte = self.CPU.memory[0x100 + (y * 8) + x]
                        for xx = 0, 7 do
                            local pixel = bit.band(byte, 0x80)
                            byte = bit.lshift(byte, 1)
                            if pixel ~= 0 then
                                lg.rectangle("fill", (x * 64) + (xx * 8), y * 8, 8, 8)
                            end
                        end
                    end
                end
            end)
            lg.setCanvas()
            self.CPU.drawflag = false
        end
        imgui.Image(self.canvases.display, 64*8 + 8, 32*8)
        imgui.End()
    end

    if self.showCPUWindow then
        imgui.SetNextWindowSize(200, 200, "ImGuiCond_FirstUseEver")
        self.showCPUWindow = imgui.Begin("CPU", true)
        imgui.Text(string.format("Cycles: %d", cycles))
        for _, reg in ipairs({"a", "b"}) do
            if self.CPU.registers[reg]() ~= self.CPU.registers[reg].prev_value and num_instructions == self.CPU.registers[reg].prev_inst + 1 then
                imgui.PushStyleColor("ImGui_Text", 1, 0, 0, 1)
            end
            imgui.Text(string.format(" %s:       %02X", reg, self.CPU.registers[reg]()))
            if self.CPU.registers[reg]() ~= self.CPU.registers[reg].prev_value and num_instructions == self.CPU.registers[reg].prev_inst + 1 then
                imgui.PopStyleColor()
            end
        end
        for _, reg in ipairs({"pc", "sp", "ix"}) do
            if self.CPU.registers[reg]() ~= self.CPU.registers[reg].prev_value and num_instructions == self.CPU.registers[reg].prev_inst + 1 then
                imgui.PushStyleColor("ImGui_Text", 1, 0, 0, 1)
            end
            imgui.Text(string.format("%s:     %04X", reg, self.CPU.registers[reg]()))
            if self.CPU.registers[reg]() ~= self.CPU.registers[reg].prev_value and num_instructions == self.CPU.registers[reg].prev_inst + 1 then
                imgui.PopStyleColor()
            end
        end
        local s = ""
        for i, cc in ipairs({"h", "i", "n", "z", "v", "c"}) do
            s = s .. (self.CPU.registers.status[cc] and "1" or "0")
        end
        imgui.Text(string.format("CC: 11%s", s))--string.format("CC: %02X", self.CPU.registers.status()))
        imgui.Text("      HINZVC")
        if self.CPU.irq then
            imgui.PushStyleColor("ImGui_Text", 1, 0, 0, 1)
        end
        imgui.Text("IRQ")
        if self.CPU.irq then
            imgui.PopStyleColor()
        end
        imgui.SameLine()
        if self.CPU.reset then
            imgui.PushStyleColor("ImGui_Text", 1, 0, 0, 1)
        end
        imgui.Text("RST")
        if self.CPU.reset then
            imgui.PopStyleColor()
        end
        imgui.End()
    end

    if self.showPIAWindow then
        imgui.SetNextWindowSize(200, 200, "ImGuiCond_FirstUseEver")
        self.showPIAWindow = imgui.Begin("PIA", true)
        imgui.End()
    end

    if self.showInstructionsWindow then
        imgui.SetNextWindowSize(200, 200, "ImGuiCond_FirstUseEver")
        self.showInstructionsWindow = imgui.Begin("Instructions", true, "MenuBar")
        if imgui.BeginMenuBar() then
            if imgui.BeginMenu("Settings") then
                if imgui.MenuItem("Follow PC", nil, self.followPC, true) then
                    self.followPC = not self.followPC
                end
                imgui.EndMenu()
            end
            imgui.EndMenuBar()
        end
        imgui.Text("Breakpoint: ")
        imgui.SameLine()
        imgui.PushItemWidth(4 * 9) -- TODO get char width
        local text, textinput = imgui.InputText("##breakpoint", self.CPU.breakpoint and string.format("%04X", self.CPU.breakpoint) or "", 5, hex_input_flags)
        imgui.PopItemWidth()
        if textinput then
            self.CPU.breakpoint = tonumber(text, 16)
        end

        local padding = 2 -- Vertical space taken up by breakpoint and jump
        local font_height = imgui.GetFontSize() + 4
        imgui.BeginChild("##instructions", 0, -(font_height * padding))
        local win_w, win_h = imgui.GetWindowSize()
        local line = math.floor(imgui.GetScrollY() / font_height)
        local j = 0
        for i = 0, 0xFFFF do -- TODO only to the largest mapped memory?
            if self.instructionsScrollNow and self.instructionsScroll == i - math.floor(win_h / font_height / 2) - 1 then
                imgui.SetScrollHere()
                line = self.instructionsScroll
                self.instructionsScrollNow = false
            end
            if disassembler.memory[i] then
                if i == self.CPU.registers.pc() then
                    imgui.Text(">")
                    if self.followPC then
                        imgui.SetScrollHere()
                    end
                elseif i == self.CPU.breakpoint then
                    imgui.Text("!")
                else
                    imgui.Text(" ")
                end
                -- Cull output so we don't bog down the UI
                if j > line - 1 and j < line + (win_h / font_height) + 1 then
                    imgui.SameLine()
                    imgui.Text(string.format("%04X: ", i) .. disassembler.memory[i])
                end
                j = j + 1
            end
        end
        imgui.EndChild()
        -- Scroll
        imgui.Text("Scroll to: ")
        imgui.SameLine()
        imgui.PushItemWidth(4 * 9) -- TODO get char width
        local scroll, scroll_input = imgui.InputText("##instructionscroll", string.format("%04X", self.instructionsScroll or 0), 5, hex_input_flags)
        imgui.PopItemWidth()
        if scroll_input then
            self.instructionsScroll = tonumber(scroll, 16)
            self.instructionsScrollNow = true
        end
        imgui.End()
    end

    if self.showMemoryWindow then
        imgui.SetNextWindowSize(200, 200, "ImGuiCond_FirstUseEver")
        self.showMemoryWindow = imgui.Begin("Memory", true, "MenuBar")
        if imgui.BeginMenuBar() then
            if imgui.BeginMenu("Settings") then
                if imgui.MenuItem("Random uninitialized memory", nil, self.ram.uninitialized_random, true) then
                    self.ram:set_uninitialized_value(self.ram.uninitialized_random and 0 or nil)
                end
                imgui.EndMenu()
            end
            imgui.EndMenuBar()
        end

        -- Memory breakpoint
        imgui.Text("Breakpoint: ")
        imgui.SameLine()
        imgui.PushItemWidth(4 * 9) -- TODO get char width
        local breakpoint = self.CPU.memory.breakpoint
        local new_breakpoint, breakpoint_input = imgui.InputText("##membreakpoint", breakpoint.address and string.format("%04X", breakpoint.address) or "", 5, hex_input_flags)
        imgui.PopItemWidth()
        if breakpoint_input then
            breakpoint.address = tonumber(new_breakpoint, 16)
        end
        imgui.SameLine()
        breakpoint.read = imgui.Checkbox("R", breakpoint.read)
        imgui.SameLine()
        breakpoint.write = imgui.Checkbox("W", breakpoint.write)

        -- Memory viewer
        local padding = 3 -- Vertical space taken up by breakpoint and jump
        local font_height = imgui.GetFontSize() + 4
        imgui.BeginChild("##memory", 0, -(font_height * padding))
        local win_w, win_h = imgui.GetWindowSize()
        local line = math.floor(imgui.GetScrollY() / font_height)
        for i = 0, 0xFFFF do -- TODO only to the largest mapped memory?
            -- Set scroll if user has jumped to an address
            -- imgui.SetScrollHere() sets it immediately, and centers the viewport
            -- We want the address to be at the top (do we really?) so maths
            if self.memoryScrollNow and self.memoryScroll == i - math.floor(win_h / font_height / 2) - 1 then
                imgui.SetScrollHere()
                line = self.memoryScroll
                self.memoryScrollNow = false
            end
            -- Cull output so we don't bog down the UI
            if i > line - 1 and i < line + (win_h / font_height) + 1 then
                local c = self.CPU.memory[i]
                if i < self.ram.size and not self.ram.initialized[i] then
                    imgui.PushStyleColor("ImGui_Text", 0.65, 0.65, 0.65, 1)
                end
                imgui.Text(string.format("%04X: %02X %03d", i, c, c))
                imgui.SameLine()
                -- Print only printable ASCII characters
                if c > 31 and c < 127 then imgui.Text(string.char(c) .. " ") else imgui.Text("  ") end
                imgui.SameLine()
                local byte = {}
                for j = 1, 8 do
                    byte[j] = bit.band(bit.rshift(c, 7 - j + 1), 1)
                end
                imgui.Text(table.concat(byte))
                if i < self.ram.size and not self.ram.initialized[i] then
                    imgui.PopStyleColor()
                end
            else
                imgui.Text("")
            end
        end
        -- If we should scroll but haven't yet, we want to scroll to the end
        if self.memoryScrollNow then
            imgui.SetScrollHere(1)
            self.memoryScrollNow = false
        end
        imgui.EndChild()

        -- Scroll
        imgui.Text("Scroll to: ")
        imgui.SameLine()
        imgui.PushItemWidth(4 * 9) -- TODO get char width
        local scroll, scroll_input = imgui.InputText("##memscroll", string.format("%04X", self.memoryScroll or 0), 5, hex_input_flags)
        imgui.PopItemWidth()
        if scroll_input then
            self.memoryScroll = tonumber(scroll, 16)
            self.memoryScrollNow = true
        end
        if imgui.Button("RAM") then
            self.memoryScroll = 0
            self.memoryScrollNow = true
        end
        imgui.SameLine()
        if imgui.Button("CHIP-8") then
            self.memoryScroll = 0x0200
            self.memoryScrollNow = true
        end
        imgui.SameLine()
        if imgui.Button("ROM") then
            self.memoryScroll = 0xC000
            self.memoryScrollNow = true
        end

        imgui.End()
    end

    if self.showKeypadWindow then
        imgui.SetNextWindowPos(540, 300, "ImGuiCond_FirstUseEver")
        self.showKeypadWindow = imgui.Begin("Keypad", true, { "NoScrollbar", "MenuBar" })
        if imgui.BeginMenuBar() then
            if imgui.BeginMenu("Layout") then
                if imgui.MenuItem("Digitran", nil, self.keypad.keys_dream == self.keypad.keys_digitran, true) then
                    self.keypad.keys_dream = self.keypad.keys_digitran
                end
                if imgui.IsItemHovered() then
                    imgui.SetTooltip("Used in many DREAM builds; de facto standard.\nStandard layout in the DREAMER newsletter.\nAlso used by the 40th anniversary DREAM reproduction")
                end
                if imgui.MenuItem("Original", nil, self.keypad.keys_dream == self.keypad.keys_original, true) then
                    self.keypad.keys_dream = self.keypad.keys_original
                end
                if imgui.IsItemHovered() then
                    imgui.SetTooltip("The layout used in the Electronics Australia articles.\nUsed by the prototype DREAM 6800, and the CHIP-8 Classic Computer.")
                end
                if imgui.MenuItem("COSMAC VIP", nil, self.keypad.keys_dream == self.keypad.keys_cosmac, true) then
                    self.keypad.keys_dream = self.keypad.keys_cosmac
                end
                if imgui.IsItemHovered() then
                    imgui.SetTooltip("Used by RCA's COSMAC VIP, the DREAM's predecessor.\nUseful for CHIP-8 compatibility.")
                end
                imgui.EndMenu()
            end
            imgui.EndMenuBar()
        end
        local win_w, win_h = imgui.GetWindowSize()
        local but_w, but_h = (win_w / 4) - 5, (win_h / 5) - (7 * 2)
        for k = 0, 15 do
            -- TODO this can't be right
            if self.keypad.button_status[k] then
                self.keypad.button_status[k] = false
                self.keypad:keyreleased(nil, self.keypad.keys_qwerty[k])
            end
            local button_pressed = false
            if self.keypad.key_status[k] then
                button_pressed = true
                imgui.PushStyleColor("ImGuiCol_Button", 117 / 255, 138 / 255, 204 / 255, 1)
            end
            self.keypad.button_status[k] = imgui.Button(string.format("%X", self.keypad.keys_dream.layout[k]), but_w, but_h)
            if self.keypad.button_status[k] then
                self.keypad:keypressed(nil, self.keypad.keys_qwerty[k])
            end
            if button_pressed then
                imgui.PopStyleColor(1)
            end
            if imgui.IsItemHovered() then
                imgui.SetTooltip(self.keypad.keys_qwerty[k])
            end
            if (k + 1) % 4 ~= 0 then
                imgui.SameLine(0, 4)
            end
        end
        imgui.Dummy(0, 2)
        if imgui.Button("FN", (but_w * 2) + 4, but_h) then
            self.keypad:keypressed(nil, "lshift")
        end
        if imgui.IsItemHovered() then
            imgui.SetTooltip("shift")
        end
        imgui.SameLine(0, 4)
        if imgui.Button("RESET", (but_w * 2) + 4, but_h) then
            self.CPU.reset = true
        end
        if imgui.IsItemHovered() then
            imgui.SetTooltip("escape")
        end
        imgui.End()
    end

    if imgui.BeginMainMenuBar() then
        if imgui.BeginMenu("File") then
            if imgui.MenuItem("Quit") then
                love.event.quit()
            end
            imgui.EndMenu()
        end
        if imgui.BeginMenu("Windows") then
            if imgui.MenuItem("Display", nil, self.showDisplayWindow, false) then
                self.showDisplayWindow = not self.showDisplayWindow
            end
            if imgui.MenuItem("CPU", nil, self.showCPUWindow, true) then
                self.showCPUWindow = not self.showCPUWindow
            end
            if imgui.MenuItem("PIA", nil, self.showPIAWindow, true) then
                self.showPIAWindow = not self.showPIAWindow
            end
            if imgui.MenuItem("Keypad", nil, self.showKeypadWindow, true) then
                self.showKeypadWindow = not self.showKeypadWindow
            end
            if imgui.MenuItem("Instructions", nil, self.showInstructionsWindow, true) then
                self.showInstructionsWindow = not self.showInstructionsWindow
            end
            if imgui.MenuItem("Memory", nil, self.showMemoryWindow, true) then
                self.showMemoryWindow = not self.showMemoryWindow
            end
            if imgui.MenuItem("Speaker", nil, self.showSpeakerWindow, true) then
                self.showSpeakerWindow = not self.showSpeakerWindow
            end
            imgui.EndMenu()
        end
        if imgui.BeginMenu("Help") then
            if imgui.MenuItem("CHIPOS manual...") then
            end
            if imgui.MenuItem("About...") then
                self.showAboutPopup = true
                imgui.OpenPopup("About")
            end
            imgui.EndMenu()
        end
        imgui.EndMainMenuBar()
    end

    if self.showAboutPopup then
        imgui.OpenPopup("About DRÖM")
    end

    self.showAboutPopup = imgui.BeginPopupModal("About DRÖM", self.showAboutPopup)
    if self.showAboutPopup then
        local drom_url = "https://github.com/tobiasvl/drom"
        local dream_url = "http://www.mjbauer.biz/DREAM6800.htm"
        local chip8_url = "https://johnearnest.github.io/chip8Archive/?sort=platform"
        imgui.Text("DRÖM is an emulator for DREAM 6800, a hobby")
        imgui.Text("computer created by Michael J. Bauer in 1979.")
        imgui.Dummy(1, 1)
        imgui.Text("DRÖM © 2020 Tobias V. Langhoff")
        imgui.Text("Source code available under MIT license at")
        if imgui.Button(drom_url) then
            love.system.openURL(drom_url)
        end
        imgui.Dummy(1, 1)
        imgui.Text("CHIPOS © 1978 Michael J. Bauer")
        imgui.Text("Dream Invaders © 1980 Michael J. Bauer")
        imgui.Text("Source code and binaries available at")
        if imgui.Button(dream_url) then
            love.system.openURL(dream_url)
        end
        imgui.Text("(used in DRÖM with permission)")
        imgui.Dummy(1, 1)
        imgui.Text("All CHIP-8 games included in DRÖM are")
        imgui.Text("in the public domain and are available")
        imgui.Text("in the")
        imgui.SameLine()
        if imgui.Button("CHIP-8 Archive") then
            love.system.openURL(chip8_url)
        end
        imgui.SameLine()
        imgui.Text(".")
        if imgui.Button("Close") then
            imgui.CloseCurrentPopup()
            self.showAboutPopup = false
        end
        imgui.EndPopup()
    end

    imgui.Render()
end

return ui