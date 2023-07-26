--[[

Run Lua On Love2d. . ??

 (1st) Watch Udemy. . Lua Programming and Game Development with LÖVE
(2nd) DRAG GAME FILE AND DROP ON LOVE ICON. . Section 1.4 Project Structure @3:15. .
 (3rd) . . Or . . 
(4th) ALT + L . . Section 1.4 Project Structure @3:51. . 

]]   

function love.load()
    math.randomseed(os.time())

    sprites = {}
    sprites.background = love.graphics.newImage('sprites/background.png')
    sprites.bullet = love.graphics.newImage('sprites/bullet.png')
    sprites.player = love.graphics.newImage('sprites/player.png')
    sprites.zombie = love.graphics.newImage('sprites/zombie.png')

    player = {}
    player.x = love.graphics.getWidth() / 2
    player.y = love.graphics.getHeight() / 2
    player.speed = 180

    myFont = love.graphics.newFont(30)

    zombies = {}
    bullets = {}

    gameState = 1
    score = 0
    maxTime = 2
    timer = maxTime
end

function love.update(dt)
    if gameState == 2 then
        if love.keyboard.isDown("d") and player.x < love.graphics.getWidth() then
            player.x = player.x + player.speed*dt
        end

        if love.keyboard.isDown("a") and player.x > 0 then
            player.x = player.x - player.speed*dt
        end

        if love.keyboard.isDown("w") and player.y > 0 then
            player.y = player.y - player.speed*dt
        end

        if love.keyboard.isDown("s") and player.y < love.graphics.getHeight()then
            player.y = player.y + player.speed*dt
        end
    end

    for i,z in ipairs(zombies) do 
      z.x = z.x + (math.cos(zombiePlayerAngle(z)) * z.speed * dt)
      z.y = z.y + (math.sin(zombiePlayerAngle(z)) * z.speed * dt)

      if distanceBetween (z.x, z.y, player.x, player.y) < 5 then
        for i,z in ipairs(zombies) do 
            zombies[i] = nil
            gameState = 1
            player.x = love.graphics.getWidth()/2
            player.y = love.graphics.getHeight()/2
        end
      end
    end

    for i,b in ipairs(bullets) do 
        b.x = b.x + (math.cos(b.direction) * b.speed * dt)
        b.y = b.y + (math.sin(b.direction) * b.speed * dt)
    end

    for i=#bullets, 1, -1 do
        local b = bullets[i]
        if b.x < 0 or b.y < 0 or b.x > love.graphics.getWidth() or b.y > love.graphics.getHeight() then
            table.remove(bullets, i)
        end
    end

    for i,z in ipairs(zombies) do 
        for j,b in ipairs(bullets) do
            if distanceBetween(z.x, z.y,b.x, b.y ) < 20 then
                z.dead = true
                b.dead = true
                score = score + 1
            end
        end
    end

    for i=#zombies, 1, -1 do
        local z = zombies[i]
        if z.dead == true then
            table.remove(zombies, i)
        end
    end

    for i=#bullets, 1, -1 do
        local b = bullets[i]
        if b.dead == true then
            table.remove(bullets, i)
        end
    end

    if gameState == 2 then 
        timer = timer - dt
        if timer <= 0 then
            spawnZombie()
            maxTime = 0.95 * maxTime
            timer = maxTime
        end
    end
end

function love.draw()
    love.graphics.draw(sprites.background, 0, 0)

    if gameState == 1 then
        love.graphics.setFont(myFont)
        love.graphics.printf("Click anywhere to begin", 0, 50, love.graphics.getWidth(), "center")
    end
    love.graphics.printf("Score: " .. score, 0, love.graphics.getHeight()-100, love.graphics.getWidth(), "center")

    love.graphics.draw(sprites.player, player.x, player.y, playerMouseAngle(), nil, nil, sprites.player:getWidth()/2, sprites.player:getHeight()/2)

    for i,z in ipairs(zombies) do 
        love.graphics.draw(sprites.zombie, z.x, z.y, zombiePlayerAngle(z), nil, nil, sprites.zombie:getWidth()/2, sprites.zombie:getHeight()/2)
    end

    for i,b in ipairs(bullets) do 
        love.graphics.draw(sprites.bullet, b.x, b.y, nil, 0.5, nil, sprites.bullet:getWidth()/2, sprites.zombie:getHeight()/2)
    end
end

--[[
function love.keypressed(key)
    if key == "space" then
        spawnZombie()
    end
end
]]

--[[ 2 PLAYER: HARD MODE ]--
function love.keyreleased(key)
    if key == "space" then
        spawnBullet()
    end
end
]]

--[[ 1 PLAYER: EASY MODE ]]
function love.mousepressed(x, y, button)
    if button == 1 and gameState == 2 then
        spawnBullet()
    elseif button == 1 and gameState == 1 then
        gameState = 2
        maxTime = 2
        timer = maxTime
        score = 0
    end
end

function playerMouseAngle()
    return math.atan2(love.mouse.getY() - player.y, love.mouse.getX() - player.x)
end

function zombiePlayerAngle(enemy)
    return math.atan2(enemy.y - player.y, enemy.x - player.x) + math.pi
end

function spawnZombie()
    local zombie = {}
    zombie.x = 0
    zombie.y = 0
    zombie.speed = 100
    zombie.dead = false

    local side = math.random(1, 4)
    if side == 1 then
        zombie.x = -30
        zombie.y = math.random(0, love.graphics.getHeight())
    elseif side == 2 then
        zombie.x = love.graphics.getWidth() + 30
        zombie.y = math.random(0, love.graphics.getHeight())
    elseif side == 3 then
        zombie.x = math.random(0, love.graphics.getWidth())
        zombie.y = -30
    elseif side == 4 then
        zombie.x = math.random(0, love.graphics.getWidth())
        zombie.y = love.graphics.getHeight() + 30
    end 

    table.insert(zombies, zombie)
end

function spawnBullet()
    local bullet = {}
    bullet.x = player.x
    bullet.y = player.y
    bullet.speed = 500
    bullet.dead = false
    bullet.direction = playerMouseAngle()
    table.insert(bullets, bullet)

end

function distanceBetween(x1, y1, x2, y2)
    return math.sqrt((x2 - x1)^2 + (y2 - y1)^2)
end

--[[
    
-- Udemy. . Section 5. . #49 @ 0:30

STOP @ #60 SUNDAY

-- Udemy. . Section 5. . #61 @ 0:30 long 
-- Udemy. . Section 6. . #70 @ 0:30 short
-- Udemy. . Section 7. . #74 @ 0:30
-- Udemy. . Section 8. . #82 @ 0:30 

FINISH @ #82 MONDAY

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
