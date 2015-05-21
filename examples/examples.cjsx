React = require('react/addons')
ColorPicker = require 'react-color-picker'
chroma = require 'chroma-js'
colorPairsPicker = require '../src/index'

module.exports = React.createClass

  mixins: [React.addons.LinkedStateMixin]

  getInitialState: ->
    color = "red"

    return {
      contrast: 5
      foregroundMin: 0.02
      foregroundMax: 0.98
      backgroundMin: 0.15
      backgroundMax: 0.85
      color: color
    }

  render: ->
    {bg, fg} = colorPairsPicker(@state.color, {
      contrast: parseFloat(@state.contrast)
      foregroundMin: parseFloat(@state.foregroundMin)
      foregroundMax: parseFloat(@state.foregroundMax)
      backgroundMax: parseFloat(@state.backgroundMax)
      backgroundMin: parseFloat(@state.backgroundMin)
    })

    <div style={width:'500px', margin:'0 auto'}>
      <h1>Color Pairs Picker</h1>
      <p>Given a color, it picks a pleasing and well contrasted background and foreground colors</p>
      <a href="https://github.com/KyleAMathews/color-pairs-picker">Code on Github</a>
      <br />
      <br />
      <h2>Pick a color</h2>
      <label>Target contrast</label>
      <input type="number" valueLink={@linkState('contrast')} />
      <br />
      <label>Minimum foreground luminance</label>
      <input type="number" valueLink={@linkState('foregroundMin')} />
      <br />
      <label>Maxiumum foreground luminance</label>
      <input type="number" valueLink={@linkState('foregroundMax')} />
      <br />
      <label>Minimum background luminance</label>
      <input type="number" valueLink={@linkState('backgroundMin')} />
      <br />
      <label>Maxiumum background luminance</label>
      <input type="number" valueLink={@linkState('backgroundMax')} />
      <br />
      <br />
      <ColorPicker color={@state.color} onDrag={@handleChange} />
      <p>Background luminance: {chroma(bg).luminance()}</p>
      <p>Foreground luminance: {chroma(fg).luminance()}</p>
      <p>Contrast: {chroma.contrast(fg, bg)}</p>
      <p style={{background: bg, color: fg}}>DIY PBR&B Portland paleo, listicle Carles meggings seitan salvia hoodie McSweeney's whatever direct trade polaroid. Seitan organic health goth, photo booth kogi bespoke banjo pug cray gluten-free Shoreditch. Retro slow-carb shabby chic, flexitarian Pitchfork Vice scenester. Kogi Echo Park High Life flannel. Stumptown Neutra banjo distillery. Odd Future fixie Blue Bottle, pickled mixtape listicle semiotics vinyl Thundercats forage ennui gluten-free before they sold out Austin. PBR&B sartorial kitsch, sriracha Banksy flannel single-origin coffee kale chips Shoreditch.</p>
    </div>

  handleChange: (color) ->
    @setState {
      color: color
    }
