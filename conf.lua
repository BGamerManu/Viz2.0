--Own taskbar identity, so Windows does not group Viz2.0 with VizHelper (both run on love.exe)
if jit.os == "Windows" then
    local ffi = require "ffi"
    ffi.cdef[[int SetCurrentProcessExplicitAppUserModelID(const wchar_t *AppID);]]
    local id = "beebViz.Viz2"
    local w = ffi.new("wchar_t[?]", #id + 1)
    for i = 1, #id do w[i - 1] = id:byte(i) end
    pcall(function() ffi.load("shell32").SetCurrentProcessExplicitAppUserModelID(w) end)
end

function love.conf(t)
    t.window.fullscreen = false
    t.window.width = 1920
    t.window.height = 1080
    t.title = "Viz2.0"
end
