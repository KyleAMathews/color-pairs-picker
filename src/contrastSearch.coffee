chroma = require 'chroma-js'
#debug = require('debug')('color-pairs-picker-binary-search-contrast')

counter = 0

module.exports = contrastSearch = (targetColor, compareColor=targetColor, start=0, end=1, direction="end", contrast=5) ->
  counter += 1
  #console.log "\n"
  #console.log "new recurse"

  middle = (start + end) / 2

  #console.log targetColor, compareColor, start, end, middle, direction

  # Create new middle color.
  b = chroma(targetColor, 'lab')
  #console.log b.luminance(middle).css()
  color = b.luminance(middle).lab()
  #console.log "color", color
  #console.log chroma(color).css()

  # Calculate contrast.
  curContrast = chroma.contrast(chroma(compareColor).css(), b.css())
  #console.log "contrast", curContrast

  if counter > 15
    #console.log "too many cycles!!!", counter
    counter = 0
    #return color
    return color

  # Found!
  if (contrast - 0.1) < curContrast and curContrast < (contrast + 0.1)
    #console.log "found!"
    #console.log 'cycles', counter
    counter = 0
    return color

  # Contrast is too high
  if curContrast > contrast
    #console.log "too high"
    if direction is "end"
      contrastSearch(targetColor, compareColor, start, middle-0.001, direction, contrast)
    else
      contrastSearch(targetColor, compareColor, middle+0.001, end, direction, contrast)
  else if curContrast < contrast
    #console.log "too low"
    if direction is "start"
      contrastSearch(targetColor, compareColor, start, middle-0.001, direction, contrast)
    else
      contrastSearch(targetColor, compareColor, middle+0.001, end, direction, contrast)

color = 'rgb(8, 27, 44)'
targetColor = 'rgb(124, 171, 217)'
color = 'red'
targetColor = 'red'
#console.log "the perfect contrast:", contrastSearch(targetColor, color, 0, .97, "end", 4.5)
