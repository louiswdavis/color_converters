module ColorConverters
  class OklabConverter < BaseConverter
    def self.matches?(color_input)
      return false unless color_input.is_a?(Hash)

      color_input.keys - [:l, :a, :b, :space] == [] && color_input[:space].to_s == 'ok'
    end

    def self.bounds
      { l: [0.0, 100.0], a: [-100.0, 100.0], b: [-100.0, 100.0] }
    end

    private

    def validate_input(color_input)
      bounds = OklabConverter.bounds
      color_input[:l].to_f.between?(*bounds[:l]) && color_input[:a].to_f.between?(*bounds[:a]) && color_input[:b].to_f.between?(*bounds[:b])
    end

    def input_to_rgba(color_input)
      r, g, b = OklabConverter.oklab_to_rgb(color_input)

      [r, g, b, 1.0]
    end

    def self.oklab_to_rgb(color_input)
      l = color_input[:l].to_f
      a = color_input[:a].to_f
      b = color_input[:b].to_f

      # Convert Oklab (L*a*b*) to LMS'
      l_lms = (1.0000000000 * l) + (0.3963377774 * a) + (0.2158037573 * b)
      m_lms = (1.0000000000 * l) + (-0.1055613458 * a) + (-0.0638541728 * b)
      s_lms = (1.0000000000 * l) + (-0.0894841775 * a) + (-1.2914855480 * b)

      l_lms **= 3
      m_lms **= 3
      s_lms **= 3

      # Convert LMS to linear RGB
      rr = (4.0767416621 * l_lms) + (-3.3077115913 * m_lms) + (0.2309699292 * s_lms)
      gg = (-1.2684380046 * l_lms) + (2.6097574011 * m_lms) + (-0.3413193965 * s_lms)
      bb = (-0.0041960863 * l_lms) + (-0.7034186147 * m_lms) + (1.7076147010 * s_lms)

      RgbConverter.lrgb_to_rgb([rr, gg, bb])
    end

    def self.rgb_to_oklab(rgb_array)
      rr, gg, bb = RgbConverter.rgb_to_lrgb(rgb_array)

      l_lms = (0.4122214708 * rr) + (0.5363325363 * gg) + (0.0514459929 * bb)
      m_lms = (0.2119034982 * rr) + (0.6806995451 * gg) + (0.1073969566 * bb)
      s_lms = (0.0883024619 * rr) + (0.2817188376 * gg) + (0.6299787005 * bb)

      l_lms **= (1.0 / 3.0)
      m_lms **= (1.0 / 3.0)
      s_lms **= (1.0 / 3.0)

      # Convert LMS' to Oklab (L*a*b*)
      l = (0.2104542553 * l_lms) + (0.7936177850 * m_lms) + (-0.0040720468 * s_lms)
      a = (1.9779984951 * l_lms) + (-2.4285922050 * m_lms) + (0.4505937099 * s_lms)
      b = (0.0259040371 * l_lms) + (-0.7827717662 * m_lms) + (-0.8086757660 * s_lms)

      # Now, scale l to a percentage
      l *= 100.0

      [l, a, b]
    end
  end
end
