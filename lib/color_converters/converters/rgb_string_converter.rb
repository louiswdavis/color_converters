# frozen_string_literal: true

module ColorConverters
  class RgbStringConverter < BaseConverter
    def self.matches?(colour_input)
      return false unless colour_input.is_a?(String)

      colour_input.include?('rgb(') || colour_input.include?('rgba(')
    end

    private

    def validate_input(_colour_input)
      true
    end

    def input_to_rgba(colour_input)
      matches = colour_input.match(/rgba?\(([0-9.,\s]+)\)/)
      raise InvalidColorError unless matches

      r, g, b, a = matches[1].split(',').map(&:strip)
      raise InvalidColorError unless r.present? && g.present? && b.present?

      a ||= 1.0

      r = r.to_f
      g = g.to_f
      b = b.to_f
      a = a.to_f

      [r, g, b, a]
    end
  end
end
