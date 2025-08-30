# frozen_string_literal: true

module ColorConverters
  class HsvConverter < BaseConverter
    def self.matches?(colour_input)
      return false unless colour_input.is_a?(Hash)

      colour_input.keys - [:h, :s, :v] == [] || colour_input.keys - [:h, :s, :b] == []
    end

    def self.bounds
      { h: [0.0, 360.0], s: [-128.0, 127.0], v: [-128.0, 127.0], b: [-128.0, 127.0] }
    end

    private

    # def clamp_input(colour_input)
    #   colour_input.each { |key, value| colour_input[key] = value.clamp(*HsvConverter.bounds[key]) }
    # end

    def validate_input(colour_input)
      HsvConverter.bounds.collect do |key, range|
        "#{key} must be between #{range[0]} and #{range[1]}" unless colour_input[key].blank? || colour_input[key].to_f.between?(*range)
      end.compact
    end

    def input_to_rgba(colour_input)
      h = colour_input[:h].to_f
      s = colour_input[:s].to_f
      v = (colour_input[:v] || colour_input[:b]).to_f

      h /= 360
      s /= 100
      v /= 100

      i = (h * 6).floor
      f = h * 6 - i

      p = v * (1 - s)
      q = v * (1 - f * s)
      t = v * (1 - (1 - f) * s)

      p = (p * 255).round(IMPORT_DP)
      q = (q * 255).round(IMPORT_DP)
      t = (t * 255).round(IMPORT_DP)
      v = (v * 255).round(IMPORT_DP)

      case i % 6
      when 0
        [v, t, p, 1.0]
      when 1
        [q, v, p, 1.0]
      when 2
        [p, v, t, 1.0]
      when 3
        [p, q, v, 1.0]
      when 4
        [t, p, v, 1.0]
      when 5
        [v, p, q, 1.0]
      end
    end
  end
end
