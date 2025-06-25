module ColorConverters
  class RgbStringConverter < BaseConverter
    def self.matches?(color_input)
      return false unless color_input.is_a?(String)

      color_input.include?('rgb(') || color_input.include?('rgba(')
    end

    private

    def validate_input(color_input)
      true
      # color_input[:l].between?(0.0, 100.0) && color_input[:a].between?(-128.0, 127.0) && color_input[:b].between?(-128.0, 127.0)
    end

    def input_to_rgba(color_input)
      matches = color_input.match(/rgba?\(([0-9.,\s]+)\)/)
      raise InvalidColorError unless matches

      r, g, b, a = matches[1].split(',').map(&:strip)
      raise InvalidColorError unless r.present? && g.present? && b.present?

      a ||= 1.0

      r = r.to_f.round(IMPORT_DP)
      g = g.to_f.round(IMPORT_DP)
      b = b.to_f.round(IMPORT_DP)
      a = a.to_f.round(IMPORT_DP)

      { r: r, g: g, b: b, a: a }
    end
  end
end
