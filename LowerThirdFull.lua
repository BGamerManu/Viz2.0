local BBCTextReithSansBold = love.graphics.newFont("fonts/ReithSansBd.ttf",35)
local BBCTextReithSansMedium = love.graphics.newFont("fonts/ReithSansMd.ttf",35)


LowerThirdFull = {
    WhitePart = {
        x = 0,
        y = 988,
        w = 1920,
        h = 98,
        col = {254/255, 251/255, 254/255, 0.85}
    },

    ClearPart = {
        x = 0,
        y = 940,
        w = 1920,
        h = 48,
        col = {0, 0, 0, 0.8}
    },

    ClearPartScissor = {
        x = 0,
        y = 940,
        w = 1920,
        h = 48,
    },

    PresenterNameScissor = {
        x = 270,
        y = 860,
        w = 1920,
        h = 48+32,
    },
    

    BBCBox = {
        x = 277,
        y = 940,
        w = 255,
        h = 48,
        col = ThemeColor
    },

    BBCText = {
        x = 413,
        y = 934,
        w = 255,
        h = 48,
        col = {1, 1, 1, 1},
        Text = "NEWS"
    },
    LowerThirdShowing = true,

    --Breaking box should span the width of the screen and should always be on top of clear part
    BreakingBox = {
        x = 0,
        y = 988,
        w = 1920,
        h = 0,
        col = {184/255, 0, 0, 1},
        Text1 = "BREAKING",
        Text1Showing = false,
        Text1Y = 0,
        Text2 = " ",
        Text2Showing = false,
        Text2Y = 0,
        Font1 = love.graphics.newFont("fonts/ReithSansBd.ttf",95),
        Font2 = love.graphics.newFont("fonts/ReithSerifMd.ttf",90),

        --Headline that is rolling out of the strap while its replacement rolls in
        OldText = "",
        OldFont = nil,
        OldY = 0,

        --The BREAKING / headline layout has a headline after BREAKING (it is optional)
        HasHeadline = false,
    },

    --What the breaking strap is showing: nil (not up), "title" (BREAKING / headline), "single" or "double" (text lines)
    BreakingMode = nil,

    SingleText = {
        x = 0,
        y = 988,
        w = 1920,
        h = 0,
        col = {184/255, 0, 0, 1},
        Text2 = "U.S. Journalist arrested in Russia",
        Showing = false,
        Text2Y = 0,
        Font2 = love.graphics.newFont("fonts/ReithSerifMd.ttf",90),

        --Where y settles once the text is up (the font shrink for long text moves it down)
        yRest = 820,

        --Headline that is rolling out of the strap while its replacement rolls in
        OldText = "",
        OldFont = nil,
        OldY = 0,
    },

    --Presenter Name text
    PresenterName = {
        x = 295,
        y = 940,
        w = 1920,
        h = 48,
        col = {1, 1, 1, 1},
        Text = " "
    },

    PresenterSubtitle = {
        x = 295,
        y = 1100,
        w = 1920,
        h = 48,
        col = {1, 1, 1, 1},
        Font = love.graphics.newFont("fonts/ReithSansMd.ttf", 40),
    },
    PresenterNameShowing = false,

    --Ticker
    TickerText = {
        x = 310,
        y = 986,
        col = {0.2,0.2,0.2,0},
        Text = " "
    },

    TickerBlock = {
        x = 288,
        y = 1005,
        w = 10,
        h = 12,
        col = {ThemeColor[1],ThemeColor[2],ThemeColor[3],0}
    },
    TickerScissor = false,


    LowerThirdTitle = {
        x = 290,
        y = 980,
        col = {1,1,1,1},
        Text = "",
        Text2 = "",
        Text1Y = 0,
        Text2Y = 100,
        TextShowing = 1,

    },
    LowerThirdTitleChanging = false,

    LowerThirdSubtitle1 = {
        x = 290,
        y = 1060,
        col = {1,1,1,1},
        Text = " "
    },

    LowerThirdSubtitle2 = {
        x = 290,
        y = 1110,
        col = {1,1,1,1},
        Text = " "
    },
    OnSubtitle = 1,

    LowerThirdTitleShowing = false,

    LowerThirdSubtitleFont = love.graphics.newFont("fonts/ReithSansMd.ttf",40),

    ProgramBadge = {
        scissorX = 0,
        scissorY = 940,
        scissorW = 1920,
        scissorH = 48,
        x = 1430,
        y = 940,
        w = 150,
        h = 48,
        bcol = {0,0,0,0},
        tcol = {1,1,1,1},
        alpha = 1,
        Text = "",
        Font = love.graphics.newFont("fonts/ReithSansMd.ttf",30),
        BoxYOffset = 0,
        TextYOffset = 0,
        ClearPartOffset = 0,
        ClearPartCol = {0,0,0,0.8},
    },
    ProgramBadgeShowing = false,
    ProgramBadgeShouldShow = false,

    --The programme badge to bring back with the bar. ProgramBadge itself is shared with the info badges (socials, credit).
    ProgramBadgeDef = nil,

    --This one is next to the BBC News Box on the lower third
    LowerThirdBox = {
        x = 530,
        y = -49,
        w = 210,
        h = 48,
        bCol = {1,1,1,1},
        tCol = {60/255,60/255,60/255,1},
        Font = love.graphics.newFont("fonts/ReithSansMd.ttf",33),
        scissorX = 0,
        scissorY = 0,
        scissorW = 1920,
        scissorH = 48,
        Text = "COMING UP",
        Showing = false,
    }
}

local yAdjusted = 820

--Shrink the 90px strap headline font until the text fits in 1400px.
--Returns the font and baseY moved down by 0.7px per size step, which keeps the smaller text vertically centred.
local function fitSerif(text, baseY)
    local size, y = 90, baseY
    local font = love.graphics.newFont("fonts/ReithSerifMd.ttf", size)

    while font:getWidth(text) > 1400 and size > 24 do
        size, y = size - 1, y + 0.7
        font = love.graphics.newFont("fonts/ReithSerifMd.ttf", size)
    end

    return font, y
end

--Bring a one line headline up from below the strap (text of the single line text strap and of the single line breaking strap)
local function rollInSingle(text)
    local single = LowerThirdFull.SingleText
    local font, y = fitSerif(text, 820)

    single.Text2, single.Font2, single.Text2Y, single.yRest = text, font, 0, y
    single.y = y + 120
    Anim.to(single, 1, {y = y}):ease("cubicinout")
end

--Roll the one line headline that is on screen out of the top of the strap
local function rollOutSingle()
    local single = LowerThirdFull.SingleText
    local gone = single.Text2

    single.OldText, single.OldFont, single.OldY = gone, single.Font2, single.y
    single.Text2 = ""
    Anim.to(single, 0.8, {OldY = single.y - 120}):ease("cubicinout"):oncomplete(function()
        --A newer update may already have put another headline in this slot
        if single.OldText == gone then single.OldText = "" end
    end)
end

--Roll the title and subtitles out of the top of the strap and park them below it again, ready for the next text
local function rollOutDouble()
    if OnSub1Timer ~= nil then Timer.cancel(OnSub1Timer) end
    if OnSub2Timer ~= nil then Timer.cancel(OnSub2Timer) end
    if OnSub1EndTimer ~= nil then Timer.cancel(OnSub1EndTimer) end
    if OnSub2TimerEnd ~= nil then Timer.cancel(OnSub2TimerEnd) end

    LowerThirdFull.OnSubtitle = 1

    --The title is clipped just below the BBC NEWS / BREAKING boxes while it rolls out
    LowerThirdFull.LowerThirdTitleChanging = true

    local title, sub1, sub2 = LowerThirdFull.LowerThirdTitle, LowerThirdFull.LowerThirdSubtitle1, LowerThirdFull.LowerThirdSubtitle2
    Anim.to(title, 0.8, {y = title.y - 120}):ease("cubicinout")
    Anim.to(sub1, 0.8, {y = sub1.y - 120}):ease("cubicinout")
    Anim.to(sub2, 0.8, {y = sub2.y - 120}):ease("cubicinout")

    --Park them once all three are out of sight. A tween of its own does it: the order the three above complete in is not defined,
    --and a late one would put its text back where it ends
    Anim.to({}, 0.85, {}):oncomplete(function()
        title.y, sub1.y, sub2.y = 980, 1060, 1110
        LowerThirdFull.LowerThirdTitleChanging = false
    end)
end

--A strap line is single (no subtitle) or double (title and subtitles)
local function isSingle(subtitles)
    return subtitles[1] == nil or subtitles[1] == "" or subtitles[1] == "NOP"
end

--What a strap says, to tell whether the text of the text strap and of the breaking strap is the same
local function strapKey(text, subtitles)
    if isSingle(subtitles) then return text end
    return text.."\n"..subtitles[1].."\n"..(subtitles[2] or "")
end

--What the strap that is up is showing: "single" or "double" (text strap or breaking strap), "title" (BREAKING / headline) or nil
local function currentLayout()
    if LowerThirdFull.LowerThirdTitleShowing == true then
        return LowerThirdFull.SingleText.Showing == true and "single" or "double"
    end

    return LowerThirdFull.BreakingMode
end

--Bring the title and subtitles of a two line strap up from below it
local function rollInDouble(text, subtitles)
    local title, sub1, sub2 = LowerThirdFull.LowerThirdTitle, LowerThirdFull.LowerThirdSubtitle1, LowerThirdFull.LowerThirdSubtitle2

    title.Text = text
    sub1.Text = subtitles[1]
    sub2.Text = subtitles[2]

    if subtitles[2] ~= nil and subtitles[2] ~= "NOP" then LoopBetweenSubtitles() end

    Anim.to(title, 1, {y = 980-120}):ease("cubicinout")
    Anim.to(sub1, 1, {y = 980-50}):ease("cubicinout")
    Anim.to(sub2, 1, {y = 980}):ease("cubicinout")
end

--Roll whatever the strap is showing (see currentLayout) out of the top, its replacement comes in from below
local function rollOutContent(layout)
    if layout == "title" then
        local box = LowerThirdFull.BreakingBox
        if box.Text1Showing == true then
            Anim.to(box, 0.8, {Text1Y = -110}):ease("cubicinout")
            box.Text1Showing = false
        else
            Anim.to(box, 0.8, {Text2Y = -110}):ease("cubicinout")
            box.Text2Showing = false
        end
    elseif layout == "single" then
        rollOutSingle()
    elseif layout == "double" then
        rollOutDouble()
    end
end

