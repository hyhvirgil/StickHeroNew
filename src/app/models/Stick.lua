--
-- Created by IntelliJ IDEA.
-- User: virgil.huang
-- Date: 2015/9/23
-- Time: 11:24
--

local Stick = class("Stick")

Stick.INIT_WIDTH = 5
Stick.INIT_HEIGHT = 10

function Stick:ctor()
	self.speed_ = 4
	self.length_ = 10
	self.max_length_ = display.width
end

--local fixedDeltaTime = 1.0 / 60.0
function Stick:extend()
	self.length_ = self.length_ + self.speed_-- * (dt / fixedDeltaTime)
--	print("self.length_ = ", self.length_)
	return self
end

function Stick:getLength()
	return self.length_
end

function Stick:lengthIsMaxLength()
	if self.length_ >= self.max_length_ then
		self.length_ = self.max_length_
		return true
	end
	return false
end

function Stick:getMaxLength()
	return self.max_length_
end

function Stick:setMaxLength(max_length)
	self.max_length_ = max_length
end

return Stick
