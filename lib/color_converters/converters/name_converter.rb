# frozen_string_literal: true

require 'color_swatch_collection'

module ColorConverters
  class NameConverter < BaseConverter
    def self.matches?(colour_input)
      return false unless colour_input.is_a?(String)

      !colour_input.include?('#') && !colour_input.include?('rgb') && !colour_input.include?('hsl')
    end

    def self.rgb_to_name(rgb_array, fuzzy = false)
      if fuzzy
        source_colour = ColorConverters::Color.new({ r: rgb_array[0], g: rgb_array[1], b: rgb_array[2] })

        collection_colours = []

        ::ColorSwatchCollection.list_collections.each do |collection_name|
          collection_colours += self.add_colour_distances_to_collection(Object.const_get("::ColorSwatchCollection::#{collection_name.capitalize}").colours, source_colour)
        end

        collection_colours.min_by { |swatch| swatch[:distance] }.dig(:name)
      else
        ::ColorSwatchCollection.get_from_hex(HexConverter.rgb_to_hex(rgb_array)).dig(:name)
      end
    end

    private

    # def clamp_input(colour_input)
    #   colour_input.each { |key, value| colour_input[key] = value.clamp(*CielchConverter.bounds[key]) }
    # end

    def validate_input(colour_input)
      self.class.match_name_from_palettes(colour_input).present? ? [] : ['name could not be found across colour collections']
    end

    def input_to_rgba(colour_input)
      found_colour = self.class.match_name_from_palettes(colour_input) || ''

      HexConverter.hex_to_rgba(found_colour) if found_colour.present?
    end

    # this is a checking for a direct naming match against the ColorSwatchCollection
    def self.match_name_from_palettes(colour_name)
      ::ColorSwatchCollection.get_from_name(colour_name).dig(:hex)
    end

    def self.add_colour_distances_to_collection(collection_colours, source_colour)
      collection_colours.map do |swatch|
        swatch[:distance] = self.distance_between_colours(ColorConverters::Color.new(swatch.dig(:hex)), source_colour)
      end

      collection_colours
    end

    def self.distance_between_colours(comparison_colour, source_colour)
      # https://en.wikipedia.org/wiki/Euclidean_distance#Higher_dimensions
      # https://www.baeldung.com/cs/compute-similarity-of-colours
      # TODO: allow the type of matching to be set via config. Use HSL for now as it's far faster than CIELab
      conversion_1 = comparison_colour.hsl
      conversion_2 = source_colour.hsl

      keys = conversion_1.keys
      Math.sqrt((conversion_1[keys[0]] - conversion_2[keys[0]])**2 + (conversion_1[keys[1]] - conversion_2[keys[1]])**2 + (conversion_1[keys[2]] - conversion_2[keys[2]])**2)
    end
  end
end
