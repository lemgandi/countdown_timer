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
   me.currentIter=0
   me.selected=false
   me.currentImage=NumberPictures[10]
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

function cell:select()
   self.selected=true
   local imageW,imageH
   imageW,imageH=self.currentImage:getSize()
   gfx.fillTriangle(self.hPosition+imageW/2,
		    self.vPosition+imageH+2,
		    self.hPosition,self.vPosition+imageH+40,
		    self.hPosition+imageW,self.vPosition+imageH+40)
   
end

function cell:unselect()
   if self.selected then
      self.selected=false
      local curX,curY,curW,curH,newW,newH
      newW,newH=self.currentImage:getSize()
      curX,curY,curW,curH=gfx.getClipRect()
      gfx.setScreenClipRect(self.vPosition+2,
		      self.hPosition,
		      newW,newH)
      gfx.clearClipRect()
      gfx.setScreenClipRect(curX,curY,curW,curH)      
   end
end
