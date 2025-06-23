module ColorConversion
  class NullConverter < ColorConverter
    def self.matches?(_color)
      true
    end

    private

    def to_rgba(_color)
      raise InvalidColorError
    end
  end
end
