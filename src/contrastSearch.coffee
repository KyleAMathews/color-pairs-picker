chroma = require 'chroma-js'
debug = require('debug')('color-pairs-picker-binary-search-contrast')

counter = 0

module.exports = contrastSearch = (baseColor, compareColor, start, end, direction="end", contrast=5.5) ->
  counter += 1
  #console.log "\n"
  #console.log "new recurse"

  middle = (start + end) / 2

  #console.log baseColor, start, end, middle, direction

  # Create new middle color.
  b = chroma.lab(baseColor)
  color = b.luminance(middle).lab()
  #console.log color

  # Calculate contrast.
  curContrast = chroma.contrast(chroma.lab(compareColor).hex(), b)
  #console.log "contrast", curContrast

  if counter > 15
    #console.log "too many cycles!!!", counter
    counter = 0
    return color

  # Found!
  if (contrast - 0.1) < curContrast and curContrast < (contrast + 0.1)
    #console.log "found!"
    counter = 0
    return color

  # Contrast is too high
  if curContrast > contrast
    #console.log "too high"
    if direction is "end"
      contrastSearch(baseColor, compareColor, start, middle-0.001, direction, contrast)
    else
      contrastSearch(baseColor, compareColor, middle+0.001, end, direction, contrast)
  else if curContrast < contrast
    #console.log "too low"
    if direction is "start"
      contrastSearch(baseColor, compareColor, start, middle-0.001, direction, contrast)
    else
      contrastSearch(baseColor, compareColor, middle+0.001, end, direction, contrast)

#color = 'purple'
#console.log "the perfect contrast:", contrastSearch(color, 0, .97, "light")
#console.log "recursions:", counter