function DrawLowerThirdFull()
    LowerThirdFull.BBCBox.w = 137 + BBCTextReithSansBold:getWidth(LowerThirdFull.BBCText.Text) + 10

    love.graphics.setScissor(LowerThirdFull.ClearPartScissor.x,LowerThirdFull.ClearPartScissor.y,LowerThirdFull.ClearPartScissor.w,LowerThirdFull.ClearPartScissor.h)
        love.graphics.setColor(LowerThirdFull.ClearPart.col)
        love.graphics.rectangle("fill",LowerThirdFull.ClearPart.x,LowerThirdFull.ClearPart.y,LowerThirdFull.ClearPart.w,LowerThirdFull.ClearPart.h)

        --Presenter name
        
        love.graphics.setScissor(LowerThirdFull.PresenterNameScissor.x,LowerThirdFull.PresenterNameScissor.y,LowerThirdFull.PresenterNameScissor.w,LowerThirdFull.PresenterNameScissor.h)
            local P, sub = LowerThirdFull.PresenterName, LowerThirdFull.PresenterSubtitle
            local function drawName(text, y, subY)
                --Put text into array by lines
                local lines = {}
                for line in text:gmatch("[^\n]+") do
                    table.insert(lines, line)
                end
                love.graphics.setColor(P.col)
                love.graphics.setFont(PresenterName)
                love.graphics.printf(lines[1],P.x,y,P.w,"left")

                --Presenter subtitle
                love.graphics.setColor(sub.col)
                love.graphics.setFont(sub.Font)
                if lines[2] ~= nil then love.graphics.printf(lines[2],sub.x,subY,sub.w,"left") end
            end
            drawName(P.Text, P.y, sub.y)
            --The name that is rolling out
            if P.OldText then drawName(P.OldText, P.OldY, P.OldSubY) end

        --Set scissor for subtitles
        --TO DO
        --Subtitle 1
        love.graphics.setScissor(290,940,1920,48)
            love.graphics.setColor(LowerThirdFull.LowerThirdSubtitle1.col)
            love.graphics.setFont(LowerThirdFull.LowerThirdSubtitleFont)
            love.graphics.printf(LowerThirdFull.LowerThirdSubtitle1.Text,LowerThirdFull.LowerThirdSubtitle1.x,LowerThirdFull.LowerThirdSubtitle1.y,1920,"left")

            --Subtitle 2
            if LowerThirdFull.LowerThirdSubtitle2.Text ~= nil then 
                love.graphics.setColor(LowerThirdFull.LowerThirdSubtitle2.col)
                love.graphics.setFont(LowerThirdFull.LowerThirdSubtitleFont)
                love.graphics.printf(LowerThirdFull.LowerThirdSubtitle2.Text,LowerThirdFull.LowerThirdSubtitle2.x,LowerThirdFull.LowerThirdSubtitle2.y,1920,"left")
            end


        --Reset to big scissor
        love.graphics.setScissor(LowerThirdFull.ClearPartScissor.x,LowerThirdFull.ClearPartScissor.y,LowerThirdFull.ClearPartScissor.w,LowerThirdFull.ClearPartScissor.h)


        love.graphics.setColor(LowerThirdFull.BBCBox.col)
        love.graphics.rectangle("fill",LowerThirdFull.BBCBox.x,LowerThirdFull.BBCBox.y,LowerThirdFull.BBCBox.w,LowerThirdFull.BBCBox.h)

        --Breaking News stuff first
        love.graphics.setColor(LowerThirdFull.BreakingBox.col)
        love.graphics.rectangle("fill",LowerThirdFull.BreakingBox.x,LowerThirdFull.BreakingBox.y,LowerThirdFull.BreakingBox.w,LowerThirdFull.BreakingBox.h)
        love.graphics.setScissor(0,736+130,1920,122)
            love.graphics.setColor(1,1,1,1)
            love.graphics.setFont(LowerThirdFull.BreakingBox.Font1)
            love.graphics.print(LowerThirdFull.BreakingBox.Text1,LowerThirdFull.BreakingBox.x+286,LowerThirdFull.BreakingBox.y+39+LowerThirdFull.BreakingBox.Text1Y)
            love.graphics.setFont(LowerThirdFull.BreakingBox.Font2)
            love.graphics.print(LowerThirdFull.BreakingBox.Text2,LowerThirdFull.BreakingBox.x+286,LowerThirdFull.BreakingBox.y+39+LowerThirdFull.BreakingBox.Text2Y)
            if LowerThirdFull.BreakingBox.OldText ~= "" then
                love.graphics.setFont(LowerThirdFull.BreakingBox.OldFont)
                love.graphics.print(LowerThirdFull.BreakingBox.OldText,LowerThirdFull.BreakingBox.x+286,LowerThirdFull.BreakingBox.y+39+LowerThirdFull.BreakingBox.OldY)
            end

            --Draw our own copy of the subtitles
            love.graphics.setScissor(290,940,1920,48)
                love.graphics.setColor(LowerThirdFull.LowerThirdSubtitle1.col)
                love.graphics.setFont(LowerThirdFull.LowerThirdSubtitleFont)
                love.graphics.printf(LowerThirdFull.LowerThirdSubtitle1.Text,LowerThirdFull.LowerThirdSubtitle1.x,LowerThirdFull.LowerThirdSubtitle1.y,1920,"left")

                --Subtitle 2
                if LowerThirdFull.LowerThirdSubtitle2.Text ~= nil then 
                    love.graphics.setColor(LowerThirdFull.LowerThirdSubtitle2.col)
                    love.graphics.setFont(LowerThirdFull.LowerThirdSubtitleFont)
                    love.graphics.printf(LowerThirdFull.LowerThirdSubtitle2.Text,LowerThirdFull.LowerThirdSubtitle2.x,LowerThirdFull.LowerThirdSubtitle2.y,1920,"left")
                end
        love.graphics.setScissor(LowerThirdFull.ClearPartScissor.x,LowerThirdFull.ClearPartScissor.y,LowerThirdFull.ClearPartScissor.w,LowerThirdFull.ClearPartScissor.h)
        
        love.graphics.setColor(1,1,1,1)
        if CustomLogo ~= nil then
            DrawCustomLogo(LowerThirdFull.BBCBox.x+13,LowerThirdFull.BBCBox.y+7,115.2,33,LowerThirdFull.BBCBox.col)
        elseif gillMode == true then
            love.graphics.draw(BBCSmallGill,LowerThirdFull.BBCBox.x+13,LowerThirdFull.BBCBox.y+7, 0 , 0.045, 0.045)
        else
            love.graphics.draw(BBCSmall,LowerThirdFull.BBCBox.x+13,LowerThirdFull.BBCBox.y+7, 0 , 0.045, 0.045)
        end

        love.graphics.setColor(LowerThirdFull.BBCText.col)
        if gillMode == true then
            love.graphics.setFont(BBCTextReithSansMedium)
            love.graphics.print(LowerThirdFull.BBCText.Text, LowerThirdFull.BBCText.x, LowerThirdFull.BBCText.y+5)
        else
            love.graphics.setFont(BBCTextReithSansBold)
            love.graphics.print(LowerThirdFull.BBCText.Text, LowerThirdFull.BBCText.x, LowerThirdFull.BBCText.y+5)
        end
        

        --Lower Third Title
        -- love.graphics.setColor(0.5,0,0,0.5)
        -- love.graphics.setScissor()
        if LowerThirdFull.LowerThirdTitleChanging == true then 
            love.graphics.setScissor(0,50+LowerThirdFull.ClearPart.y,1920,70)
        elseif LowerThirdFull.SingleText.OldText ~= "" then
            --A one line headline is rolling out, keep it from running over the BBC NEWS / BREAKING boxes
            love.graphics.setScissor(0,870,1920,120)
        else
            love.graphics.setScissor(0,850,1920,140)
        end
            love.graphics.setColor(LowerThirdFull.LowerThirdTitle.col)
            love.graphics.setFont(PresenterName)
            love.graphics.printf(LowerThirdFull.LowerThirdTitle.Text,LowerThirdFull.LowerThirdTitle.x,LowerThirdFull.LowerThirdTitle.y+LowerThirdFull.LowerThirdTitle.Text1Y,1920,"left")
            love.graphics.printf(LowerThirdFull.LowerThirdTitle.Text2,LowerThirdFull.LowerThirdTitle.x,LowerThirdFull.LowerThirdTitle.y+LowerThirdFull.LowerThirdTitle.Text2Y,1920,"left")

            --The one line text is not clipped to the title window, it can come in while a two line text rolls out
            if LowerThirdFull.SingleText.OldText ~= "" then
                love.graphics.setScissor(0,870,1920,120)
            else
                love.graphics.setScissor(0,850,1920,140)
            end
            love.graphics.setFont(LowerThirdFull.SingleText.Font2)
            love.graphics.print(LowerThirdFull.SingleText.Text2,LowerThirdFull.SingleText.x+286,LowerThirdFull.SingleText.y+39+LowerThirdFull.SingleText.Text2Y)
            if LowerThirdFull.SingleText.OldText ~= "" then
                love.graphics.setFont(LowerThirdFull.SingleText.OldFont)
                love.graphics.print(LowerThirdFull.SingleText.OldText,LowerThirdFull.SingleText.x+286,LowerThirdFull.SingleText.OldY+39)
            end
        love.graphics.setScissor()

    --Lower Third Box
    love.graphics.setScissor(LowerThirdFull.LowerThirdBox.scissorX,LowerThirdFull.LowerThirdBox.scissorY+LowerThirdFull.BBCBox.y,LowerThirdFull.LowerThirdBox.scissorW,LowerThirdFull.LowerThirdBox.scissorH)
        love.graphics.setColor(LowerThirdFull.LowerThirdBox.bCol)
        love.graphics.rectangle("fill",LowerThirdFull.BBCBox.x+LowerThirdFull.BBCBox.w,LowerThirdFull.LowerThirdBox.y+LowerThirdFull.BBCBox.y,LowerThirdFull.LowerThirdBox.w,LowerThirdFull.LowerThirdBox.h)
        love.graphics.setFont(LowerThirdFull.LowerThirdBox.Font)
        love.graphics.setColor(LowerThirdFull.LowerThirdBox.tCol)
        love.graphics.printf(LowerThirdFull.LowerThirdBox.Text,LowerThirdFull.BBCBox.x+LowerThirdFull.BBCBox.w,LowerThirdFull.LowerThirdBox.y+1+LowerThirdFull.BBCBox.y,LowerThirdFull.LowerThirdBox.w,"center")
    love.graphics.setScissor()

        

    love.graphics.setColor(LowerThirdFull.WhitePart.col)
    love.graphics.rectangle("fill",LowerThirdFull.WhitePart.x,LowerThirdFull.WhitePart.y,LowerThirdFull.WhitePart.w,LowerThirdFull.WhitePart.h)

    --Ticker
    if LowerThirdFull.TickerScissor then
        love.graphics.setScissor(280,995,1260,40)
        
    end
        love.graphics.setColor(LowerThirdFull.TickerText.col)
        if LowerThirdFull.TickerText.Text == "HEADLINES" or LowerThirdFull.TickerText.Text == "INTERACTIVE" then love.graphics.setFont(TickerFontBold) else love.graphics.setFont(TickerFont) end
        if LowerThirdFull.TickerText.Text ~= nil then love.graphics.printf(LowerThirdFull.TickerText.Text, LowerThirdFull.TickerText.x, LowerThirdFull.TickerText.y+5, 1700-LowerThirdFull.TickerText.x, "left") end
        

        love.graphics.setColor(LowerThirdFull.TickerBlock.col)
        love.graphics.rectangle("fill",LowerThirdFull.TickerBlock.x,LowerThirdFull.TickerBlock.y,LowerThirdFull.TickerBlock.w,LowerThirdFull.TickerBlock.h) 

    if LowerThirdFull.TickerScissor then
        love.graphics.setScissor()
    end

    love.graphics.setScissor()
    
    --Program Badge and Info Badge
    love.graphics.setScissor(LowerThirdFull.ProgramBadge.scissorX,LowerThirdFull.ProgramBadge.scissorY,LowerThirdFull.ProgramBadge.scissorW,LowerThirdFull.ProgramBadge.scissorH)
        love.graphics.setColor(LowerThirdFull.ProgramBadge.ClearPartCol)
        love.graphics.rectangle("fill", LowerThirdFull.ProgramBadge.x, LowerThirdFull.ProgramBadge.y+LowerThirdFull.ProgramBadge.ClearPartOffset, LowerThirdFull.ProgramBadge.w, 48)
        love.graphics.setColor(LowerThirdFull.ProgramBadge.bcol)
        love.graphics.rectangle("fill",LowerThirdFull.ProgramBadge.x,LowerThirdFull.ProgramBadge.y+LowerThirdFull.ProgramBadge.BoxYOffset,LowerThirdFull.ProgramBadge.w,LowerThirdFull.ProgramBadge.h)
        love.graphics.setColor(LowerThirdFull.ProgramBadge.tcol)
        love.graphics.setFont(LowerThirdFull.ProgramBadge.Font)
        love.graphics.printf(LowerThirdFull.ProgramBadge.Text,LowerThirdFull.ProgramBadge.x,LowerThirdFull.ProgramBadge.y+3+LowerThirdFull.ProgramBadge.TextYOffset,LowerThirdFull.ProgramBadge.w,"center")
    love.graphics.setScissor()
