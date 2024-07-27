--[[
  Countdown Timer for Playdate
  
  Charles Shapiro
  23 July 2024

]]
import "CoreLibs/strict"

import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "cell"

gfx = playdate.graphics

local NumWidth=60
local NumHeight=75
local Pad=5



NumberPictures = {
   gfx.image.new("Images/One.png"),
   gfx.image.new("Images/Two.png"),
   gfx.image.new("Images/Three.png"),
   gfx.image.new("Images/Four.png"),
   gfx.image.new("Images/Five.png"),
   gfx.image.new("Images/Six.png"),
   gfx.image.new("Images/Seven.png"),
   gfx.image.new("Images/Eight.png"),
   gfx.image.new("Images/Nine.png"),
   gfx.image.new("Images/Zero.png"),
}

Colon = gfx.image.new("Images/Colon.png")
print("NumWidth*2+Pad: ",NumWidth*2+Pad)

-- hh:mm:ss cells on screen
Cells = {
   cell.new({0}),
   cell.new({NumWidth+Pad}),
   cell.new({NumWidth*2+Pad}),
   cell.new({NumWidth*3+Pad}),
   cell.new({NumWidth*4+Pad}),
   cell.new({NumWidth*5+Pad})
}

function setupTimer()
   
   Cells[1]:draw()
   Cells[2]:draw()
   Colon:draw((NumWidth*2)+1,0)
   Cells[3]:draw()
   Cells[4]:draw()
   Colon:draw((NumWidth*4)+1,0)   
   Cells[5]:draw()
   Cells[6]:draw()

end

setupTimer()

function playdate.update()
   
   if playdate.buttonIsPressed(playdate.kButtonA) then
      Cells[1]:update(2)
   elseif playdate.buttonIsPressed(playdate.kButtonB) then
      Cells[1]:update(1)
   end
   
end
