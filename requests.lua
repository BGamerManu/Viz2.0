

server:on("connect", function(data)
    print("viz Connected")  
    Timer.tween(0.8, waterMarkFade, {a = 0}, "in-out-cubic", function()
        waterMark = false
    end)
end)

server:on("disconnect", function(data)
    print("viz Disconnected")
    Timer.tween(0.8, waterMarkFade, {a = 1}, "in-out-cubic", function()
        waterMark = true
    end)
end)

server:on("headline", function(data)
    if data.Type == "Show-Headline" then
        if data.Regional == nil then
            PlayoutShowHeadline(data.Text, data.Style)
            KeepBottomText = data.Text
        else
            if data.Regional == false then
                PlayoutShowHeadline(data.Text, data.Style)
                KeepBottomText = data.Text
            else 
                ShowShitHeadlines(data.Text)
            end
        end

    end

    if data.Type == "Next-Headline" then
        
        PlayoutNextHeadline(data.Text)
        KeepBottomText = data.Text
    end

    if data.Type == "Hide-Headline" then 
        if data.Regional == nil then
            HideHeadline()
        else
            if data.Regional == false then
                HideHeadline()
            else 
                RemoveShitHeadline()
            end
        end

        
    end

    if data.Type == "Show-Headline-KeepText" then
        PlayoutShowHeadline(KeepBottomText)
    end


    if data.Type == "Show-TitleLogo" then
        ShowTitleLogo(data.Style)
    end

    if data.Type == "Hide-TitleLogo" then
        HideTitleLogo()
    end

    if data.Type == "Show-TitleLogoInstant" then
        ShowTitleLogoInstant()
    end
	
	if data.Type == "Hide-TitleLogoInstant" then
		HideTitleLogoInstant()
	end

    if data.Type == "ShowLowerThird" then
        ShowLowerThirdFull()
    end

    if data.Type == "HideLowerThird" then
        HideLowerThirdFull()
    end

    if data.Type == "Show-PlaceName" then
        ShowPlaceName(data.Text, data.Side)
    end

    if data.Type == "Show-PlaceNameWithTime" then
        ShowPlaceNameWithTime(data.Text, data.Offset, data.Side)
    end

    if data.Type == "Hide-PlaceName" then
        HidePlaceName()
    end

    if data.Type == "Show-PresenterName" then
        LowerThirdFull.PresenterName.Text = data.Text
        ShowPresenterName()
    end

    if data.Type == "Hide-PresenterName" then
        HidePresenterName()
    end

    if data.Type == "Show-BreakfastIntroClock" then
        ShowBreakfastIntroClock()
    end

    if data.Type == "Hide-BreakfastIntroClock" then
        HideBreakfastIntroClock()
    end

    if data.Type == "Flash" then
        Flash()
    end

    if data.Type == "Wipe" then
        ShowTransition()
    end

    if data.Type == "Set-ProgramBadge" then
        if LowerThirdFull.ProgramBadgeShowing == true then 
            
            HideProgramBadge()
            Timer.after(0.5, function()
                SetProgramBadge(data.Text, data.TextColor, data.BackgroundColor)
                ShowProgramBadge(data.Text, LowerThirdFull.ProgramBadge.tcol, LowerThirdFull.ProgramBadge.bcol)
            end)
            return
        end

        
        SetProgramBadge(data.Text, data.TextColor, data.BackgroundColor)
    end

    if data.Type == "Show-ProgramBadge" then
        ShowProgramBadge(data.Text, stringToTable(data.TextColor), stringToTable(data.BackgroundColor))
    end

    if data.Type == "Hide-ProgramBadge" then
        HideProgramBadge()
    end

    if data.Type == "Hide-Clock" then
        HideLowerThirdClock()
    end

    if data.Type == "Show-Clock" then
        ShowLowerThirdClock()
    end

    if data.Type == "Show-TickerOnly" then
        ShowTickerOnly()
    end

    if data.Type == "Hide-TickerOnly" then
        HideTickerOnly()
    end

    if data.Type == "Toggle-Backdrop" then
        ToggleBackdrop()
    end

    if data.Type == "Toggle-GillMode" then
        ToggleGillMode()
    end

    if data.Type == "Hide-Splash" then
        HideSplash()
    end

    if data.Type == "Toggle-WindowMode" then
        ToggleWindowMode()
    end

    if data.Type == "Remove-ProgramBadge" then
        RemoveProgramBadge()
    end


    if data.Type == "Load-AVPlayout" then
        LoadAVPlayout(data.vid, data.aud, data.freeze)
    end

    if data.Type == "Play-AV" then
        PlayAV()
    end

    if data.Type == "Set-HeadlineBong" then
        SetHeadlineBong(data.aud)
    end

    if data.Type == "Play-HeadlineBong" then
        PlayHeadlineBong()
    end

    if data.Type == "Stop-HeadlineBong" then
        StopHeadlineBong()
    end

    if data.Type == "FadeOut-HeadlineBong" then
        FadeOutHeadlineBong()
    end





    if data.Type == "Set-Branding" then
        Headline.LeftBarPurple.col = data.ThemeColor 
        Headline.BBCBox.col = data.ThemeColor
        LowerThirdFull.BBCBox.col = data.ThemeColor

        LowerThirdFull.BBCText.Text = data.channelName
        Headline.BBCText.Text = data.channelName

        if data.opaque == true then
            LowerThirdFull.WhitePart.col = {254/255, 251/255, 254/255, 1}
        else
            LowerThirdFull.WhitePart.col = {254/255, 251/255, 254/255, 0.85}
        end

        if data.coloredStrap == true then
            LowerThirdFull.ClearPart.col = data.ThemeColor
            LowerThirdFull.BreakingBox.col = {255/255,0,0,1}
        else
            LowerThirdFull.ClearPart.col = {0,0,0,0.8}
            LowerThirdFull.BreakingBox.col = {0.72,0,0,1}
        end

        --Find any occurence of the word "World" in the channel name
        if string.find(string.lower(data.channelName), "world") then
            TitleLogo.image = worldTitle
        else
            TitleLogo.image = newsTitle
        end

        if gillMode == true then
            if TitleLogo.image == newsTitle then
                TitleLogo.image = newsTitleGill
            elseif TitleLogo.image == worldTitle then
                TitleLogo.image = worldTitleGill
            end
        else
            if TitleLogo.image == newsTitleGill then
                TitleLogo.image = newsTitle
            elseif TitleLogo.image == worldTitleGill then
                TitleLogo.image = worldTitle
            end
        end

        if data.clockMode == "default" or data.clockMode == "breakfast" then 
            LowerThirdClock.ShowClock = true
            if LowerThirdFullShowing == true then
                ShowLowerThirdClock()
            end
        elseif data.clockMode == "off" then
            HideLowerThirdClock()
            LowerThirdClock.ShowClock = false
        end
    end


    if data.Type == "SetStyle" then
        if data.Style == "Channel" then
            Headline.LeftBarPurple.col = ThemeColor 
            Headline.BBCBox.col = ThemeColor
            LowerThirdFull.BBCBox.col = ThemeColor

            LowerThirdFull.BBCText.Text = "NEWS"
            Headline.BBCText.Text = "NEWS"

            TitleLogo.image = newsTitle

            LowerThirdClock.ShowClock = true
            
            RemoveProgramBadge()

            if LowerThirdFullShowing == true then
                ShowLowerThirdClock()
            end
        elseif data.Style == "World" then
            Headline.LeftBarPurple.col = ThemeColor 
            Headline.BBCBox.col = ThemeColor
            LowerThirdFull.BBCBox.col = ThemeColor

            LowerThirdFull.BBCText.Text = "WORLD NEWS"
            Headline.BBCText.Text = "WORLD NEWS"

            TitleLogo.image = worldTitle

            HideLowerThirdClock()
            LowerThirdClock.ShowClock = false

            RemoveProgramBadge()
        elseif data.Style == "Breakfast" then
            Headline.LeftBarPurple.col = {0.95,0.3,0}
            Headline.BBCBox.col = {0.95,0.3,0}
            LowerThirdFull.BBCBox.col = {0.95,0.3,0}

            LowerThirdFull.BBCText.Text = "BREAKFAST"
            Headline.BBCText.Text = "BREAKFAST"

            TitleLogo.image = newsTitle

            LowerThirdClock.ShowClock = true

            RemoveProgramBadge()
        end
    end
    
    if data.Type == "Show-BreakingTitle" then
        ShowBreakingTitle(data.Text)
    end

    if data.Type == "Advance-BreakingTitle" then
        AdvanceBreakingTitle()
    end

    if data.Type == "Show-BreakingLowerThird" then
        --Split the text into a table by new line
        local split = {}
        for match in (data.Text):gmatch("[^\r\n]+") do
            table.insert(split, match)
        end

        --Remove first item from table and put it in a var
        local first = table.remove(split, 1)
        if first == nil then return end

        --Shows the strap, or changes its text if it is already up (one line or two lines)
        ShowBreakingLowerThird(first, split)
    end

    if data.Type == "Hide-BreakingLowerThird" then
        HideBreakingLowerThird()
    end

    if data.Type == "BulletinSetup" then
        --Setup the Bulletin
        
        --TODO: Badge
        print(inspect(data))



        if data.StrapColor == "def" then 
            Headline.LeftBarPurple.col = ThemeColor 
            Headline.BBCBox.col = ThemeColor
            LowerThirdFull.BBCBox.col = ThemeColor
        else 
            Headline.LeftBarPurple.col = data.StrapColor 
            Headline.BBCBox.col = data.StrapColor
            LowerThirdFull.BBCBox.col = data.StrapColor
        end
        
        if data.L3Text == "def" then
            LowerThirdFull.BBCText.Text = "NEWS"
            Headline.BBCText.Text = "NEWS"
        else
            LowerThirdFull.BBCText.Text = data.L3Text
            Headline.BBCText.Text = data.L3Text
        end

        if data.TransitionColor == "def" then
            Transition.col = ThemeColor
        else
            Transition.col = data.TransitionColor
        end

        if data.TitleLogo == "def" then
            TitleLogo.image = newsTitle
        elseif string.lower(data.TitleLogo) == "news" then
            TitleLogo.image = newsTitle
        elseif string.lower(data.TitleLogo) == "world" then
            TitleLogo.image = worldTitle
        else
            TitleLogo.image = newsTitle
        end

        if data.L3ShowClock == "def" then
            LowerThirdClock.ShowClock = true
        elseif string.lower(data.L3ShowClock) == "true" then
            LowerThirdClock.ShowClock = true
        elseif string.lower(data.L3ShowClock) == "false" then
            LowerThirdClock.ShowClock = false
        else
            LowerThirdClock.ShowClock = true
        end

    end

    if data.Type == "Show-CreditBadge" then
        ShowCreditBadge(data.Text)
    end

    if data.Type == "Hide-CreditBadge" then
        HideInfoBadge()
    end

    if data.Type == "Show-SocialsBadge" then
        ShowInfoBadge(data.Text)
    end

    if data.Type == "Hide-SocialsBadge" then
        HideInfoBadge()
    end

    if data.Type == "Show-LowerThirdText" then
        --Split the text into a table by new line
        local split = {}
        for match in (data.Text):gmatch("[^\r\n]+") do
            table.insert(split, match)
        end

        --Remove first item from table and put it in a var
        local first = table.remove(split, 1)

        --The text strap is up: change its text in place, from one line to two lines and back too
        if LowerThirdFull.LowerThirdTitleShowing == true then
            UpdateTextStrap(first, split)
            return
        end
        
        if data.BoxText == "" then data.BoxText = nil end
        

        ShowLowerThirdText(first, split, data.BoxText,{60/255, 60/255, 60/255, 1}, {1,1,1,1} )
    end
    

    if data.Type == "Hide-LowerThirdText" then
        HideLowerThirdText()
    end



    if data.Type == "ToggleL3" then
        if LowerThirdFull.LowerThirdShowing == true then
            HideLowerThirdFull()
        else
            ShowLowerThirdFull()
        end
    end

    if data.Type == "KillTicker" then
        KillTicker(data.Text)
    end

    if data.Type == "ResumeTicker" then
        ResumeTicker()
    end


    if data.Type == "GetTickerText" then
        --Decode the text
        --Firstly lets split the text into a table by new line
        local split = {}
        local myString = data.Text
        for line in myString:gmatch("%s*([^\n]+)\n?") do
            table.insert(split, line)
        end

        local tickerText = {
            {mode = "Head", text = data.DefaultText, duration = 1},
        }

        for i, v in ipairs(split) do
            --Take first 3 chars
            local firstThree = v:sub(1,3)
            if firstThree == "!h " then
                --This is a headline
                local headline = v:sub(4)
                table.insert(tickerText, {mode = "Normal", text = headline, duration = 5})
            elseif firstThree == "!i " then
                local interactive = v:sub(4)
                table.insert(tickerText, {mode = "Normal", text = interactive, duration = 4})
            elseif firstThree == "!b " then
                local breaking = v:sub(4)
                table.insert(tickerText, {mode = "Breaking", text = breaking, duration = 5})
            elseif firstThree == "!bb" then
                --Breaking head 
                table.insert(tickerText, {mode = "BreakingHead", text = "BREAKING", duration = 3})
            elseif firstThree == "!hh" then
                --Headline head
                table.insert(tickerText, {mode = "Head", text = "HEADLINES", duration = 3})
            elseif firstThree == "!ii" then
                --Interactive head
                table.insert(tickerText, {mode = "BlueHead", text = "INTERACTIVE", duration = 3})
            end
        end
        --Send the ticker text to the ticker
        TickerSequence = tickerText

    end

    if data.Type == "GetTickerTextTable" then
        local tickerText = {
            {mode = "Head", text = data.DefaultText, duration = 1},
            {mode = "Head", text = "HEADLINES", duration = 3}
        }

        local limit = data.Limit

        for i,v in ipairs(data.Text) do
            if limit ~= 0 and i > limit then break end
            table.insert(tickerText, {mode = "Normal", text = v, duration = 5})
        end

        TickerSequence = tickerText
    end

end)



function convertTableToCondensedString(tbl)
    local str = ""
    for i, num in ipairs(tbl) do
        str = str .. string.format("%.1f", num)
        if i < #tbl then
            str = str .. "/"
        end
    end
    return str
end