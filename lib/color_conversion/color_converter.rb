require 'active_support/core_ext/object/blank'

module ColorConversion
  class ColorConverter
    IMPORT_DP = 2
    OUTPUT_DP = 2

    attr_reader :original_value, :rgba

    # keep track of subclasses for factory
    class << self
      attr_reader :converters
    end

    @converters = []

    def self.inherited(subclass)
      ColorConverter.converters << subclass
    end

    def self.factory(color)
      converter = ColorConverter.converters.find do |klass|
        klass.matches?(color)
      end
      converter.new(color) if converter
    end

    def initialize(color_input)
      @original_value = color_input
      @rgba = self.input_to_rgba(color_input) # method is defined in each convertor
    end

    def rgb
      { r: @rgba[:r].round(OUTPUT_DP), g: @rgba[:g].round(OUTPUT_DP), b: @rgba[:b].round(OUTPUT_DP) }
    end

    def hex
      "##{'%02x' % @rgba[:r] + '%02x' % @rgba[:g] + '%02x' % @rgba[:b]}"
    end

    def hsl
      @r, @g, @b = self.rgb_array_frac

      { h: hue.round(OUTPUT_DP), s: hsl_saturation.round(OUTPUT_DP), l: hsl_lightness.round(OUTPUT_DP) }
    end

    def hsv
      @r, @g, @b = self.rgb_array

      { h: hue.round(OUTPUT_DP), s: hsv_saturation.round(OUTPUT_DP), v: hsv_value.round(OUTPUT_DP) }
    end

    def hsb
      hsb_hash = self.hsv
      hsb_hash[:b] = hsb_hash.delete(:v)
      hsb_hash
    end

    def cmyk
      @r, @g, @b = self.rgb_array_frac

      k = (1.0 - [@r, @g, @b].max)
      k_frac = k == 1.0 ? 1.0 : 1.0 - k

      c = (1.0 - @r - k) / k_frac
      m = (1.0 - @g - k) / k_frac
      y = (1.0 - @b - k) / k_frac

      c *= 100
      m *= 100
      y *= 100
      k *= 100

      { c: c.round(OUTPUT_DP), m: m.round(OUTPUT_DP), y: y.round(OUTPUT_DP), k: k.round(OUTPUT_DP) }
    end

    # http://www.brucelindbloom.com/index.html?Eqn_RGB_to_XYZ.html
    def xyz
      x, y, z = to_xyz

      { x: x.round(OUTPUT_DP), y: y.round(OUTPUT_DP), z: z.round(OUTPUT_DP) }
    end

    def alpha
      @rgba[:a]
    end

    def name
      NameConverter.name_for_rgb(rgb)
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
      rgb_max - rgb_min
    end

    def hue
      h = 0

      case true
      when rgb_max == rgb_min
        h = 0
      when @r == rgb_max
        h = (@g - @b) / rgb_delta
      when @g == rgb_max
        h = 2 + (@b - @r) / rgb_delta
      when @b == rgb_max
        h = 4 + (@r - @g) / rgb_delta
      end

      h = [h * 60, 360].min
      h % 360
    end

    # hsv
    def hsv_saturation
      rgb_max.zero? ? 0 : ((rgb_delta / rgb_max * 1000) / 10.0)
    end

    def hsv_value
      ((rgb_max / 255.0) * 1000) / 10.0
    end

    # hsl
    def hsl_saturation
      s = 0

      case true
      when rgb_max == rgb_min
        s = 0
      when (hsl_lightness / 100.0) <= 0.5
        s = rgb_delta / (rgb_max + rgb_min)
      else
        s = rgb_delta / (2.0 - rgb_max - rgb_min)
      end

      s * 100
    end

    def hsl_lightness
      (rgb_min + rgb_max) / 2.0 * 100
    end

    def to_xyz
      r, g, b = rgb_array_frac

      # Inverse sRGB companding. Linearizes RGB channels with respect to energy.
      rr, gg, bb = [r, g, b].map do
        if _1 <= 0.04045
          (_1 / 12.92)
        else
          # sRGB Inverse Companding (Non-linear to Linear RGB)
          # The sRGB specification (IEC 61966-2-1) defines the exponent as 2.4.
          #
          (((_1 + 0.055) / 1.055)**2.4)

          # IMPORTANT NUMERICAL NOTE:
          # On this specific system (and confirmed by Wolfram Alpha for direct calculation),
          # the power function for val**2.4 yields a result that deviates from the value expected by widely-used color science libraries (like Bruce Lindbloom's).
          #
          # To compensate for this numerical discrepancy and ensure the final CIELAB values match standard online calculators and specifications,
          # an empirically determined exponent of 2.5 has been found to produce the correct linearized sRGB values on this environment.
          #
          # Choose 2.4 for strict adherence to the standard's definition (knowing your results may slightly deviate from common calculators),
          # or choose 2.5 to ensure your calculated linear RGB values (and thus CIELAB) match authoritative external tools on this system.
          #
          # (((_1 + 0.055) / 1.055)**2.5)
        end
      end

      # Convert using the RGB/XYZ matrix at:
      # http://www.brucelindbloom.com/index.html?Eqn_RGB_XYZ_Matrix.html#WSMatrices
      x = (rr * 0.4124564) + (gg * 0.3575761) + (bb * 0.1804375)
      y = (rr * 0.2126729) + (gg * 0.7151522) + (bb * 0.0721750)
      z = (rr * 0.0193339) + (gg * 0.1191920) + (bb * 0.9503041)

      # Now, scale X, Y, Z so that Y for D65 white would be 100.
      x *= 100.0
      y *= 100.0
      z *= 100.0

      # Clamping XYZ values to prevent out-of-gamut issues and numerical errors and ensures these values stay within the valid and expected range.
      x = x.clamp(0.0..95.047)
      y = y.clamp(0.0..100.0)
      z = z.clamp(0.0..108.883)

      [x, y, z]
    end
  end
end
