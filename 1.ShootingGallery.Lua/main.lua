--[[

Run Lua On Love2d. . ??

 (1st) Watch Udemy. . Lua Programming and Game Development with LÖVE
(2nd) DRAG GAME FILE AND DROP ON LOVE ICON. . Section 1.4 Project Structure @3:15. .
 (3rd) . . Or . . 
(4th) ALT + L . . Section 1.4 Project Structure @3:51. . 

]]   

function love.load()
    target= {}
    target.x = 300
    target.y = 300 
    target.radius = 50

    score = 0
    timer = 0
    gameState = 1
    
    gameFont = love.graphics.newFont(40)

    sprites = {}
    sprites.sky = love.graphics.newImage('sprites/sky.png') 
    sprites.target= love.graphics.newImage('sprites/target.png') 
    sprites.crosshairs = love.graphics.newImage('sprites/crosshairs.png')

    love.mouse.setVisible(false)
end 


function love.update(dt)
    if timer > 0 then
        timer = timer - dt
    end 

    if timer < 0 then
        timer = 0
        gameState = 1
    end
end

function love.draw()
    love.graphics.draw(sprites.sky, 0, 0)
   -- love.graphics.setColor(1,0,0)
   -- love.graphics.circle("fill", target.x, target.y, target.radius )

    love.graphics.setColor(1, 1, 1)
    love.graphics.setFont(gameFont) 
    love.graphics.print("Score: " .. score, 5, 5)
    love.graphics.print("Time: " .. math.ceil(timer), 300, 5)

    if gameState == 1 then
        love.graphics.printf("Click Anywhere To Begin", 0, 250, love.graphics.getWidth(), "center")
    end


    if gameState == 2 then
        love.graphics.draw(sprites.target, target.x - target.radius, target.y - target.radius)
    end

    love.graphics.draw(sprites.crosshairs, love.mouse.getX()-20, love.mouse.getY()-20)
end 

function love.mousepressed(x, y, button, istouch, presses)
    if button == 1 and gameState == 2 then
        local mouseToTarget = distanceBetween(x, y, target.x, target.y)
        if mouseToTarget < target.radius then
            score = score + 1
            target.x = math.random(target.radius, love.graphics.getWidth() - target.radius)
            target.y = math.random(target.radius, love.graphics.getHeight() - target.radius)
        end
    elseif button == 1 and gameState == 1 then
        gameState = 2
        timer = 10
        score = 0
    end
end

function distanceBetween(x1,y1,x2,y2)
    return math.sqrt( (x2 - x1)^2 + (y2 - y1)^2 )
end

--[[
    

function love.load()

end

function love.update(dt)

end

function love.draw()

end

]]--



-- notes

--[[ 

D20 = 0

function love.load()
    D20 = love.math.random(1, 20)
end

function love.draw()
    love.graphics.setFont( love.graphics.newFont(50) )
    love.graphics.print( D20 )
end 

function love.draw()
    love.graphics.setColor(1,0,0)
    love.graphics.rectangle("fill",200, 400, 200, 100 )

    love.graphics.setColor(1,0,1)
    love.graphics.circle("fill",300, 200, 100 )

end 

 ]]--

