module ColorConversion
  class NullConverter < ColorConverter
    def self.matches?(_color)
      true
    end

    private

    def input_to_rgba(_color)
      raise InvalidColorError
    end
  end
end
