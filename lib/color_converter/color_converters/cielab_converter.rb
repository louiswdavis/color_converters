module ColorConverter
  class CielabConverter < BaseConverter
    def self.matches?(color_input)
      return false unless color_input.is_a?(Hash)

      color_input.keys - [:l, :a, :b] == []
    end

    def self.bounds
      { l: [0.0, 100.0], a: [-128.0, 127.0], b: [-128.0, 127.0] }
    end

    private

    def validate_input(color_input)
      bounds = CielabConverter.bounds
      color_input[:l].to_f.between?(*bounds[:l]) && color_input[:a].to_f.between?(*bounds[:a]) && color_input[:b].to_f.between?(*bounds[:b])
    end

    def input_to_rgba(color_input)
      xyz_hash = CielabConverter.lab_to_xyz(color_input)
      XyzConverter.new(xyz_hash, limit_override: true).rgba
    end

    def self.lab_to_xyz(color_input)
      l = color_input[:l].to_f
      a = color_input[:a].to_f
      b = color_input[:b].to_f

      yy = (l + 16.0) / 116.0
      xx = (a / 500.0) + yy
      zz = yy - (b / 200.0)

      ratio = 6.0 / 29.0

      x, y, z = [xx, yy, zz].map do
        if _1 <= ratio
          (3.0 * (6.0 / 29.0) * (6.0 / 29.0) * (_1 - (4.0 / 29.0)))
        else
          _1**3
        end
      end

      x *= 95.047
      y *= 100.0
      z *= 108.883

      { x: x, y: y, z: z }
    end

    def self.xyz_to_lab(xyz_array)
      x, y, z = xyz_array

      # The D65 standard illuminant white point
      xr = 95.047
      yr = 100.0
      zr = 108.883

      # Calculate the ratio of the XYZ values to the reference white.
      # http://www.brucelindbloom.com/index.html?Equations.html
      rel = [x / xr, y / yr, z / zr]

      e = 216.0 / 24_389.0
      k = 841.0 / 108.0

      # And now transform
      # http://en.wikipedia.org/wiki/Lab_color_space#Forward_transformation
      # There is a brief explanation there as far as the nature of the calculations,
      # as well as a much nicer looking modeling of the algebra.
      xx, yy, zz = rel.map do
        if _1 > e
          _1**(1.0 / 3.0)
        else
          (k * _1) + (4.0 / 29.0)
          # The 4/29 here is for when t = 0 (black). 4/29 * 116 = 16, and 16 -
          # 16 = 0, which is the correct value for L* with black.
          # ((1.0/3)*((29.0/6)**2) * t) + (4.0/29)
        end
      end

      l = ((116.0 * yy) - 16.0)
      a = (500.0 * (xx - yy))
      b = (200.0 * (yy - zz))

      [l, a, b]
    end
  end
end
