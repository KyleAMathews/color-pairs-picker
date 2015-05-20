chroma = require 'chroma-js'
#debug = require('debug')('color-pairs-picker')
objectAssign = require 'object-assign'
contrastSearch = require './contrastSearch'
isObject = require 'is-object'

module.exports = (color, targetColor, options={}) ->
  unless targetColor?
    targetColor = color

  if isObject(targetColor)
    options = targetColor
    targetColor = color

  options = objectAssign({
    colorIsBackground: true
    contrast: 5
    foregroundMax: 0.98
    foregroundMin: 0.02
    backgroundMax: 0.85
    backgroundMin: 0.15
    direction: undefined
  }, options)

  # Get start/end
  if options.colorIsBackground
    start = options.foregroundMin
    end = options.foregroundMax
  else
    start = options.backgroundMin
    end = options.backgroundMax

  #console.log "start,end", start,end
  #console.log "luminance of base color is:", chroma(color, 'lab').luminance()
  # Decide which direction to go.
  if options.direction?
    secondColor = contrastSearch(targetColor, color, start, end, options.direction, options.contrast)
  else
    # Decide which direction to search for the second color.
    endColor = chroma(targetColor, 'lab').luminance(end)
    startColor = chroma(targetColor, 'lab').luminance(start)
    #console.log startColor, endColor
    contrastToStart = chroma.contrast(color, startColor.hex())
    #console.log "contrast to start", contrastToStart
    contrastToEnd = chroma.contrast(color, endColor.hex())
    #console.log "contrast to end"

    if contrastToEnd > options.contrast
      #console.log "Finding second color in direction of end"
      secondColor = contrastSearch(targetColor, color, start, end, 'end', options.contrast)
    else if contrastToStart > options.contrast
      #console.log "Finding second color in direction of start"
      secondColor = contrastSearch(targetColor, color, start, end, 'start', options.contrast)
    else
      #console.log "contrast isn't high enough, modifying base color now from direction
      #of highest contrast endpoint"
      # We can't get the second color to the proper contrast without modifying
      # the base color. So we'll chose the endpoint with the highest contrast
      # and make that the new base color.

      # Start and end are now based on either the foreground if a background
      # color was passed in or vise versa.
      if options.colorIsBackground
        newStart = options.backgroundMin
        newEnd = options.backgroundMax
      else
        newStart = options.foregroundMin
        newEnd = options.foregroundMax

      if contrastToEnd > contrastToStart
        secondColor = chroma(targetColor, 'lab').luminance(end)
        #console.log "contrast to end is highest. new second color is", secondColor

        highestPossibleContrast = chroma.contrast(secondColor.hex(), chroma(color, 'lab').luminance(newStart))
        #console.log 'possible contrast', highestPossibleContrast
        if highestPossibleContrast > options.contrast
          color = contrastSearch(color, secondColor.lab(), newStart, newEnd, 'start', options.contrast)
        else
          color = chroma(color, 'lab').luminance(newStart).lab()

        secondColor = secondColor.lab()
      else
        secondColor = chroma(color, 'lab').luminance(start)
        #console.log "contrast to start is highest. new second color is", secondColor

        highestPossibleContrast = chroma.contrast(secondColor.hex(), chroma(color, 'lab').luminance(newEnd))
        #console.log 'possible contrast', highestPossibleContrast
        if highestPossibleContrast > options.contrast
          color = contrastSearch(color, secondColor.hex(), newStart, newEnd, 'end', options.contrast)
        else
          color = chroma(color, 'lab').luminance(newEnd).lab()

        secondColor = secondColor.lab()

  #console.log color, secondColor

  if options.colorIsBackground
    bg = color
    fg = secondColor
  else
    bg = secondColor
    fg = color



  return {bg: chroma.lab(bg).hex(), fg: chroma.lab(fg).hex()}
