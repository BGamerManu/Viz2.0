--"Election 24 Viz - Experimental": a second look for the News Bar, straps, LIVE bug and headline, after the BBC Election 2024
--graphics, with the name and the colours of the branding (BBC News, not BBC Election).
--It is switched on by Set-Branding with Style = "election24". While it is on, the requests of the classic graphics are answered
--here (E24.request) and the classic News Bar, straps, bug and headline are not drawn. No badges, no vote panels.
--
--Sizes, colours and timings come from the frames of the video https://youtu.be/30-SS2-rtIk:
--  * the News Bar is a header (logo and channel name) on top of a white bar; a strap is the BODY that opens between them,
--    the header rides up with it
--  * a strap that changes: the text fades out in 0.2 s, the colour fades in 0.25 s, the new text fades in 0.2 s (and drifts up 5 px)
--  * BREAKING / headline: BREAKING rolls up behind the header in 0.2 s, the white BREAKING tag is wiped in 0.35 s, the headline fades in
--  * LIVE bug: it closes (and opens) in 0.25 s as a mask rising from its bottom edge
E24 = {Active = false}

--------------------------------------------------------------------------------------------------- layout and colours

--(1920x1080: strap and bar between x 69 and 1851, header 54 high, body 167 high, white bar from y 988 to 1038)
local L, R = 69, 1851
local HEADER_H, BODY_H = 54, 167
local BAR_TOP, BAR_H = 988, 50
local CLOCK_W = 144
local BAR_HIDDEN = 120

--The header is the strap colour at 59%, the body fades to 94.5% of it towards its bottom, the BREAKING strap is one flat colour
local HEADER_DARK, BODY_FADE = 0.59, 0.055
local BAR_WHITE = {250/255, 251/255, 248/255}
local DEFAULT_BREAKING = {177/255, 0, 0}

local fonts = {}
local function font(file, size)
    local key = file..size
    if not fonts[key] then fonts[key] = love.graphics.newFont("fonts/"..file..".ttf", size) end
    return fonts[key]
end

--The biggest font (down to minSize) in which text fits maxW
local function fit(text, file, size, minSize, maxW)
    while size > minSize and font(file, size):getWidth(text) > maxW do size = size - 2 end
    return font(file, size)
end

local function theme() return Headline.BBCBox.col end

local function breakingColour() return BreakingColor or DEFAULT_BREAKING end

local function mix(a, b, p) return a + (b - a) * p end

local function rgb(c, k, a) return {c[1] * k, c[2] * k, c[3] * k, a or 1} end

--------------------------------------------------------------------------------------------------- state

local S = {
    off = BAR_HIDDEN, barUp = false,   --0 on screen, BAR_HIDDEN out of sight (header, body and bar move together)
    bodyH = 0,                          --how far the strap is open
    strap = {
        kind = nil,                    --nil, "text", "name" or "breaking"
        c = nil,                       --{mode = "lines", lines = {...}} or {mode = "title", t1, t2, hasHeadline}
        tag = nil, tagP = 0,           --white tag in the header and how much of it is wiped in
        alpha = 1, drift = 0,          --text fade and its small drift up
        mix = 0,                       --0 strap colour, 1 BREAKING colour
        word = 0, headline = 0,        --title mode: BREAKING rolled out (1 up, -1 down) and how visible the headline is
        gen = 0,
    },
    bug = {p = 0},
    headline = {text = "", textY = 0, tagP = 0, shade = 0, alpha = 0, gen = 0},
}

E24.bug = S.bug

--------------------------------------------------------------------------------------------------- tweens (their own, not the timers
--of the ticker: StopTicker clears every timer of the program)

local tweens, timers = {}, {}

local EASE = {
    linear = function(t) return t end,
    quadout = function(t) return 1 - (1 - t) * (1 - t) end,
    cubicout = function(t) return 1 - (1 - t) ^ 3 end,
    cubicin = function(t) return t ^ 3 end,
}

