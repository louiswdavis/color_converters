module ColorConverters
  class OklabConverter < BaseConverter
    def self.matches?(colour_input)
      return false unless colour_input.is_a?(Hash)

      colour_input.keys - [:l, :a, :b, :space] == [] && colour_input[:space].to_s == 'ok'
    end

    def self.bounds
      { l: [0.0, 100.0], a: [-0.5, 0.5], b: [-0.5, 0.5] }
    end

    private

    def validate_input(colour_input)
      bounds = OklabConverter.bounds
      colour_input[:l].to_f.between?(*bounds[:l]) && colour_input[:a].to_f.between?(*bounds[:a]) && colour_input[:b].to_f.between?(*bounds[:b])
    end

    def input_to_rgba(colour_input)
      x, y, z = OklabConverter.oklab_to_xyz(colour_input)
      r, g, b = XyzConverter.xyz_to_rgb({ x: x, y: y, z: z })

      [r, g, b, 1.0]
    end

    def self.oklab_to_xyz(colour_input)
      l = colour_input[:l].to_d
      a = colour_input[:a].to_d
      b = colour_input[:b].to_d

      # Now, scale l to a decimal
      l /= 100.0.to_d

      # Convert Oklab (L*a*b*) to LMS'
      lab_to_lms_matrix = ::Matrix[
        [1.0000000000000000.to_d, 0.3963377773761749.to_d,  0.2158037573099136.to_d],
        [1.0000000000000000.to_d, -0.1055613458156586.to_d, -0.0638541728258133.to_d],
        [1.0000000000000000.to_d, -0.0894841775298119.to_d, -1.2914855480194092.to_d]
      ]

      l_lms, m_lms, s_lms = (lab_to_lms_matrix * ::Matrix.column_vector([l, a, b])).to_a.flatten

      l_lms **= 3.to_d
      m_lms **= 3.to_d
      s_lms **= 3.to_d

      lms_to_xyz_matrix = ::Matrix[
        [1.2268798758459243.to_d, -0.5578149944602171.to_d, 0.2813910456659647.to_d],
        [-0.0405757452148008.to_d, 1.1122868032803170.to_d, -0.0717110580655164.to_d],
        [-0.0763729366746601.to_d, -0.4214933324022432.to_d, 1.5869240198367816.to_d]
      ]

      x, y, z = (lms_to_xyz_matrix * ::Matrix.column_vector([l_lms, m_lms, s_lms])).to_a.flatten

      x *= 100.0.to_d
      y *= 100.0.to_d
      z *= 100.0.to_d

      [x, y, z]
    end

    def self.xyz_to_oklab(xyz_array)
      x, y, z = xyz_array.map(&:to_d)

      # The transformation matrix expects normalised X, Y, Z values.
      x /= 100.0.to_d
      y /= 100.0.to_d
      z /= 100.0.to_d

      # Given XYZ relative to D65, convert to OKLab
      xyz_to_lms_matrix = ::Matrix[
        [0.8190224379967030.to_d, 0.3619062600528904.to_d, -0.1288737815209879.to_d],
        [0.0329836539323885.to_d, 0.9292868615863434.to_d, 0.0361446663506424.to_d],
        [0.0481771893596242.to_d, 0.2642395317527308.to_d, 0.6335478284694309.to_d]
      ]

      l_lms, m_lms, s_lms = (xyz_to_lms_matrix * ::Matrix.column_vector([x, y, z])).to_a.flatten

      l_lms **= (1.0.to_d / 3.0.to_d)
      m_lms **= (1.0.to_d / 3.0.to_d)
      s_lms **= (1.0.to_d / 3.0.to_d)

      lms_to_lab_matrix = ::Matrix[
        [0.2104542683093140.to_d, 0.7936177747023054.to_d, -0.0040720430116193.to_d],
        [1.9779985324311684.to_d, -2.4285922420485799.to_d, 0.4505937096174110.to_d],
        [0.0259040424655478.to_d, 0.7827717124575296.to_d, -0.8086757549230774.to_d]
      ]

      l_lab, a_lab, b_lab = (lms_to_lab_matrix * ::Matrix.column_vector([l_lms, m_lms, s_lms])).to_a.flatten

      # Now, scale l to a percentage
      l_lab *= 100.0.to_d

      [l_lab, a_lab, b_lab]
    end
  end
end
