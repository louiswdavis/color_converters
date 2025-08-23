# frozen_string_literal: true

module ColorConverters
  class NullConverter < BaseConverter
    def self.matches?(_colour_input)
      true
    end

    private

    def clamp_input(colour_input)
      colour_input
    end

    def validate_input(_colour_input)
      ['did not recognise colour input']
    end

    def input_to_rgba(_colour_input)
      raise InvalidColorError
    end
  end
end
