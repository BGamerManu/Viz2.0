--The logo in the BBC boxes can be replaced by an SVG picked in VizHelper (it arrives as a PNG, VizHelper draws the SVG)
--and the BREAKING graphics can have an accent colour of their own. Both come with Set-Branding.

--nil = the BBC logo. Otherwise {png = the received string, color = Image, mask = Image (white, alpha only), mode, col}
CustomLogo = nil

--nil = the red of the branding as it always was
BreakingColor = nil

--Colour table of the BREAKING graphics with the given alpha; default is the colour used when nothing is set
function BreakingCol(a, default)
    local c = BreakingColor or default or {184/255, 0, 0}
    return {c[1], c[2], c[3], a}
end

--mode: "original" (colours of the SVG), "colour" (one colour, col) or "auto" (black or white, whichever reads on the box)
function SetBrandLogo(png, mode, col)
    if png == nil or png == "" then
        CustomLogo = nil
        return
    end
    if CustomLogo ~= nil and CustomLogo.png == png then
        CustomLogo.mode, CustomLogo.col = mode or "auto", col or {1, 1, 1}
        return
    end

    local ok, data = pcall(function() return love.image.newImageData(love.filesystem.newFileData(png, "logo.png")) end)
    if not ok then
        print("Custom logo not loaded: "..tostring(data))
        CustomLogo = nil
        return
    end

    local mask = data:clone()
    mask:mapPixel(function(x, y, r, g, b, a) return 1, 1, 1, a end)
    local color, maskImage = love.graphics.newImage(data, {mipmaps = true}), love.graphics.newImage(mask, {mipmaps = true})
    for _, image in ipairs({color, maskImage}) do
        image:setFilter("linear", "linear")
        image:setMipmapFilter("linear")
    end

    CustomLogo = {png = png, color = color, mask = maskImage, mode = mode or "auto", col = col or {1, 1, 1}}

    --The titles are BBC graphics: they do not go with another logo
    if TitleLogo ~= nil and TitleLogo.Showing then HideTitleLogo() end
end

--Draws the custom logo inside the x, y, w, h slot of the BBC logo; boxCol is the colour behind it (for "auto")
function DrawCustomLogo(x, y, w, h, boxCol)
    local logo = CustomLogo
    local image, tint = logo.mask, logo.col
    if logo.mode == "original" then
        image, tint = logo.color, {1, 1, 1}
    elseif logo.mode == "auto" then
        local luma = 0.2126 * boxCol[1] + 0.7152 * boxCol[2] + 0.0722 * boxCol[3]
        tint = luma > 0.6 and {0.1, 0.1, 0.1} or {1, 1, 1}
    end

    local iw, ih = image:getDimensions()
    local scale = math.min(w / iw, h / ih)
    love.graphics.setColor(tint[1], tint[2], tint[3], 1)
    love.graphics.draw(image, x + (w - iw * scale) / 2, y + (h - ih * scale) / 2, 0, scale, scale)
end
