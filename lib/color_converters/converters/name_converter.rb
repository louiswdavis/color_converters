# frozen_string_literal: true

require 'color_swatch_collection'

module ColorConverters
  class NameConverter < BaseConverter
    def self.matches?(colour_input)
      false unless colour_input.is_a?(String)

      !colour_input.include?('#') && !colour_input.include?('rgb') && !colour_input.include?('hsl')
    end

    def self.rgb_to_name(rgb_array)
      ::ColorSwatchCollection.get_from_hex(HexConverter.rgb_to_hex(rgb_array)).dig(:name)
    end

    private

    def validate_input(colour_input)
      self.class.match_name_from_palettes(colour_input).present?
    end

    def input_to_rgba(colour_input)
      found_colour = self.class.match_name_from_palettes(colour_input)

      raise InvalidColorError unless found_colour.present?

      HexConverter.hex_to_rgba(found_colour)
    end

    # this is a checking for a direct naming match against the ColorSwatchCollection
    def self.match_name_from_palettes(colour_name)
      ::ColorSwatchCollection.get_from_name(colour_name).dig(:hex)
    end
  end
end
