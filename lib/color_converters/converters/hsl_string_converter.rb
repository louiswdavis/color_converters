module ColorConverters
  class HslStringConverter < BaseConverter
    def self.matches?(colour_input)
      return false unless colour_input.is_a?(String)

      colour_input.include?('hsl(') || colour_input.include?('hsla(')
    end

    private

    def validate_input(_colour_input)
      true
    end

    def input_to_rgba(colour_input)
      matches = colour_input.match(/hsla?\(([0-9.,%\s]+)\)/)
      raise InvalidColorError unless matches

      h, s, l, a = matches[1].split(',').map(&:strip)
      raise InvalidColorError unless h.present? && s.present? && l.present?

      rgba = HslConverter.new(h: h, s: s, l: l, a: a).rgba

      [rgba[:r], rgba[:g], rgba[:b], rgba[:a]]
    end
  end
end
