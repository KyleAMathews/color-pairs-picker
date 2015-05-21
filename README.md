[![Build
Status](https://img.shields.io/travis/KyleAMathews/color-pairs-picker/master.svg?style=flat-square)](http://travis-ci.org/KyleAMathews/color-pairs-picker)

color-pairs-picker
==================

Given a color, it picks a pleasing and [well contrasted](http://contrastrebellion.com/) background and foreground colors

## Demo
http://kyleamathews.github.io/color-pairs-picker/

## Install
`npm install color-pairs-picker`

## Usage

This module attempts to pick pleasing color pairs that satisfy the
following constraints:

* Contrast > 4.5 for easy readability
* Avoid pure blacks and pure whites.
* Keep the background color > 0.15 luminance

```javascript
var colorPairsPicker = require 'color-pairs-picker';

var baseColor = "#BA55D3";

var pair = colorPairsPicker(baseColor);

// Set a higher contrast over the default 5.5.
// Note, the more saturated your colors the less contrasty they'll be.
var pair = colorPairsPicker(baseColor, {contrast: 8});
```
