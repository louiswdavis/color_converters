# Color Converters

> Give me a color and I'll convert it.

Color Converters is an ruby gem package for use in ruby or other projects that provides conversions for colors to other color spaces.
Given a color in [Hexadecimal, RGA(A), HSL(A), HSV, HSB, CMYK, XYZ, CIELAB, or OKLCH format](https://github.com/devrieda/color_conversion), it can convert the color to those other spaces.

> Lab and LCH color spaces are special in that the perceived difference between two colors is proportional to their Euclidean distance in color space. This special property, called perceptual uniformity, makes them ideal for accurate visual encoding of data. In contrast, the more familiar RGB and HSL color spaces distort data when used for visualization.

## Converters

Colors can be converted between the following spaces:

- hex
- rgb(a)
- hsl(a)
- hsv/hsb
- cmyk
- xyz
- cielab
- oklch
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

Initialize a color:

```ruby
# from hex
color = Color.new("#3366cc")
color = Color.new("#36c")

# from rgb(a)
color = Color.new(r: 51, g: 102, b: 204)
color = Color.new(r: 51, g: 102, b: 204, a: 0.5)

# from hsl(a)
color = Color.new(h: 225, s: 73, l: 57)
color = Color.new(h: 225, s: 73, l: 57, a: 0.5)

# from hsv/hsb
color = Color.new(h: 220, s: 75, v: 80)
color = Color.new(h: 220, s: 75, b: 80)

# from cmyk
color = Color.new(c: 74, m: 58, y: 22, k: 3)

# from xyz
color = Color.new(x: 16, y: 44, z: 32)

# from cielab
color = Color.new(l: 16, a: 44, b: 32)

# from oklch
color = Color.new(l: 16, c: 44, h: 32)

# from textual color
color = Color.new("blue")

# from a css rgb(a) string
color = Color.new("rgb(51, 102, 204)")
color = Color.new("rgba(51, 102, 204, 0.5)")

# from a css hsl(a) string
color = Color.new("hsl(225, 73%, 57%)")
color = Color.new("hsl(225, 73%, 57%, 0.5)")
```

Converters

```ruby
color = Color.new(r: 70, g: 130, b: 180, a: 0.5)

color.alpha
=> 0.5

color.rgb
=> {:r=>70, :g=>130, :b=>180}

color.hsl
=> {:h=>207, :s=>44, :l=>49}

color.hsv
=> {:h=>207, :s=>61, :v=>71}

color.hsb
=> {:h=>207, :s=>61, :b=>71}

color.cmyk
=> {:c=>61, :m=>28, :y=>0, :k=>29}

color.xyz
=> {:x=>33, :y=>21, :z=>54}

color.cielab
=> {:l=>52.47, :a=>-4.08, :b=>-32.19}

color.oklch
=> {:l=>52.47, :c=>32.45, :h=>262.78}

color.hex
=> "#4682b4"

color.name
=> "steelblue"
```

## Options

### limit_override

By default all values are checked to be within the expected number ranges, i.e.; rgb between 0-255 each.
This parameter allows you to ignore those ranges and submit any values you want.

```ruby
Color.new(r: 270, g: 1300, b: 380, a: 0.5, limit_override: true)
```

## Development

[Converting Colors](https://convertingcolors.com/) can be usef to help verify results. Different calculators use different exponents and standards so there can be discrepency across them (like this calculator for LCH).

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at <https://github.com/louiswdavis/color_converters>. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/louiswdavis/color_converters/blob/master/CODE_OF_CONDUCT.md).

## License

Forked from original gem by Derek DeVries.
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the ColorConverters project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/louiswdavis/color_converters/blob/master/CODE_OF_CONDUCT.md).
