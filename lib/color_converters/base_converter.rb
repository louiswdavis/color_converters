require 'active_support/core_ext/object/blank'

module ColorConverters
  class BaseConverter
    IMPORT_DP = 2
    OUTPUT_DP = 2

    attr_reader :original_value, :rgba

    # keep track of subclasses for factory
    class << self
      attr_reader :converters
    end

    @converters = []

    def self.inherited(subclass)
      BaseConverter.converters << subclass
    end

    def self.factory(color)
      converter = BaseConverter.converters.find { |klass| klass.matches?(color) }
      converter.new(color) if converter
    end

    def initialize(color_input, limit_override = false)
      @original_value = color_input

      if limit_override == false && !self.validate_input(color_input)
        raise InvalidColorError # validation method is defined in each convertor
      end

      @rgba = self.input_to_rgba(color_input) # conversion method is defined in each convertor
    end

    def rgb
      { r: @rgba[:r].round(OUTPUT_DP), g: @rgba[:g].round(OUTPUT_DP), b: @rgba[:b].round(OUTPUT_DP) }
    end

    def hex
      "##{'%02x' % @rgba[:r] + '%02x' % @rgba[:g] + '%02x' % @rgba[:b]}"
    end

    def hsl
      @r, @g, @b = self.rgb_array_frac

      { h: self.hue.round(OUTPUT_DP), s: self.hsl_saturation.round(OUTPUT_DP), l: self.hsl_lightness.round(OUTPUT_DP) }
    end

    def hsv
      @r, @g, @b = self.rgb_array

      { h: self.hue.round(OUTPUT_DP), s: self.hsv_saturation.round(OUTPUT_DP), v: self.hsv_value.round(OUTPUT_DP) }
    end

    def hsb
      hsb_hash = self.hsv
      hsb_hash[:b] = hsb_hash.delete(:v)
      hsb_hash
    end

    def cmyk
      c, m, y, k = CmykConverter.rgb_to_cmyk(self.rgb_array_frac)

      { c: c.round(OUTPUT_DP), m: m.round(OUTPUT_DP), y: y.round(OUTPUT_DP), k: k.round(OUTPUT_DP) }
    end

    def xyz
      x, y, z = XyzConverter.rgb_to_xyz(self.rgb_array_frac)

      { x: x.round(OUTPUT_DP), y: y.round(OUTPUT_DP), z: z.round(OUTPUT_DP) }
    end

    def cielab
      l, a, b = CielabConverter.xyz_to_lab(XyzConverter.rgb_to_xyz(self.rgb_array_frac))

      { l: l.round(OUTPUT_DP), a: a.round(OUTPUT_DP), b: b.round(OUTPUT_DP) }
    end

    def oklch
      l, c, h = OklchConverter.lab_to_lch(CielabConverter.xyz_to_lab(XyzConverter.rgb_to_xyz(self.rgb_array_frac)))

      { l: l.round(OUTPUT_DP), c: c.round(OUTPUT_DP), h: h.round(OUTPUT_DP) }
    end

    def alpha
      @rgba[:a]
    end

    def name
      NameConverter.rgb_to_name(self.rgb_array_frac)
    end

    protected

    def rgb_array
      [@rgba[:r].to_f, @rgba[:g].to_f, @rgba[:b].to_f]
    end

    def rgb_array_frac
      [@rgba[:r] / 255.0, @rgba[:g] / 255.0, @rgba[:b] / 255.0]
    end

    def rgb_min
      [@r, @g, @b].min
    end

    def rgb_max
      [@r, @g, @b].max
    end

    def rgb_delta
      self.rgb_max - self.rgb_min
    end

    def hue
      h = 0

      case true
      when self.rgb_max == self.rgb_min
        h = 0
      when self.rgb_max == @r
        h = (@g - @b) / self.rgb_delta
      when self.rgb_max == @g
        h = 2 + (@b - @r) / self.rgb_delta
      when self.rgb_max == @b
        h = 4 + (@r - @g) / self.rgb_delta
      end

      h = [h * 60, 360].min
      h % 360
    end

    def hsl_saturation
      s = 0

      case true
      when self.rgb_max == self.rgb_min
        s = 0
      when (self.hsl_lightness / 100.0) <= 0.5
        s = self.rgb_delta / (self.rgb_max + self.rgb_min)
      else
        s = self.rgb_delta / (2.0 - self.rgb_max - self.rgb_min)
      end

      s * 100
    end

    def hsl_lightness
      (self.rgb_min + self.rgb_max) / 2.0 * 100
    end

    def hsv_saturation
      self.rgb_max.zero? ? 0 : ((self.rgb_delta / self.rgb_max * 1000) / 10.0)
    end

    def hsv_value
      ((self.rgb_max / 255.0) * 1000) / 10.0
    end
  end
end
