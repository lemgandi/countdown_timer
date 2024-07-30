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

-- Size,location of cells on screen
local NumWidth=60
local NumHeight=75
local Pad=5
local VPad=45

-- Numbers for hh:mm:ss and possibly dd
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
Selected=gfx.image.new("Images/Selected.png")

-- hh:mm:ss cells on screen
Cells = {
   cell.new({0,VPad}),
   cell.new({NumWidth+Pad,VPad}),
   cell.new({NumWidth*2+Pad,VPad}),
   cell.new({NumWidth*3+Pad,VPad}),
   cell.new({NumWidth*4+Pad,VPad}),
   cell.new({NumWidth*5+Pad,VPad})
}

SelectedCell=1

-- Set up before main line callback
function setupTimer()
   
   Cells[1]:draw()
   Cells[2]:draw()
   Colon:draw((NumWidth*2)+1,VPad)
   Cells[3]:draw()
   Cells[4]:draw()
   Colon:draw((NumWidth*4)+1,VPad)   
   Cells[5]:draw()
   Cells[6]:draw()

   Cells[SelectedCell]:select()
end


-- Bump a counter up or down, circle to a max/min value.
function bump(updown,current,top,bottom)
   bottom=bottom or 1
   local retVal=current
   
   if updown then
      retVal=retVal+1
      if retVal > top then
	 retVal=bottom
      end      
   else
      retVal=retVal-1
      if retVal < bottom then
	 retVal=bottom
      end
   end
      
   return retVal
end

-- Main Line

setupTimer()

-- Update Callback
function playdate.update()
   
   if playdate.buttonJustPressed(playdate.kButtonRight) then
      Cells[SelectedCell]:unselect()
      SelectedCell = bump(true,SelectedCell,6)
      print("kButtonRight " .. SelectedCell)      
      Cells[SelectedCell]:select()
   end
   
   if playdate.buttonJustPressed(playdate.kButtonLeft) then
      Cells[SelectedCell]:unselect()
      SelectedCell=bump(false,SelectedCell,6)
      print("kButtonLeft " .. SelectedCell)            
      Cells[SelectedCell]:select()
   end
   
end
   
