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

	animation_image = {
		[1] = { image = "texture/walk.png", data = "texture/walk.plist", filename = "z000%d.png", min_index = 1, max_index = 9, },
		[2] = { image = "texture/yao.png", data = "texture/yao.plist", filename = "d000%d.png", min_index = 1, max_index = 9, },
	},
}

