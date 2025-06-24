module ColorConversion
  class HslConverter < ColorConverter
    def self.matches?(color_input)
      return false unless color_input.is_a?(Hash)

      color_input.keys - [:h, :s, :l] == [] || color_input.keys - [:h, :s, :l, :a] == []
    end

    def self.bounds
      { h: [0.0, 360.0], s: [0.0, 100.0], l: [0.0, 100.0] }
    end

    private

    def validate_input(color_input)
      bounds = HslConverter.bounds
      color_input[:h].to_f.between?(*bounds[:h]) && color_input[:s].to_f.between?(*bounds[:s]) && color_input[:l].to_f.between?(*bounds[:l])
    end

    def input_to_rgba(color_input)
      h = color_input[:h].to_s.gsub(/[^0-9.]/, '').to_f / 360.0
      s = color_input[:s].to_s.gsub(/[^0-9.]/, '').to_f / 100.0
      l = color_input[:l].to_s.gsub(/[^0-9.]/, '').to_f / 100.0
      a = color_input[:a] ? color_input[:a].to_s.gsub(/[^0-9.]/, '').to_f : 1.0

      return greyscale(l, a) if s.zero?

      t2 = if l < 0.5
             l * (1 + s)
           else
             l + s - l * s
           end

      t1 = 2 * l - t2

      rgb = [0, 0, 0]

      (0..2).each do |i|
        t3 = h + 1 / 3.0 * - (i - 1)
        t3 < 0 && t3 += 1
        t3 > 1 && t3 -= 1

        val = if 6 * t3 < 1
                t1 + (t2 - t1) * 6 * t3
              elsif 2 * t3 < 1
                t2
              elsif 3 * t3 < 2
                t1 + (t2 - t1) * (2 / 3.0 - t3) * 6
              else
                t1
              end

        rgb[i] = (val * 255).round(IMPORT_DP)
      end

      { r: rgb[0], g: rgb[1], b: rgb[2], a: a }
    end

    def greyscale(luminosity, alpha)
      rgb_equal_value = (luminosity * 255).round(IMPORT_DP)
      { r: rgb_equal_value, g: rgb_equal_value, b: rgb_equal_value, a: alpha }
    end
  end
end
