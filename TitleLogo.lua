TitleLogo = {
    image = newsTitle,
    c = {1,1,1,0},
    Showing = false,

    --"legacy": the red boxed BBC NEWS logo, "chameleon": the BBC blocks with the channel name under them
    Style = "legacy",
}


Chameleon = {
    bimg = love.graphics.newImage("images/b.png"),
    cimg = love.graphics.newImage("images/c.png"),
    c = {1,1,1,1},
    Showing = false,
    vy = 74,
    by = 74,
    ny = 74,
    newsy = 895,
    newscol = {1,1,1,1},
    newsfont = love.graphics.newFont("fonts/ReithSansBd.ttf", 93),
}

Chameleon.bimg:setFilter("nearest","nearest")
Chameleon.cimg:setFilter("nearest","nearest")


function DrawTitleLogo()
    love.graphics.setColor(TitleLogo.c)
    love.graphics.draw(TitleLogo.image, 287, 780, 0, 0.77,0.77)

    love.graphics.setColor(Chameleon.c)
    love.graphics.draw(Chameleon.bimg, 794, Chameleon.vy, 0, 0.13)
    love.graphics.draw(Chameleon.bimg, 913, Chameleon.by, 0, 0.13)
    love.graphics.draw(Chameleon.cimg, 1032, Chameleon.ny, 0, 0.13)

    --The text under the blocks is the channel name from the branding ("NEWS", "WORLD NEWS"...),
    --centred where "NEWS" has always been
    local channel = Headline.BBCText.Text
    love.graphics.setColor(Chameleon.newscol)
    love.graphics.setFont(Chameleon.newsfont)
    love.graphics.print(channel, 832 + (Chameleon.newsfont:getWidth("NEWS") - Chameleon.newsfont:getWidth(channel)) / 2, Chameleon.newsy)
end


--style is "chameleon" or anything else for the legacy red boxed logo
function ShowTitleLogo(style)
    style = style == "chameleon" and "chameleon" or "legacy"

    if TitleLogo.Showing and TitleLogo.Style ~= style then
        HideTitleLogo()
        Timer.after(1, function() ShowTitleLogo(style) end)
    elseif HeadlineShowing then
        HideHeadline()
        Timer.after(1, function() ShowTitleLogo(style) end)
    elseif LowerThirdFull.LowerThirdShowing then
        HideLowerThirdFull()
        Timer.after(1, function() ShowTitleLogo(style) end)
    else
        TitleLogo.Style = style
        if style == "chameleon" then
            ShowChameleon()
        else
            Anim.to(TitleLogo.c, 0.3, {1,1,1,1})
        end
        TitleLogo.Showing = true
    end
end

function HideTitleLogo()
    if TitleLogo.Style == "chameleon" then
        HideChameleon()
    else
        Anim.to(TitleLogo.c, 0.8, {1,1,1,0})
    end
    TitleLogo.Showing = false
end

function ShowTitleLogoInstant()
    HideLowerThirdFull()

    TitleLogo.Style = "legacy"
    TitleLogo.c = {1,1,1,1}
    TitleLogo.Showing = true
end

function HideTitleLogoInstant()
	TitleLogo.c = {1,1,1,0}
	TitleLogo.Showing = false
	HideChameleonInstant()
end


function ShowChameleon()
    Anim.to(Chameleon , 0.7, {vy = 74}):ease("cubicout")
    Anim.to(Chameleon , 0.7, {by = 74}):delay(0.05):ease("cubicout")
    Anim.to(Chameleon , 0.7, {ny = 74}):delay(0.1):ease("cubicout")

    Anim.to(Chameleon , 0.7, {newsy = 895}):ease("cubicout")
    Anim.to(Chameleon.newscol , 0.7, {1,1,1,1})

    Chameleon.Showing = true
end

function HideChameleon()
    Anim.to(Chameleon , 0.7, {vy = -95}):ease("cubicin")
    Anim.to(Chameleon , 0.7, {by = -95}):delay(0.05):ease("cubicin")
    Anim.to(Chameleon , 0.7, {ny = -95}):delay(0.1):ease("cubicin")

    Anim.to(Chameleon , 0.7, {newsy = 920}):ease("cubicin")
    Anim.to(Chameleon.newscol , 0.7, {1,1,1,0})

    Chameleon.Showing = false
end

function HideChameleonInstant()
    Chameleon.vy = -95
    Chameleon.by = -95
    Chameleon.ny = -95
    Chameleon.newsy = 920
    Chameleon.newscol = {1,1,1,0}

    Chameleon.Showing = false
end 