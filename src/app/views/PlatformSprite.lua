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

function PlatformSprite:getModel()
	return self.model_
end

-- 创建
function PlatformSprite:transformToNewPlatform(start_x, callback)
	self:resetRandomWidth()
	self:randomMoveToLeft(start_x, callback)
	return self
end

function PlatformSprite:resetRandomWidth()
	local width = math.random(self.model_.MIN_WIDTH, self.model_.MAX_WIDTH)
	self:setContentSize(cc.size(width, self.model_.HEIGHT))
		:move(display.width + width, self.model_.HEIGHT)
	return self
end
-- 随机位置左移
function PlatformSprite:randomMoveToLeft(start_x, callback)
	local target_x = math.random(start_x + self.model_.MIN_MARGIN, display.width - self.model_.MIN_MARGIN)
	self.schedulerId = self.scheduler:scheduleScriptFunc(function() return self:moveToLeft(target_x, callback) end, 0.01, false)
	return self
end
-- 固定位置左移
--function PlatformSprite:fixedMoveToLeft(fixed_distance, callback)
--	local pos = cc.p(self:getPosition())
--	target_x = pos.x - fixed_distance
--	self.schedulerId = self.scheduler:scheduleScriptFunc(function() return self:moveToLeft(callback) end, 0.01, false)
--	return self
--end

function PlatformSprite:moveToLeft(target_x, callback)
	local pos = cc.p(self:getPosition())
	if pos.x - self.model_:getSpeed() <= target_x then
		self:move(target_x, pos.y)
		if self.schedulerId then
			self.scheduler:unscheduleScriptEntry(self.schedulerId)
			self.schedulerId = nil
		end
		if callback then
			callback()
			return
		end
	end
	self:move(pos.x - self.model_:getSpeed(), pos.y)
end

return PlatformSprite
