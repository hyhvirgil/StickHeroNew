--
-- Created by IntelliJ IDEA.
-- User: hyhvirgil
-- Date: 2015/9/22
-- Time: 22:45
-- To change this template use File | Settings | File Templates.
--

local HeroSprite = class("HeroSprite", function(image_index)
--	local texture = display.getImage(imageFilename)
--	local frameWidth = texture:getPixelsWide() / 3
--	local frameHeight = texture:getPixelsHigh()

--	local spriteFrame = display.newSpriteFrame(texture, cc.rect(0, 0, frameWidth, frameHeight))
	print(
	string.format(Config.Res.animation_image[image_index].filename,
		Config.Res.animation_image[image_index].min_index))
	local spriteFrame = display.newSpriteFrame(
		string.format(Config.Res.animation_image[image_index].filename,
			Config.Res.animation_image[image_index].min_index))
	local sprite = display.newSprite(spriteFrame)
	sprite.animationName_ = Config.Res.animation_image[image_index].image
--	sprite.frameWidth_ = frameWidth
--	sprite.frameHeight_ = frameHeight
	return sprite
end)

function HeroSprite:ctor(image_index, model)
	self.model_ = model
end

function HeroSprite:getModel()
	return self.model_
end

function HeroSprite:start()
--	self.model_:setDestination(destination)
--	self:updatePosition()
	self:playAnimationForever(display.getAnimationCache(self.animationName_))
		:setTag(self.model_.TAB_YAO)
	return self
end

function HeroSprite:step(dt)
	self.model_:step(dt)
	self:updatePosition()
	return self
end

--function HeroSprite:updatePosition()
--	self:move(self.model_:getPosition())
--	:rotate(self.model_:getRotation())
--end

function HeroSprite:playWalkAnimation()
--	self:stopAllActions()
	self:stopActionByTag(self.model_.TAB_YAO)
	self:playAnimationForever(display.getAnimationCache(
		Config.Res.animation_image[Config.Res.image_walk_index].image))
	:setTag(self.model_.TAG_WALK)
	return self
end

function HeroSprite:playYaoAnimation()
--	self:stopAllActions()
--local animate = cc.Animate:create(display.getAnimationCache(
--	Config.Res.animation_image[Config.Res.image_walk_index].image))
--local action = cc.RepeatForever:create(animate)
--self:stopAction(action)
	self:stopActionByTag(self.model_.TAG_WALK)
	self:playAnimationForever(display.getAnimationCache(
		Config.Res.animation_image[Config.Res.image_yao_index].image))
		:setTag(self.model_.TAB_YAO)
	return self
end

function HeroSprite:fallAnimation(callback)
	local size = self:getContentSize()
	self:rotateBy({time = 0.5, rotation = 90})
		:moveTo({time = 0.6, y = -size.height, onComplete = callback})
end

return HeroSprite

