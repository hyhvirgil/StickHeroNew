--
-- Created by IntelliJ IDEA.
-- User: virgil.huang
-- Date: 2015/9/22
-- Time: 17:02
--

local HomeScene = class("HomeScene", cc.load("mvc").ViewBase)

function HomeScene:onCreate()
	-- add background image
	local random = math.random(1, #Config.Res.bg)
	display.newSprite(Config.Res.bg[random])
	:move(display.center)
	:addTo(self)

	-- add play button
	local playButton = cc.MenuItemImage:create(Config.Res.btn_start.normal, Config.Res.btn_start.select)
	:onClicked(function()
		self:getApp():enterScene("PlayScene")
	end)
	cc.Menu:create(playButton)
	:move(display.cx, display.cy + 200)
	:addTo(self)
end

return HomeScene