end

function HideLowerThirdFull()
    if LowerThirdFull.LowerThirdShowing == false then return end
    local timeAfter = 0.5
    LowerThirdFullShowing = false
    StopTicker()

    if LowerThirdFull.BreakingBox.h > 0 then
        HideBreakingLowerThird()
        Timer.after(1, function() HideLowerThirdFull() end)
        return
    end

    if LowerThirdFull.ProgramBadgeShowing == true then
        HideProgramBadge()
        timeAfter = 0.7
        Timer.after(0.4, function() HideLowerThirdClock() end)
    else
        HideLowerThirdClock()
    end
    Timer.after(timeAfter, function()
        if LowerThirdFull.PresenterNameShowing == true then
            HidePresenterName()
            Timer.after(0.7, function() HideLowerThirdFull() end)
            return
        elseif LowerThirdFull.LowerThirdTitleShowing == true then
            HideLowerThirdText()
            Timer.after(0.7, function() HideLowerThirdFull() end)
            return
        end
        

        --Move the White part down
        Anim.to(LowerThirdFull.WhitePart, 0.8, {y = 1080}):ease("cubicinout")

        --Move the clear part down
        Anim.to(LowerThirdFull.ClearPart, 0.8, {y = 1080}):ease("cubicinout")

        --Move the clearpart scissor down
        Anim.to(LowerThirdFull.ClearPartScissor, 0.8, {y = 1036}):ease("cubicinout")

        --Move the BBC box down
        Anim.to(LowerThirdFull.BBCBox, 0.8, {y = 1080}):ease("cubicinout")

        --Move the BBC text down
        Anim.to(LowerThirdFull.BBCText, 0.8, {y = 1071}):ease("cubicinout")
    
        LowerThirdFull.LowerThirdShowing = false

    end)
end

function ShowLowerThirdFull()
    if LowerThirdFull.LowerThirdShowing == true then return end

    if TitleLogo.Showing == true then
        HideTitleLogo()
        Timer.after(0.6, function() ShowLowerThirdFull() end)
        return
    end

    --If the headline is showing, hide it
    if HeadlineShowing == true then
        HideHeadline()
        Timer.after(1, function() ShowLowerThirdFull() end)
        return
    end

    if LowerThirdFull.PresenterNameShowing == true then
        ShowTickerOnly()
        return
    end

    if LowerThirdFull.LowerThirdTitleShowing == true or LowerThirdFull.BreakingMode ~= nil then
        ShowTickerOnly()
        return
    end



    LowerThirdFullShowing = true

    
    if LowerThirdFull.ProgramBadgeShouldShow == true then
        --make sure program badge is in the right place
        LowerThirdFull.ProgramBadge.y = 940+48
        LowerThirdFull.ProgramBadge.scissorY = 940
        --(it was just dropped out of sight, whichever badge was in the slot)
        LowerThirdFull.ProgramBadgeShowing = false
        Timer.after(0.9, function() ShowProgramBadge(LowerThirdFull.ProgramBadgeDef.Text, LowerThirdFull.ProgramBadgeDef.tcol, LowerThirdFull.ProgramBadgeDef.bcol) end)
    end

    Timer.after(0.3, function () ShowLowerThirdClock() end)

    --Move the White part up
    Anim.to(LowerThirdFull.WhitePart, 0.8, {y = 988}):ease("cubicout")

    --Move the clear part up
    Anim.to(LowerThirdFull.ClearPart, 0.8, {y = 940}):ease("cubicout")

    --Move the clearpart scissor up
    Anim.to(LowerThirdFull.ClearPartScissor, 0.8, {y = 940}):ease("cubicout")

    --Move the BBC box up
    Anim.to(LowerThirdFull.BBCBox, 0.8, {y = 940}):ease("cubicout")

    --Move the BBC text up
    Anim.to(LowerThirdFull.BBCText, 0.8, {y = 934}):ease("cubicout")

    Timer.after(0.5, function()
        TickerI = 0
        StartTicker()
    end)

    LowerThirdFull.LowerThirdShowing = true
end

function ShowTickerOnly()
    if LowerThirdFull.LowerThirdShowing == true then return end




    if TitleLogo.Showing == true then
        HideTitleLogo()
        Timer.after(1, function() ShowLowerThirdFull() end)
        return
    end

    LowerThirdFullShowing = true

    Timer.after(0.3, function () ShowLowerThirdClock() end)

    --Move the White part up
    Anim.to(LowerThirdFull.WhitePart, 0.8, {y = 988}):ease("cubicout")

    Timer.after(0.5, function()
        TickerI = 0
        StartTicker()
    end)

    LowerThirdFull.LowerThirdShowing = true
end


function HideTickerOnly()
    if LowerThirdFull.LowerThirdShowing == false then return end

    LowerThirdFullShowing = false
    StopTicker()
    HideLowerThirdClock()

    Timer.after(0.5, function()
        if LowerThirdFull.PresenterNameShowing == true then
            HidePresenterName()
            Timer.after(0.7, function() HideLowerThirdFull() end)
            return
        elseif LowerThirdFull.LowerThirdTitleShowing == true then
            HideLowerThirdText()
            Timer.after(0.7, function() HideLowerThirdFull() end)
            return
        end

        --Move the White part down
        Anim.to(LowerThirdFull.WhitePart, 0.8, {y = 1080}):ease("cubicinout")
    
        LowerThirdFull.LowerThirdShowing = false

    end)
end


function HideLowerThirdFullInstant()
    --Move the White part down
    LowerThirdFull.WhitePart.y = 1080

    --Move the clear part down
    LowerThirdFull.ClearPart.y = 1080

    --Move the clearpart scissor down
    LowerThirdFull.ClearPartScissor.y = 1036

    --Move the BBC box down
    LowerThirdFull.BBCBox.y = 1080

    --Move the BBC text down
    LowerThirdFull.BBCText.y = 1071

    LowerThirdFull.LowerThirdShowing = false
end


function ShowPresenterName()
    if LowerThirdFull.PresenterNameShowing == true then return end

    --If lowerthird is not showing, show presenter name only
    if LowerThirdFull.LowerThirdShowing == false then
        ShowPresenterNameSolo()
        return
    end

        --If badge is showing fade output its clear part
    if LowerThirdFull.ProgramBadgeShowing == true then
        Timer.tween(0.5,LowerThirdFull.ProgramBadge.ClearPartCol, {0,0,0,0.0})
    end

    --If breaking text is showing, hide it
    if LowerThirdFull.BreakingBox.h > 0 then
        HideBreakingLowerThird()
        Timer.after(0.9, function() ShowPresenterName() end)
        return
    end

    --If lower third text is showing, hide it
    if LowerThirdFull.LowerThirdTitleShowing == true then
        HideLowerThirdText()
        Timer.after(1.3, function() ShowPresenterName() end)
        return
    end



    --If text has one line then
    if LowerThirdFull.PresenterName.Text:find("\n") == nil then
        --Set scissor height and y
        LowerThirdFull.PresenterNameScissor.y = 860
        LowerThirdFull.PresenterNameScissor.h = 80

        LowerThirdFull.PresenterNameShowing = true

        LowerThirdFull.PresenterName.y = 940
    
        --Expand clear part up
        Anim.to(LowerThirdFull.ClearPart, 0.8, {y = 940-75, h = 125}):ease("cubicout") 
    
        --Expand clear part scissor up
        Anim.to(LowerThirdFull.ClearPartScissor, 0.8, {y = 940-140, h = 190}):ease("cubicout")
    
        --Move presenter name up
        Anim.to(LowerThirdFull.PresenterName, 0.8, {y = 860}):ease("cubicout"):delay(0.1)
    else    
        --Set scissor height and y
        LowerThirdFull.PresenterNameScissor.y = 760
        LowerThirdFull.PresenterNameScissor.h = 180

        LowerThirdFull.PresenterNameShowing = true

        LowerThirdFull.PresenterName.y = 940

        --Expand clear part up
        Anim.to(LowerThirdFull.ClearPart, 0.8, {y = 940-120, h = 170}):ease("cubicout") 

        --Expand clear part scissor up
        Anim.to(LowerThirdFull.ClearPartScissor, 0.8, {y = 940-180, h = 230}):ease("cubicout")

        --Move presenter name up
        Anim.to(LowerThirdFull.PresenterName, 0.8, {y = 813}):ease("cubicout"):delay(0.1)

        --Move subtitle up
        Anim.to(LowerThirdFull.PresenterSubtitle, 1, {y = 880}):ease("cubicout")

    end
end

--Change the name strap that is up, like the text strap does: the old name rolls out of the top, the new one rolls in from below.
--One line to two lines (or back) changes the strap height, so the strap is taken down and put up again.
local presenterSwapTimer
local presenterRollId = 0
function UpdatePresenterName(text)
    local P, sub = LowerThirdFull.PresenterName, LowerThirdFull.PresenterSubtitle
    if presenterSwapTimer ~= nil then Timer.cancel(presenterSwapTimer) end

    local two = text:find("\n") ~= nil
    if two ~= (P.Text:find("\n") ~= nil) then
        HidePresenterName()
        presenterSwapTimer = Timer.after(1.1, function()
            P.Text = text
            ShowPresenterName()
        end)
        return
    end

    presenterRollId = presenterRollId + 1
    local id = presenterRollId
    P.OldText, P.OldY, P.OldSubY = P.Text, P.y, sub.y
    Anim.to(P, 0.8, {OldY = P.y - 120, OldSubY = sub.y - 120}):ease("cubicinout"):oncomplete(function()
        if id == presenterRollId then P.OldText = nil end
    end)

    local rest, subRest = two and 813 or 860, 880
    P.Text = text
    P.y, sub.y = rest + 120, subRest + 120
    Anim.to(P, 1, {y = rest}):ease("cubicinout")
    if two then Anim.to(sub, 1, {y = subRest}):ease("cubicinout") end
