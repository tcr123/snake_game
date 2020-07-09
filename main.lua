VIRTUAL_WIDTH=400
VIRTUAL_HEIGHT=400

WINDOW_WIDTH=900
WINDOW_HEIGHT=900
 
push = require 'push'
Class = require 'class'

require 'Player'

math.randomseed(os.time())
player=Player()

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')
    push:setupScreen(VIRTUAL_WIDTH,VIRTUAL_HEIGHT,WINDOW_WIDTH,WINDOW_HEIGHT,{
        fullscreen=false,
        vsyncs=true,
        resizable=false
    })
    timer=0
    interval=0.25
    stoptime=0.02
    scorefont=love.graphics.newFont('font.ttf',16)
    bigfont=love.graphics.newFont('font.ttf',20)

    love.window.setTitle('play snake')
end

function love.update(dt)
    timer=timer+dt
    while timer>interval do
        timer=timer-interval
        player:update(dt)
    end

    if tail_length>10 then
        interval=0.20
    elseif tail_length>20 then
        interval=0.18
    elseif tail_length>30 then
        interval=0.16
    elseif tail_length>50 then
        interval=0.10
    end
end

function love.keypressed(key)

    if key == 'escape' then
        love.event.quit()
    elseif key == 'enter' or key == 'return' then
        if player.state == 'lose' then
            player.state='play'
            player.sounds['restart']:play()
            player:reset()
            oldscore=0
            interval=0.2
        end
    end
end

function love.draw()
    push:apply('start')
    love.graphics.clear(0,0,0,0)
    player:render()

    love.graphics.setFont(scorefont)
    love.graphics.print("Tail length:",0,0)
    love.graphics.print("Record:",200,0)

    love.graphics.setFont(scorefont)
    love.graphics.print(tostring(oldscore),100,0)

    if player.state=='lose' and oldscore>record then
        record=oldscore
    end
    love.graphics.print(tostring(record),270,0)

    if player.state=='lose' then
        love.graphics.setColor(1,1,1,1)
        love.graphics.setFont(bigfont)
        love.graphics.printf("You lose , press enter to restart",0,100,VIRTUAL_WIDTH,'center')
    end

    push:apply('end')
end

