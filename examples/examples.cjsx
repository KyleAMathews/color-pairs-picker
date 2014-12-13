React = require('react/addons')
ColorPicker = require 'react-color-picker'
chroma = require 'chroma-js'
colorPairsPicker = require '../src/index'

module.exports = React.createClass

  getInitialState: ->
    color = "red"
    {bg, fg} = colorPairsPicker(color, contrast: 5.5)

    return {
      contrast: 5.5
      color: color
      bg: bg
      fg: fg
    }

  render: ->
    <div style={width:'500px', margin:'0 auto'}>
      <h1>Color Pairs Picker</h1>
      <p>Given a color, it picks a pleasing and well contrasted background and foreground colors</p>
      <a href="https://github.com/KyleAMathews/color-pairs-picker">Code on Github</a>
      <br />
      <br />
      <h2>Pick a color</h2>
      <label>Target contrast</label>
      <input type="number" value={@state.contrast} ref="contrast" onChange={@onContrastChange} />
      <br />
      <br />
      <ColorPicker color={@state.color} onDrag={@handleChange} />
      <p>Background luminance: {chroma(@state.bg).luminance()}</p>
      <p>Foreground luminance: {chroma(@state.fg).luminance()}</p>
      <p>Contrast: {chroma.contrast(@state.fg, @state.bg)}</p>
      <p style={{background: @state.bg, color: @state.fg}}>DIY PBR&B Portland paleo, listicle Carles meggings seitan salvia hoodie McSweeney's whatever direct trade polaroid. Seitan organic health goth, photo booth kogi bespoke banjo pug cray gluten-free Shoreditch. Retro slow-carb shabby chic, flexitarian Pitchfork Vice scenester. Kogi Echo Park High Life flannel. Stumptown Neutra banjo distillery. Odd Future fixie Blue Bottle, pickled mixtape listicle semiotics vinyl Thundercats forage ennui gluten-free before they sold out Austin. PBR&B sartorial kitsch, sriracha Banksy flannel single-origin coffee kale chips Shoreditch.</p>
      <p style={{background: @state.bg, color: @state.fg}}>Kogi direct trade cardigan, vinyl wayfarers listicle Truffaut. Crucifix hashtag freegan tofu gentrify aesthetic, heirloom salvia craft beer Wes Anderson. Taxidermy migas crucifix, pickled chia hella whatever disrupt Truffaut bicycle rights. Distillery jean shorts synth, chillwave fashion axe photo booth drinking vinegar gentrify four dollar toast stumptown kogi kale chips. Readymade Thundercats gluten-free, Neutra XOXO PBR&B food truck Godard keffiyeh blog kogi Austin dreamcatcher cred. Beard DIY direct trade whatever kogi Echo Park, artisan heirloom. Schlitz bitters normcore Neutra.</p>

    </div>

  handleChange: (color) ->
    {bg, fg} = colorPairsPicker(color, contrast: @state.contrast)
    @setState {
      color: color
      bg: bg
      fg: fg
    }

  onContrastChange: ->
    @setState contrast: @refs.contrast.getDOMNode().value
    @handleChange(@state.color)