--obj[key] goes to the value in dur seconds (after delay); another tween of the same value is dropped
local function tween(obj, key, to, dur, ease, delay)
    for i = #tweens, 1, -1 do
        if tweens[i].obj == obj and tweens[i].key == key then table.remove(tweens, i) end
    end
    tweens[#tweens + 1] = {obj = obj, key = key, to = to, dur = dur, ease = EASE[ease or "cubicout"], t0 = love.timer.getTime() + (delay or 0)}
end

local function after(delay, fn)
    timers[#timers + 1] = {at = love.timer.getTime() + delay, fn = fn}
end

local function update()
    local now = love.timer.getTime()
    for i = #tweens, 1, -1 do
        local tw = tweens[i]
        if tw and now >= tw.t0 then
            if tw.from == nil then tw.from = tw.obj[tw.key] end
            local p = math.min(1, (now - tw.t0) / tw.dur)
            tw.obj[tw.key] = tw.from + (tw.to - tw.from) * tw.ease(p)
            if p >= 1 then table.remove(tweens, i) end
        end
    end
    for i = #timers, 1, -1 do
        if timers[i] and now >= timers[i].at then
            local fn = timers[i].fn
            table.remove(timers, i)
            fn()
        end
    end
end

--------------------------------------------------------------------------------------------------- drawing

--A 1x1 quad that fades from the colour at its top to the colour at its bottom; scaled to the size wanted
local mesh
local function gradientMesh(top, bottom)
    if not mesh then
        mesh = love.graphics.newMesh({{0, 0, 0, 0}, {1, 0, 1, 0}, {1, 1, 1, 1}, {0, 1, 0, 1}}, "fan", "stream")
    end
    mesh:setVertices({
        {0, 0, 0, 0, top[1], top[2], top[3], 1}, {1, 0, 1, 0, top[1], top[2], top[3], 1},
        {1, 1, 1, 1, bottom[1], bottom[2], bottom[3], 1}, {0, 1, 0, 1, bottom[1], bottom[2], bottom[3], 1},
    })
    return mesh
end

local function drawLogo(x, y, w, h, boxCol)
    if CustomLogo ~= nil then
        DrawCustomLogo(x, y, w, h, boxCol)
    else
        local image = gillMode and BBCSmallGill or BBCSmall
        local scale = w / image:getWidth()
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.draw(image, x, y + (h - image:getHeight() * scale) / 2, 0, scale, scale)
    end
end

--Colours of the strap right now
local function strapColours()
    local t, b, m = theme(), breakingColour(), S.strap.mix
    local body = {mix(t[1], b[1], m), mix(t[2], b[2], m), mix(t[3], b[3], m)}
    return body, mix(HEADER_DARK, 1, m), mix(BODY_FADE, 0, m)
end

--The clock box: the strap colour a little brighter, the strap colour itself on the BREAKING strap
local function clockColour()
    local t, b, m = theme(), breakingColour(), S.strap.mix
    return {mix(math.min(1, t[1] * 1.15), b[1], m), mix(math.min(1, t[2] * 1.15), b[2], m), mix(math.min(1, t[3] * 1.15), b[3], m), 1}
end

--Baselines measured on the video, from the top of the body; the text is drawn where the body is fully open
local function put(text, f, baseline, bodyTop, dy)
    love.graphics.setFont(f)
    love.graphics.print(text, L + 30, bodyTop + baseline - f:getBaseline() + (dy or 0))
end

local function drawHeader(y0, col, dark)
    local s = S.strap
    love.graphics.setColor(rgb(col, dark))
    love.graphics.rectangle("fill", L, y0, R - L, HEADER_H)

    drawLogo(L + 20, y0 + 12, 111, 32, col)
    local channel = Headline.BBCText.Text
    local f = font("ReithSansMd", 34)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setFont(f)
    local cx = L + 20 + 111 + 15
    love.graphics.print(channel, cx, y0 + (HEADER_H - f:getHeight()) / 2)

    --The white tag (box text, BREAKING) is wiped in from its right end
    if s.tag and s.tag ~= "" and s.tagP > 0.001 then
        local tf = font("ReithSansMd", 30)
        local w = tf:getWidth(s.tag) + 24
        local tx = cx + f:getWidth(channel) + 14
        love.graphics.setScissor(tx + w * (1 - s.tagP), y0, w * s.tagP + 1, HEADER_H)
            love.graphics.setColor(1, 1, 1, 1)
            love.graphics.rectangle("fill", tx, y0 + 5, w, HEADER_H - 10)
            love.graphics.setColor(rgb(col, 1))
            love.graphics.setFont(tf)
            love.graphics.print(s.tag, tx + 12, y0 + (HEADER_H - tf:getHeight()) / 2)
        love.graphics.setScissor()
    end
end

local function drawBody(bodyTop, col, fade)
    local s = S.strap
    local c = s.c
    --The body is a window on a strap that is fully open: its gradient and its text stay where they are
    love.graphics.setScissor(L, bodyTop + BODY_H - S.bodyH, R - L, S.bodyH)
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.draw(gradientMesh(rgb(col, 1), rgb(col, 1 - fade)), L, bodyTop, 0, R - L, BODY_H)
        if c then
            local maxW = R - L - 60
            local drift = s.drift
            love.graphics.setColor(1, 1, 1, s.alpha)
            if c.mode == "title" then
                --BREAKING rolls out behind the header, the headline fades in
                put(c.t1, font("ReithSansBd", 92), 106, bodyTop, -s.word * BODY_H)
                love.graphics.setColor(1, 1, 1, s.alpha * s.headline)
                put(c.t2, fit(c.t2, "ReithSerifMd", 58, 36, maxW), 100, bodyTop, drift)
            else
                local n = #c.lines
                if n == 1 then
                    put(c.lines[1], fit(c.lines[1], "ReithSansMd", 56, 36, maxW), 77, bodyTop, drift)
                elseif n == 2 then
                    --Name and job, or title and the line under it
                    put(c.lines[1], fit(c.lines[1], "ReithSansMd", 68, 36, maxW), 77, bodyTop, drift)
                    put(c.lines[2], font("ReithSansRg", 37), 128, bodyTop, drift)
                else
                    put(c.lines[1], fit(c.lines[1], "ReithSansMd", 56, 36, maxW), 64, bodyTop, drift)
                    put(c.lines[2], font("ReithSansRg", 34), 106, bodyTop, drift)
                    put(c.lines[3], font("ReithSansRg", 34), 146, bodyTop, drift)
                end
            end
        end
    love.graphics.setScissor()
end

local function drawBar(y)
    local clock = LowerThirdClock.ShowClock ~= false
    local textRight = clock and R - CLOCK_W - 10 or R - 20

    love.graphics.setColor(BAR_WHITE[1], BAR_WHITE[2], BAR_WHITE[3], LowerThirdFull.WhitePart.col[4])
    love.graphics.rectangle("fill", L, y, R - L, BAR_H)

    love.graphics.setScissor(L, y, textRight - L, BAR_H)
        --The small square and the text of the ticker move as the ticker engine says (Ticker.lua)
        local block, text = LowerThirdFull.TickerBlock, LowerThirdFull.TickerText
        love.graphics.setColor(rgb(theme(), 0.5, block.col[4]))
        love.graphics.rectangle("fill", L + 18, y + 20 + (block.y - 1005), 9, 9)

        love.graphics.setColor(text.col)
        local bold = text.Text == "HEADLINES" or text.Text == "INTERACTIVE"
        love.graphics.setFont(bold and TickerFontBold or TickerFont)
        if text.Text ~= nil then love.graphics.print(text.Text, L + 40, y + 3 + (text.y - 986)) end
    love.graphics.setScissor()

    if clock then
        love.graphics.setColor(clockColour())
        love.graphics.rectangle("fill", R - CLOCK_W, y, CLOCK_W, BAR_H)
        love.graphics.setColor(1, 1, 1, 1)
        local cf = font("ReithSansMd", 32)
        love.graphics.setFont(cf)
        love.graphics.printf(LowerThirdClock.text, R - CLOCK_W, y + (BAR_H - cf:getHeight()) / 2, CLOCK_W, "center")
    end
end

local function drawNewsBar()
    if S.off >= BAR_HIDDEN then return end
    local col, dark, fade = strapColours()
    local barY = BAR_TOP + S.off
    drawBar(barY)
    if S.bodyH > 0.5 then drawBody(barY - BODY_H, col, fade) end
    drawHeader(barY - S.bodyH - HEADER_H, col, dark)
end

local function drawBug(right)
    local bug = S.bug
    if bug.p <= 0.005 then return end
    local f = font("ReithSansMd", 30)
    local gap = 14
    local w = 28 + (bug.live and f:getWidth("LIVE") + gap or 0) + f:getWidth(bug.place)
    local time = bug.time and os.date("%H:%M", os.time() + bug.timeOffset) or nil
    if time then w = w + gap + f:getWidth(time) end
    local x = right and R - w or L
    local y, h = 80, 44

    --The box is a window that opens from (and closes to) its bottom edge
    love.graphics.setScissor(x, y + h * (1 - bug.p), w, h * bug.p)
        love.graphics.setColor(rgb(theme(), HEADER_DARK))
        love.graphics.rectangle("fill", x, y, w, h)
        love.graphics.setFont(f)
        local tx = x + 14
        local ty = y + (h - f:getHeight()) / 2
        if bug.live then
            love.graphics.setColor(0.36, 0.74, 0.96, 1)
            love.graphics.print("LIVE", tx, ty)
            tx = tx + f:getWidth("LIVE") + gap
        end
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.print(bug.place, tx, ty)
        if time then love.graphics.print(time, tx + f:getWidth(bug.place) + gap, ty) end
    love.graphics.setScissor()
end

local function drawHeadline()
    local h = S.headline
    if h.shade > 0.005 then
        --A darker bottom to read the headline
        love.graphics.setColor(0, 0, 0, h.shade * 0.6)
        love.graphics.draw(Fader, 0, 0, 0, 1.5, 1.5)
    end
    if h.text == "" then return end

    local tag = font("ReithSansMd", 34)
    local channel = Headline.BBCText.Text
    local w = 18 + 111 + 15 + tag:getWidth(channel) + 18
    local y = 789

    if h.tagP > 0.005 then
        love.graphics.setScissor(240, y, w * h.tagP, 48)
            love.graphics.setColor(rgb(theme(), HEADER_DARK))
            love.graphics.rectangle("fill", 240, y, w, 48)
            drawLogo(240 + 18, y + 8, 111, 32, theme())
            love.graphics.setColor(1, 1, 1, 1)
            love.graphics.setFont(tag)
            love.graphics.print(channel, 240 + 18 + 111 + 15, y + (48 - tag:getHeight()) / 2)
        love.graphics.setScissor()
    end

    --The headline rolls up from below its box (and out of it)
    local f = fit(h.text, "ReithSansMd", 92, 48, R - 240 - 40)
    love.graphics.setScissor(0, y + 54, 1920, 150)
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.setFont(f)
        love.graphics.print(h.text, 240, y + 60 + h.textY)
    love.graphics.setScissor()
end

function DrawElection24()
    update()
    drawHeadline()
    drawNewsBar()
    local side = S.bug.side or "left"
    if side == "right" or side == "both" then drawBug(true) end
    if side ~= "right" then drawBug(false) end
    love.graphics.setScissor()
end

--------------------------------------------------------------------------------------------------- the News Bar and the strap

local hideHeadline

local function showBar()
    if S.barUp then return end
    if S.headline.alpha > 0.5 then
        --The headline goes first, as in the classic graphics
        hideHeadline()
        after(0.6, showBar)
        return
    end
    S.barUp = true
    LowerThirdFull.LowerThirdShowing = true
    tween(S, "off", 0, 0.5, "cubicout")
    after(0.5, function()
        if not S.barUp then return end
        TickerI = 0
        StartTicker()
    end)
end

local function hideBar()
    if not S.barUp then return end
    S.barUp = false
    StopTicker()
    LowerThirdFull.LowerThirdShowing = false
    --A strap that is up closes first
    tween(S, "off", BAR_HIDDEN, 0.45, "cubicin", S.strap.kind and 0.45 or 0)
end

local function hideStrap()
    local s = S.strap
    if s.kind == nil then return end
    s.kind = nil
    s.gen = s.gen + 1
    local gen = s.gen
    tween(s, "alpha", 0, 0.15, "quadout")
    tween(s, "tagP", 0, 0.2, "quadout")
    tween(S, "bodyH", 0, 0.4, "cubicin", 0.1)
    tween(s, "mix", 0, 0.3, "linear", 0.3)
    after(0.55, function() if s.gen == gen then s.c, s.tag = nil, nil end end)
end

--What the strap says, and what it is: "text", "name" or "breaking" (content mode "lines" or "title")
local setStrap
setStrap = function(kind, content, tag)
    local s = S.strap
    if S.headline.alpha > 0.5 then
        hideHeadline()
        after(0.6, function() setStrap(kind, content, tag) end)
        return
    end
    s.gen = s.gen + 1
    local gen = s.gen
    local mixTo = kind == "breaking" and 1 or 0

    if s.kind == nil then
        --Opens: the body opens between header and bar, then the text fades in
        s.kind, s.c, s.tag, s.tagP = kind, content, tag, 0
        s.mix, s.alpha, s.drift, s.word, s.headline = mixTo, 0, 5, 0, content.mode == "title" and 0 or 1
        tween(S, "bodyH", BODY_H, 0.5, "cubicout")
        tween(s, "alpha", 1, 0.2, "cubicout", 0.3)
        tween(s, "drift", 0, 0.25, "cubicout", 0.3)
        if tag then tween(s, "tagP", 1, 0.35, "cubicout", 0.45) end
        return
    end

    --Changes: the text fades out, the colour changes, the new text fades in
    local colourChange = math.abs(s.mix - mixTo) > 0.01
    s.kind = kind
    tween(s, "alpha", 0, 0.18, "quadout")
    tween(s, "tagP", 0, 0.2, "quadout")
    if colourChange then tween(s, "mix", mixTo, 0.25, "linear", 0.06) end
    after(0.22, function()
        if s.gen ~= gen then return end
        s.c, s.tag = content, tag
        s.word, s.headline, s.drift = 0, content.mode == "title" and 0 or 1, 5
    end)
    --(a later tween of the same value would replace the fade out, so the way in is started when its time comes)
    local back = colourChange and 0.42 or 0.3
    after(back, function()
        if s.gen ~= gen then return end
        tween(s, "alpha", 1, 0.18, "cubicout")
        tween(s, "drift", 0, 0.25, "cubicout")
    end)
    if tag then
        after(back + 0.1, function()
            if s.gen == gen then tween(s, "tagP", 1, 0.35, "cubicout") end
        end)
    end
end

--BREAKING / headline: the word BREAKING rolls out and the headline comes in (and back)
local function advanceTitle()
    local s = S.strap
    local c = s.c
    if s.kind ~= "breaking" or not c or c.mode ~= "title" or not c.hasHeadline then return end
    if s.headline < 0.5 then
        s.drift = 5
        tween(s, "word", 1, 0.22, "cubicin")
        s.tag = "BREAKING"
        tween(s, "tagP", 1, 0.35, "cubicout", 0.38)
        tween(s, "headline", 1, 0.22, "cubicout", 0.52)
        tween(s, "drift", 0, 0.25, "cubicout", 0.52)
    else
        tween(s, "headline", 0, 0.18, "quadout")
        tween(s, "tagP", 0, 0.25, "quadout", 0.05)
        s.word = -1
        tween(s, "word", 0, 0.3, "cubicout", 0.3)
    end
end

--------------------------------------------------------------------------------------------------- bug and headline

local function setBug(data, withTime)
    local bug = S.bug
    local text = data.Text or ""
    bug.live = text:sub(1, 4) == "LIVE"
    bug.place = (bug.live and text:sub(5) or text):gsub("^%s+", "")
    bug.time = withTime
    bug.timeOffset = withTime and (data.Offset or 0) * 3600 or 0
    bug.side = data.Side or "left"
    tween(bug, "p", 1, 0.25, "cubicout")
end

local function showHeadline(text)
    local line = (text or ""):gsub("|", " "):match("^%s*(.-)%s*$")
    if line == "" then return end
    local h = S.headline
    h.gen = h.gen + 1
    local gen = h.gen

    local delay = 0
    if S.barUp or S.strap.kind then
        --The News Bar goes first, as in the classic graphics
        E24.request({Type = "HideLowerThird"})
        delay = 1.0
    elseif h.alpha > 0.5 then
        --Another headline is up: it rolls out first
        tween(h, "textY", -36, 0.12, "cubicin")
        tween(h, "tagP", 0, 0.15, "quadout")
        delay = 0.3
    end
    h.alpha = 1
    after(delay, function()
        if h.gen ~= gen then return end
        h.text, h.textY = line, 36
        tween(h, "textY", 0, 0.3, "cubicout")
        tween(h, "tagP", 1, 0.3, "cubicout", 0.12)
        tween(h, "shade", 1, 0.3, "cubicout")
    end)
end

hideHeadline = function()
    local h = S.headline
    h.gen = h.gen + 1
    h.alpha = 0
    tween(h, "textY", -36, 0.12, "cubicin")
    tween(h, "tagP", 0, 0.15, "quadout")
    tween(h, "shade", 0, 0.3, "quadout")
end

--------------------------------------------------------------------------------------------------- requests

local function lines(text)
    local list = {}
    for line in (text or ""):gmatch("[^\r\n]+") do
        if line:find("%S") then list[#list + 1] = line end
    end
    return list
end

--Answers the request and returns true, or returns false when the classic graphics must answer it
function E24.request(data)
    local t = data.Type

    if t == "ShowLowerThird" or t == "Show-TickerOnly" then showBar()
    elseif t == "HideLowerThird" or t == "Hide-TickerOnly" then
        hideStrap()
        hideBar()
    elseif t == "ToggleL3" then
        if S.barUp then
            hideStrap()
            hideBar()
        else
            showBar()
        end
    elseif t == "Show-Clock" then LowerThirdClock.ShowClock = true
    elseif t == "Hide-Clock" then LowerThirdClock.ShowClock = false

    elseif t == "Show-LowerThirdText" then
        local list = lines(data.Text)
        if #list == 0 then return true end
        for i = #list, 4, -1 do list[i] = nil end
        local tag = data.BoxText
        setStrap("text", {mode = "lines", lines = list}, tag ~= "" and tag or nil)
    elseif t == "Hide-LowerThirdText" or t == "Hide-BreakingLowerThird" or t == "Hide-PresenterName" then hideStrap()

    elseif t == "Show-PresenterName" then
        local list = lines(data.Text)
        if #list == 0 then return true end
        setStrap("name", {mode = "lines", lines = {list[1], list[2]}})

    elseif t == "Show-BreakingTitle" then
        local s = S.strap
        local headline = (data.Text or ""):gsub("^%s+", ""):gsub("%s+$", "")
        if s.kind == "breaking" and s.c and s.c.mode == "title" then
            --Strap already up: the headline changes (BREAKING stays or comes back)
            s.c.t2 = headline
            s.c.hasHeadline = headline ~= ""
            if s.headline > 0.5 and headline == "" then advanceTitle() end
        else
            setStrap("breaking", {mode = "title", t1 = "BREAKING", t2 = headline, hasHeadline = headline ~= ""}, nil)
        end
    elseif t == "Advance-BreakingTitle" then advanceTitle()
    elseif t == "Show-BreakingLowerThird" then
        local list = lines(data.Text)
        if #list == 0 then return true end
        for i = #list, 4, -1 do list[i] = nil end
        setStrap("breaking", {mode = "lines", lines = list}, "BREAKING")

    elseif t == "Show-PlaceName" then setBug(data, false)
    elseif t == "Show-PlaceNameWithTime" then setBug(data, true)
    elseif t == "Hide-PlaceName" then tween(S.bug, "p", 0, 0.25, "cubicin")

    elseif t == "Show-Headline" or t == "Next-Headline" or t == "Show-Headline-KeepText" then
        if data.Regional == true then return false end
        local text = data.Text
        if t == "Show-Headline-KeepText" then text = KeepBottomText else KeepBottomText = text end
        showHeadline(text)
    elseif t == "Hide-Headline" then
        if data.Regional == true then return false end
        hideHeadline()
    else
        return false
    end
    return true
end

--Called by Set-Branding with Style = "election24" or anything else (the classic graphics)
function E24.setActive(active)
    if E24.Active == active then return end
    E24.Active = active

    --Nothing of the other look stays on screen (StopTicker clears every timer, so only when a ticker is running)
    if TickerRunning then StopTicker() end
    HideLowerThirdFullInstant()
    HidePlaceNameInstant()
    HideHeadlineInstant()
    HideLowerThirdClockInstant()
    LowerThirdClockShowing = false

    tweens, timers = {}, {}
    S.off, S.barUp, S.bodyH = BAR_HIDDEN, false, 0
    S.strap.kind, S.strap.c, S.strap.tag, S.strap.mix = nil, nil, nil, 0
    S.bug.p = 0
    S.headline.text, S.headline.alpha, S.headline.shade, S.headline.tagP = "", 0, 0, 0
    LowerThirdFull.LowerThirdShowing = false
    LowerThirdFullShowing = false
end
