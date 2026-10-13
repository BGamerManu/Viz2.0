--Headline straps are always one line
HeadlineShowing = false

HeadlineFadeColor = {1,1,1,0.4}

--The red BBC NEWS box in front of the headline is retired, the Chameleon title replaces it.
--Set this to true to bring the box back.
HeadlineBBCBox = false

--Widest a headline gets before its font shrinks to fit (leaves a right margin of about 250px)
local HeadlineMaxWidth = 1400

Headline = {

    LeftBarPurple = {
        x = 240,
        y = 780,
        w = 5,
        h = 205,
        col = ThemeColor
    },

    LeftBarWhite = {
        x = 240,
        y = 780,
        w = 5,
        h = 205,
    },

    BBCBox = {
        x = 270,
        y = 780,

        w = 215,
        h = 44,
        col = ThemeColor
    },

    comingUp = false,

    comingUpBox = {
        x = 485,
        y = 780,
        w = 190,
        h = 44,
        col = {0.95,0.95,0.95,1}
    },

    comingUpText = {
        x = 493,
        y = 780,
        text = "COMING UP",
        col = {73/255,73/255,73/255,1}
    },

    --Without the BBC NEWS box only the COMING UP box is drawn, flush with the text
    comingUpOnly = not HeadlineBBCBox,

    BBCText = {
        x = 390,
        y = 780,
        w = 250,
        h = 42,
        col = {1,1,1,1},
        Text = "NEWS"
    },

    BBCLogo = {
        x = 280,
        y = 787,
    },


    TextXLo = 270,
    TextYLo = 820,
    TextLo = "Test",

    --Font the text fits in (nil: the full size ReithSerif) and how far it moves down to keep the same baseline
    Font = nil,
    FontYAdj = 0,

}


function HideHeadlineSingle()
    Anim.to(HeadlineFadeColor, 1.8, {1,1,1,0})
    HeadlineShowing = false
    --Move whole logo box up
    Anim.to(Headline.BBCBox, .5, {y = 780-50}):ease("quartout")
    Anim.to(Headline.BBCText, .5, {y = 780-50}):ease("quartout")
    Anim.to(Headline.BBCLogo, .5, {y = 787-50}):ease("quartout")
    Anim.to(Headline.comingUpBox, .5, {y = 780-50}):ease("quartout")
    Anim.to(Headline.comingUpText, .5, {y = 780-50}):ease("quartout")

    --Make Left Bar Purple and White shrink downwards
    LeftBarPurpleAnim = Anim.to(Headline.LeftBarPurple, 0.8, {y = 780+205}):ease("quartout")
    LeftBarWhiteAnim = Anim.to(Headline.LeftBarWhite, 0.8, {y = 780+205}):ease("quartout")

    --Move Text up
    Anim.to(Headline, 0.8, {TextYLo = 820-215}):ease("quartout"):delay(0.05)

end

function ShowHeadlineSingle()

    --if logo is showing, hide it
    if TitleLogo.Showing then
        HideTitleLogo()
        Timer.after(1, function() ShowHeadlineSingle() end)
        return
    end

    Anim.to(HeadlineFadeColor, 1.5, {1,1,1,1})
    HeadlineShowing = true
    --Clear left bar anim
    if LeftBarPurpleAnim ~= nil then
        LeftBarPurpleAnim:stop()
        LeftBarWhiteAnim:stop()
    end

    --Set Double height for left bars
    Headline.LeftBarWhite.h = 205
    Headline.LeftBarPurple.h = 205

    --Move whole logo box up
    Headline.BBCBox.y = 780+50
    Headline.BBCText.y = 780+50
    Headline.BBCLogo.y = 787+50
    Headline.comingUpBox.y = 780+50
    Headline.comingUpText.y = 780+50
    Anim.to(Headline.BBCBox, 1, {y = 780}):ease("quartout"):delay(0.2)
    Anim.to(Headline.BBCText, 1, {y = 780}):ease("quartout"):delay(0.2)
    Anim.to(Headline.BBCLogo, 1, {y = 787}):ease("quartout"):delay(0.2)
    Anim.to(Headline.comingUpBox, 1, {y = 780}):ease("quartout"):delay(0.2)
    Anim.to(Headline.comingUpText, 1, {y = 780}):ease("quartout"):delay(0.2)

    --Make Left bar white grow downwards
    Headline.LeftBarWhite.y = 780-205
    Anim.to(Headline.LeftBarWhite, 1, {y = 780}):ease("quartout")

    --Make Left Bar Purple grow downwards
    Headline.LeftBarPurple.y = 780-205
    Anim.to(Headline.LeftBarPurple, 1, {y = 780}):ease("quartout"):delay(0.2)

    --Move Text up
    Headline.TextYLo = 820+215
    Anim.to(Headline, 1, {TextYLo = 820}):ease("quartout"):delay(0.05)
end


