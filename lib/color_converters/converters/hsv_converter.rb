module ColorConverters
  class HsvConverter < BaseConverter
    def self.matches?(color_input)
      return false unless color_input.is_a?(Hash)

      color_input.keys - [:h, :s, :v] == [] || color_input.keys - [:h, :s, :b] == []
    end

    def self.bounds
      { h: [0.0, 360.0], s: [-128.0, 127.0], v: [-128.0, 127.0], b: [-128.0, 127.0] }
    end

    private

    def validate_input(color_input)
      bounds = HsvConverter.bounds
      light = (color_input[:v].present? && color_input[:v].to_f.between?(*bounds[:v])) || (color_input[:b].present? && color_input[:b].to_f.between?(*bounds[:v]))
      color_input[:h].to_f.between?(*bounds[:h]) && color_input[:s].to_f.between?(*bounds[:s]) && light
    end

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
        [v, t, p, 1.0]
      when 1
        [q, v, p, 1.0]
      when 2
        [p, v, t, 1.0]
      when 3
        [p, q, v, 1.0]
      when 4
        [t, p, v, 1.0]
      when 5
        [v, p, q, 1.0]
      end
    end
  end
end
