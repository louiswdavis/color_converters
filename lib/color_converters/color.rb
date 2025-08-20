# frozen_string_literal: true

module ColorConverters
  class Color
    extend Forwardable
    def_delegators :@converter, :rgb, :hex, :hsl, :hsv, :hsb, :cmyk, :xyz, :cielab, :cielch, :oklab, :oklch, :name, :alpha

    def initialize(color)
      @converter = BaseConverter.factory(color)
    end

    def ==(other)
      return false unless other.is_a?(Color)

      rgb == other.rgb && alpha == other.alpha
    end
  end
end