end

function ShowPresenterNameSolo()
    if LowerThirdFull.PresenterNameShowing == true then return end

    --if LowerThirdFull.ProgramBadgeShowing == true then
        --Timer.tween(0.8, LowerThirdFull.ProgramBadge.ClearPartCol, {0,0,0,0})
    --end

    --Show lowerthird BBC News box
    --Move the BBC box up
    Anim.to(LowerThirdFull.BBCBox, 0.8, {y = 940}):ease("cubicout")

    --Move the BBC text up
    Anim.to(LowerThirdFull.BBCText, 0.8, {y = 934}):ease("cubicout")


    --If text has one line then
    if LowerThirdFull.PresenterName.Text:find("\n") == nil then
            --Set clearpart scissor height and y
            LowerThirdFull.ClearPartScissor.y = 790
            LowerThirdFull.ClearPartScissor.h = 198

        --Set scissor height and y
        LowerThirdFull.PresenterNameScissor.y = 860
        LowerThirdFull.PresenterNameScissor.h = 80

        LowerThirdFull.PresenterNameShowing = true

        LowerThirdFull.PresenterName.y = 940
    
        --Expand clear part up
        Anim.to(LowerThirdFull.ClearPart, 1.1, {y = 940-75, h = 123}):ease("cubicout") 
   
        --Move presenter name up
        Anim.to(LowerThirdFull.PresenterName, 0.9, {y = 860}):ease("cubicout"):delay(0.45)
    else    

            --Set clearpart scissor height and y
    LowerThirdFull.ClearPartScissor.y = 790
    LowerThirdFull.ClearPartScissor.h = 200


        --Set scissor height and y
        --LowerThirdFull.PresenterNameScissor.y = 760
        --LowerThirdFull.PresenterNameScissor.h = 180

        Anim.to(LowerThirdFull.PresenterNameScissor, 0.8, {y = 820, h = 120}):ease("cubicout"):delay(0.23)


        LowerThirdFull.PresenterNameShowing = true

        LowerThirdFull.PresenterName.y = 1080

        --Expand clear part up
        Anim.to(LowerThirdFull.ClearPart, 0.8, {y = 940-120, h = 168}):ease("cubicout") 

        

        --Move presenter name up
        Anim.to(LowerThirdFull.PresenterName, 0.8, {y = 813}):ease("cubicout"):delay(0.23)

        --Move subtitle up
        Anim.to(LowerThirdFull.PresenterSubtitle, 1, {y = 880}):ease("cubicout"):delay(0.23)

    end
end

function HidePresenterName()
    if LowerThirdFull.PresenterNameShowing == false then
        return
    end

    --If lowerthird is not showing, hide presenter name only
    if LowerThirdFull.LowerThirdShowing == false then
        HidePresenterNameSolo()
        return
    end


    
    LowerThirdFull.PresenterNameShowing = false
    --Shrink clear part down
    Anim.to(LowerThirdFull.ClearPart, 0.8, {y = 940, h = 50}):ease("cubicinout")

    --Shrink clear part scissor down
    Anim.to(LowerThirdFull.ClearPartScissor, 0.8, {y = 940, h = 50}):ease("cubicinout")

    --Move presenter name down
    Anim.to(LowerThirdFull.PresenterName, 0.8, {y = 932}):ease("cubicinout")

    --Move subtitle down
    Anim.to(LowerThirdFull.PresenterSubtitle, 1, {y = 1100}):ease("cubicinout")
end

function HidePresenterNameSolo()

    if LowerThirdFull.PresenterNameShowing == false then
        return
    end


    --If badge is showing fade in its clear part
    if LowerThirdFull.ProgramBadgeShowing == true then
        Timer.tween(0.5,LowerThirdFull.ProgramBadge.ClearPartCol, {0,0,0,0.8})
    end


    Anim.to(LowerThirdFull.PresenterNameScissor, 0.6, {y = 1000-48, h = 50}):ease("cubicinout")

    LowerThirdFull.PresenterNameShowing = false
    --Shrink clear part down
    Anim.to(LowerThirdFull.ClearPart, 0.8, {y = 1080, h = 50}):ease("cubicinout"):delay(0.03)

    --Shrink clear part scissor down
    --Anim.to(LowerThirdFull.ClearPartScissor, 0.8, {y = 940, h = 50}):ease("cubicinout")

    --Move presenter name down
    Anim.to(LowerThirdFull.PresenterName, 0.8, {y = 1059}):ease("cubicinout")

    --Move subtitle down
    Anim.to(LowerThirdFull.PresenterSubtitle, 0.7, {y = 1100}):ease("cubicinout")

    --Move the BBC box down
    Anim.to(LowerThirdFull.BBCBox, 0.8, {y = 1080}):ease("cubicinout")

    --Move the BBC text down
    Anim.to(LowerThirdFull.BBCText, 0.8, {y = 1071}):ease("cubicinout")

    Timer.after(0.8, function() 
        LowerThirdFull.ClearPartScissor = {
            x = 0,
            y = 1036,
            w = 1920,
            h = 48,
        }
     end)
end

--The breaking strap turns into the text strap without going down: the red box and the BREAKING tag leave,
--and the text only rolls if it is not the same text (or the same number of lines) as on the breaking strap
local function breakingToText(Title, Subtitles, boxText, boxTcolor, boxBcolor)
    local old = LowerThirdFull.BreakingMode
    local box = LowerThirdFull.BreakingBox
    local single = isSingle(Subtitles)
    local layout = single and "single" or "double"
    local sameText = LowerThirdFull.StrapKey == strapKey(Title, Subtitles)

    LowerThirdFull.StrapKey = strapKey(Title, Subtitles)
    LowerThirdFull.BreakingMode = nil
    LowerThirdFull.LowerThirdTitleShowing = true
    LowerThirdFull.SingleText.Showing = single

    Anim.to(box, 0.8, {y = 988, h = 0}):ease("cubicinout")
    HideLowerThirdBox()
    if boxText ~= nil then Timer.after(0.6, function() ShowLowerThirdBox(boxText, boxTcolor, boxBcolor) end) end

    if old == layout then
        if not sameText then
            if single then UpdateSingleText(Title) else UpdateLowerThirdText(Title, Subtitles) end
        end
    else
        rollOutContent(old)
        if single then rollInSingle(Title) else rollInDouble(Title, Subtitles) end
    end

    --The BREAKING / headline texts are out of sight by now, do not leave them behind
    Timer.after(0.8, function()
        if LowerThirdFull.BreakingMode ~= nil then return end
        box.Text1, box.Text2, box.OldText = "", "", ""
    end)
end

function ShowLowerThirdText(Title, Subtitles, boxText, boxTcolor, boxBcolor)

    --If the breaking strap is showing, it becomes the text strap
    if LowerThirdFull.BreakingMode ~= nil then
        breakingToText(Title, Subtitles, boxText, boxTcolor, boxBcolor)
        return
    end

    LowerThirdFull.StrapKey = strapKey(Title, Subtitles)

    if isSingle(Subtitles) then LowerThirdFull.SingleText.Showing = true ShowLowerThirdTextSingle(Title, boxText, boxTcolor, boxBcolor) return end

    if LowerThirdFull.LowerThirdShowing == false then
        ShowLowerThirdTextSolo(Title, Subtitles, boxText, boxTcolor, boxBcolor)
        return
    elseif LowerThirdFull.PresenterNameShowing == true then
        HidePresenterName()
        Timer.after(0.8, function() ShowLowerThirdText(Title, Subtitles, boxText, boxTcolor, boxBcolor) end)
        return
    end

    if boxText ~= nil then
        if LowerThirdFull.LowerThirdBox.Showing == false then
            Timer.after(0.8,function() ShowLowerThirdBox(boxText, boxTcolor, boxBcolor) end)
        end
    end

    LowerThirdFull.LowerThirdTitleShowing = true

    LowerThirdFull.LowerThirdTitle.Text = Title

    LowerThirdFull.LowerThirdSubtitle1.Text = Subtitles[1]
    LowerThirdFull.LowerThirdSubtitle2.Text = Subtitles[2]

    LowerThirdFull.LowerThirdTitle.y = 980

    if Subtitles[2] ~= nil and Subtitles[2] ~= "" then LoopBetweenSubtitles() end


    --Move clear part up and heighen it
    Anim.to(LowerThirdFull.ClearPart, 1, {y = 940-120, h = 170}):ease("cubicinout")
    --And its scissor
    Anim.to(LowerThirdFull.ClearPartScissor, 1, {y = 940-185, h = 235}):ease("cubicinout")

    --Move BBC box up
    Anim.to(LowerThirdFull.BBCBox, 1, {y = 940-120}):ease("cubicinout")

    --Move BBC text up
    Anim.to(LowerThirdFull.BBCText, 1, {y = 934-120}):ease("cubicinout")


    --Move the title up
    Anim.to(LowerThirdFull.LowerThirdTitle, 1, {y = 940-80}):ease("cubicinout"):delay(0.02)

    --Move the subtitle 1 up
    Anim.to(LowerThirdFull.LowerThirdSubtitle1, 1, {y = 980-50}):ease("cubicinout"):delay(0.04)

    --Move the subtitle 2 up
    Anim.to(LowerThirdFull.LowerThirdSubtitle2, 1, {y = 980}):ease("cubicinout"):delay(0.06)

    if LowerThirdFull.ProgramBadgeShowing == true then
        --Move the program badge up
        Anim.to(LowerThirdFull.ProgramBadge, 1, {y = 940-120}):ease("cubicinout")
 
        --Move program badge scissors up
        Anim.to(LowerThirdFull.ProgramBadge, 1, {scissorY = 940-120}):ease("cubicinout")
    end

end

