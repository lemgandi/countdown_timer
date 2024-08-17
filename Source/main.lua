--[[
  Countdown Timer for Playdate
  
  Charles Shapiro
   23 July 2024
   
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

import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"

import "cell"
import "cells"

gfx = playdate.graphics

SelectedCell=nil

-- Set up before main line callback

function setupTimer()

   local colonW,colonH


   readConfig()
   local sysmenu=playdate.getSystemMenu()
   assert(sysmenu:addCheckmarkMenuItem("Alarm Stop",Config.alarmStop,
				       saveconfigCheckMark))
   playdate.setAutoLockDisabled(true)
   colonW,colonH=Colon:getSize()
   Cells[1]:draw()
   Cells[2]:draw()
   
   Colon:draw((NumWidth*2),VPad)
   Cells[3]:draw()
   Cells[4]:draw()
   Colon:draw((NumWidth*4),VPad)   
   Cells[5]:draw()
   Cells[6]:draw()
end

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

-- Make a Noise when time is up.
function Notify()
   
   assert(Config.alarmStop ~= nil)
   
   local duration
   if Config.alarmStop then
      duration=3
   end
   
   Notifier:playNote(Config.alarmNote,1,duration)         
end

-- Timer State table and variable
StateT={["Setting"]=1,["Timing"]=2,["Paused"]=3,["Popped"]=4}

State = StateT.Setting
TheTime=nil
Notifier=playdate.sound.synth.new(playdate.sound.kWaveSine)

Config = {
   ["alarmStop"]=true,
   ["alarmNote"]=440
}



function saveconfigCheckMark(checkState)
   Config.alarmStop=checkState
   saveConfig()
end

function saveConfig()
   playdate.datastore.write(Config,nil,true)
end

function readConfig()
   local retVal=playdate.datastore.read()
   if retVal then
      Config = retVal
   end   
end


-- Main Line

setupTimer()

-- Update Callback
function playdate.update()
   
   if State == StateT.Setting then
      if not SelectedCell then
	 SelectedCell=1
	 Cells[SelectedCell]:select()
      end
      if not Config.alarmStop and
	 playdate.buttonJustPressed(playdate.kButtonB) then
	 Notifier:noteOff()
      end
      
      findCell()
      Cells[SelectedCell]:set()
      if playdate.buttonJustPressed(playdate.kButtonA) then
	 State = StateT.Timing
      end
   end
   
   if State == StateT.Timing then
      if playdate.buttonJustPressed(playdate.kButtonB) then
	 State=StateT.Setting
      else
	 if not TheTime then
	    Cells[SelectedCell]:unselect()
	    SelectedCell=nil
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

      TheTime=nil
      Notify()      
      State=StateT.Setting

   end
   
end
   
