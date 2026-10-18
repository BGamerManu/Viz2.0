PlaceName = {
    LIVE = false,

    Box = {
        x = 280,
        y = 50,
        w = 100,
        h = 40,
        c = {0,0,0,0.7}
    },

    BottomBar = {
        x = 280,
        y = 90,
        w = 100,
        h = 5,
        c = ThemeColor
    },

    liveBox = {
        x = 280,
        y = 50,
        w = 85,
        h = 40,
        c = ThemeColor
    },

    Name = "LIVE   Newsroom",
    --Text of the right hand bug when Side is "both" (nil: same as Name)
    Name2 = nil,

    --"left" or "right" screen edge, or "both" for a bug on each; the right hand bug is the mirror image of the left one
    Side = "left",

    TimeOffset = 0,

    timeBox = {
        x = 300,
        y = -90,
        w = 85,
        h = 40,
        c = ThemeColor,
        text = "00:00",
    }
}

PlaceNameShowing = false

local function drawPlaceNameSide(right)
    --The right hand bug has its own text when one was given (Name2), else it repeats Name
    local full = (right and PlaceName.Name2) or PlaceName.Name
    local live = string.sub(full,1,4) == "LIVE"
    local place = live and (string.gsub(string.sub(full, 5), "^%s+", "")) or full
    PlaceName.LIVE = live
    if not live and place == "" then return end

    love.graphics.setScissor(right and 0 or 280,50,1920,PlaceName.Box.h + PlaceName.BottomBar.h)
        PlaceName.timeBox.text = os.date("%H:%M", os.time() + PlaceName.TimeOffset)

        --Left: the whole name (including "LIVE") is printed in one box and the red box covers its first word.
        --Right (or LIVE without a place): the red box sits at the outer edge, so "LIVE" and the place are printed separately.
        local name, liveW = full, 0
        if live and (right or place == "") then
            name = place
            liveW = PlaceName.liveBox.w
        end

        local textW = name == "" and 0 or ReithSansRegular:getWidth(name) + 20
        PlaceName.Box.w, PlaceName.BottomBar.w = textW + liveW, textW + liveW
        PlaceName.timeBox.w = ReithSansRegular:getWidth(PlaceName.timeBox.text) + 20

        local boxX, liveX = PlaceName.Box.x, PlaceName.liveBox.x
        if right then
            boxX = 1920 - PlaceName.Box.x - PlaceName.Box.w
            liveX = boxX + PlaceName.Box.w - PlaceName.liveBox.w
            PlaceName.timeBox.x = boxX - 10 - PlaceName.timeBox.w
        else
            PlaceName.timeBox.x = PlaceName.Box.w + PlaceName.Box.x + 10
        end

        --Place Name Box
        love.graphics.setColor(PlaceName.Box.c)
        love.graphics.rectangle("fill",boxX,PlaceName.Box.y,PlaceName.Box.w,PlaceName.Box.h)

        --Place Name liveBox
        if live then
            love.graphics.setColor(ThemeColor)
            love.graphics.rectangle("fill",liveX,PlaceName.liveBox.y,PlaceName.liveBox.w,PlaceName.liveBox.h)
        end

        --Place Name Bottom Bar
        love.graphics.setColor(ThemeColor)
        love.graphics.rectangle("fill",boxX,PlaceName.BottomBar.y,PlaceName.BottomBar.w,PlaceName.BottomBar.h)

        --Place Name Text
        love.graphics.setFont(ReithSansRegular)
        love.graphics.setColor(1,1,1,1)
        love.graphics.print(name,boxX + 10,PlaceName.Box.y)
        if liveW > 0 then love.graphics.print("LIVE",liveX + 10,PlaceName.Box.y) end

        --Time box
        love.graphics.setColor(PlaceName.Box.c)
        love.graphics.rectangle("fill", PlaceName.timeBox.x, PlaceName.timeBox.y, PlaceName.timeBox.w, PlaceName.timeBox.h)

        --Place Name Bottom Bar
        love.graphics.setColor(ThemeColor)
        love.graphics.rectangle("fill",PlaceName.timeBox.x,PlaceName.timeBox.y+PlaceName.timeBox.h,PlaceName.timeBox.w,PlaceName.BottomBar.h)
        

        --Time Text
        love.graphics.setFont(ReithSansRegular)
        love.graphics.setColor(1,1,1,1)
        love.graphics.print(PlaceName.timeBox.text,PlaceName.timeBox.x + 10,PlaceName.timeBox.y)

    love.graphics.setScissor()
end

function DrawPlaceName()
    if PlaceName.Side == "both" then
        drawPlaceNameSide(false)
        drawPlaceNameSide(true)
    else
        drawPlaceNameSide(PlaceName.Side == "right")
    end
end

local function sideOf(side)
    return (side == "right" or side == "both") and side or "left"
end

function ShowPlaceName(text, side, text2)
    if PlaceNameShowing then 
        HidePlaceName()
        Timer.after(0.5, function() ShowPlaceName(text, side, text2) end)
    return
    end

    PlaceNameShowing = true
    PlaceName.Side = sideOf(side)
    PlaceName.Name = text
    PlaceName.Name2 = text2
    PlaceName.Box.y = 50+50
    PlaceName.BottomBar.y = 90+50
    PlaceName.liveBox.y = 50+50

    --Move Place Name Box up
    Anim.to(PlaceName.Box,0.5,{y = 50}):ease("quartout")
    Anim.to(PlaceName.BottomBar,0.5,{y = 90}):ease("quartout")
    Anim.to(PlaceName.liveBox,0.5,{y = 50}):ease("quartout")
    
end

function ShowPlaceNameWithTime(text, TimeOffset, side, text2)


    if PlaceNameShowing then 
        HidePlaceName()
        Timer.after(0.5, function() ShowPlaceNameWithTime(text, TimeOffset, side, text2) end)
    return
    end

    PlaceName.TimeOffset = TimeOffset*3600

    PlaceNameShowing = true
    PlaceName.Side = sideOf(side)
    PlaceName.Name = text
    PlaceName.Name2 = text2
    PlaceName.Box.y = 50+50
    PlaceName.BottomBar.y = 90+50
    PlaceName.timeBox.y = 90+50
    PlaceName.liveBox.y = 50+50

    --Move Place Name Box up
    Anim.to(PlaceName.Box,0.5,{y = 50}):ease("quartout")
    Anim.to(PlaceName.BottomBar,0.5,{y = 90}):ease("quartout")
    Anim.to(PlaceName.liveBox,0.5,{y = 50}):ease("quartout")
    
    Anim.to(PlaceName.timeBox,0.5,{y = 50}):ease("quartout")
    Anim.to(PlaceName.BottomBar,0.5,{y = 90}):ease("quartout")
    
    
end 

function HidePlaceName()
    PlaceNameShowing = false
    --Move Place Name Box up
    Anim.to(PlaceName.Box,0.5,{y = -90}):ease("quartin")

    --Move Place Name Bottom Bar up
    Anim.to(PlaceName.BottomBar,0.5,{y = -90}):ease("quartin")

    --Move Place Name liveBox up
    Anim.to(PlaceName.liveBox,0.5,{y = -90}):ease("quartin")

    Anim.to(PlaceName.timeBox,0.5,{y = -90}):ease("quartin")

end

function HidePlaceNameInstant()
    PlaceName.Box.y = -90
    PlaceName.BottomBar.y = -90
    PlaceName.liveBox.y = -90
end