function ShowLowerThirdTextSolo(Title, Subtitles, boxText, boxTcolor, boxBcolor)

    if Subtitles[1] == nil or Subtitles[1] == "" then LowerThirdFull.SingleText.Showing = true ShowLowerThirdTextSingle(Title, boxText, boxTcolor, boxBcolor) return end

    --if LowerThirdFull.LowerThirdShowing == false then
        --ShowLowerThirdFull()
        --Timer.after(0.7, function() ShowLowerThirdText(Title, Subtitles, boxText, boxTcolor, boxBcolor) end)
    --    return
    if LowerThirdFull.PresenterNameShowing == true then
        HidePresenterName()
        Timer.after(0.8, function() ShowLowerThirdText(Title, Subtitles, boxText, boxTcolor, boxBcolor) end)
        return
    end

    if boxText ~= nil then
        if LowerThirdFull.LowerThirdBox.Showing == false then
            Timer.after(0.8,function() ShowLowerThirdBox(boxText, boxTcolor, boxBcolor) end)
        end
    end


    LowerThirdFull.ClearPartScissor.y = 790
    LowerThirdFull.ClearPartScissor.h = 200

     --Move BBC box down
     LowerThirdFull.BBCBox.y = 990
     --Move BBC text down
     LowerThirdFull.BBCText.y = 984

    --Move clear part down and shrink it
    LowerThirdFull.ClearPart.y, LowerThirdFull.ClearPart.h = 990, 50
    
    LowerThirdFull.LowerThirdTitle.y = 1010

    
    LowerThirdFull.LowerThirdTitleShowing = true

    LowerThirdFull.LowerThirdTitle.Text = Title

    LowerThirdFull.LowerThirdSubtitle1.Text = Subtitles[1]
    LowerThirdFull.LowerThirdSubtitle2.Text = Subtitles[2]

    if Subtitles[2] ~= nil and Subtitles[2] ~= "" then LoopBetweenSubtitles() end


    --Move clear part up and heighen it
    Anim.to(LowerThirdFull.ClearPart, 1, {y = 940-120, h = 170}):ease("cubicinout")
    --And its scissor
    --Anim.to(LowerThirdFull.ClearPartScissor, 1, {y = 940-185, h = 235}):ease("cubicinout")

    --Move BBC box up
    Anim.to(LowerThirdFull.BBCBox, 1, {y = 940-120}):ease("cubicinout")

    --Move BBC text up
    Anim.to(LowerThirdFull.BBCText, 1, {y = 934-120}):ease("cubicinout")


    --Move the title up
    Anim.to(LowerThirdFull.LowerThirdTitle, 1, {y = 940-80}):ease("cubicinout"):delay(0.02)

    --Move the subtitle 1 up
    Anim.to(LowerThirdFull.LowerThirdSubtitle1, 1, {y = 980-50}):ease("cubicinout"):delay(0.04)

    --Move the subtitle 2 up
    Anim.to(LowerThirdFull.LowerThirdSubtitle2, 1, {y = 980}):ease("cubicinout"):delay(0.06)

    if LowerThirdFull.ProgramBadgeShowing == true then
        --Move the program badge up
        Anim.to(LowerThirdFull.ProgramBadge, 1, {y = 940-120}):ease("cubicinout")
 
        --Move program badge scissors up
        Anim.to(LowerThirdFull.ProgramBadge, 1, {scissorY = 940-120}):ease("cubicinout")
    end

end


function HideLowerThirdTextSolo()

    
    if LowerThirdFull.SingleText.Showing == true then
        LowerThirdFull.SingleText.Showing = false
        HideLowerThirdTextSingle()
        return
    end


    LowerThirdFull.LowerThirdTitleShowing = false

    if OnSub1Timer ~= nil then Timer.cancel(OnSub1Timer) end
    if OnSub2Timer ~= nil then Timer.cancel(OnSub2Timer) end
    if OnSub1EndTimer ~= nil then Timer.cancel(OnSub1EndTimer) end
    if OnSub2TimerEnd ~= nil then Timer.cancel(OnSub2TimerEnd) end

    LowerThirdFull.OnSubtitle = 1


    if LowerThirdFull.LowerThirdBoxShowing == true then
        HideLowerThirdBox()
        Timer.after(0.5, function() HideLowerThirdText() end)
        return
    end

    --Move clear part down and shrink it
    Anim.to(LowerThirdFull.ClearPart, 0.8, {y = 990, h = 50}):ease("cubicinout")
    --And its scissor
    Anim.to(LowerThirdFull.ClearPartScissor, 0.8, {y = 940, h = 50}):ease("cubicinout")

    --Move BBC box down
    Anim.to(LowerThirdFull.BBCBox, 0.8, {y = 990}):ease("cubicinout")

    --Move BBC text down
    Anim.to(LowerThirdFull.BBCText, 0.8, {y = 984}):ease("cubicinout")

    --Move the title down
    Anim.to(LowerThirdFull.LowerThirdTitle, 0.8, {y = 1010}):ease("cubicinout")

    --Move the subtitle 1 down
    Anim.to(LowerThirdFull.LowerThirdSubtitle1, 0.8, {y = 1060}):ease("cubicinout")

    --Move the subtitle 2 down
    Anim.to(LowerThirdFull.LowerThirdSubtitle2, 0.8, {y = 1110}):ease("cubicinout")

    Timer.after(0.8, function() 
        LowerThirdFull.LowerThirdTitle.Text = ""

        LowerThirdFull.ClearPartScissor = {
            x = 0,
            y = 1036,
            w = 1920,
            h = 48,
        }

        --Move the White part down
    LowerThirdFull.WhitePart.y = 1080

    --Move the clear part down
    LowerThirdFull.ClearPart.y = 1080

    --Move the clearpart scissor down
    LowerThirdFull.ClearPartScissor.y = 1036

    --Move the BBC box down
    LowerThirdFull.BBCBox.y = 1080

    --Move the BBC text down
    LowerThirdFull.BBCText.y = 1071

    end)

    if LowerThirdFull.ProgramBadgeShowing == true then
        --Move the program badge down
        Anim.to(LowerThirdFull.ProgramBadge, 0.8, {y = 940}):ease("cubicinout")

        --Move program badge scissors down
        Anim.to(LowerThirdFull.ProgramBadge, 0.8, {scissorY = 940}):ease("cubicinout")
    end
    
end


function ShowLowerThirdTextSingle(Title, boxText, boxTcolor, boxBcolor)

    if LowerThirdFull.PresenterNameShowing == true then
        HidePresenterName()
        Timer.after(0.85, function() ShowLowerThirdTextSingle(Title, boxText, boxTcolor, boxBcolor) end)
        return
    end

    if boxText ~= nil then
        if LowerThirdFull.LowerThirdBox.Showing == false then
            Timer.after(0.8,function() ShowLowerThirdBox(boxText, boxTcolor, boxBcolor) end)
        end
    end

    LowerThirdFull.LowerThirdTitleShowing = true

    --Without the white ticker the strap comes up on its own, the same way the two line text strap does
    if LowerThirdFull.LowerThirdShowing == false then
        LowerThirdFull.ClearPartScissor.y = 790
        LowerThirdFull.ClearPartScissor.h = 200

        LowerThirdFull.BBCBox.y = 990
        LowerThirdFull.BBCText.y = 984
        LowerThirdFull.ClearPart.y, LowerThirdFull.ClearPart.h = 990, 50
    end

    --Move clear part up and heighen it
    Anim.to(LowerThirdFull.ClearPart, 1, {y = 940-120, h = 170}):ease("cubicinout")
    --And its scissor
    Anim.to(LowerThirdFull.ClearPartScissor, 1, {y = 940-185, h = 235}):ease("cubicinout")

    --Move BBC box up
    Anim.to(LowerThirdFull.BBCBox, 1, {y = 940-120}):ease("cubicinout")

    --Move BBC text up
    Anim.to(LowerThirdFull.BBCText, 1, {y = 934-120}):ease("cubicinout")


    --Move the title up
    rollInSingle(Title)

    if LowerThirdFull.ProgramBadgeShowing == true then
        --Move the program badge up
        Anim.to(LowerThirdFull.ProgramBadge, 1, {y = 940-120}):ease("cubicinout")
 
        --Move program badge scissors up
        Anim.to(LowerThirdFull.ProgramBadge, 1, {scissorY = 940-120}):ease("cubicinout")
    end

end


function HideLowerThirdTextSingle()

    LowerThirdFull.LowerThirdTitleShowing = false

    if OnSub1Timer ~= nil then Timer.cancel(OnSub1Timer) end
    if OnSub2Timer ~= nil then Timer.cancel(OnSub2Timer) end
    if OnSub1EndTimer ~= nil then Timer.cancel(OnSub1EndTimer) end
    if OnSub2TimerEnd ~= nil then Timer.cancel(OnSub2TimerEnd) end

    LowerThirdFull.OnSubtitle = 1


    if LowerThirdFull.LowerThirdBoxShowing == true then
        HideLowerThirdBox()
        Timer.after(0.5, function() HideLowerThirdTextSingle() end)
        return
    end

    --With the white ticker down the strap sinks out of sight (the scissor hides it below 990), otherwise it settles above the ticker
    local restY = LowerThirdFull.LowerThirdShowing == false and 990 or 940

    --Move clear part down and shrink it
    Anim.to(LowerThirdFull.ClearPart, 0.8, {y = restY, h = 50}):ease("cubicinout")
    --And its scissor
    Anim.to(LowerThirdFull.ClearPartScissor, 0.8, {y = 940, h = 50}):ease("cubicinout")

    --Move BBC box down
    Anim.to(LowerThirdFull.BBCBox, 0.8, {y = restY}):ease("cubicinout")

    --Move BBC text down
    Anim.to(LowerThirdFull.BBCText, 0.8, {y = restY - 6}):ease("cubicinout")

    --Move the title down
    Anim.to(LowerThirdFull.SingleText, 0.8, {y = LowerThirdFull.SingleText.yRest + 120}):ease("cubicinout")

    Timer.after(0.8, function() 
        LowerThirdFull.SingleText.Text2 = ""
    end)

    if LowerThirdFull.ProgramBadgeShowing == true then
        --Move the program badge down
        Anim.to(LowerThirdFull.ProgramBadge, 0.8, {y = 940}):ease("cubicinout")

        --Move program badge scissors down
        Anim.to(LowerThirdFull.ProgramBadge, 0.8, {scissorY = 940}):ease("cubicinout")
    end
    
end

--Change the headline of a one line strap while it stays up: the old one rolls out of the top as the new one rolls in
function UpdateSingleText(text)
    rollOutSingle()
    rollInSingle(text)
end

--Change the text of the text strap that is up. From one line to two lines (or back) the strap stays where it is.
function UpdateTextStrap(text, subtitles)
    local single = isSingle(subtitles)
    local wasSingle = LowerThirdFull.SingleText.Showing == true

    LowerThirdFull.StrapKey = strapKey(text, subtitles)
    LowerThirdFull.SingleText.Showing = single

    if single and wasSingle then
        UpdateSingleText(text)
    elseif not single and not wasSingle then
        UpdateLowerThirdText(text, subtitles)
    elseif single then
        rollOutDouble()
        rollInSingle(text)
    else
        rollOutSingle()
        rollInDouble(text, subtitles)
    end
end

