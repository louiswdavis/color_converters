module ColorConverter
  class NullConverter < BaseConverter
    def self.matches?(_color_input)
      true
    end

    private

    def validate_input(_color_input)
      false
    end

    def input_to_rgba(_color_input)
      raise InvalidColorError
    end
  end
end
