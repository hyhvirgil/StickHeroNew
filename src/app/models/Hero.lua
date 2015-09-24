--
-- Created by IntelliJ IDEA.
-- User: virgil.huang
-- Date: 2015/9/24
-- Time: 20:16
--

local Hero = class("Hero")

function Hero:ctor()
	self.walk_speed_ = 16
end

function Hero:getWalkSpeed()
	return self.walk_speed_
end

return Hero