function DrawHeadlineSingle()
    if Headline.comingUpOnly ~= true then
        Headline.BBCBox.w = 118 + ReithSansBold:getWidth(Headline.BBCText.Text) + 10
        Headline.comingUpBox.x = Headline.BBCBox.x + Headline.BBCBox.w
        Headline.comingUpText.x = Headline.comingUpBox.x + 8
    else
        Headline.BBCBox.w = 0
        Headline.comingUpBox.x = Headline.BBCBox.x + Headline.BBCBox.w
        Headline.comingUpText.x = Headline.comingUpBox.x + 8
    end

        --Fader
        love.graphics.setColor(HeadlineFadeColor)
        love.graphics.draw(Fader,0,0,0,1.5,1.5)

    love.graphics.setScissor(0,845,love.graphics.getWidth(),ReithSerif:getHeight(Headline.TextLo)-30)
         --Headline Text (1 line, lower)
         love.graphics.setColor(1,1,1,1)
         love.graphics.setFont(Headline.Font or ReithSerif)
         love.graphics.print(Headline.TextLo,Headline.TextXLo,Headline.TextYLo + Headline.FontYAdj)
     love.graphics.setScissor()

    love.graphics.setScissor(270,780,900,44)

        if Headline.comingUpOnly ~= true then
        --BBC Box
         love.graphics.setColor(Headline.BBCBox.col)
         love.graphics.rectangle("fill",Headline.BBCBox.x,Headline.BBCBox.y,Headline.BBCBox.w,Headline.BBCBox.h)

        --BBC Box Text
         love.graphics.setColor(1,1,1,1)
         if gillMode == true then
            love.graphics.setFont(ReithSansMediumHeadline)
         else
            love.graphics.setFont(ReithSansBold)
         end
         love.graphics.print(Headline.BBCText.Text,Headline.BBCText.x,Headline.BBCText.y)

         --BBC Logo
         love.graphics.setColor(1,1,1,1)
         if gillMode == true then
            love.graphics.draw(BBCSmallGill,Headline.BBCLogo.x,Headline.BBCLogo.y,0,0.04,0.04)
         else
            love.graphics.draw(BBCSmall,Headline.BBCLogo.x,Headline.BBCLogo.y,0,0.04,0.04)
         end

        end

        --Coming Up Box
        if Headline.comingUp then
            love.graphics.setColor(Headline.comingUpBox.col)
            love.graphics.rectangle("fill",Headline.comingUpBox.x,Headline.comingUpBox.y,Headline.comingUpBox.w,Headline.comingUpBox.h)
            love.graphics.setColor(Headline.comingUpText.col)
            love.graphics.setFont(ReithSansBold)
            love.graphics.print(Headline.comingUpText.text,Headline.comingUpText.x,Headline.comingUpText.y)
        end
     love.graphics.setScissor()



     love.graphics.setScissor(240,780,5,205)
         --Left Bar White
         love.graphics.setColor(1,1,1,1)
         love.graphics.rectangle("fill",Headline.LeftBarWhite.x,Headline.LeftBarWhite.y,Headline.LeftBarWhite.w,Headline.LeftBarWhite.h)

         --Left Bar Purple
         love.graphics.setColor(Headline.LeftBarPurple.col)
         love.graphics.rectangle("fill",Headline.LeftBarPurple.x,Headline.LeftBarPurple.y,Headline.LeftBarPurple.w,Headline.LeftBarPurple.h)
     love.graphics.setScissor()


end


function HideHeadline()
    HideHeadlineSingle()
end

function PlayoutShowHeadline(text, style)
    HeadlineShow(text, style)
end

function PlayoutNextHeadline(text, style)
    ShowTransition()
    HeadlineShow(text, style)
end

--Shrink the headline font until the text fits in HeadlineMaxWidth.
--Returns the font and how far down it has to be drawn to keep the baseline of the full size font.
local function fitHeadline(text)
    local font = ReithSerif
    local width = font:getWidth(text)

    if width > HeadlineMaxWidth then
        --The width does not scale exactly with the size: start from the ratio and step down
        local size = math.max(56, math.floor(130 * HeadlineMaxWidth / width))
        font = love.graphics.newFont("fonts/ReithSerifRg.ttf", size)
        while font:getWidth(text) > HeadlineMaxWidth and size > 56 do
            size = size - 1
            font = love.graphics.newFont("fonts/ReithSerifRg.ttf", size)
        end
    end

    return font, ReithSerif:getBaseline() - font:getBaseline()
end

function HeadlineShow(text, style)
    if HeadlineShowing == true then
        HideHeadline()
        Timer.after(1, function()
            PlayoutShowHeadline(text, style)
        end)
    elseif LowerThirdFull.LowerThirdShowing == true then
        HideLowerThirdFull()
        Timer.after(1, function()
            PlayoutShowHeadline(text, style)
        end)
    elseif TitleLogo.Showing == true then
        HideTitleLogo()
        Timer.after(1, function()
            PlayoutShowHeadline(text,style)
        end)
    else

        ConfigureHeadlineStyle("clear")

        --Headlines are one line: the "|" that used to split two lines is a space now
        local line = text:gsub("|", " "):match("^%s*(.-)%s*$")
        if line == "" then return end

        Headline.TextLo = line
        Headline.Font, Headline.FontYAdj = fitHeadline(line)
        if style ~= nil then
            ConfigureHeadlineStyle(style)
        else
            ConfigureHeadlineStyle("clear")
        end
        ShowHeadlineSingle()
    end
end

function ConfigureHeadlineStyle(text)
    Headline.comingUpOnly = not HeadlineBBCBox

    if text == "clear" or text == "" or text == nil then
        Headline.comingUp = false
        return
    end

    local configurationWords = {}
    for w in text:gmatch("%S+") do table.insert(configurationWords, w) end

    for i,v in pairs(configurationWords) do
        if v == "ComingUp" then Headline.comingUp = true end
        if v == "ComingUpOnly" then Headline.comingUpOnly = true end
    end
end

function HideHeadlineInstant()
    HeadlineShowing = false
    HeadlineFadeColor = {0,0,0,0}
    Headline.TextYLo = 820+215
    Headline.BBCBox.y = 650-350
    Headline.BBCText.y = 650-350
    Headline.BBCLogo.y = 657-350
    Headline.comingUpBox.y = 650-350
    Headline.comingUpText.y = 650-350
    Headline.LeftBarWhite.y = 650-350
    Headline.LeftBarPurple.y = 650-350
end
