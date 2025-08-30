# Color Converters

[![Gem Version](https://badge.fury.io/rb/color_converters.svg)](https://badge.fury.io/rb/color_converters)
![Static Badge](https://img.shields.io/badge/RubyGems-red?link=https%3A%2F%2Frubygems.org%2Fgems%color_converters)

> Give me a colour and I'll convert it.

Color Converters is an ruby gem package for use in ruby or other projects that provides conversions for colours to other colour spaces.
Given a colour in [Hexadecimal, RGA(A), HSL(A), HSV, HSB, CMYK, XYZ, CIELAB, or OKLCH format](https://github.com/devrieda/color_conversion), it can convert the colour to those other spaces.

> Lab and LCH colour spaces are special in that the perceived difference between two colours is proportional to their Euclidean distance in colour space. This special property, called perceptual uniformity, makes them ideal for accurate visual encoding of data. In contrast, the more familiar RGB and HSL colour spaces distort data when used for visualization.

## Converters

Colours can be converted between the following spaces:

- hex
- rgb(a)
- hsl(a)
- hsv/hsb
- cmyk
- xyz
- cielab
- cielch
- oklab (not always reliable when going from oklab to the source colour)
- oklch (not always reliable when going from oklch to the source colour)
- name

## Installation

Install the gem and add to the application's Gemfile by executing:

```bash
bundle add color_converters
```

If bundler is not being used to manage dependencies, install the gem by executing:

```bash
gem install color_converters
```

## Usage

Initialize a colour:

```ruby
# from hex
colour = ColorConverters::Color.new("#3366cc")
colour = ColorConverters::Color.new("#36c")

# from rgb(a)
colour = ColorConverters::Color.new(r: 51, g: 102, b: 204)
colour = ColorConverters::Color.new(r: 51, g: 102, b: 204, a: 0.5)

# from hsl(a)
colour = ColorConverters::Color.new(h: 225, s: 73, l: 57)
colour = ColorConverters::Color.new(h: 225, s: 73, l: 57, a: 0.5)

# from hsv/hsb
colour = ColorConverters::Color.new(h: 220, s: 75, v: 80)
colour = ColorConverters::Color.new(h: 220, s: 75, b: 80)

# from cmyk
colour = ColorConverters::Color.new(c: 74, m: 58, y: 22, k: 3)

# from xyz
colour = ColorConverters::Color.new(x: 16, y: 44, z: 32)

# from cielab
colour = ColorConverters::Color.new(l: 16, a: 44, b: 32, space: :cie)

# from cielch
colour = ColorConverters::Color.new(l: 16, c: 44, h: 32, space: :cie)

# from oklab
colour = ColorConverters::Color.new(l: 16, a: 44, b: 32, space: :ok)

# from oklch
colour = ColorConverters::Color.new(l: 16, c: 44, h: 32, space: :ok)

# from textual colour
colour = ColorConverters::Color.new("blue")

# from a css rgb(a) string
colour = ColorConverters::Color.new("rgb(51, 102, 204)")
colour = ColorConverters::Color.new("rgba(51, 102, 204, 0.5)")

# from a css hsl(a) string
colour = ColorConverters::Color.new("hsl(225, 73%, 57%)")
colour = ColorConverters::Color.new("hsl(225, 73%, 57%, 0.5)")
```

Converters

```ruby
colour = ColorConverters::Color.new("rgba(70, 130, 180, 0.5)")
colour = ColorConverters::Color.new(r: 70, g: 130, b: 180, a: 0.5)

colour.alpha
=> 0.5

colour.rgb
=> {:r=>70, :g=>130, :b=>180}

colour.hsl
=> {:h=>207, :s=>44, :l=>49}

colour.hsv
=> {:h=>207, :s=>61, :v=>71}

colour.hsb
=> {:h=>207, :s=>61, :b=>71}

colour.cmyk
=> {:c=>61, :m=>28, :y=>0, :k=>29}

colour.xyz
=> {:x=>33, :y=>21, :z=>54}

colour.cielab
=> {:l=>52.47, :a=>-4.08, :b=>-32.19}

colour.cielch
=> {:l=>52.47, :c=>32.45, :h=>262.78}

colour.oklab # not always accurate
=> {:l=>52.47, :a=>-4.08, :b=>-32.19}

colour.oklch # not always accurate
=> {:l=>52.47, :c=>32.45, :h=>262.78}

colour.hex
=> "#4682b4"

colour.name
=> "steelblue"
```

## Options

### space

As there are certain colour spaces that use the same letter keys, there needed to be a way to different between those space.
The space parameter allows that, with examples in the usage code above

```ruby
ColorConverters::Color.new(l: 64, a: 28, b: -15, space: :cie)
ColorConverters::Color.new(l: 64, a: 0.28, b: -0.15, space: :ok)
```

### limit_override

By default all values are checked to be within the expected number ranges, i.e.; rgb between 0-255 each but there are certain spaces where this is less fixed which this option is purposed for.
This parameter allows you to ignore those ranges and submit any values you want.
**WARNING: even if you use this, there may be certain conversions that can not handle the large source values; e.g.**

```ruby
ColorConverters::Color.new(r: 270, g: 1300, b: 380, a: 0.5, limit_override: true).rgb
=> {r: 270.0, g: 1300.0, b: 380.0}

ColorConverters::Color.new(x: 174, y: 135, z: 137, limit_override: true).xyz
=> {x: 91.58, y: 93.06, z: 107.75}
```

### fuzzy

Name conversions by default look for exact matches between the hex value of the colour

```ruby
colour = ColorConverters::Color.new(r: 175.8, g: 196.4, b: 222.1)

colour.name
=> nil

colour.name(fuzzy: true)
=> 'lightsteelblue'
```

## Development

[Converting Colors](https://convertingcolors.com/) and [Colorffy](https://colorffy.com/) can be used to help verify results. Different calculators use different exponents and standards so there can be discrepency across them (like this calculator for LCH).

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at <https://github.com/louiswdavis/color_converters>. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/louiswdavis/color_converters/blob/master/CODE_OF_CONDUCT.md).

## License

Forked from original gem by Derek DeVries.
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the ColorConverters project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/louiswdavis/color_converters/blob/master/CODE_OF_CONDUCT.md).
