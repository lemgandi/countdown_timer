--[[
    Table of cells holding the current elapsed time

    copyright(c) Charles Shapiro Aug 2024
]]

import "cell"

-- Size,location of cells on screen
NumWidth=60
NumHeight=75
HPad=4
VPad=45



gfx = playdate.graphics


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
