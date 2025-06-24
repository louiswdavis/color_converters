module ColorConversion
  class CmykConverter < ColorConverter
    def self.matches?(color_input)
      return false unless color_input.is_a?(Hash)

      color_input.keys - [:c, :m, :y, :k] == []
    end

    def self.bounds
      { c: [0.0, 100.0], m: [0.0, 100.0], y: [0.0, 100.0], k: [0.0, 100.0] }
    end

    private

    def validate_input(color_input)
      bounds = CmykConverter.bounds
      color_input[:c].to_f.between?(*bounds[:c]) && color_input[:m].to_f.between?(*bounds[:m]) && color_input[:y].to_f.between?(*bounds[:y]) && color_input[:k].to_f.between?(*bounds[:k])
    end

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

    def self.rgb_to_cmyk(rgb_array_frac)
      r, g, b = rgb_array_frac

      k = (1.0 - [r, g, b].max)
      k_frac = k == 1.0 ? 1.0 : 1.0 - k

      c = (1.0 - r - k) / k_frac
      m = (1.0 - g - k) / k_frac
      y = (1.0 - b - k) / k_frac

      c *= 100
      m *= 100
      y *= 100
      k *= 100

      [c, m, y, k]
    end
  end
end
