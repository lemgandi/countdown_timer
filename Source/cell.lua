--[[
   One display cell of countdown timer

   Charles Shapiro  26 Jul 2024
]]

import "CoreLibs/strict"

-- references NumberPictures in main.lua
gfx = playdate.graphics
   
cell={}
cell.__index = cell

-- Create a single timer number cell
function cell.new(h)
   local me = {}
   setmetatable(me,cell)   
   me.__index=me
   me.hPosition=h[1]
   me.vPosition=h[2]
   me.topValue=h[3]
   me.currentIter=0
   me.selected=false
   me.currentImage=NumberPictures[0]
   return me
end

-- Draw the timer cell on the screen
function cell:draw()
   self.currentImage:draw(self.hPosition,self.vPosition)
end


-- Update the timer cell
function cell:update(currentIter)
  self.currentIter=currentIter
  self.currentImage=NumberPictures[currentIter]   
  self:draw()
end

function cell:drawSelectedTriangle()
   local imageW,imageH
   imageW,imageH=self.currentImage:getSize()
   local cColor=gfx.getColor()
   gfx.setColor(gfx.kColorXOR)
   gfx.fillTriangle(self.hPosition+imageW/2,		   
		    self.vPosition+imageH+2,
		    self.hPosition,self.vPosition+imageH+40,
		    self.hPosition+imageW,self.vPosition+imageH+40)
   gfx.setColor(cColor)
end

function cell:select()
   self.selected=true
   self:drawSelectedTriangle()
end

function cell:unselect()
   if self.selected then
      self.selected=false
      self:drawSelectedTriangle()
   end
end

function cell:set()
   if playdate.buttonJustPressed(playdate.kButtonUp) then
      self.currentIter=bump(true,self.currentIter,self.topValue,0)
      self:update(self.currentIter)   
   elseif playdate.buttonJustPressed(playdate.kButtonDown) then
      self.currentIter=bump(false,self.currentIter,self.topValue,0)
      self:update(self.currentIter)         
   end

end
