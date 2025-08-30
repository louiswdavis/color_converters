# frozen_string_literal: true

module ColorConverters
  class Color
    extend Forwardable
    def_delegators :@converter, :rgb, :hex, :hsl, :hsv, :hsb, :cmyk, :xyz, :cielab, :cielch, :oklab, :oklch, :name, :alpha

    # the two arguments mean we can support calling styles of a hash of colour keys, flattened hash, and string
    # colour_input is nil when key-values are passed and must be pulled from the kwargs hash
    # colour_input is set when a string is passed and kwargs is a hash of the extra options
    def initialize(colour_input = nil, **kwargs)
      if colour_input.nil?
        colour_input = kwargs.except(:limit_override, :limit_clamp)
        kwargs = kwargs.slice(:limit_override, :limit_clamp)
      end

      @original_value = colour_input

      limit_override = kwargs.delete(:limit_override) || false
      limit_clamp = kwargs.delete(:limit_clamp) || false

      @converter = BaseConverter.factory(colour_input, limit_override, limit_clamp)
    end

    def ==(other)
      return false unless other.is_a?(Color)

      rgb == other.rgb && alpha == other.alpha
    end
  end
end
