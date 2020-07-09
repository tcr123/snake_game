Player=Class{}

function Player:init()
    self.mapWidth=24
    self.mapHeight=24
    self.state='play'
    self.music = love.audio.newSource('sounds/Chad_Crouch_-_Algorithms.mp3', 'static')
    self.musiclose=love.audio.newSource('sounds/game-over-30-sound-effect-65063477.mp3', 'static')
    self.sounds = {
        ['coin'] = love.audio.newSource('sounds/coin.wav', 'static'),
        ['restart']=love.audio.newSource('sounds/restart.wav','static'),
        ['hit']=love.audio.newSource('sounds/hit.wav','static'),
        ['death']=love.audio.newSource('sounds/kill.wav','static')
    }

    self.width=16
    self.height=16
    self.x=10
    self.y=10
    self.dy=0
    self.dx=0
    soundplaytime=1
    eatapple=false

    self.Applex=math.random(self.mapWidth-1)
    self.Appley=math.random(self.mapHeight-1)

    if self.Applex==self.x and self.Appley==self.y then
        self.Applex=math.random(self.mapWidth-1)
        self.Appley=math.random(self.mapHeight-1)
    end

    oldscore=0
    record=0
    tail_length=0
    tail={}

    up,down,right,left=false,false,false,false
    self.music:setLooping(true)
    self.music:play()
end

function Player:render()
    love.graphics.setColor(150/255,3/255,32/255,255/255)
    love.graphics.rectangle('fill',self.x*self.width,self.y*self.height,self.width,self.height,4,4)

    love.graphics.setColor(100/255,3/255,32/255,255/255)
    for _,v in ipairs(tail) do
        love.graphics.rectangle('fill',v[1]*self.width,v[2]*self.height,self.width,self.height,10,10)
    end

    love.graphics.setColor(19/255,132/255,70/255,255/255)
    love.graphics.rectangle('fill',self.Applex*self.width,self.Appley*self.height,self.width,self.height,9,9)
end

function Player:update(dt)
    if love.keyboard.isDown('d') and self.state=='play' then
        up,down,right,left=false,false,true,false
    elseif love.keyboard.isDown('w') and self.state=='play' then
        up,down,right,left=true,false,false,false
    elseif love.keyboard.isDown('a') and self.state=='play' then
        up,down,right,left=false,false,false,true
    elseif love.keyboard.isDown('s') and self.state=='play' then
        up,down,right,left=false,true,false,false
    end

    if self.dy<0 then
        down=false
    elseif self.dy>0 then
        up=false
    elseif self.dx<0 then
        right=false
    elseif self.dx>0 then
        left=false
    end
    
    if up==true then
        self.dx=0
        self.dy=-1
    elseif down==true then
        self.dx=0
        self.dy=1
    elseif right==true then
        self.dx=1
        self.dy=0
    elseif left==true then
        self.dx=-1
        self.dy=0
    end

    local tempX=self.x    
    local tempY=self.y

    self.x=self.x+self.dx
    self.y=self.y+self.dy
    
    if self.x==self.Applex and self.y==self.Appley then
        self.Applex=math.random(self.mapWidth-1)
        self.Appley=math.random(self.mapHeight-1)
        tail_length=tail_length+1
        oldscore=tail_length
        table.insert(tail,{0,0})
        eatapple=true
    else
        eatapple=false
    end

    if eatapple==true then
        self.sounds['coin']:play()
    end

    for _,v in ipairs(tail) do
        if self.Applex==v[1] and self.Appley==v[2] then
            self.Applex=math.random(self.mapWidth-1)
            self.Appley=math.random(self.mapHeight-1)
        end
    end

    if tail_length>0 then
        for _,v in ipairs(tail) do
            local x,y=v[1],v[2]
            v[1],v[2]=tempX,tempY
            tempX,tempY=x,y
            if self.x==v[1] and self.y==v[2] then
                if soundplaytime==1 then
                    self.sounds['death']:play()
                    self.musiclose:play()
                    self.state='lose'
                    up,down,right,left=false,false,false,false
                    self.dx=0
                    self.dy=0
                    tail_length=0
                end
            end
        end
    end

    if self.x<0 and soundplaytime==1 then
        self.sounds['death']:play()
        self.musiclose:play()
        left=false
        self.dx=0
        self.state='lose'
        tail_length=0
        soundplaytime=0
    elseif self.x>self.mapWidth and soundplaytime==1 then
        self.sounds['death']:play()
        self.musiclose:play()
        right=false
        self.dx=0
        self.state='lose'
        tail_length=0
        soundplaytime=0
    elseif self.y<0 and soundplaytime==1 then
        self.sounds['death']:play()
        self.musiclose:play()
        up=false
        self.dy=0
        self.state='lose'
        tail_length=0
        soundplaytime=0
    elseif self.y>self.mapHeight and soundplaytime==1 then
        self.sounds['death']:play()
        self.musiclose:play()
        down=false
        self.dy=0
        self.state='lose'
        tail_length=0
        soundplaytime=0
    end
end

function Player:reset() 
    self.x=10
    self.y=10
    self.dy=0
    self.dx=0
    soundplaytime=1

    self.Applex=math.random(self.mapWidth-1)
    self.Appley=math.random(self.mapHeight-1)
    tail_length=0
    tail={}

    up,down,right,left=false,false,false,false
end
