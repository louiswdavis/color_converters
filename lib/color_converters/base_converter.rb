# frozen_string_literal: true

require 'active_support/core_ext/object/blank'
require 'bigdecimal'
require 'bigdecimal/util'

module ColorConverters
  class BaseConverter
    IMPORT_DP = 8
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

    def self.factory(colour_input, limit_override = false, limit_clamp = false)
      converter = BaseConverter.converters.find { |klass| klass.matches?(colour_input) }
      converter&.new(colour_input, limit_override, limit_clamp)
    end

    def initialize(colour_input, limit_override = false, _limit_clamp = false)
      colour_input.delete(:space) if colour_input.is_a?(Hash)

      # colour_input = self.clamp_input(colour_input) if limit_clamp == true

      validation_errors = self.validate_input(colour_input) # validation method is defined in each convertor
      raise InvalidColorError, "Invalid color input: #{validation_errors.join(', ')}" if limit_override == false && validation_errors.present?

      r, g, b, a = self.input_to_rgba(colour_input) # conversion method is defined in each convertor

      @rgba = { r: r.to_f.round(IMPORT_DP), g: g.to_f.round(IMPORT_DP), b: b.to_f.round(IMPORT_DP), a: a.to_f.round(IMPORT_DP) }
    end

    def rgb
      { r: @rgba[:r].to_f.round(OUTPUT_DP), g: @rgba[:g].to_f.round(OUTPUT_DP), b: @rgba[:b].to_f.round(OUTPUT_DP) }
    end

    def hex
      HexConverter.rgb_to_hex(self.rgb_array)
    end

    # not refactored to SubClass methods due to needing so many of the private methods
    def hsl
      @r, @g, @b = self.rgb_array_frac

      { h: self.hue.to_f.round(OUTPUT_DP), s: self.hsl_saturation.to_f.round(OUTPUT_DP), l: self.hsl_lightness.to_f.round(OUTPUT_DP) }
    end

    # not refactored to SubClass methods due to needing so many of the private methods
    def hsv
      @r, @g, @b = self.rgb_array

      { h: self.hue.to_f.round(OUTPUT_DP), s: self.hsv_saturation.to_f.round(OUTPUT_DP), v: self.hsv_value.to_f.round(OUTPUT_DP) }
    end

    def hsb
      hsb_hash = self.hsv
      hsb_hash[:b] = hsb_hash.delete(:v)
      hsb_hash
    end

    def cmyk
      c, m, y, k = CmykConverter.rgb_to_cmyk(self.rgb_array_frac)

      { c: c.to_f.round(OUTPUT_DP), m: m.to_f.round(OUTPUT_DP), y: y.to_f.round(OUTPUT_DP), k: k.to_f.round(OUTPUT_DP) }
    end

    def xyz
      x, y, z = XyzConverter.rgb_to_xyz(self.rgb_array_frac)

      { x: x.to_f.round(OUTPUT_DP), y: y.to_f.round(OUTPUT_DP), z: z.to_f.round(OUTPUT_DP) }
    end

    def cielab
      l, a, b = CielabConverter.xyz_to_cielab(XyzConverter.rgb_to_xyz(self.rgb_array_frac))

      { l: l.to_f.round(OUTPUT_DP), a: a.to_f.round(OUTPUT_DP), b: b.to_f.round(OUTPUT_DP) }
    end

    def cielch
      l, c, h = CielchConverter.cielab_to_cielch(CielabConverter.xyz_to_cielab(XyzConverter.rgb_to_xyz(self.rgb_array_frac)))

      { l: l.to_f.round(OUTPUT_DP), c: c.to_f.round(OUTPUT_DP), h: h.to_f.round(OUTPUT_DP) }
    end

    def oklab
      l, a, b = OklabConverter.xyz_to_oklab(XyzConverter.rgb_to_xyz(self.rgb_array_frac))

      { l: l.to_f.round(OUTPUT_DP), a: a.to_f.round(OUTPUT_DP), b: b.to_f.round(OUTPUT_DP) }
    end

    def oklch
      l, c, h = OklchConverter.oklab_to_oklch(OklabConverter.xyz_to_oklab(XyzConverter.rgb_to_xyz(self.rgb_array_frac)))

      { l: l.to_f.round(OUTPUT_DP), c: c.to_f.round(OUTPUT_DP), h: h.to_f.round(OUTPUT_DP) }
    end

    def alpha
      @rgba[:a]
    end

    def name(fuzzy: false)
      NameConverter.rgb_to_name(self.rgb_array, fuzzy)
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
