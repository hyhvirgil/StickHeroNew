--
-- Created by IntelliJ IDEA.
-- User: hyhvirgil
-- Date: 2015/9/23
-- Time: 23:39
-- To change this template use File | Settings | File Templates.
--

local PlatformSprite = class ("Platform", function(model)
	local sprite = display.newSprite(Config.Res.img_stick, model.MAX_WIDTH, model.HEIGHT,
		{ rect = cc.rect(0, 0, model.MAX_WIDTH, model.HEIGHT), scale9 = true, })
	:setAnchorPoint(display.RIGHT_TOP)
	:move(display.width + model.MAX_WIDTH, model.HEIGHT)

	return sprite
end)

function PlatformSprite:ctor(model)
	self.model_ = model
	self.scheduler = cc.Director:getInstance():getScheduler()
end

-- 创建
function PlatformSprite:transformToNewPlatform(surplus_distance, callback)
	self:resetRandomWidth()
	self:randomMoveToLeft(surplus_distance, callback)
	return self
end

function PlatformSprite:resetRandomWidth()
	local width = math.random(self.model_.MIN_WIDTH, self.model_.MAX_WIDTH)
	self:setContentSize(cc.size(width, self.model_.HEIGHT))
		:move(display.width + width, self.model_.HEIGHT)
	return self
end
-- 随机位置左移
function PlatformSprite:randomMoveToLeft(surplus_distance, callback)
	local distance = math.random(self.model_.MIN_MARGIN * 2, surplus_distance)
	local pos = cc.p(self:getPosition())
	self.target_x = pos.x - self.model_.MIN_MARGIN - distance
	self.schedulerId = self.scheduler:scheduleScriptFunc(function() return self:moveToLeft(callback) end, 0.01, false)
	return self
end
-- 固定位置左移
function PlatformSprite:fixedMoveToLeft(fixed_distance, callback)
	local pos = cc.p(self:getPosition())
	self.target_x = pos.x - fixed_distance
	self.schedulerId = self.scheduler:scheduleScriptFunc(function() return self:moveToLeft(callback) end, 0.01, false)
	return self
end

function PlatformSprite:moveToLeft(callback)
	local pos = cc.p(self:getPosition())
	if pos.x - self.model_:getSpeed() <= self.target_x then
		self:move(self.target_x, pos.y)
		if self.schedulerId then
			self.scheduler:unscheduleScriptEntry(self.schedulerId)
			self.schedulerId = nil
		end
		if callback then
			callback()
		end
	end
	self:move(pos.x - self.model_:getSpeed(), pos.y)
end

return PlatformSprite
