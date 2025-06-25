# frozen_string_literal: true

require 'forwardable'

require 'color_converter/version'

require 'color_converter/color'
require 'color_converter/base_converter'

require 'color_converter/color_converters/rgb_converter'
require 'color_converter/color_converters/rgb_string_converter'
require 'color_converter/color_converters/hex_converter'
require 'color_converter/color_converters/hsl_converter'
require 'color_converter/color_converters/hsl_string_converter'
require 'color_converter/color_converters/hsv_converter'
require 'color_converter/color_converters/cmyk_converter'
require 'color_converter/color_converters/xyz_converter'
require 'color_converter/color_converters/cielab_converter'
require 'color_converter/color_converters/oklch_converter'

require 'color_converter/color_converters/name_converter'
require 'color_converter/color_converters/null_converter'

module ColorConverter
  class Error < StandardError; end
  class InvalidColorError < Error; end
  # Your code goes here...
end
