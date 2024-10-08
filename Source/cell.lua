--[[
   One display cell of countdown timer

   Charles Shapiro  26 Jul 2024
   
   This file is part of Playdate Timer.
    Playdate Timer is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.
    Playdate Timer is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.
    You should have received a copy of the GNU General Public License
    along with Playdate Timer.  If not, see <http://www.gnu.org/licenses/>.

]]

import "CoreLibs/strict"
import "CoreLibs/crank"

-- references NumberPictures in main.lua
gfx = playdate.graphics
   
cell={}
cell.__index = cell

function cell:getValue()
   return self.currentIter   
end

function cell:setValue(value)
   value = value or 0
   self.currentIter=value
end

function cell:decrement()
   self.currentIter = self.currentIter - 1
   self:update(self.currentIter)
end

function cell:resetValueToMax()
   self:setValue(self.topValue)
   self:update(self.currentIter)
end

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

   local direction
   
   if playdate.buttonJustPressed(playdate.kButtonUp) then
      direction=true
   elseif playdate.buttonJustPressed(playdate.kButtonDown) then
      direction=false
   end
   local crankTicks = playdate.getCrankTicks(20)
   local bumpSize
   
   if crankTicks ~= 0 then
      bumpSize=math.abs(crankTicks)
      if crankTicks > 0 then
	 direction=true
      elseif (crankTicks < 0) then
	 direction=false
      end
   end
   
   
   if direction ~= nil then
      self.currentIter=bump(direction,self.currentIter,self.topValue,0,bumpSize)
      self:update(self.currentIter)
   end
   
end
