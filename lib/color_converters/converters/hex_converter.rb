# frozen_string_literal: true

module ColorConverters
  class HexConverter < BaseConverter
    def self.matches?(colour)
      return false unless colour.is_a?(String)

      colour.include?('#') && [4, 7, 9].include?(colour.length)
    end

    private

    def validate_input(_colour_input)
      # TODO
      true
    end

    def input_to_rgba(colour_input)
      HexConverter.hex_to_rgba(colour_input)
    end

    def self.hex_to_rgba(hex_input)
      hex_input = self.normalize_hex(hex_input)

      r = hex_input[0, 2].hex
      g = hex_input[2, 2].hex
      b = hex_input[4, 2].hex
      a = hex_input.length == 8 ? hex[6, 2].hex : 1.0

      [r, g, b, a]
    end

    def self.rgb_to_hex(rgb_array)
      r, g, b = rgb_array

      format('#%<r>02x%<g>02x%<b>02x', r: r, g: g, b: b)
    end

    def self.normalize_hex(hex_input)
      hex_input = hex_input.gsub('#', '')

      (hex_input.length == 3 ? hex_input[0, 1] * 2 + hex_input[1, 1] * 2 + hex_input[2, 1] * 2 : hex_input).downcase
    end
  end
end
