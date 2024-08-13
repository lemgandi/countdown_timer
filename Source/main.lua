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
      print("Popped")
      TheTime=nil
      Notify()
      
      State=StateT.Setting
      print("State: ",State)
   end
   
end
   
