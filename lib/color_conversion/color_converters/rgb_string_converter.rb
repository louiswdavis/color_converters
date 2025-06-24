module ColorConversion
  class RgbStringConverter < ColorConverter
    def self.matches?(color_input)
      return false unless color_input.is_a?(String)

      color_input.include?('rgb(') || color_input.include?('rgba(')
    end

    private

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
