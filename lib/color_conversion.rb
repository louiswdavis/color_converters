# frozen_string_literal: true

require 'forwardable'

require 'color_conversion/version'

require 'color_conversion/color'
require 'color_conversion/color_converter'

require 'color_conversion/color_converters/rgb_converter'
require 'color_conversion/color_converters/rgb_string_converter'
require 'color_conversion/color_converters/hex_converter'
require 'color_conversion/color_converters/hsl_converter'
require 'color_conversion/color_converters/hsl_string_converter'
require 'color_conversion/color_converters/hsv_converter'
require 'color_conversion/color_converters/cmyk_converter'
require 'color_conversion/color_converters/xyz_converter'
require 'color_conversion/color_converters/cielab_converter'
require 'color_conversion/color_converters/oklch_converter'

require 'color_conversion/color_converters/name_converter'
require 'color_conversion/color_converters/null_converter'

module ColorConversion
  class Error < StandardError; end
  class InvalidColorError < Error; end
  # Your code goes here...
end
