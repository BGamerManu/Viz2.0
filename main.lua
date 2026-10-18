
--[[
    Viz2.0

    MADE BY playsamay4
]]


Anim = require "lib.flux"
Timer = require "lib.timer"
inspect = require "lib.inspect"
push = require "lib.push"
local sock = require "lib.sock"
local ShowBG = false
KeepBottomText = ""
EnableBadge = false
shouldUsePush = false

gillMode = false

newsTitle = love.graphics.newImage("images/bbcbox.png")
worldTitle = love.graphics.newImage("images/worldbox.png")

newsTitleGill = love.graphics.newImage("images/bbcboxgill.png")
worldTitleGill = love.graphics.newImage("images/worldboxgill.png")

server = sock.newServer("*", 10655)

ThemeColor = {185/255, 0,0}

require "Logo"
require "Headlines"
require "PlaceName"
require "TitleLogo"
require "Transition"
require "Ticker"
require "requests"
require "LowerThirdFull"
require "LowerThirdClock"
require "Election24"
require "Flash"
require "AVplayout"

require "ShitHeadlines"

waterMark = true
waterMarkFade = {a = 1}
local waterMarkFont = love.graphics.newFont("fonts/ReithSansMd.ttf",40)
local waterMarkFontSmall = love.graphics.newFont("fonts/ReithSansMd.ttf",20)

function love.load()
    
    local icon = love.image.newImageData("images/icon.png")
    love.window.setIcon(icon)
    

    bg = love.graphics.newImage("images/studio.jpg")

    Fader = love.graphics.newImage("images/HeadlineFade.png")

    BBCSmall = love.graphics.newImage("images/WhiteLogoTransparent.png")
    BBCSmallGill = love.graphics.newImage("images/GillSansLogoWhite.png")

    ReithSerif = love.graphics.newFont("fonts/ReithSerifRg.ttf",130)
    ReithSansBold = love.graphics.newFont("fonts/ReithSansBd.ttf",30)
    ReithSansRegular = love.graphics.newFont("fonts/ReithSansRg.ttf",30)
    ReithSansMedium = love.graphics.newFont("fonts/ReithSansMd.ttf",30)
    ReithSansMediumHeadline = love.graphics.newFont("fonts/ReithSansMd.ttf",31)

    TickerFont = love.graphics.newFont("fonts/ReithSansMd.ttf",32)
    TickerFontBold = love.graphics.newFont("fonts/ReithSansBd.ttf",32)
    PresenterName = love.graphics.newFont("fonts/ReithSerifMd.ttf",56)

    Splash = love.graphics.newImage("images/splash.png")

    if shouldUsePush == true then
        local gameWidth, gameHeight = 1920,1080 --fixed game resolution
        local windowWidth, windowHeight = 1280,720

        push:setupScreen(gameWidth, gameHeight, windowWidth, windowHeight, {resizable = true,canvas = true, fullscreen = false})
    end
   

end


function love.update(dt)
    if love.thread.getChannel("tcpThreadData"):getCount() > 0 then
        local data = love.thread.getChannel("tcpThreadData"):pop()
        if data == "Connect" then
            Timer.tween(0.8, waterMarkFade, {a = 0}, "in-out-cubic", function()
                waterMark = false
            end)
        end

        request(data)

    end

    Anim.update(dt)
    Timer.update(dt)
    server:update()

    UpdateLowerThirdClock()
    UpdateAVplayout(dt)
end


function love.draw()
    
    if shouldUsePush == true then push:start() end
    love.graphics.setBackgroundColor(0,0,0,0)
    
    if ShowBG then
        love.graphics.setColor(1,1,1,1)
        love.graphics.draw(bg,0,0)
    end

    DrawAVplayout()

    DrawShitHeadlines()


    DrawTransition()

    DrawFlash()

    if not E24.Active then DrawLowerThirdFull() end

    if not E24.Active then DrawPlaceName() end

    DrawTitleLogo()

    if not E24.Active then DrawLowerThirdClock() end

    if not E24.Active then DrawHeadlineSingle() end

    if E24.Active then DrawElection24() end

    if waterMark == true then
        love.graphics.setColor(1,1,1,waterMarkFade.a)
        love.graphics.draw(Splash)
        love.graphics.setColor(1,1,1,waterMarkFade.a)
        love.graphics.setFont(waterMarkFont)
        love.graphics.print("Made by Manuel_Ottani\n\nForked from PlaySamay4 Viz2.0\n\nI'm trying to keep this app\nupdated as far as i can", 100, 700)
        love.graphics.print("Viz2.0", 1750,1000)

        love.graphics.setColor(1,1,1,waterMarkFade.a-0.7)
        love.graphics.setFont(waterMarkFontSmall)
        love.graphics.print("1.4.0", 1850, 10 )
    end
    
    if shouldUsePush == true then push:finish() end
end
--Called from VizHelper's Testing area
function ToggleBackdrop()
    ShowBG = not ShowBG
end

function ToggleWindowMode()
    shouldUsePush = not shouldUsePush
    if shouldUsePush == true then
        local gameWidth, gameHeight = 1920,1080 --fixed game resolution
        local windowWidth, windowHeight = 1280,720

        push:setupScreen(gameWidth, gameHeight, windowWidth, windowHeight, {resizable = true,canvas = true, fullscreen = false})
    else
        love.window.setMode(1920,1080, {resizable = false, fullscreen = false})
    end
end

function love.resize(w,h)
    push:resize(w, h)
end

HideHeadlineInstant()
HidePlaceNameInstant()
HideLowerThirdFullInstant()
HideLowerThirdClockInstant()
HideBadgesInstant()
HideChameleonInstant()



