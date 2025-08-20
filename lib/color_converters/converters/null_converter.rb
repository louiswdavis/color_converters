# frozen_string_literal: true

module ColorConverters
  class NullConverter < BaseConverter
    def self.matches?(_colour_input)
      true
    end

    private

    def validate_input(_colour_input)
      false
    end

    def input_to_rgba(_colour_input)
      raise InvalidColorError
    end
  end
end
