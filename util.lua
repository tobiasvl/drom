local nativefs = require "love-imgui-filedialog.love-nativefs.nativefs"

local util = {}

function util.read_file(file)
    if type(file) == "string" then
        file = love.filesystem.newFile(file)
    end

    local ok, err = file:open("r")

    if ok then
        local rom = {}
        local address = 0

        while (not file:isEOF()) do
            local byte, len = file:read(1)
            -- Dropped files don't seem to report EOF
            if len ~= 1 or not string.byte(byte) then
                break
            end
            rom[address] = string.byte(byte)
            address = address + 1
        end

        file:close()
        rom.size = address
        return rom
    else
        return err
    end
end

return util
