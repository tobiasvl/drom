local imgui = require("imgui")
local Filedialog = require('filedialog')

local message = "Click anywhere to open the file picker dialog"

function love.update(dt)
    imgui.NewFrame()
end

function love.draw()
    love.graphics.print(message, 40, 40)

    if filedialog then
        -- Draw the file dialog if it's open
        filedialog = filedialog:draw()
    end

    -- Draws imgui, without this no imgui windows will appear
    imgui.Render()
end

function love.quit()
    imgui.ShutDown()
end

function love.textinput(t)
    imgui.TextInput(t)
end

function love.keypressed(key)
    imgui.KeyPressed(key)
end

function love.keyreleased(key)
    imgui.KeyReleased(key)
end

function love.mousemoved(x, y)
    imgui.MouseMoved(x, y)
end

function love.mousepressed(x, y, button)
    imgui.MousePressed(button)
    if not filedialog then
        -- This function will be called if a file is selected
        local function fileCallback(file)
            message = "You've picked "..file.name
        end

        -- This function will be called if the file picker is closed without selecting a file
        local function cancelCallback()
            message = "You didn't pick a file"
        end

        -- Create a file dialog.
        -- args:
        -- path -> the initial path to show in the file browser. If none is given, it will default to the location of main.lua
        -- fileCallback -> the function to call when a file is selected
        -- cancelCallback -> the function to call when the file browser is closed without selecting a file
        filedialog = Filedialog.new('open', fileCallback, cancelCallback)
    end
end

function love.mousereleased(x, y, button)
    imgui.MouseReleased(button)
end

function love.wheelmoved(x, y)
    imgui.WheelMoved(y)
end
