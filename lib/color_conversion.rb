# frozen_string_literal: true

require 'forwardable'

require 'color_conversion/version'

require 'color_conversion/color'
require 'color_conversion/color_converter'

require 'color_conversion/converters/hex_converter'
require 'color_conversion/converters/rgb_string_converter'
require 'color_conversion/converters/hsl_string_converter'
require 'color_conversion/converters/name_converter'

require 'color_conversion/converters/cmyk_converter'
require 'color_conversion/converters/hsl_converter'
require 'color_conversion/converters/hsv_converter'
require 'color_conversion/converters/rgb_converter'
require 'color_conversion/converters/xyz_converter'
require 'color_conversion/converters/null_converter'

module ColorNamerRuby
  class Error < StandardError; end
  class InvalidColorError < Error; end
  # Your code goes here...
end
