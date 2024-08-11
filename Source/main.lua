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
local HPad=4
local VPad=45

-- Numbers for hh:mm:ss and possibly dd
NumberPictures = {}
NumberPictures[0] = gfx.image.new("Images/Zero.png")
NumberPictures[1] = gfx.image.new("Images/One.png")
NumberPictures[2] = gfx.image.new("Images/Two.png")
NumberPictures[3] = gfx.image.new("Images/Three.png")
NumberPictures[4] = gfx.image.new("Images/Four.png")
NumberPictures[5] = gfx.image.new("Images/Five.png")
NumberPictures[6] = gfx.image.new("Images/Six.png")
NumberPictures[7] = gfx.image.new("Images/Seven.png")
NumberPictures[8] = gfx.image.new("Images/Eight.png")
NumberPictures[9] = gfx.image.new("Images/Nine.png")


Colon = gfx.image.new("Images/Colon.png")
Selected=gfx.image.new("Images/Selected.png")

-- hh:mm:ss cells on screen
Cells = {
   
   
   cell.new({0+HPad,VPad,9,1}),    -- HH  1
   cell.new({NumWidth+HPad,VPad,9}), -- HH 2
   cell.new({(NumWidth*2)+HPad,VPad,5}), -- MM 3
   cell.new({(NumWidth*3)+HPad,VPad,9}), -- MM 4
   cell.new({(NumWidth*4)+HPad,VPad,5}), -- SS 5
   cell.new({(NumWidth*5)+HPad,VPad,9})  -- SS 6
   
   
}

-- Reset all the cells to the right of the one I have decremented
-- to their maximum values (e.g. 1:00:00 becomes 0:59:59 )
function Cells:resetRight(cellNumber)
   local loop =  #self
   
   while loop > cellNumber do
      self[loop]:resetValueToMax()
      loop = loop - 1
   end
   
end

-- Bump displayed time table down by one second, return whether
-- we are at zero seconds.
function Cells:decSecond()
   local carry=false
   local cellKey=#self
   local allZero=true
   
   while(cellKey > 0) do
      if (self[cellKey]:getValue() > 0) then
	 if self[cellKey]:getValue() > 0 then
	    self[cellKey]:decrement()
	    self:resetRight(cellKey)
	    allZero=false
	 end
      end
      cellKey = cellKey - 1
      if not allZero then
	 break
      end
   end
   
   return allZero
end

function Cells:calculateSeconds()
   local retVal=0
   local hhmm = {
      360000,
      36000,
      600,
      60,
      10,
      1
   }

   for jj,kk in ipairs(self) do
      retVal=retVal + kk:getValue() *  hhmm[jj] 
   end
   return retVal   
end

SelectedCell=1

-- Set up before main line callback
function setupTimer()

   local colonW,colonH
   colonW,colonH=Colon:getSize()
   Cells[1]:draw()
   Cells[2]:draw()
   
   Colon:draw((NumWidth*2),VPad)
   Cells[3]:draw()
   Cells[4]:draw()
   Colon:draw((NumWidth*4),VPad)   
   Cells[5]:draw()
   Cells[6]:draw()
   
   Cells[SelectedCell]:select()
end

-- Timer State table and variable
StateT={["Setting"]=1,["Timing"]=2,["Paused"]=3,["Popped"]=4}

State = StateT.Setting
TheTime=nil

-- Bump a counter up or down, circle to a max/min value.
function bump(updown,current,top,bottom,step)
   bottom = bottom or 1
   step = step or 1
   local retVal=current

   assert( updown ~= nil,"main.bump: Direction cannot be nil")
   if updown then
      retVal=retVal+step
      if retVal > top then
	 retVal=bottom
      end      
   else
      retVal=retVal-step
      if retVal < bottom then
	 retVal=top
      end
   end
      
   return retVal
end

function findCell()
      if playdate.buttonJustPressed(playdate.kButtonRight) then
	 Cells[SelectedCell]:unselect()
	 SelectedCell = bump(true,SelectedCell,6)
	 Cells[SelectedCell]:select()      
      elseif playdate.buttonJustPressed(playdate.kButtonLeft) then
	 Cells[SelectedCell]:unselect()
	 SelectedCell=bump(false,SelectedCell,6)
	 Cells[SelectedCell]:select()
      end
end



-- Main Line

setupTimer()

-- Update Callback
function playdate.update()
   

   
   if State == StateT.Setting then
      findCell()
      Cells[SelectedCell]:set()
      if playdate.buttonJustPressed(playdate.kButtonA) then
	 print("Timing")	    
	 State = StateT.Timing
      end
   end
   
   if State == StateT.Timing then
      if playdate.buttonJustPressed(playdate.kButtonB) then
	 print("Set")
	 State=StateT.Setting
      else
	 if not TheTime then
	    TheTime=playdate.getSecondsSinceEpoch()
	 else
	    if playdate.getSecondsSinceEpoch() - TheTime >= 1
	    then
	       if true == Cells:decSecond() then
		  State = StateT.Popped
	       else	  
		  TheTime = playdate.getSecondsSinceEpoch()
	       end	       
	    end
	 end
      end
   end
   
      
      if State == StateT.Popped then
	 print("Popped")
	 TheTime=nil
	 State=StateT.Setting
      end
   
end
   
