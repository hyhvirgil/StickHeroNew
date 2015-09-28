
-- GameView is a combination of view and controller
local GameView = class("GameView", cc.load("mvc").ViewBase)

--local BugBase   = import("..models.BugBase")
--local BugAnt    = import("..models.BugAnt")
--local BugSpider = import("..models.BugSpider")
local Hero = import("..models.Hero")
local Stick = import("..models.Stick")
local Platform = import("..models.Platform")

local HeroSprite = import(".HeroSprite")
local StickSprite = import(".StickSprite")
local PlatformSprite = import(".PlatformSprite")
--local BugSprite = import(".BugSprite")
--local DeadBugSprite = import(".DeadBugSprite")

--GameView.HOLE_POSITION = cc.p(display.cx - 30, display.cy - 75)
--GameView.INIT_LIVES = 5
--GameView.ADD_BUG_INTERVAL_MIN = 1
--GameView.ADD_BUG_INTERVAL_MAX = 3
--
--GameView.IMAGE_FILENAMES = {}
--GameView.IMAGE_FILENAMES[BugBase.BUG_TYPE_ANT] = "BugAnt.png"
--GameView.IMAGE_FILENAMES[BugBase.BUG_TYPE_SPIDER] = "BugSpider.png"

--GameView.BUG_ANIMATION_TIMES = {}
--GameView.BUG_ANIMATION_TIMES[BugBase.BUG_TYPE_ANT] = 0.15
--GameView.BUG_ANIMATION_TIMES[BugBase.BUG_TYPE_SPIDER] = 0.1
GameView.ANIMATION_TIMES = {}
GameView.ANIMATION_TIMES[Config.Res.image_walk_index] = 0.3
GameView.ANIMATION_TIMES[Config.Res.image_yao_index] = 0.1
GameView.ALL_MOVE_SPEED = 10
--GameView.ZORDER_BUG = 100
--GameView.ZORDER_DEAD_BUG = 50

GameView.events = {
    PLAYER_DEAD_EVENT = "PLAYER_DEAD_EVENT",
}

GameView.STICK_STATE = {
    VERTICAL = 1,
    HORIZONTAL = 2,
    OTHER = 3,
}

GameView.PLATFORM_INIT_WIDTH = Platform.MAX_WIDTH
GameView.PLATFORM_INIT_HEIGHT = Platform.HEIGHT

local SCHEDULER = cc.Director:getInstance():getScheduler()

function GameView:start() print("start GameView = ", GameView)
--    self:scheduleUpdate(handler(self, self.update))
    local listener = cc.EventListenerTouchOneByOne:create()

    listener:setSwallowTouches(true)
    listener:registerScriptHandler(function(...) return self:touchBegan(...) end, cc.Handler.EVENT_TOUCH_BEGAN)
    listener:registerScriptHandler(function(...) return self:touchMove(...) end, cc.Handler.EVENT_TOUCH_MOVED)
    listener:registerScriptHandler(function(...) return self:touchEnd(...) end, cc.Handler.EVENT_TOUCH_ENDED)

    local eventDispather = cc.Director:getInstance():getEventDispatcher()
    eventDispather:addEventListenerWithFixedPriority(listener, 1)
    return self
end

function GameView:stop()
--    self:unscheduleUpdate()
    return self
end

function GameView:restart()
    print("Gameview restart")
    if self.hero_ then
        self.hero_:removeSelf()
        self.hero_ = nil
    end
    if self.first_platform then
        self.first_platform:removeSelf()
        self.first_platform = nil
    end
    if self.second_platform then
        self.second_platform:removeSelf()
        self.second_platform = nil
    end
    if self.stick_ then
        self.stick_:removeSelf()
        self.stick_ = nil
    end

    self:resetScore()
    self:createAll()
end

function GameView:createAll()
    self:addPlatform()
    self:addPlatform()
    self:addStick()
    self:addHero()
end

function GameView:addHero()
    local hero_model = Hero:create()
    self.hero_ = HeroSprite:create(Config.Res.image_yao_index, hero_model)
        :start()
        :move(GameView.PLATFORM_INIT_WIDTH, GameView.PLATFORM_INIT_HEIGHT - 1)
        :setAnchorPoint(display.RIGHT_BOTTOM)
        :addTo(self)

    return self
end

function GameView:after_platform_setup()
    self.can_touch_ = true
end

