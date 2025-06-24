module ColorConversion
  class RgbConverter < ColorConverter
    def self.matches?(color_input)
      return false unless color_input.is_a?(Hash)

      color_input.keys - [:r, :g, :b] == [] || color_input.keys - [:r, :g, :b, :a] == []
    end

    def self.bounds
      { r: [0.0, 255.0], g: [0.0, 255.0], b: [0.0, 255.0] }
    end

    private

    def validate_input(color_input)
      bounds = RgbConverter.bounds
      color_input[:r].to_f.between?(*bounds[:r]) && color_input[:g].to_f.between?(*bounds[:g]) && color_input[:b].to_f.between?(*bounds[:b])
    end

    def input_to_rgba(color_input)
      r = color_input[:r].to_f
      g = color_input[:g].to_f
      b = color_input[:b].to_f
      a = (color_input[:a] || 1.0).to_f

      { r: r.round(IMPORT_DP), g: g.round(IMPORT_DP), b: b.round(IMPORT_DP), a: a.round(IMPORT_DP) }
    end
  end
end
