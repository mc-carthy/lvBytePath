gw = 320
gh = 240 
sx = 3
sy = 3

function love.conf(t)
    t.window.width = gw
    t.window.height = gh
    t.window.title = 'LÖVE BytePath'
    t.window.icon = nil
    t.window.highdpi = false

    t.modules.audio = true
    t.modules.event = true
    t.modules.graphics = true
    t.modules.image = true
    t.modules.joystick = true
    t.modules.keyboard = true
    t.modules.math = true
    t.modules.mouse = true
    t.modules.physics = true
    t.modules.sound = true
    t.modules.system = true
    t.modules.timer = true
    t.modules.touch = false
    t.modules.video = true
    t.modules.window = true
    t.modules.thread = true
end

