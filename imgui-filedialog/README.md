# FileDialog for LOVE's imgui module
This is just a simple file picker that allows you to browse your file system, and select a file to open. It will then pass that file to your program using a callback function. This was written for the LOVE imgui module, but may also work with other frameworks using the Lua bindings for imgui. I have not tested anything other than LOVE.

![Screenshot](https://i.imgur.com/CtOerfS.png)

## Usage
### Open the file picker
```lua
Filedialog = require('filedialog')
filedialog = Filedialog.new(path, fileCallback, cancelCallback)
```

### Draw the file picker
```lua
if filedialog then
	filedialog = filedialog.draw()
end
```