function UpdateLowerThirdText(text, subtitles)
    if OnSub1Timer ~= nil then Timer.cancel(OnSub1Timer) end
    if OnSub2Timer ~= nil then Timer.cancel(OnSub2Timer) end
    if OnSub1EndTimer ~= nil then Timer.cancel(OnSub1EndTimer) end
    if OnSub2TimerEnd ~= nil then Timer.cancel(OnSub2TimerEnd) end

    if subtitles[2] == nil or subtitles[2] == "NOP" then
        if LowerThirdFull.OnSubtitle == 1 then
            LowerThirdFull.LowerThirdSubtitle2.y = 980+20
            LowerThirdFull.OnSubtitle = 2
            LowerThirdFull.LowerThirdSubtitle2.Text = subtitles[1]
            Anim.to(LowerThirdFull.LowerThirdSubtitle1, 1, {y = 930-55}):ease("cubicinout")
            Anim.to(LowerThirdFull.LowerThirdSubtitle2, 1, {y = 960-30}):ease("cubicinout"):oncomplete(function() LowerThirdFull.LowerThirdSubtitle1.Text = "" end)
        elseif LowerThirdFull.OnSubtitle == 2 then
            LowerThirdFull.LowerThirdSubtitle1.y = 980+20
            LowerThirdFull.OnSubtitle = 1
            LowerThirdFull.LowerThirdSubtitle1.Text = subtitles[1]
            Anim.to(LowerThirdFull.LowerThirdSubtitle1, 1, {y = 980-50}):ease("cubicinout")
            Anim.to(LowerThirdFull.LowerThirdSubtitle2, 1, {y = 980-105}):ease("cubicinout"):oncomplete(function() LowerThirdFull.LowerThirdSubtitle2.Text = "" end)
        end
    else
        if LowerThirdFull.OnSubtitle == 1 then
            --If we're currently showing Subtitle 1, then update subtitle 2 and move it up
            LowerThirdFull.OnSubtitle = 2
            LowerThirdFull.LowerThirdSubtitle2.Text = subtitles[1]
            Anim.to(LowerThirdFull.LowerThirdSubtitle1, 1, {y = 930-55}):ease("cubicinout")
            Anim.to(LowerThirdFull.LowerThirdSubtitle2, 1, {y = 960-30}):ease("cubicinout")

            LowerThirdFull.OnSubtitle = 2
            OnSub1EndTimer = Timer.after(1, function() 
                --Move subtitle 1 to the bottom
                LowerThirdFull.LowerThirdSubtitle1.Text = subtitles[2]
                LowerThirdFull.LowerThirdSubtitle1.y = 980+20
                LoopBetweenSubtitles() 
            end)

            -- LoopBetweenSubtitles()
        elseif LowerThirdFull.OnSubtitle == 2 then
            LowerThirdFull.OnSubtitle = 1
            LowerThirdFull.LowerThirdSubtitle1.Text = subtitles[1]
            Anim.to(LowerThirdFull.LowerThirdSubtitle1, 1, {y = 980-50}):ease("cubicinout")
            Anim.to(LowerThirdFull.LowerThirdSubtitle2, 1, {y = 980-105}):ease("cubicinout")

            LowerThirdFull.OnSubtitle = 1
            OnSub2TimerEnd = Timer.after(1, function() 
                --Move subtitle 2 to the bottom
                LowerThirdFull.LowerThirdSubtitle2.Text = subtitles[2]
                LowerThirdFull.LowerThirdSubtitle2.y = 980+20
                LoopBetweenSubtitles() 
            end)

        end
    end

    
        --Update the text
        LowerThirdFull.LowerThirdTitle.Text2Y = 60
        LowerThirdFull.LowerThirdTitle.Text2 = text
        LowerThirdFull.LowerThirdTitleChanging = true
        Anim.to(LowerThirdFull.LowerThirdTitle, 0.6, {Text1Y = -80})
        Anim.to(LowerThirdFull.LowerThirdTitle, 0.8, {Text2Y = 0})
        Timer.after(0.8, function() 
            LowerThirdFull.LowerThirdTitleChanging = false 
            LowerThirdFull.LowerThirdTitle.Text = text
            LowerThirdFull.LowerThirdTitle.Text2 = "" 
            LowerThirdFull.LowerThirdTitle.Text1Y = 0
            LowerThirdFull.LowerThirdTitle.Text2Y = -90

        end)

end


function LoopBetweenSubtitles()

    if LowerThirdFull.OnSubtitle == 1 then 
        OnSub1Timer = Timer.after(7, function()
            --Move subtitle 1 up
            Anim.to(LowerThirdFull.LowerThirdSubtitle1, 1, {y = 930-55}):ease("cubicinout")

            --Move subtitle 2 up
            Anim.to(LowerThirdFull.LowerThirdSubtitle2, 1, {y = 960-30}):ease("cubicinout")

            LowerThirdFull.OnSubtitle = 2
            OnSub1EndTimer = Timer.after(1, function() 
                --Move subtitle 1 to the bottom
                LowerThirdFull.LowerThirdSubtitle1.y = 980+20
                LoopBetweenSubtitles() 
            end)
        end)
    end

    if LowerThirdFull.OnSubtitle == 2 then 
        OnSub2Timer = Timer.after(7, function()
            --Move subtitle 1 down
            Anim.to(LowerThirdFull.LowerThirdSubtitle1, 1, {y = 980-50}):ease("cubicinout")

            --Move subtitle 2 up
            Anim.to(LowerThirdFull.LowerThirdSubtitle2, 1, {y = 980-105}):ease("cubicinout")

            LowerThirdFull.OnSubtitle = 1
            OnSub2TimerEnd = Timer.after(1, function() 
                --Move subtitle 2 to the bottom
                LowerThirdFull.LowerThirdSubtitle2.y = 980+20
                LoopBetweenSubtitles() 
            end)
        end)
    end
end

function HideLowerThirdTextSolo()

    
    if LowerThirdFull.SingleText.Showing == true then
        LowerThirdFull.SingleText.Showing = false
        HideLowerThirdTextSingle()
        return
    end


    LowerThirdFull.LowerThirdTitleShowing = false

    if OnSub1Timer ~= nil then Timer.cancel(OnSub1Timer) end
    if OnSub2Timer ~= nil then Timer.cancel(OnSub2Timer) end
    if OnSub1EndTimer ~= nil then Timer.cancel(OnSub1EndTimer) end
    if OnSub2TimerEnd ~= nil then Timer.cancel(OnSub2TimerEnd) end

    LowerThirdFull.OnSubtitle = 1


    if LowerThirdFull.LowerThirdBoxShowing == true then
        HideLowerThirdBox()
        Timer.after(0.5, function() HideLowerThirdText() end)
        return
    end

    --Move clear part down and shrink it
    Anim.to(LowerThirdFull.ClearPart, 0.8, {y = 990, h = 50}):ease("cubicinout")
    --And its scissor
    Anim.to(LowerThirdFull.ClearPartScissor, 0.8, {y = 940, h = 50}):ease("cubicinout")

    --Move BBC box down
    Anim.to(LowerThirdFull.BBCBox, 0.8, {y = 990}):ease("cubicinout")

    --Move BBC text down
    Anim.to(LowerThirdFull.BBCText, 0.8, {y = 984}):ease("cubicinout")

    --Move the title down
    Anim.to(LowerThirdFull.LowerThirdTitle, 0.8, {y = 1010}):ease("cubicinout")

    --Move the subtitle 1 down
    Anim.to(LowerThirdFull.LowerThirdSubtitle1, 0.8, {y = 1060}):ease("cubicinout")

    --Move the subtitle 2 down
    Anim.to(LowerThirdFull.LowerThirdSubtitle2, 0.8, {y = 1110}):ease("cubicinout")

    Timer.after(0.8, function() 
        LowerThirdFull.LowerThirdTitle.Text = ""

        LowerThirdFull.ClearPartScissor = {
            x = 0,
            y = 1036,
            w = 1920,
            h = 48,
        }

        --Move the White part down
    LowerThirdFull.WhitePart.y = 1080

    --Move the clear part down
    LowerThirdFull.ClearPart.y = 1080

    --Move the clearpart scissor down
    LowerThirdFull.ClearPartScissor.y = 1036

    --Move the BBC box down
    LowerThirdFull.BBCBox.y = 1080

    --Move the BBC text down
    LowerThirdFull.BBCText.y = 1071

    end)

    if LowerThirdFull.ProgramBadgeShowing == true then
        --Move the program badge down
        Anim.to(LowerThirdFull.ProgramBadge, 0.8, {y = 940}):ease("cubicinout")

        --Move program badge scissors down
        Anim.to(LowerThirdFull.ProgramBadge, 0.8, {scissorY = 940}):ease("cubicinout")
    end
    
end


function HideLowerThirdText()

    
    if LowerThirdFull.LowerThirdShowing == false then
        HideLowerThirdTextSolo()
        return
    end
    
    if LowerThirdFull.SingleText.Showing == true then
        LowerThirdFull.SingleText.Showing = false
        HideLowerThirdTextSingle()
        return
    end



    LowerThirdFull.LowerThirdTitleShowing = false

    if OnSub1Timer ~= nil then Timer.cancel(OnSub1Timer) end
    if OnSub2Timer ~= nil then Timer.cancel(OnSub2Timer) end
    if OnSub1EndTimer ~= nil then Timer.cancel(OnSub1EndTimer) end
    if OnSub2TimerEnd ~= nil then Timer.cancel(OnSub2TimerEnd) end

    LowerThirdFull.OnSubtitle = 1


    if LowerThirdFull.LowerThirdBoxShowing == true then
        HideLowerThirdBox()
        Timer.after(0.5, function() HideLowerThirdText() end)
        return
    end

    --Move clear part down and shrink it
    Anim.to(LowerThirdFull.ClearPart, 0.8, {y = 940, h = 50}):ease("cubicinout")
    --And its scissor
    Anim.to(LowerThirdFull.ClearPartScissor, 0.8, {y = 940, h = 50}):ease("cubicinout")

    --Move BBC box down
    Anim.to(LowerThirdFull.BBCBox, 0.8, {y = 940}):ease("cubicinout")

    --Move BBC text down
    Anim.to(LowerThirdFull.BBCText, 0.8, {y = 934}):ease("cubicinout")

    --Move the title down
    Anim.to(LowerThirdFull.LowerThirdTitle, 0.8, {y = 980}):ease("cubicinout")

    --Move the subtitle 1 down
    Anim.to(LowerThirdFull.LowerThirdSubtitle1, 0.8, {y = 1060}):ease("cubicinout")

    --Move the subtitle 2 down
    Anim.to(LowerThirdFull.LowerThirdSubtitle2, 0.8, {y = 1110}):ease("cubicinout")

    Timer.after(0.8, function() 
        LowerThirdFull.LowerThirdTitle.Text = ""
    end)

    if LowerThirdFull.ProgramBadgeShowing == true then
        --Move the program badge down
        Anim.to(LowerThirdFull.ProgramBadge, 0.8, {y = 940}):ease("cubicinout")

        --Move program badge scissors down
        Anim.to(LowerThirdFull.ProgramBadge, 0.8, {scissorY = 940}):ease("cubicinout")
    end
    
end

