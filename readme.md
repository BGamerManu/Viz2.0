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

## License

Viz2.0 is licensed under the [GNU General Public License v3.0](LICENSE).
