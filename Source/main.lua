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


gfx = playdate.graphics

local NumWidth=75
local NumHeight=75
local Pad=5

local Zero,One,Two,Three,Four,Five,Six,Seven,Eight,Nine

function setupTimer()
   
   Zero = gfx.image.new("Images/Zero.png")
   One  =  gfx.image.new("Images/One.png")
   Two = gfx.image.new("Images/Two.png")
   Three = gfx.image.new("Images/Three.png")
   Four = gfx.image.new("Images/Four.png")
   Five = gfx.image.new("Images/Five.png")
   Six = gfx.image.new("Images/Six.png")
   Seven = gfx.image.new("Images/Seven.png")
   Eight = gfx.image.new("Images/Eight.png")
   Nine = gfx.image.new("Images/Nine.png")
   
   Zero:draw(0,0)
   Zero:draw(NumWidth+Pad,0)
   Zero:draw(NumWidth*2+Pad,0)
   Zero:draw(NumWidth*3+Pad,0)
   
end

setupTimer()

function playdate.update()
   
   if playdate.buttonIsPressed(playdate.kButtonA) then
      gfx.fillRect(0,0,NumWidth+Pad,400)
      One:draw(0,0)
   elseif playdate.buttonIsPressed(playdate.kButtonB) then
      gfx.fillRect(0,0,NumWidth+Pad,400)
      Zero:draw(0,0)
   end
   
end
