# frozen_string_literal: true

module ColorConverters
  class OklchConverter < BaseConverter
    def self.matches?(colour_input)
      return false unless colour_input.is_a?(Hash)

      colour_input.keys - [:l, :c, :h, :space] == [] && colour_input[:space].to_s == 'ok'
    end

    def self.bounds
      { l: [0.0, 100.0], c: [0.0, 500.0], h: [0.0, 360.0] }
    end

    private

    def clamp_input(colour_input)
      colour_input.each { |key, value| colour_input[key] = value.clamp(*OklchConverter.bounds[key]) }
    end

    def validate_input(colour_input)
      OklchConverter.bounds.collect do |key, range|
        "#{key} must be between #{range[0]} and #{range[1]}" unless colour_input[key].to_f.between?(*range)
      end.compact
    end

    def input_to_rgba(colour_input)
      l, a, b = OklchConverter.oklch_to_oklab(colour_input)
      x, y, z = OklabConverter.oklab_to_xyz({ l: l, a: a, b: b })
      r, g, b = XyzConverter.xyz_to_rgb({ x: x, y: y, z: z })

      [r, g, b, 1.0]
    end

    def self.oklch_to_oklab(colour_input)
      l = colour_input[:l].to_d
      c = colour_input[:c].to_d
      h = colour_input[:h].to_d

      h_rad = h * (Math::PI.to_d / 180.0.to_d)

      a = c * Math.cos(h_rad).to_d
      b = c * Math.sin(h_rad).to_d

      [l, a, b]
    end

    def self.oklab_to_oklch(lab_array)
      l, aa, bb = lab_array.map(&:to_d)

      e = 0.000015.to_d; # if chroma is smaller than this, set hue to 0 similar to CIELch

      c = ((aa**2.to_d) + (bb**2.to_d))**0.5.to_d

      h_rad = Math.atan2(bb, aa).to_d
      h = h_rad * (180.0.to_d / Math::PI.to_d)

      h %= 360

      h = 0 if c < e

      [l, c, h]
    end
  end
end
