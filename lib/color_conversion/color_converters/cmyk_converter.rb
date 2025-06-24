module ColorConversion
  class CmykConverter < ColorConverter
    def self.matches?(color_input)
      return false unless color_input.is_a?(Hash)

      color_input.keys - [:c, :m, :y, :k] == []
    end

    def rgb_to_cmyk
    end

    private

    def input_to_rgba(color_input)
      c = color_input[:c].to_f
      m = color_input[:m].to_f
      y = color_input[:y].to_f
      k = color_input[:k].to_f

      c /= 100.0
      m /= 100.0
      y /= 100.0
      k /= 100.0

      r = (255 * (1.0 - [1.0, c * (1.0 - k) + k].min)).round(IMPORT_DP)
      g = (255 * (1.0 - [1.0, m * (1.0 - k) + k].min)).round(IMPORT_DP)
      b = (255 * (1.0 - [1.0, y * (1.0 - k) + k].min)).round(IMPORT_DP)

      { r: r, g: g, b: b, a: 1.0 }
    end
  end
end
