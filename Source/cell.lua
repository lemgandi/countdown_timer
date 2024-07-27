--[[
   One display cell of countdown timer

   Charles Shapiro  26 Jul 2024
]]

import "CoreLibs/strict"

-- references NumberPictures in main.lua

cell={}
cell.__index = cell

-- Create a single timer number cell
function cell.new(h)
   local me = {}
   setmetatable(me,cell)   
   me.__index=me
   me.hPosition=h[1]
   print("h= ",h,"New hPosition:",me.hPosition)
   me.currentIter=0
   me.currentImage=NumberPictures[10]
   return me
end

-- Draw the timer cell on the screen
function cell:draw()
   print("currentImage: ",self.currentImage," hPosition: ",self.hPosition)
   self.currentImage:draw(self.hPosition,0)
end

-- Update the timer cell
function cell:update(currentIter)
  self.currentIter=currentIter
  self.currentImage=NumberPictures[currentIter]   
  self:draw()
end
