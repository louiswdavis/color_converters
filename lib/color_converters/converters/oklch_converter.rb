module ColorConverters
  class OklchConverter < BaseConverter
    def self.matches?(color_input)
      return false unless color_input.is_a?(Hash)

      color_input.keys - [:l, :c, :h, :space] == [] && color_input[:space].to_s == 'ok'
    end

    def self.bounds
      { l: [0.0, 100.0], c: [0.0, 100.0], h: [0.0, 360.0] }
    end

    private

    def validate_input(color_input)
      bounds = OklchConverter.bounds
      color_input[:l].to_f.between?(*bounds[:l]) && color_input[:c].to_f.between?(*bounds[:c]) && color_input[:h].to_f.between?(*bounds[:h])
    end

    def input_to_rgba(color_input)
      l, a, b = OklchConverter.oklch_to_oklab(color_input)
      r, g, b = OklabConverter.oklab_to_rgb({ l: l, a: a, b: b })

      [r, g, b, 1.0]
    end

    def self.oklch_to_oklab(color_input)
      l = color_input[:l].to_f
      c = color_input[:c].to_f
      h = color_input[:h].to_f

      h_rad = h * (Math::PI / 180.0)

      a = c * Math.cos(h_rad)
      b = c * Math.sin(h_rad)

      [l, a, b]
    end

    def self.oklab_to_oklch(lab_array)
      l, aa, bb = lab_array

      c = ((aa**2) + (bb**2))**0.5

      h_rad = Math.atan2(bb, aa)
      h = h_rad * (180.0 / Math::PI)

      h %= 360

      [l, c, h]
    end
  end
end
