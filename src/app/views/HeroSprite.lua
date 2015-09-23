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
	self:playAnimationForever(display.getAnimationCache(
		Config.Res.animation_image[Config.Res.image_walk_index].image))
	return self
end

function HeroSprite:playYaoAnimation()
	self:playAnimationForever(display.getAnimationCache(
		Config.Res.animation_image[Config.Res.image_yao_index].image))
	return self
end

return HeroSprite

