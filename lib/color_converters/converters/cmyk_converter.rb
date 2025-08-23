# frozen_string_literal: true

module ColorConverters
  class CmykConverter < BaseConverter
    def self.matches?(colour_input)
      return false unless colour_input.is_a?(Hash)

      colour_input.keys - [:c, :m, :y, :k] == []
    end

    def self.bounds
      { c: [0.0, 100.0], m: [0.0, 100.0], y: [0.0, 100.0], k: [0.0, 100.0] }
    end

    private

    def clamp_input(colour_input)
      colour_input.each { |key, value| colour_input[key] = value.clamp(*CmykConverter.bounds[key]) }
    end

    def validate_input(colour_input)
      CmykConverter.bounds.collect do |key, range|
        "#{key} must be between #{range[0]} and #{range[1]}" unless colour_input[key].to_f.between?(*range)
      end.compact
    end

    def input_to_rgba(colour_input)
      c = colour_input[:c].to_f
      m = colour_input[:m].to_f
      y = colour_input[:y].to_f
      k = colour_input[:k].to_f

      c /= 100.0
      m /= 100.0
      y /= 100.0
      k /= 100.0

      r = (255 * (1.0 - [1.0, c * (1.0 - k) + k].min))
      g = (255 * (1.0 - [1.0, m * (1.0 - k) + k].min))
      b = (255 * (1.0 - [1.0, y * (1.0 - k) + k].min))

      [r, g, b, 1.0]
    end

    def self.rgb_to_cmyk(rgb_array_frac)
      r, g, b = rgb_array_frac

      k = (1.0 - [r, g, b].max)
      k_frac = k == 1.0 ? 1.0 : 1.0 - k

      c = (1.0 - r - k) / k_frac
      m = (1.0 - g - k) / k_frac
      y = (1.0 - b - k) / k_frac

      c *= 100
      m *= 100
      y *= 100
      k *= 100

      [c, m, y, k]
    end
  end
end
