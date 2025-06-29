# frozen_string_literal: true

require 'forwardable'

require 'color_converters/version'

require 'color_converters/color'
require 'color_converters/base_converter'

require 'color_converters/converters/rgb_converter'
require 'color_converters/converters/rgb_string_converter'
require 'color_converters/converters/hex_converter'
require 'color_converters/converters/hsl_converter'
require 'color_converters/converters/hsl_string_converter'
require 'color_converters/converters/hsv_converter'
require 'color_converters/converters/cmyk_converter'
require 'color_converters/converters/xyz_converter'
require 'color_converters/converters/cielab_converter'
require 'color_converters/converters/cielch_converter'
require 'color_converters/converters/oklab_converter'
require 'color_converters/converters/oklch_converter'

require 'color_converters/converters/name_converter'
require 'color_converters/converters/null_converter'

module ColorConverters
  class Error < StandardError; end
  class InvalidColorError < Error; end
  # Your code goes here...
end
