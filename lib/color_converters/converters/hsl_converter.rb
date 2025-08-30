# frozen_string_literal: true

module ColorConverters
  class HslConverter < BaseConverter
    def self.matches?(colour_input)
      return false unless colour_input.is_a?(Hash)

      colour_input.keys - [:h, :s, :l] == [] || colour_input.keys - [:h, :s, :l, :a] == []
    end

    def self.bounds
      { h: [0.0, 360.0], s: [0.0, 100.0], l: [0.0, 100.0], a: [0.0, 1.0] }
    end

    private

    # def clamp_input(colour_input)
    #   colour_input.each { |key, value| colour_input[key] = value.clamp(*HslConverter.bounds[key]) }
    # end

    def validate_input(colour_input)
      HslConverter.bounds.collect do |key, range|
        "#{key} must be between #{range[0]} and #{range[1]}" unless colour_input[key].to_f.between?(*range)
      end.compact
    end

    def input_to_rgba(colour_input)
      h = colour_input[:h].to_s.gsub(/[^0-9.]/, '').to_f / 360.0
      s = colour_input[:s].to_s.gsub(/[^0-9.]/, '').to_f / 100.0
      l = colour_input[:l].to_s.gsub(/[^0-9.]/, '').to_f / 100.0
      a = colour_input[:a] ? colour_input[:a].to_s.gsub(/[^0-9.]/, '').to_f : 1.0

      return greyscale(l, a) if s.zero?

      t2 = if l < 0.5
             l * (1 + s)
           else
             l + s - l * s
           end

      t1 = 2 * l - t2

      rgb = [0, 0, 0]

      (0..2).each do |i|
        t3 = h + 1 / 3.0 * - (i - 1)
        t3.negative? && t3 += 1
        t3 > 1 && t3 -= 1

        val = if 6 * t3 < 1
                t1 + (t2 - t1) * 6 * t3
              elsif 2 * t3 < 1
                t2
              elsif 3 * t3 < 2
                t1 + (t2 - t1) * (2 / 3.0 - t3) * 6
              else
                t1
              end

        rgb[i] = (val * 255)
      end

      [rgb[0], rgb[1], rgb[2], a]
    end

    def greyscale(luminosity, alpha)
      rgb_equal_value = (luminosity * 255).round(IMPORT_DP)

      [rgb_equal_value, rgb_equal_value, rgb_equal_value, alpha]
    end
  end
end
