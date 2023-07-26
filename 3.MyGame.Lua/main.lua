-- HAS A PAUSE BUTTON --

function love.load()
    camera = require 'libraries/camera'
    cam = camera()
    anim8 = require 'libraries/anim8'
    love.graphics.setDefaultFilter("nearest", "nearest")

    sti = require 'libraries/sti'
    gameMap = sti('maps/testMap.lua')

--------------------------------------[PAUSE]------------------------------------
    local paused = false
--------------------------------------[PAUSE]------------------------------------

    player = {}
    player.x = 400
    player.y = 200
    player.speed = 3
    player.sprite = love.graphics.newImage('sprites/parrot.png')
    player.spriteSheet = love.graphics.newImage('sprites/player-sheet.png')
    player.grid = anim8.newGrid( 12, 18, player.spriteSheet:getWidth(), player.spriteSheet:getHeight() )

    player.animations = {}
    player.animations.down = anim8.newAnimation( player.grid('1-4', 1), 0.2 )
    player.animations.left = anim8.newAnimation( player.grid('1-4', 2), 0.2 )
    player.animations.right = anim8.newAnimation( player.grid('1-4', 3), 0.2 )
    player.animations.up = anim8.newAnimation( player.grid('1-4', 4), 0.2 )

    player.anim = player.animations.left

    background = love.graphics.newImage('sprites/background.png')
end

function love.update(dt)
    local isMoving = false
--------------------------------------[PAUSE]------------------------------------
    if not paused then
--------------------------------------[PAUSE]------------------------------------
        if love.keyboard.isDown("right") then
            player.x = player.x + player.speed
            player.anim = player.animations.right
            isMoving = true
        end

        if love.keyboard.isDown("left") then
            player.x = player.x - player.speed
            player.anim = player.animations.left
            isMoving = true
        end

        if love.keyboard.isDown("down") then
            player.y = player.y + player.speed
            player.anim = player.animations.down
            isMoving = true
        end

        if love.keyboard.isDown("up") then
            player.y = player.y - player.speed
            player.anim = player.animations.up
            isMoving = true
        end

        if isMoving == false then
            player.anim:gotoFrame(2)
        end

        player.anim:update(dt)

        cam:lookAt(player.x, player.y)

        local w = love.graphics.getWidth()
        local h = love.graphics.getHeight()

        if cam.x < w/2 then
            cam.x = w/2
        end

        if cam.y < h/2 then
            cam.y = h/2
        end

        local mapW = gameMap.width * gameMap.tilewidth
        local mapH = gameMap.height * gameMap.tileheight

        -- Right Border
        if cam.x > (mapW - w/2) then
            cam.x = (mapW - w/2)
        end
        -- Bottom Border
        if cam.y > (mapH - h/2) then
            cam.y = (mapH - h/2)
        end
    end

--------------------------------------[PAUSE]------------------------------------
    -- Check for user input
    if love.keyboard.isDown("p") then
        togglePause()
    end
end
 -- Define a funtion to toggle the paused state
function togglePause()
    paused = not paused
end
--------------------------------------[PAUSE]------------------------------------




function love.draw()
    cam:attach()
        gameMap:drawLayer(gameMap.layers["Ground"])
        gameMap:drawLayer(gameMap.layers["Tree"])
        player.anim:draw(player.spriteSheet, player.x, player.y, nil, 6, nil, 6, 9)
    cam:detach()
end


 


--[[

Youtube
Love2D Basics
Challacade
7 / 9
@ 0:30

]]