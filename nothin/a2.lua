-- Step 1: Draw the player

local pd = playdate
local gfx = pd.graphics

-- Player
local playerX = 40
local playerY = 120
local playerImage = gfx.image.new("images/capybara.png")

--this dont work for some reason
--local playerImage = gfx.image.new("../images/capybara.png")

function pd.update()
    playerImage:draw(playerX, playerY)
end
