# Viz2.0

## Installation

Go to releases and download the latest version.
There's zipped versions for windows.
If you're on linux/mac use the .love version (You'll need to install [LÖVE](https://love2d.org/)).

## Usage

Use with [VizHelper](https://github.com/playsamay4/VizHelper)

## Changes in this fork

Fork of [playsamay4/Viz2.0](https://github.com/playsamay4/Viz2.0). Use it with the matching fork of VizHelper, which has the controls for these.

- **LIVE bug on the right.** `Show-PlaceName` / `Show-PlaceNameWithTime` take an optional `Side` (`"left"`, the default, or `"right"`). The right hand bug is the mirror image of the left one, anchored to the right margin: `[time] [place | LIVE]`.
- **Single line BREAKING strap.** `Show-BreakingLowerThird` only needs the top line. Leave the subtitles out (`"Top line"`, or `"Top line\n\n"` from the helper) and the strap shows one big headline next to the BREAKING box. With a subtitle it is the usual two line strap.
- **Change the BREAKING text without taking the strap down.** Sending `Show-BreakingLowerThird` or `Show-BreakingTitle` again while the strap is up swaps the text in place: the old text rolls out of the top while the new one rolls in. This also works across layouts (one line, two lines, BREAKING / headline). If BREAKING is on screen when the headline of `Show-BreakingTitle` is changed, the new headline waits for the next `Advance-BreakingTitle`.
- **No white ticker needed for straps.** The one line text strap (`Show-LowerThirdText` without subtitles) and the breaking strap come up on their own when the ticker is down, and sink out of sight when hidden (before, the one line strap raised the whole News Bar and a hidden breaking strap left the NEWS bar behind). If the News Bar is raised while a strap is up, only the ticker comes in.
- Updating a one line text strap twice no longer crashes.
- **BREAKING headline is optional.** `Show-BreakingTitle` with an empty `Text` shows just BREAKING; `Advance-BreakingTitle` has nothing to scroll to and does nothing. Sending a headline later is staged for the next scroll, and sending an empty one while the headline is on screen brings BREAKING back.
- **Headlines are one line.** The two line headline (`Top|Bottom`) is gone: a `|` is just a space. A headline that is too wide for the screen shrinks to fit (down to 56px, about 55 characters at that size). The red BBC NEWS box in front of the headline is retired too; set `HeadlineBBCBox = true` in `Headlines.lua` to bring it back (the `COMING UP` label still works).
- **Titles.** `Show-TitleLogo` takes an optional `Style`: `"chameleon"` (the BBC blocks with the channel name from the branding under them, the `=` key) or nothing / `"legacy"` for the red boxed BBC NEWS logo. Both go through the same rules: the headline and the News Bar leave before a title comes in and the other way round, and a title of one style leaves before the other style comes in.
- **Keyboard-only features have requests now**, for VizHelper's Testing area: `Show-TickerOnly` / `Hide-TickerOnly` (Numpad 1/2), `Show-Clock` (9), `Toggle-Backdrop` (Numpad *), `Toggle-GillMode` (G), `Hide-Splash` (N), `Toggle-WindowMode` (F11). `Wipe` (Space) and the breakfast clock (`;` and `\`) already had one.
- **Badges.** After a two line BREAKING strap with a badge up, the programme badge stayed behind at the old height and then every badge (programme, socials, credit) was clipped out of sight. The badge now goes back down with the strap and always comes in on the row its clip window is on. The programme badge was also re-shown with the text and colours of the last info badge (a thin line instead of a box), and an info badge could be left as a full box after the ticker stopped; both are fixed.

## License

Viz2.0 is licensed under the [GNU General Public License v3.0](LICENSE).