function GameView:addPlatform()
    local platform_model = Platform:create()
    if self.first_platform then
        local size = self.first_platform:getContentSize()
        self.second_platform = PlatformSprite:create(platform_model)
            :transformToNewPlatform(size.width, function() self:after_platform_setup() end)
            :addTo(self)
    else
        self.first_platform = PlatformSprite:create(platform_model)
            :move(GameView.PLATFORM_INIT_WIDTH, GameView.PLATFORM_INIT_HEIGHT)
            :addTo(self)
    end
    return self
end

function GameView:addStick()
    local stick_model = Stick:create()
    self.stick_ = StickSprite:create(cc.p(GameView.PLATFORM_INIT_WIDTH, GameView.PLATFORM_INIT_HEIGHT), stick_model)
        :addTo(self)

    return self
end

function GameView:onCreate()
--    self.lives_ = GameView.INIT_LIVES
--    self.kills_ = 0
--    self.bugs_ = {}
--    self.addBugInterval_ = 0
    print("onCreate")
    self.stick_state = GameView.STICK_STATE.VERTICAL
    -- add touch layer
--    display.newLayer()
--        :onTouch(handler(self, self.onTouch))
--        :addTo(self)

    -- add background image
    local random = math.random(1, #Config.Res.bg)
    display.newSprite(Config.Res.bg[random])
        :move(display.center)
        :addTo(self)

    -- add bugs node
--    self.heroNode_ = display.newNode():addTo(self)
--    self.firstNode_ = display.newNode():addTo(self)
--    self.secodeNode_ = display.newNode():addTo(self)

    self.can_touch_ = false
    self.schedulerIdArray = {}
    self.score = 0
--    -- add lives icon and label
    local score_bg = display.newSprite(Config.Res.img_score_bg)
        :move(display.cx, display.height / 3 * 2)
        :addTo(self)
    local score_bg_size = score_bg:getContentSize()
    self.label_score = cc.Label:createWithSystemFont(""..self.score, Config.Font.default, 32)
        :move(score_bg_size.width / 2, score_bg_size.height / 2)
        :addTo(score_bg)

    -- create animation for bugs
    for index, data in pairs(Config.Res.animation_image) do
        -- load image
--        local texture = display.loadImage(filename)
--        local frameWidth = texture:getPixelsWide() / 3
--        local frameHeight = texture:getPixelsHigh()
--
--        -- create sprite frame based on image
--        local frames = {}
--        for i = 0, 1 do
--            local frame = display.newSpriteFrame(texture, cc.rect(frameWidth * i, 0, frameWidth, frameHeight))
--            frames[#frames + 1] = frame
--        end
--
--        -- create animation
--        local animation = display.newAnimation(frames, GameView.BUG_ANIMATION_TIMES[bugType])
--        -- caching animation
--        display.setAnimationCache(filename, animation)
        --
        display.loadSpriteFrames(data.data, data.image)
        local frames = {}
        for i = data.min_index, data.max_index do
            local filename = string.format(data.filename, i)
            local frame = display.newSpriteFrame(filename)
            frames[#frames + 1] = frame
        end

        local animation = display.newAnimation(frames, GameView.ANIMATION_TIMES[index])
        -- caching animation
        display.setAnimationCache(data.image, animation)
    end

    self:createAll()
    -- bind the "event" component
    cc.bind(self, "event")
end

--function GameView:onTouch(event)
--    if event.name ~= "began" then return end
--    local x, y = event.x, event.y
--    for _, bug in pairs(self.bugs_) do
--        if bug:getModel():checkTouch(x, y) then
--            self:bugDead(bug)
--        end
--    end
--end

function GameView:onCleanup()
    self:removeAllEventListeners()
end

-- 触摸事件
function GameView:touchBegan(touch, event)
    print("touchBegan", self.can_touch_)
    if not self.can_touch_ then
        return false
    end

    local function addStickLen()
        local stick_model = self.stick_:getModel()
        if stick_model:lengthIsMaxLength() then
            self:touchEnd()
        else
            self.stick_:extend()
        end
    end

    self.schedulerId = SCHEDULER:scheduleScriptFunc(addStickLen, 0.05, false)
    return true
end

function GameView:touchMove(touch, event)
--    print("touchMove")
end
-- 触摸结束
function GameView:touchEnd(touch, event)
    print("touchEnd", self.schedulerId)
    self.can_touch_ = false

    self:cancelSchedule()

    self.stick_:rotateToHorizontal(function() self:crossToSecondPlatform() end)
end

function GameView:crossToSecondPlatform()
    self.hero_:playWalkAnimation()
    local hero_model = self.hero_:getModel()
    local hero_init_pos = cc.p(self.hero_:getPosition())
    local hero_size = self.hero_:getContentSize()

    local stick_start_pos = cc.p(self.stick_:getPosition())
    local stick_size = self.stick_:getContentSize()
    local stick_end_x = stick_start_pos.x + stick_size.height

    local second_platform_size = self.second_platform:getContentSize()
    local second_platform_pos = cc.p(self.second_platform:getPosition())

    local function crossPlatform()
        local hero_pos = cc.p(self.hero_:getPosition())
        local hero_really_x = hero_pos.x - hero_size.width / 2   -- 人物脚下实际x坐标
        if hero_pos.x >= stick_end_x then
            if stick_end_x < (second_platform_pos.x - second_platform_size.width) or
                    stick_end_x > second_platform_pos.x then
                self:cancelSchedule()
                self.hero_:fallAnimation(function() self:afterHeroFall() end)
                return
            elseif hero_really_x >= (second_platform_pos.x - second_platform_size.width)
                and hero_pos.x > second_platform_pos.x then
                self.hero_:setPosition(hero_pos.x, hero_init_pos.y)
                self:cancelSchedule()
                self.hero_:playYaoAnimation()
                -- 都向左移，棍子回到原位，然后设置可以触摸
                self:addScore()
                self:allMoveToLeft()
                return
            end
        end
        local hero_cur_y = hero_init_pos.y
        if hero_really_x >= stick_start_pos.x and hero_really_x <= stick_end_x then
            hero_cur_y = hero_init_pos.y + stick_size.width
        end
        self.hero_:move(hero_pos.x + hero_model:getWalkSpeed(), hero_cur_y)
    end
    self.schedulerId = SCHEDULER:scheduleScriptFunc(crossPlatform, 0.01, false)
end

function GameView:cancelSchedule()
    if self.schedulerId then
        SCHEDULER:unscheduleScriptEntry(self.schedulerId)
        self.schedulerId = nil
    end
end

function GameView:afterHeroFall()
    self:dispatchEvent({name = GameView.events.PLAYER_DEAD_EVENT, score = self.score})
end

function GameView:allMoveToLeft()
    local second_platform_size = self.second_platform:getContentSize()
    local second_platform_pos = cc.p(self.second_platform:getPosition())
    local distance = second_platform_pos.x - second_platform_size.width

    local function after_move_to_left()
        local size1 = self.first_platform:getContentSize()
        local size2 = self.second_platform:getContentSize()
        local temp = self.first_platform
        self.first_platform = self.second_platform
        self.second_platform = temp

        local size = self.first_platform:getContentSize()
        self.second_platform:transformToNewPlatform(size.width, function() self:after_platform_setup() end)

        self.stick_:reset(size.width, size.height)
    end

    self:fixedMoveToLeft(self.hero_, distance, after_move_to_left)
    self:fixedMoveToLeft(self.first_platform, distance)
    self:fixedMoveToLeft(self.second_platform, distance)
    self:fixedMoveToLeft(self.stick_, distance)
end

function GameView:fixedMoveToLeft(obj, distance, callback)
    local pos = cc.p(obj:getPosition())
    local target_x = pos.x - distance
    self.schedulerIdArray[obj] = SCHEDULER:scheduleScriptFunc(
        function() return self:moveToLeft(obj, target_x, callback) end, 0.01, false)
    return self
end

function GameView:moveToLeft(obj, target_x, callback)
    local pos = cc.p(obj:getPosition())
    if pos.x - GameView.ALL_MOVE_SPEED <= target_x then
        obj:move(target_x, pos.y)
        if self.schedulerIdArray[obj] then
            SCHEDULER:unscheduleScriptEntry(self.schedulerIdArray[obj])
            self.schedulerIdArray[obj] = nil
        end
        if callback then
            callback()
            return
        end
    end
    obj:move(pos.x - GameView.ALL_MOVE_SPEED, pos.y)
end

function GameView:addScore()
    self.score = self.score + 1
    self.label_score:setString(self.score)
end

function GameView:resetScore()
    self.score = 0
    self.label_score:setString(self.score)
end

return GameView
