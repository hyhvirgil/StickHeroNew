
local PlayScene = class("PlayScene", cc.load("mvc").ViewBase)

local GameView = import(".GameView")

function PlayScene:onCreate()
    -- create game view and add it to stage
    self.gameView_ = GameView:create()
        :addEventListener(GameView.events.PLAYER_DEAD_EVENT, handler(self, self.onPlayerDead))
        :start()
        :addTo(self)
end

function PlayScene:onPlayerDead(event)
    local layer = display.newLayer(cc.c4b(0, 0, 0, 70), display.size)
--        :align(display.CENTER, display.center)
--        :setAnchorPoint(display.CENTER)
--        :move(display.center)
        :addTo(self)
    -- add game over text
    local text_game_over = string.format(Config.text.game_over)
    cc.Label:createWithSystemFont(text_game_over, Config.Font.default, 96)
        :align(display.CENTER, cc.p(display.cx, display.top - 100))
        :addTo(layer)

    local score_bg = display.newSprite(Config.Res.img_over_score_bg, display.cx, display.top - 300)
        :setAnchorPoint(display.CENTER)
        :addTo(layer)
    local score_bg_size = score_bg:getContentSize()
     cc.Label:createWithSystemFont(Config.text.score, Config.Font.default, 50)
        :setTextColor(cc.c3b(0, 0, 0))
--        :setAnchorPoint(display.CENTER)
        :move(score_bg_size.width / 2, score_bg_size.height / 2 + 50)
--        :align(display.CENTER, cc.p(score_bg_pos.x, score_bg_pos.y))
        :addTo(score_bg)
    local text_score_num = "10"
    cc.Label:createWithSystemFont(text_score_num, Config.Font.default, 50)
        :setTextColor(cc.c3b(0, 0, 0))
--        :setAnchorPoint(display.CENTER)
        :move(score_bg_size.width / 2, score_bg_size.height / 2 - 50)
--        :align(display.CENTER, cc.p(score_bg_pos.x, score_bg_pos.y))
        :addTo(score_bg)

    -- add exit button
    local restartButton = cc.MenuItemImage:create(Config.Res.img_restart, Config.Res.img_restart)
        :move(display.cx - 100, display.bottom + 200)
        :onClicked(function()
            layer:removeSelf()
            self.gameView_:restart()
        end)
    local homeButton = cc.MenuItemImage:create(Config.Res.img_home, Config.Res.img_home)
        :move(display.cx + 100, display.bottom + 200)
        :onClicked(function()
            self:getApp():enterScene("HomeScene")
        end)
    cc.Menu:create(restartButton, homeButton)
        :move(0, 0)
        :addTo(layer)
--    local restartButton = cc.ControlButton:create(Config.Res.img_restart, Config.Res.img_restart)
--            :move(display.cx - 100, display.bottom + 200)
--            :onClicked(function()
--                   print("restart button")
--            end)
--            :addTo(self)
end

return PlayScene
