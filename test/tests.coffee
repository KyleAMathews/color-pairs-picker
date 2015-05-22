chai = require 'chai'
expect = chai.expect
_ = require 'underscore'
chroma = require 'chroma-js'

colorPicker = require '../src/'
contrastSearch = require '../src/contrastSearch'

describe 'contrastSearch', ->
  it 'should exist', ->
    expect(contrastSearch).to.exist

  it 'should return a lab value', ->
    expect(contrastSearch('blue')).to.be.array
    expect(contrastSearch('blue').length).to.equal(3)

  it 'should return color with contrast that is within 0.1 of what is requested', ->
    color = "blue"
    result = chroma.lab(contrastSearch(color))
    contrast = chroma.contrast(result, chroma(color))
    expect(4.9 <= contrast <= 5.1).to.be.true

  it 'should return results for impossibly high contrast', ->
    result = chroma.lab(contrastSearch('black', 'black', 0, 1, 'end', 100))
    expect(result.css()).to.exist

describe 'color pairs picker', ->
  it 'should exist', ->
    expect(colorPicker).to.exist

  it 'should return an object', ->
    expect(colorPicker('blue')).to.be.object

  it 'should work when asking for low contrast between colors', ->
    color = "blue"
    result = colorPicker(color, contrast: 3)
    contrast = chroma.contrast(result.bg, result.fg)
    #console.log color, result, contrast
    # We give ourselves a bit more leniency as converting from lab -> hex is
    # lossy so contrast can change slightly.
    expect(2.9 <= contrast <= 3.1).to.be.true

  it 'should work when asking for high contrast between colors', ->
    color = "lightgrey"
    result = colorPicker(color, contrast: 12)
    contrast = chroma.contrast(result.bg, result.fg)
    # We give ourselves a bit more leniency as converting from lab -> hex is
    # lossy so contrast can change slightly.
    expect(11.9 <= contrast <= 12.1).to.be.true

  it 'should return color with contrast that is within 0.1 of what is requested', ->
    colorPickerTester = (color) ->
      result = colorPicker(color)
      contrast = chroma.contrast(result.bg, result.fg)
      #console.log color, result, contrast
      # We give ourselves a bit more leniency as converting from lab -> hex is
      # lossy so contrast can change slightly.
      expect(4.9 <= contrast <= 5.1).to.be.true

    colorPickerTester('blue')
    colorPickerTester('pink')
    colorPickerTester('white')
    colorPickerTester('black')
    colorPickerTester('purple')
    colorPickerTester('red')
    colorPickerTester('orange')
    colorPickerTester('green')
    colorPickerTester('aqua')
    colorPickerTester('fuchsia')
    colorPickerTester('gray')
    colorPickerTester('lime')
    colorPickerTester('maroon')
    colorPickerTester('navy')
    colorPickerTester('olive')
    colorPickerTester('teal')
    colorPickerTester('yellow')
