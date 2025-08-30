# frozen_string_literal: true

module ColorConverters
  class HslStringConverter < BaseConverter
    def self.matches?(colour_input)
      return false unless colour_input.is_a?(String)

      colour_input.include?('hsl(') || colour_input.include?('hsla(')
    end

    def self.bounds
      HslConverter.bounds
    end

    private

    # def clamp_input(colour_input)
    #   colour_input = HslStringConverter.sanitize_input(colour_input)
    #   colour_input.each { |key, value| colour_input[key] = value.to_f.clamp(*HslConverter.bounds[key]) }
    #   HslStringConverter.rgb_to_rgbstring([colour_input[:h], colour_input[:s], colour_input[:l]], colour_input[:a])
    # end

    def validate_input(colour_input)
      keys = colour_input.include?('hsla(') ? [:h, :s, :l, :a] : [:h, :s, :l]
      colour_input = HslStringConverter.sanitize_input(colour_input)

      errors = keys.collect do |key|
        "#{key} must be present" if colour_input[key].blank?
      end.compact

      return errors if errors.present?

      HslStringConverter.bounds.collect do |key, range|
        "#{key} must be between #{range[0]} and #{range[1]}" unless colour_input[key].to_f.between?(*range)
      end.compact
    end

    def input_to_rgba(colour_input)
      colour_input = HslStringConverter.sanitize_input(colour_input)

      rgba = HslConverter.new(h: colour_input[:h], s: colour_input[:s], l: colour_input[:l], a: colour_input[:a], limit_override: true).rgba

      [rgba[:r], rgba[:g], rgba[:b], rgba[:a]]
    end

    def self.sanitize_input(colour_input)
      matches = colour_input.match(/hsla?\(([0-9.,%\s]+)\)/) || []
      h, s, l, a = matches[1]&.split(',')&.map(&:strip)
      { h: h, s: s, l: l, a: a }
    end

    # def self.rgb_to_hslstring(rgb_array_frac, alpha)
    #   r, g, b = rgb_array_frac
    #   if alpha == 1.0
    #     "hsl(#{[r, g, b].join(', ')})"
    #   else
    #     "hsla(#{[r, g, b, alpha].join(', ')})"
    #   end
    # end
  end
end
