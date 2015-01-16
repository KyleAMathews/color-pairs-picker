chroma = require 'chroma-js'
debug = require('debug')('color-pairs-picker')
objectAssign = require 'object-assign'

module.exports = (bg, options) ->
  options = objectAssign({
    contrast: 5
    foregroundMax: 0.98
    foregroundMin: 0.02
    backgroundMax: 0.85
    backgroundMin: 0.15
  }, options)

  bg = chroma(bg, 'lab')
  fg = chroma(bg, 'lab')

  debug "Passed in color's luminance:", bg.luminance()
  debug "Passed in color is", if bg.luminance() > 0.5 then "light" else "dark"

  # If the bg color is in the lighter side of the spectrum
  if bg.luminance() > 0.5
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
      scaler = (options.contrast - contrast)/(options.contrast + 1)
      debug "scaler:", scaler

      # Constraints:
      # Avoid making fg text completely white
      # as well as loosing all color to blackness in the background.
      if fg.luminance() > options.foregroundMin
        fg = fg.darken(10 * scaler)
      if bg.luminance() < options.backgroundMax
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
      scaler = (options.contrast - contrast)/(options.contrast + 1)
      debug "scaler:", scaler

      if fg.luminance() < options.foregroundMax
        fg = fg.brighten(10 * scaler)
      # If the background drops below .15 (our default) luminance,
      # it becomes hard to see against a white page background.
      if bg.luminance() > options.backgroundMin
        bg = bg.darken(5 * scaler)
      else
        bg = bg.brighten(5 * scaler)

      debug "fg luminance:", fg.luminance()
      debug "bg luminance:", bg.luminance()
      debug "contrast level:", chroma.contrast(bg, fg)

  return {bg: bg.hex(), fg: fg.hex()}
