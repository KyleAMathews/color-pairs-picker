chroma = require 'chroma-js'
debug = require('debug')('color-pairs-picker')
objectAssign = require 'object-assign'

module.exports = (bg, options) ->
  options = objectAssign({
    contrast: 5.5
  }, options)

  debug "Passed in color's luminance:", chroma(bg).luminance()
  debug "Passed in color is", if chroma(bg).luminance() > 0.5 then "light" else "dark"

  bg = chroma(bg)
  fg = chroma(bg)

  # If the bg color is in the lighter side of the spectrum
  if chroma(bg).luminance() > 0.5
    # Bg is dark so immediately brighten the fg to kick things off.
    fg = fg.darken(25)
    cycleCount = 0

    # There should be at least a contrast of 4.5 to ensure readability.
    # 5.5 seems like a particularly pleasing place to stop.
    while chroma.contrast(bg, fg) < options.contrast
      # Prevent infinite loops if can't get our desired contrast.
      cycleCount += 1
      if cycleCount > 30 then break

      debug ""
      debug "cycle:", cycleCount

      # Measure contrast. The closer we get to our desired contrast, the slower
      # we should change to avoid osscilating back and forth over our
      # desired constraints.
      contrast = chroma.contrast(bg, fg)
      scaler = (6-contrast)/7
      debug "scaler:", scaler

      # Constraints:
      # Avoid making fg text completely white
      # as well as loosing all color to blackness in the background.
      if fg.luminance() > 0.02
        fg = fg.darken(10 * scaler)
      if bg.luminance() < 0.85
        bg = bg.brighten(5 * scaler)
      else
        bg = bg.darken(5 * scaler)

      debug "fg luminance:", fg.luminance()
      debug "bg luminance:", bg.luminance()
      debug "contrast level:", chroma.contrast(bg, fg)

  # bg color is on darker side of spectrum
  else
    fg = fg.brighten(25)
    cycleCount = 0
    while chroma.contrast(bg, fg) < options.contrast
      cycleCount += 1
      if cycleCount > 30 then break

      debug ""
      debug "cycle:", cycleCount

      contrast = chroma.contrast(bg, fg)
      scaler = (6-contrast)/7
      debug "scaler:", scaler

      if fg.luminance() < 0.98
        fg = fg.brighten(10 * scaler)
      # If the background drops below .15 luminance, it becomes hard to see
      # against a white page background.
      if bg.luminance() > 0.15
        bg = bg.darken(5 * scaler)
      else
        bg = bg.brighten(5 * scaler)

      debug "fg luminance:", fg.luminance()
      debug "bg luminance:", bg.luminance()
      debug "contrast level:", chroma.contrast(bg, fg)

  return {bg: bg.hex(), fg: fg.hex()}