--Change the headline of the BREAKING strap while it stays up, whichever layout it is showing
local function UpdateBreakingTitle(text)
    local box = LowerThirdFull.BreakingBox
    local font
    font, yAdjusted = fitSerif(text, 0)

    if LowerThirdFull.BreakingMode == "title" then
        if box.Text1Showing == true then
            --BREAKING is on screen, the new headline just waits below it for the next scroll
            box.Text2, box.Font2, box.Text2Y, box.HasHeadline = text, font, 110+yAdjusted, text ~= ""
        elseif text == "" then
            --No headline any more: it rolls out and BREAKING comes back
            box.HasHeadline = false
            AdvanceBreakingTitle()
        else
            --The headline is on screen: it rolls out of the top as the new one rolls in from below
            box.HasHeadline = true
            local gone = box.Text2
            box.OldText, box.OldFont, box.OldY = gone, box.Font2, box.Text2Y
            Anim.to(box, 0.8, {OldY = -110}):ease("cubicout"):oncomplete(function()
                --A newer update may already have put another headline in this slot
                if box.OldText == gone then box.OldText = "" end
            end)

            box.Text2, box.Font2, box.Text2Y = text, font, 110+yAdjusted
            Anim.to(box, 0.8, {Text2Y = yAdjusted}):ease("cubicout")
        end
        return
    end

    --A text layout is on the strap: roll it out, take the box (BREAKING or the text strap's) down and bring the big BREAKING in
    rollOutContent(currentLayout())
    HideLowerThirdBox()

    --The text strap turns into the breaking strap: the red box comes up over it
    if LowerThirdFull.LowerThirdTitleShowing == true then
        LowerThirdFull.LowerThirdTitleShowing = false
        LowerThirdFull.SingleText.Showing = false
        Anim.to(box, 1, {y = 940-120, h = 170}):ease("cubicout")
    end

    LowerThirdFull.BreakingMode = "title"
    box.Text1, box.Text1Y, box.Text1Showing = "BREAKING", 110, true
    box.Text2, box.Font2, box.Text2Y, box.Text2Showing, box.HasHeadline = text, font, 110+yAdjusted, false, text ~= ""
    Anim.to(box, 0.8, {Text1Y = 0}):ease("cubicout")
end

function ShowBreakingTitle(text)
    --The strap is already up (breaking or text strap): change it in place instead of lowering and raising it
    if LowerThirdFull.BreakingMode ~= nil or LowerThirdFull.LowerThirdTitleShowing == true then
        UpdateBreakingTitle(text)
        return
    end

    --Hide program badge if showing
    if LowerThirdFull.ProgramBadgeShowing == true then
        HideProgramBadge()
    end

    --Hide presenter name if showing
    if LowerThirdFull.PresenterNameShowing == true then
        HidePresenterName()
        Timer.after(0.2, function() ShowBreakingTitle(text) end)
        return
    end

    --Adjust font size dynamically
    LowerThirdFull.BreakingBox.Font2, yAdjusted = fitSerif(text, 0)

    Timer.after(0.8, function ()

        --Expand the breaking part up

        LowerThirdFull.BreakingMode = "title"
        LowerThirdFull.BreakingBox.HasHeadline = text ~= ""
        LowerThirdFull.BreakingBox.OldText = ""
        LowerThirdFull.BreakingBox.Text1Y = 0
        LowerThirdFull.LowerThirdTitle.Text = ""
        LowerThirdFull.BreakingBox.Text1 = "BREAKING"
        LowerThirdFull.BreakingBox.Text1Showing = true
        LowerThirdFull.BreakingBox.Text2 = text
        LowerThirdFull.BreakingBox.Text2Y = 110+yAdjusted

        --Move clear part up and heighen it
        Anim.to(LowerThirdFull.ClearPart, 1, {y = 940-120, h = 170}):ease("cubicout")
        Anim.to(LowerThirdFull.BreakingBox, 1, {y = 940-120, h = 170}):ease("cubicout")
        --And its scissor
        Anim.to(LowerThirdFull.ClearPartScissor, 1, {y = 940-185, h = 235}):ease("cubicout")

        --Move BBC box up
        Anim.to(LowerThirdFull.BBCBox,1, {y = 940-120}):ease("cubicout")

        --Move BBC text up
        Anim.to(LowerThirdFull.BBCText,1, {y = 934-120}):ease("cubicout")

        if LowerThirdFull.ProgramBadgeShowing == true then
            --Move the program badge up
            Anim.to(LowerThirdFull.ProgramBadge, 1, {y = 940-120}):ease("cubicout")

            --Move program badge scissors up
            Anim.to(LowerThirdFull.ProgramBadge, 1, {scissorY = 940-120}):ease("cubicout")
        end
    end)
end

function AdvanceBreakingTitle()
    --Only the BREAKING / headline layout has something to scroll between, and only with a headline
    if LowerThirdFull.BreakingMode ~= "title" then return end
    if LowerThirdFull.BreakingBox.Text1Showing == true and not LowerThirdFull.BreakingBox.HasHeadline then return end

    --Change offsetts
    if LowerThirdFull.BreakingBox.Text1Showing == true then
        LowerThirdFull.BreakingBox.Text2Y = 110+yAdjusted

        Anim.to(LowerThirdFull.BreakingBox, 0.8, {Text1Y = -110}):ease("cubicout")
        Anim.to(LowerThirdFull.BreakingBox, 0.8, {Text2Y = yAdjusted}):ease("cubicout")
        LowerThirdFull.BreakingBox.Text1Showing = false
        LowerThirdFull.BreakingBox.Text2Showing = true
    else
        LowerThirdFull.BreakingBox.Text1Y = 110

        Anim.to(LowerThirdFull.BreakingBox, 0.8, {Text1Y = 0}):ease("cubicout")
        Anim.to(LowerThirdFull.BreakingBox, 0.8, {Text2Y = -110}):ease("cubicout")
        LowerThirdFull.BreakingBox.Text1Showing = true
        LowerThirdFull.BreakingBox.Text2Showing = false
    end

end

function ShowBreakingLowerThird(text, subtitles)
    --No subtitle means a one line strap
    local single = isSingle(subtitles)
    local layout = single and "single" or "double"
    local mode = LowerThirdFull.BreakingMode

    --The strap is already up with this layout: change its text in place instead of lowering and raising it
    if mode == layout then
        LowerThirdFull.StrapKey = strapKey(text, subtitles)
        if single then UpdateSingleText(text) else UpdateLowerThirdText(text, subtitles) end
        return
    end

    --if the presenter name is showing, hide it
    if LowerThirdFull.PresenterNameShowing == true then
        HidePresenterName()
        Timer.after(0.8, function() ShowBreakingLowerThird(text, subtitles) end)
        return
    end

    --The text strap is up: it turns into the breaking strap in place. Its text stays if it is the same text.
    local fromText = LowerThirdFull.LowerThirdTitleShowing == true
    local textInPlace = fromText and currentLayout() == layout
    local sameText = LowerThirdFull.StrapKey == strapKey(text, subtitles)
    LowerThirdFull.StrapKey = strapKey(text, subtitles)

    --Whatever the strap is showing now (headline, one line or two line text) rolls out of the top
    if not textInPlace then rollOutContent(currentLayout()) end

    --The BREAKING box only comes up (and flashes) if it is not up already, e.g. when going from one line to two lines.
    --The box of a text strap makes way for it.
    local boxUp = LowerThirdFull.LowerThirdBoxShowing == true and not fromText
    local boxDelay = 0.3
    if fromText and LowerThirdFull.LowerThirdBoxShowing == true then
        HideLowerThirdBox()
        boxDelay = 0.6
    end

    --The text waits for the strap and box to come up, with both up already it only waits for the old text to get going
    local textDelay = boxUp and 0.25 or 0.5

    --If the breaking part was not showig, show it
    if LowerThirdFull.BreakingBox.h == 0 then

        LowerThirdFull.BreakingBox.Text1 = ""
        LowerThirdFull.BreakingBox.Text2 = ""

        if fromText then
            --The strap is up already, only the red box comes up over it
            Anim.to(LowerThirdFull.BreakingBox, 1, {y = 940-120, h = 170}):ease("cubicout")
        else
            --Move clear part up and heighen it
            Anim.to(LowerThirdFull.ClearPart, 1, {y = 940-120, h = 170}):ease("cubicout")
            Anim.to(LowerThirdFull.BreakingBox, 1, {y = 940-120, h = 170}):ease("cubicout")
            --And its scissor
            Anim.to(LowerThirdFull.ClearPartScissor, 1, {y = 940-185, h = 235}):ease("cubicout")

            --Move BBC box up
            Anim.to(LowerThirdFull.BBCBox,1, {y = 940-120}):ease("cubicout")

            --Move BBC text up
            Anim.to(LowerThirdFull.BBCText,1, {y = 934-120}):ease("cubicout")

            if LowerThirdFull.ProgramBadgeShowing == true then
                --Move the program badge up
                Anim.to(LowerThirdFull.ProgramBadge, 1, {y = 940-120}):ease("cubicout")

                --Move program badge scissors up
                Anim.to(LowerThirdFull.ProgramBadge, 1, {scissorY = 940-120}):ease("cubicout")
            end
        end
    end

    LowerThirdFull.BreakingMode = layout
    LowerThirdFull.LowerThirdTitleShowing = false
    LowerThirdFull.SingleText.Showing = false

    if not boxUp then
        Timer.after(boxDelay,function() ShowLowerThirdBox("BREAKING", BreakingCol(1),{1,1,1,1}) end)
    end
    Timer.after(textDelay, function()

        if not boxUp then
            --Flash LowerThirdBox's text color
            Timer.after(0, function() Anim.to(LowerThirdFull.LowerThirdBox.tCol, 0.2, BreakingCol(1)):ease("cubicinout") end)
            Timer.after(0.2, function() Anim.to(LowerThirdFull.LowerThirdBox.tCol, 0.2, BreakingCol(0)):ease("cubicinout") end)
            Timer.after(0.4, function() Anim.to(LowerThirdFull.LowerThirdBox.tCol, 0.2, BreakingCol(1)):ease("cubicinout") end)
            Timer.after(0.6, function() Anim.to(LowerThirdFull.LowerThirdBox.tCol, 0.2, BreakingCol(0)):ease("cubicinout") end)
            Timer.after(0.8, function() Anim.to(LowerThirdFull.LowerThirdBox.tCol, 0.2, BreakingCol(1)):ease("cubicinout") end)
            Timer.after(1, function() Anim.to(LowerThirdFull.LowerThirdBox.tCol, 0.2, BreakingCol(0)):ease("cubicinout") end)
            Timer.after(1.2, function() Anim.to(LowerThirdFull.LowerThirdBox.tCol, 0.2, BreakingCol(1)):ease("cubicinout") end)
        end

        if textInPlace then
            --Same number of lines as the text strap had: only a different text has to change
            if not sameText then
                if single then UpdateSingleText(text) else UpdateLowerThirdText(text, subtitles) end
            end
        elseif single then
            rollInSingle(text)
        else
            rollInDouble(text, subtitles)
        end
    end)

end

function HideBreakingLowerThird()
    local delay = 0.2
    local mode = LowerThirdFull.BreakingMode
    LowerThirdFull.BreakingMode = nil

    if LowerThirdFull.BreakingBox.Text1Showing == true then
        Anim.to(LowerThirdFull.BreakingBox, 0.8, {Text1Y = -100}):ease("cubicinout")
        LowerThirdFull.BreakingBox.Text1Showing = false
        delay = 0.8
    elseif LowerThirdFull.BreakingBox.Text2Showing == true then
        Anim.to(LowerThirdFull.BreakingBox, 0.8, {Text2Y = -100}):ease("cubicinout")
        LowerThirdFull.BreakingBox.Text2Showing = false
        delay = 0.8
    end

    LowerThirdFull.LowerThirdTitleShowing = false

    if OnSub1Timer ~= nil then Timer.cancel(OnSub1Timer) end
    if OnSub2Timer ~= nil then Timer.cancel(OnSub2Timer) end
    if OnSub1EndTimer ~= nil then Timer.cancel(OnSub1EndTimer) end
    if OnSub2TimerEnd ~= nil then Timer.cancel(OnSub2TimerEnd) end

    LowerThirdFull.OnSubtitle = 1

    HideLowerThirdBox()

    Timer.after(delay, function()

        LowerThirdFull.LowerThirdTitleShowing = false
        LowerThirdFull.BreakingBox.Text1 = ""
        LowerThirdFull.BreakingBox.Text2 = ""
        LowerThirdFull.BreakingBox.OldText = ""

        --Move the text down
        Anim.to(LowerThirdFull.LowerThirdTitle, 0.8, {y = 980}):ease("cubicinout")

        --Move the subtitle 1 down
        Anim.to(LowerThirdFull.LowerThirdSubtitle1, 0.8, {y = 980+70}):ease("cubicinout")

        --Move the subtitle 2 down
        Anim.to(LowerThirdFull.LowerThirdSubtitle2, 0.8, {y = 980+140}):ease("cubicinout")
    end)

     --Move the one line text down
     if mode == "single" then
        LowerThirdFull.SingleText.OldText = ""
        Anim.to(LowerThirdFull.SingleText, 0.8, {y = LowerThirdFull.SingleText.yRest + 120}):ease("cubicinout"):delay(delay):oncomplete(function()
            LowerThirdFull.SingleText.Text2 = ""
        end)
     end

     --With the white ticker down the strap sinks out of sight (the scissor hides it below 990), otherwise it settles above the ticker
     local restY = LowerThirdFull.LowerThirdShowing == false and 990 or 940

     --Move clear part down and shrink it
     Anim.to(LowerThirdFull.ClearPart, 0.8, {y = restY, h = 50}):ease("cubicinout"):delay(delay)
     Anim.to(LowerThirdFull.BreakingBox, 0.8, {y = 988, h = 0}):ease("cubicinout"):delay(delay)
     --And its scissor
     Anim.to(LowerThirdFull.ClearPartScissor, 0.8, {y = 940, h = 50}):ease("cubicinout"):delay(delay)

     --Move BBC box down
     Anim.to(LowerThirdFull.BBCBox, 0.8, {y = restY}):ease("cubicinout"):delay(delay)

     --Move BBC text down
     Anim.to(LowerThirdFull.BBCText, 0.8, {y = restY - 6}):ease("cubicinout"):delay(delay)

     if LowerThirdFull.ProgramBadgeShowing == true then
        --The badge went up with the strap, it comes back down with it
        Anim.to(LowerThirdFull.ProgramBadge, 0.8, {y = 940}):ease("cubicinout"):delay(delay)
        Anim.to(LowerThirdFull.ProgramBadge, 0.8, {scissorY = 940}):ease("cubicinout"):delay(delay)
     elseif LowerThirdFull.ProgramBadgeShouldShow == true then
        --The BREAKING headline took the badge off screen, bring it back
        Timer.after(1.5, function() ShowProgramBadge(LowerThirdFull.ProgramBadgeDef.Text, LowerThirdFull.ProgramBadgeDef.tcol, LowerThirdFull.ProgramBadgeDef.bcol) end)
     end
end

--Row the badges sit in: the bottom row of the bar, or the top row of the strap while a text or breaking strap is up
local function badgeRestY()
    if LowerThirdFull.LowerThirdTitleShowing == true or LowerThirdFull.BreakingMode ~= nil then
        return 940-120
    end

    return 940
end

--Bring the badge up from below its row. Its clip window has to be on that row too, or it is not drawn.
local function badgeIn()
    local badge = LowerThirdFull.ProgramBadge
    local rest = badgeRestY()

    badge.scissorY = rest
    badge.y = rest+48
    Anim.to(badge, 0.5, {y = rest, scissorY = rest}):ease("cubicout")
end

--Take the badge out of the top of its clip window
local function badgeOut()
    local badge = LowerThirdFull.ProgramBadge

    return Anim.to(badge, 0.5, {y = badge.scissorY-48}):ease("cubicin")
end

--The black behind a text only badge is not needed when a bar or a strap is already black there
local function badgeBackdrop()
    if LowerThirdFull.PresenterNameShowing == true or LowerThirdFullShowing == true or LowerThirdFull.LowerThirdTitleShowing == true or LowerThirdFull.BreakingMode ~= nil then
        return {0,0,0,0}
    end

    return {0,0,0,0.8}
end

function ShowProgramBadge(text, tcolor, bcolor)
    LowerThirdFull.ProgramBadgeShouldShow = true
    LowerThirdFull.ProgramBadgeDef = {Text = text, tcol = tcolor, bcol = bcolor}

    if LowerThirdFull.ProgramBadgeShowing == true then
        HideProgramBadge()
        Timer.after(0.7, function() ShowProgramBadge(text, tcolor, bcolor) end)
        return
    end

    LowerThirdFull.ProgramBadgeShowing = true
    LowerThirdFull.ProgramBadge.Text = text
    LowerThirdFull.ProgramBadge.tcol = tcolor
    LowerThirdFull.ProgramBadge.bcol = bcolor

    --The plain programme badge shape (an info badge before it may have left its own)
    LowerThirdFull.ProgramBadge.h = 48
    LowerThirdFull.ProgramBadge.BoxYOffset = 0
    LowerThirdFull.ProgramBadge.TextYOffset = 0

    --Program badge X must be aligned to the right of the screen 100px from the edge
    TextWidth = LowerThirdFull.ProgramBadge.Font:getWidth(LowerThirdFull.ProgramBadge.Text)
    LowerThirdFull.ProgramBadge.w = TextWidth + 20
    LowerThirdFull.ProgramBadge.x = 1920-295 - TextWidth

    --Move program badge up from the bottom
    badgeIn()
end

function HideProgramBadge()
    LowerThirdFull.ProgramBadgeShowing = false

    badgeOut()
end

function SetProgramBadge(text, tcolor, bcolor)
    LowerThirdFull.ProgramBadge.Text = text

    LowerThirdFull.ProgramBadge.tcol = stringToTable(tcolor)
    LowerThirdFull.ProgramBadge.bcol = stringToTable(bcolor)
    LowerThirdFull.ProgramBadgeDef = {Text = text, tcol = LowerThirdFull.ProgramBadge.tcol, bcol = LowerThirdFull.ProgramBadge.bcol}

    --Program badge X must be aligned to the right of the screen 100px from the edge
    TextWidth = LowerThirdFull.ProgramBadge.Font:getWidth(LowerThirdFull.ProgramBadge.Text)
    LowerThirdFull.ProgramBadge.w = TextWidth + 20
    LowerThirdFull.ProgramBadge.x = 1920-295 - TextWidth

    LowerThirdFull.ProgramBadgeShouldShow = true
end

function RemoveProgramBadge()
    HideProgramBadge()
    LowerThirdFull.ProgramBadgeShouldShow = false
end

function ShowInfoBadge(text)
    if LowerThirdFull.ProgramBadgeShowing == true then
        HideInfoBadge()
        Timer.after(0.7, function() ShowInfoBadge(text) end)
        return
    end

    --If a bar, strap or the presenter name is showing, hide this clear part
    LowerThirdFull.ProgramBadge.ClearPartCol = badgeBackdrop()

    LowerThirdFull.ProgramBadgeShowing = true
    LowerThirdFull.ProgramBadge.Text = text
    LowerThirdFull.ProgramBadge.tcol = {1,1,1,1}
    LowerThirdFull.ProgramBadge.bcol = ThemeColor

    --Program badge X must be aligned to the right of the screen 100px from the edge
    TextWidth = LowerThirdFull.ProgramBadge.Font:getWidth(LowerThirdFull.ProgramBadge.Text)
    LowerThirdFull.ProgramBadge.w = TextWidth + 20
    LowerThirdFull.ProgramBadge.x = 1920-295 - TextWidth

    --Move program badge up from the bottom
    LowerThirdFull.ProgramBadge.h = 48
    LowerThirdFull.ProgramBadge.BoxYOffset = 0
    badgeIn()

    LowerThirdFull.ProgramBadge.TextYOffset = -5

    --The box shrinks to a line under the text. Animations, not timers: the ticker clears every timer when it stops.
    Anim.to(LowerThirdFull.ProgramBadge, 0.001, {h = 5}):delay(0.75)
    Anim.to(LowerThirdFull.ProgramBadge, 0.5, {BoxYOffset = 43}):ease("cubicinout"):delay(0.3)
end


function ShowCreditBadge(text)
    if LowerThirdFull.ProgramBadgeShowing == true then
        HideInfoBadge()
        Timer.after(0.7, function() ShowCreditBadge(text) end)
        return
    end

    --If a bar, strap or the presenter name is showing, hide this clear part
    LowerThirdFull.ProgramBadge.ClearPartCol = badgeBackdrop()

    LowerThirdFull.ProgramBadgeShowing = true
    LowerThirdFull.ProgramBadge.Text = text
    LowerThirdFull.ProgramBadge.tcol = {1,1,1,1}
    LowerThirdFull.ProgramBadge.bcol = {0,0,0,0}

    --Program badge X must be aligned to the right of the screen 100px from the edge
    TextWidth = LowerThirdFull.ProgramBadge.Font:getWidth(LowerThirdFull.ProgramBadge.Text)
    LowerThirdFull.ProgramBadge.w = TextWidth + 20
    LowerThirdFull.ProgramBadge.x = 1920-295 - TextWidth

    --Move program badge up from the bottom
    LowerThirdFull.ProgramBadge.h = 48
    LowerThirdFull.ProgramBadge.BoxYOffset = 0
    badgeIn()

    LowerThirdFull.ProgramBadge.TextYOffset = -2

    --The box shrinks to a line under the text (see ShowInfoBadge)
    Anim.to(LowerThirdFull.ProgramBadge, 0.001, {h = 5}):delay(0.75)
    Anim.to(LowerThirdFull.ProgramBadge, 0.5, {BoxYOffset = 43}):ease("cubicinout"):delay(0.3)
end





function HideInfoBadge()
    LowerThirdFull.ProgramBadgeShowing = false

    --Once it is out of sight it is the plain programme badge shape again (unless a badge came in meanwhile)
    badgeOut():oncomplete(function()
        if LowerThirdFull.ProgramBadgeShowing == true then return end

        LowerThirdFull.ProgramBadge.TextYOffset = 0
        LowerThirdFull.ProgramBadge.BoxYOffset = 0

        LowerThirdFull.ProgramBadge.h = 48
    end)
end

function HideBadgesInstant()
    LowerThirdFull.ProgramBadgeShowing = false
    LowerThirdFull.ProgramBadge.y = 892
end

function ShowLowerThirdBox(text, textColor, bgColor) 
    LowerThirdFull.LowerThirdBoxShowing = true

    LowerThirdFull.LowerThirdBox.Text = text
    LowerThirdFull.LowerThirdBox.tCol = textColor
    LowerThirdFull.LowerThirdBox.bCol = bgColor

    --Calculate the width of the text
    TextWidth = LowerThirdFull.LowerThirdBox.Font:getWidth(LowerThirdFull.LowerThirdBox.Text)
    LowerThirdFull.LowerThirdBox.w = TextWidth + 20


    LowerThirdFull.LowerThirdBox.y = 49

    --Move the box up
    Anim.to(LowerThirdFull.LowerThirdBox, 0.5, {y = 0}):ease("cubicout")

end

function HideLowerThirdBox()
    LowerThirdFull.LowerThirdBoxShowing = false

    --Move the box down
    Anim.to(LowerThirdFull.LowerThirdBox, 0.5, {y = -49}):ease("cubicin")
end


function stringToTable(str)
    local tbl = {}
    for val in string.gmatch(str, "[^/]+") do
      table.insert(tbl, tonumber(val))
    end
    return tbl
  end
  
