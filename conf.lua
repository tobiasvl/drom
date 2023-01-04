function love.conf(t)
    -- Debug mode
    t.console = false

    t.identity = "DRÖM"
    t.window.title = "DRÖM 6800"
    t.window.resizable = true

    t.version = "11.4"

    -- Disable stuff we don't use
    t.accelerometerjoystick = false
    t.modules.joystick = false
    t.modules.data = false
    t.modules.physics = false
    t.modules.touch = false
    t.modules.video = false
end
