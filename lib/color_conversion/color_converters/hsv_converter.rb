module ColorConversion
  class HsvConverter < ColorConverter
    def self.matches?(color_input)
      return false unless color_input.is_a?(Hash)

      color_input.keys - [:h, :s, :v] == [] || color_input.keys - [:h, :s, :b] == []
    end

    def rgb_to_hsv
    end

    private

    def input_to_rgba(color_input)
      h = color_input[:h].to_f
      s = color_input[:s].to_f
      v = (color_input[:v] || color_input[:b]).to_f

      h /= 360
      s /= 100
      v /= 100

      i = (h * 6).floor
      f = h * 6 - i

      p = v * (1 - s)
      q = v * (1 - f * s)
      t = v * (1 - (1 - f) * s)

      p = (p * 255).round(IMPORT_DP)
      q = (q * 255).round(IMPORT_DP)
      t = (t * 255).round(IMPORT_DP)
      v = (v * 255).round(IMPORT_DP)

      case i % 6
      when 0
        { r: v, g: t, b: p, a: 1.0 }
      when 1
        { r: q, g: v, b: p, a: 1.0 }
      when 2
        { r: p, g: v, b: t, a: 1.0 }
      when 3
        { r: p, g: q, b: v, a: 1.0 }
      when 4
        { r: t, g: p, b: v, a: 1.0 }
      when 5
        { r: v, g: p, b: q, a: 1.0 }
      end
    end

    def hsv_to_rgba
    end
  end
end
