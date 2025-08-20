# frozen_string_literal: true

module ColorConverters
  class CielchConverter < BaseConverter
    def self.matches?(colour_input)
      return false unless colour_input.is_a?(Hash)

      colour_input.keys - [:l, :c, :h, :space] == [] && colour_input[:space].to_s == 'cie'
    end

    def self.bounds
      { l: [0.0, 100.0], c: [0.0, 150.0], h: [0.0, 360.0] }
    end

    private

    def validate_input(colour_input)
      bounds = CielchConverter.bounds
      colour_input[:l].to_f.between?(*bounds[:l]) && colour_input[:c].to_f.between?(*bounds[:c]) && colour_input[:h].to_f.between?(*bounds[:h])
    end

    def input_to_rgba(colour_input)
      l, a, b = CielchConverter.cielch_to_cielab(colour_input)
      x, y, z = CielabConverter.cielab_to_xyz({ l: l, a: a, b: b })
      r, g, b = XyzConverter.xyz_to_rgb({ x: x, y: y, z: z })

      [r, g, b, 1.0]
    end

    def self.cielch_to_cielab(colour_input)
      l = colour_input[:l].to_d
      c = colour_input[:c].to_d
      h = colour_input[:h].to_d

      h_rad = h * (Math::PI.to_d / 180.0.to_d)

      a = c * Math.cos(h_rad).to_d
      b = c * Math.sin(h_rad).to_d

      [l, a, b]
    end

    def self.cielab_to_cielch(lab_array)
      l, aa, bb = lab_array.map(&:to_d)

      e = 0.0015.to_d; # if chroma is smaller than this, set hue to 0 [https://www.w3.org/TR/css-colour-4/#colour-conversion-code]

      c = ((aa**2.to_d) + (bb**2.to_d))**0.5.to_d

      h_rad = Math.atan2(bb, aa).to_d
      h = h_rad * (180.0.to_d / Math::PI.to_d)

      h %= 360

      h = 0 if c < e

      [l, c, h]
    end
  end
end
