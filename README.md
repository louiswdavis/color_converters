## Color Conversion

This gem provides conversions for colors to and from Hex, RGB, and HSL.

## Examples

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

# from textual color
color = Color.new("blue")

# from a css rgb(a) string
color = Color.new("rgb(51, 102, 204)")
color = Color.new("rgba(51, 102, 204, 0.5)")

# from a css hsl(a) string
color = Color.new("hsl(225, 73%, 57%)")
color = Color.new("hsl(225, 73%, 57%, 0.5)")
```

Conversions

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

color.hex
=> "#4682b4"

color.name
=> "steelblue"
```

## Installation

To install ColorConversion, add the gem to your Gemfile:

```ruby
gem "color_conversion"
```

## LICENSE

Copyright (c) 2013 Derek DeVries

Released under the [MIT License](http://www.opensource.org/licenses/MIT)

# UtilityPalettesRails

TODO: Delete this and the text below, and describe your gem

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/color_conversion_rails`. To experiment with that code, run `bin/console` for an interactive prompt.

## Installation

TODO: Replace `UPDATE_WITH_YOUR_GEM_NAME_IMMEDIATELY_AFTER_RELEASE_TO_RUBYGEMS_ORG` with your gem name right after releasing it to RubyGems.org. Please do not do it earlier due to security reasons. Alternatively, replace this section with instructions to install your gem from git if you don't plan to release to RubyGems.org.

Install the gem and add to the application's Gemfile by executing:

```bash
bundle add UPDATE_WITH_YOUR_GEM_NAME_IMMEDIATELY_AFTER_RELEASE_TO_RUBYGEMS_ORG
```

If bundler is not being used to manage dependencies, install the gem by executing:

```bash
gem install UPDATE_WITH_YOUR_GEM_NAME_IMMEDIATELY_AFTER_RELEASE_TO_RUBYGEMS_ORG
```

## Usage

to get the config

```bash
rails generate color_conversion:config
```

to generate the palettes

```bash
rails generate color_conversion:config
rails generate color_conversion:generate
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at <https://github.com/louiswdavis/color_conversion_rails>. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/louiswdavis/color_conversion_rails/blob/master/CODE_OF_CONDUCT.md).

## License

Forked from original gem by Derek DeVries.
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the UtilityPalettesRails project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/louiswdavis/color_conversion_rails/blob/master/CODE_OF_CONDUCT.md).
