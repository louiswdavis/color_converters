module ColorConverters
  class CielchConverter < BaseConverter
    def self.matches?(color_input)
      return false unless color_input.is_a?(Hash)

      color_input.keys - [:l, :c, :h, :space] == [] && color_input[:space].to_s == 'cie'
    end

    def self.bounds
      { l: [0.0, 100.0], c: [0.0, 100.0], h: [0.0, 360.0] }
    end

    private

    def validate_input(color_input)
      bounds = CielchConverter.bounds
      color_input[:l].to_f.between?(*bounds[:l]) && color_input[:c].to_f.between?(*bounds[:c]) && color_input[:h].to_f.between?(*bounds[:h])
    end

    def input_to_rgba(color_input)
      lab_hash = CielchConverter.cielch_to_cielab(color_input)
      xyz_hash = CielabConverter.cielab_to_xyz(lab_hash)
      XyzConverter.new(xyz_hash, limit_override: true).rgba
    end

    def self.cielch_to_cielab(color_input)
      l = color_input[:l].to_f
      c = color_input[:c].to_f
      h = color_input[:h].to_f

      h_rad = h * (Math::PI / 180.0)

      a = c * Math.cos(h_rad)
      b = c * Math.sin(h_rad)

      { l: l, a: a, b: b }
    end

    def self.cielab_to_cielch(lab_array)
      l, aa, bb = lab_array

      c = ((aa**2) + (bb**2))**0.5

      h_rad = Math.atan2(bb, aa)
      h = h_rad * (180.0 / Math::PI)

      h %= 360

      [l, c, h]
    end
  end
end
