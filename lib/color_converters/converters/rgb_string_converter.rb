# frozen_string_literal: true

module ColorConverters
  class RgbStringConverter < BaseConverter
    def self.matches?(colour_input)
      return false unless colour_input.is_a?(String)

      colour_input.include?('rgb(') || colour_input.include?('rgba(')
    end

    def self.bounds
      RgbConverter.bounds
    end

    private

    # def clamp_input(colour_input)
    #   colour_input = RgbStringConverter.sanitize_input(colour_input)
    #   colour_input.each { |key, value| colour_input[key] = value.to_f.clamp(*RgbConverter.bounds[key]) }
    #   RgbStringConverter.rgb_to_rgbstring([colour_input[:r], colour_input[:g], colour_input[:b]], colour_input[:a])
    # end

    def validate_input(colour_input)
      keys = colour_input.include?('rgba(') ? [:r, :g, :b, :a] : [:r, :g, :b]
      colour_input = RgbStringConverter.sanitize_input(colour_input)

      errors = keys.collect do |key|
        "#{key} must be present" if colour_input[key].blank?
      end.compact

      return errors if errors.present?

      RgbStringConverter.bounds.collect do |key, range|
        "#{key} must be between #{range[0]} and #{range[1]}" unless colour_input[key].to_f.between?(*range)
      end.compact
    end

    def input_to_rgba(colour_input)
      colour_input = RgbStringConverter.sanitize_input(colour_input)

      r = colour_input[:r].to_f
      g = colour_input[:g].to_f
      b = colour_input[:b].to_f
      a = (colour_input[:a] || 1.0).to_f

      [r, g, b, a]
    end

    def self.sanitize_input(colour_input)
      matches = colour_input.match(/rgba?\(([0-9.,%\s]+)\)/) || []
      r, g, b, a = matches[1]&.split(',')&.map(&:strip)
      { r: r, g: g, b: b, a: a }
    end

    # def self.rgb_to_rgbstring(rgb_array_frac, alpha)
    #   r, g, b = rgb_array_frac
    #   if alpha == 1.0
    #     "rgb(#{[r, g, b].join(', ')})"
    #   else
    #     "rgba(#{[r, g, b, alpha].join(', ')})"
    #   end
    # end
  end
end
