# frozen_string_literal: true

module ColorConverters
  class CielabConverter < BaseConverter
    def self.matches?(colour_input)
      return false unless colour_input.is_a?(Hash)

      colour_input.keys - [:l, :a, :b, :space] == [] && colour_input[:space].to_s == 'cie'
    end

    def self.bounds
      { l: [0.0, 100.0], a: [-128.0, 127.0], b: [-128.0, 127.0] }
    end

    private

    def clamp_input(colour_input)
      colour_input.each { |key, value| colour_input[key] = value.clamp(*CielabConverter.bounds[key]) }
    end

    def validate_input(colour_input)
      CielabConverter.bounds.collect do |key, range|
        "#{key} must be between #{range[0]} and #{range[1]}" unless colour_input[key].to_f.between?(*range)
      end.compact
    end

    def input_to_rgba(colour_input)
      x, y, z = CielabConverter.cielab_to_xyz(colour_input)
      r, g, b = XyzConverter.xyz_to_rgb({ x: x, y: y, z: z })

      [r, g, b, 1.0]
    end

    def self.cielab_to_xyz(colour_input)
      l = colour_input[:l].to_d
      a = colour_input[:a].to_d
      b = colour_input[:b].to_d

      yy = (l + 16.0.to_d) / 116.0.to_d
      xx = (a / 500.0.to_d) + yy
      zz = yy - (b / 200.0.to_d)

      e = 216.0.to_d / 24_389.0.to_d

      x, y, z = [xx, yy, zz].map do
        if _1**3.to_d <= e
          (3.0.to_d * (6.0.to_d / 29.0.to_d) * (6.0.to_d / 29.0.to_d) * (_1 - (4.0.to_d / 29.0.to_d)))
        else
          _1**3.to_d
        end
      end

      x *= 95.047.to_d
      y *= 100.0.to_d
      z *= 108.883.to_d

      [x, y, z]
    end

    def self.xyz_to_cielab(xyz_array)
      x, y, z = xyz_array.map(&:to_d)

      # https://www.w3.org/TR/css-color-4/#color-conversion-code
      # # The D50 & D65 standard illuminant white point
      # wp_rel = [0.3457 / 0.3585, 1.0, (1.0 - 0.3457 - 0.3585) / 0.3585]
      wp_rel = [0.3127.to_d / 0.3290.to_d, 1.0.to_d, (1.0.to_d - 0.3127.to_d - 0.3290.to_d) / 0.3290.to_d].map { _1 * 100.0.to_d }

      xr, yr, zr = wp_rel

      # # Calculate the ratio of the XYZ values to the reference white.
      # # http://www.brucelindbloom.com/index.html?Equations.html
      rel = [x / xr, y / yr, z / zr]

      e = 216.0.to_d / 24_389.0.to_d
      k = 841.0.to_d / 108.0.to_d

      # And now transform
      # http:#en.wikipedia.org/wiki/Lab_color_space#Forward_transformation
      # There is a brief explanation there as far as the nature of the calculations,
      # as well as a much nicer looking modeling of the algebra.
      xx, yy, zz = rel.map do
        if _1 > e
          _1**(1.0.to_d / 3.0.to_d)
        else
          (k * _1) + (4.0.to_d / 29.0.to_d)
          # The 4/29 here is for when t = 0 (black). 4/29 * 116 = 16, and 16 -
          # 16 = 0, which is the correct value for L* with black.
          # ((1.0/3)*((29.0/6)**2) * t) + (4.0/29)
        end
      end

      l = ((116.0.to_d * yy) - 16.0.to_d)
      a = (500.0.to_d * (xx - yy))
      b = (200.0.to_d * (yy - zz))

      [l, a, b]
    end
  end
end
