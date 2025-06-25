module ColorConverters
  class HexConverter < BaseConverter
    def self.matches?(color)
      return false unless color.is_a?(String)

      color.include?('#') && [4, 7, 9].include?(color.length)
    end

    private

    def validate_input(color_input)
      true
      # color_input[:l].to_f.between?(0.0, 100.0) && color_input[:a].between?(-128.0, 127.0) && color_input[:b].between?(-128.0, 127.0)
    end

    def input_to_rgba(color_input)
      color_input = self.normalize_hex(color_input)

      r = color_input[0, 2].hex
      g = color_input[2, 2].hex
      b = color_input[4, 2].hex
      a = color_input.length == 8 ? hex[6, 2].hex : 1.0

      { r: r, g: g, b: b, a: a }
    end

    def normalize_hex(hex_input)
      hex_input = hex_input.gsub('#', '')
      (hex_input.length == 3 ? hex_input[0, 1] * 2 + hex_input[1, 1] * 2 + hex_input[2, 1] * 2 : hex_input).downcase
    end
  end
end
