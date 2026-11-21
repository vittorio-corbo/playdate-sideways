import "CoreLibs/graphics"
import "CoreLibs/sprites"

local pd = playdate
local gfx = pd.graphics

-- Player
local playerStartX = 360
-- local playerStartX = 40 --used to be 40 (when went right)
local playerStartY = 120
local playerSpeed = 3
local playerImage = gfx.image.new("images/capybara")
local playerSprite = gfx.sprite.new(playerImage)
playerSprite:setCollideRect(4, 4, 56, 40)
playerSprite:moveTo(playerStartX, playerStartY)
playerSprite:add()

-- Game State
local gameState = "stopped"
local score = 0

-- Obstacle
local obstacleSpeed = 5
local obstacleImage = gfx.image.new("images/rock")
local obstacleSprite = gfx.sprite.new(obstacleImage)
obstacleSprite.collisionResponse = gfx.sprite.kCollisionTypeOverlap
obstacleSprite:setCollideRect(0, 0, 48, 48)
-- obstacleSprite:moveTo(450, 240)
obstacleSprite:moveTo(-50, 240)
obstacleSprite:add()

function pd.update()
    gfx.sprite.update()

    if gameState == "stopped" then
        gfx.drawTextAligned("Press A to Start", 200, 40, kTextAlignment.center)
        if pd.buttonJustPressed(pd.kButtonA) then
            gameState = "active"
            score = 0
            -- obstacleSpeed = 5
            obstacleSpeed = -5
            playerSprite:moveTo(playerStartX, playerStartY)
            -- obstacleSprite:moveTo(450, math.random(40, 200))
            obstacleSprite:moveTo(-50, math.random(40, 200))
        end
    elseif gameState == "active" then
        -- Player movement
            -- Could be sexier but its okay for now
        local crankPosition = pd.getCrankPosition()
        gfx.drawTextAligned(tostring(crankPosition), 200, 40, kTextAlignment.center)
        print(crankPosition)
        if 180 < crankPosition and crankPosition < 360 then
            -- (Left side -> crank towards player)
            playerSprite:moveTo(playerStartX,240-(4/3)*(crankPosition-180))
        else
            -- (Right side -> crank away from player)
            playerSprite:moveTo(playerStartX,(4/3)*(crankPosition))
        end


        -- OLD MOVEMENT
        -- if crankPosition <= 90 or crankPosition >= 270 then
        --     playerSprite:moveBy(0, -playerSpeed)
        -- else
        --     playerSprite:moveBy(0, playerSpeed)
        -- end



        -- Rock colisions
        local actualX, actualY, collisions, length = obstacleSprite:moveWithCollisions(obstacleSprite.x - obstacleSpeed, obstacleSprite.y)
        -- if obstacleSprite.x < -20 then
        if obstacleSprite.x > 420 then
            -- obstacleSprite:moveTo(450, math.random(40, 200))
            obstacleSprite:moveTo(-50, math.random(40, 200))
            score += 1
            -- obstacleSpeed += 0.2
            obstacleSpeed -= 0.2
            print("pizza")
        end

        -- Out of bounds
        if length > 0 or playerSprite.y > 270 or playerSprite.y < -30 then
            gameState = "stopped"
        end
    end

    gfx.drawTextAligned("Score: " .. score, 390, 10, kTextAlignment.right)
end
