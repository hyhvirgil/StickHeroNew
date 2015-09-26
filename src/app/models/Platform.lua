--
-- Created by IntelliJ IDEA.
-- User: hyhvirgil
-- Date: 2015/9/23
-- Time: 23:42
-- To change this template use File | Settings | File Templates.
--

local Platform = class("Platform")

Platform.MAX_WIDTH = display.width / 6
Platform.MIN_WIDTH = Platform.MAX_WIDTH / 5
Platform.HEIGHT = display.height / 3
Platform.MIN_MARGIN = 10	-- 最小边缘，离另一个平台和屏幕边的最小距离

function Platform:ctor()
	self.speed_ = 16
end

function Platform:getSpeed()
	return self.speed_
end

return Platform
