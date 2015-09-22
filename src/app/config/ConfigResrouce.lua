--
-- Created by IntelliJ IDEA.
-- User: virgil.huang
-- Date: 2015/9/22
-- Time: 17:15
--

Config = Config or {}

Config.Res = {
	bg = {
		[1] = "map/background0.png",
		[2] = "map/background1.png",
		[3] = "map/background2.png",
		[4] = "map/background3.png",
	},

	btn_start = {
		normal = "texture/start_normal.png",
		select = "texture/start_select.png",
	},

	image_walk_index = 1,
	image_yao_index = 2,
	animation_image = {
		[1] = { image = "texture/walk.png", data = "texture/walk.plist", filename = "z000%d.png", min_index = 1, max_index = 9, },
		[2] = { image = "texture/yao.png", data = "texture/yao.plist", filename = "d000%d.png", min_index = 1, max_index = 9, },
	},

	img_stick = "texture/stick_black.png",

	img_score_bg = "texture/scoreBg.png",
	img_over_score_bg = "texture/overScoreBg.png",

	img_restart = "texture/restart.png",
	img_home = "texture/home.png",
}

