local imgui = require "imgui"
local moonshine = require 'moonshine'

local ui = {}

local hex_input_flags = { "ImGuiInputTextFlags_CharsHexadecimal", "ImGuiInputTextFlags_CharsUppercase", "ImGuiInputTextFlags_EnterReturnsTrue"}

function ui:init(CPU)
    self.CPU = CPU
    self.canvases = {
        display = love.graphics.newCanvas(64*8, 32*8)
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
    self.showInstructionsWindow = true
    self.showMemoryWindow = true

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
    imgui.NewFrame()

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
            love.graphics.setCanvas(self.canvases.display)
            love.graphics.clear()
            self.effect(function()
                love.graphics.setColor(1,1,1)
                for y = 0, 31 do
                    for x = 0, 7 do
                        local byte = self.CPU.memory[0x100 + (y * 8) + x]
                        for xx = 0, 7 do
                            local pixel = bit.band(byte, 0x80)
                            byte = bit.lshift(byte, 1)
                            if pixel ~= 0 then
                                love.graphics.rectangle("fill", (x * 64) + (xx * 8), y * 8, 8, 8)
                            end
                        end
                    end
                end
            end)
            love.graphics.setCanvas()
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
        local text, textinput = imgui.InputText("##breakpoint", self.CPU.breakpoint and string.format("%04X", self.CPU.breakpoint) or "", 5, { "ImGuiInputTextFlags_CharsHexadecimal", "ImGuiInputTextFlags_CharsUppercase"})
        imgui.PopItemWidth()
        if textinput then
            self.CPU.breakpoint = tonumber(text, 16)
        end
        imgui.SameLine()
        imgui.Button("Set")
        --for i = 0x200, #self.CPU.memory, 2 do
        --    -- TODO handle odd byte boundaries
        --    if i == self.CPU.pc or i + 1 == self.CPU.pc then
        --        if self.followPC and not self.CPU.pause then
        --            imgui.SetScrollHere()
        --        end
        --        imgui.Text("PC ")
        --    elseif i == self.CPU.i or i + 1 == self.CPU.i then
        --        imgui.Text(" I ")
        --    else
        --        local found = false
        --        -- for j, s in ipairs(self.CPU.stack) do
        --        --     if i == s or i + 1 == s then
        --        --         imgui.Text("S" .. (j - 1) .. " ")
        --        --         found = true
        --        --     end
        --        -- end
        --        if not found then
        --            imgui.Text("   ")
        --        end
        --    end
        --    imgui.SameLine()
        --    imgui.Text(string.format("%04X: ", i))
        --    imgui.SameLine()
        --    imgui.Text(string.format("%02X%02X", self.CPU.memory[i], self.CPU.memory[i + 1] or 0))
        --end
        imgui.End()
    end

    if self.showMemoryWindow then
        imgui.SetNextWindowSize(200, 200, "ImGuiCond_FirstUseEver")
        self.showMemoryWindow = imgui.Begin("Memory", true, "MenuBar")
        if imgui.BeginMenuBar() then
            if imgui.BeginMenu("Settings") then
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
            if i > line - 3 and i < line + (win_h / font_height) then
                local c = self.CPU.memory[i]
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
                imgui.MenuItem("DREAM 6800", nil, false, false)
                if imgui.IsItemHovered() then
                    imgui.SetTooltip("DREAM 6800 assembled in Electronics Australia, and 40th anniversary reproduction")
                end
                imgui.MenuItem("DREAM 6800 prototype", nil, false, false)
                if imgui.IsItemHovered() then
                    imgui.SetTooltip("DREAM 6800 prototype and the CHIP-8 Classic Computer")
                end
                imgui.EndMenu()
            end
            imgui.EndMenuBar()
        end
        local win_w, win_h = imgui.GetWindowSize()
        imgui.PushButtonRepeat(true)
        --for k, v in pairs(keys_cosmac) do
        --    if self.CPU.key_status[v] then
        --        imgui.PushStyleColor("ImGuiCol_Button", 117 / 255, 138 / 255, 204 / 255, 1)
        --        button_status[v] = imgui.Button(string.format("%X", v), (win_w / 5), (win_h / 5) - 5)
        --        imgui.PopStyleColor(1)
        --    else
        --        button_status[v] = imgui.Button(string.format("%X", v), (win_w / 5), (win_h / 5) - 4)
        --    end
        --    if imgui.IsItemHovered() then
        --        imgui.SetTooltip(keys_qwerty[k])
        --    end
        --    if k % 4 ~= 0 then
        --        imgui.SameLine()
        --    end
        --end
        imgui.PopButtonRepeat()
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
            if imgui.MenuItem("CPU", nil, self.showCPUWindow, false) then
                self.showCPUWindow = not self.showCPUWindow
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
            imgui.EndMenu()
        end
        imgui.EndMainMenuBar()
    end

    imgui.Render()
end

function ui:quit()
    imgui.ShutDown()
end

return ui