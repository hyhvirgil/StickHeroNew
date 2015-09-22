--
-- Created by IntelliJ IDEA.
-- User: virgil.huang
-- Date: 2015/9/23
-- Time: 11:38
--

local StickSprite = class ("StickSprite", function(pos, model)
	local sprite = display.newSprite(Config.Res.img_stick, pos.x, pos.y,
		{ rect = cc.rect(0, 0, model.INIT_WIDTH, model.INIT_HEIGHT), scale9 = true, })
		:setAnchorPoint(display.RIGHT_BOTTOM)
		:move(pos)
	return sprite
end)

function StickSprite:ctor(pos, model)
	self.model_ = model
end

function StickSprite:extend()
	self.model_:extend()
	self:updateLength()
	return self
end

function StickSprite:updateLength()
	self:setContentSize(cc.size(self.model_.INIT_WIDTH, self.model_:getLength()))
end

function StickSprite:getModel()
	return self.model_
end

function StickSprite:rotateToHorizontal(callback)
	self:rotateBy({time = 0.5, rotation = 90, onComplete = callback })
end

return StickSprite
