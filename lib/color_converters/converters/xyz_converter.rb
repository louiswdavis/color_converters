module ColorConverters
  class XyzConverter < BaseConverter
    def self.matches?(color_input)
      return false unless color_input.is_a?(Hash)

      color_input.keys - [:x, :y, :z] == []
    end

    def self.bounds
      { x: [0.0, 95.047], y: [0.0, 100.0], z: [0.0, 108.883] }
    end

    private

    def validate_input(color_input)
      bounds = XyzConverter.bounds
      color_input[:x].to_f.between?(*bounds[:x]) && color_input[:y].to_f.between?(*bounds[:y]) && color_input[:z].to_f.between?(*bounds[:z])
    end

    def input_to_rgba(color_input)
      r, g, b = XyzConverter.xyz_to_rgb(color_input)

      { r: r.round(IMPORT_DP), g: g.round(IMPORT_DP), b: b.round(IMPORT_DP), a: 1.0 }
    end

    def self.xyz_to_rgb(xyz_hash)
      # Convert XYZ (typically with Y=100 for white) to normalized XYZ (Y=1 for white).
      # The transformation matrix expects X, Y, Z values in the 0-1 range.
      x = xyz_hash[:x].to_f / 100.0
      y = xyz_hash[:y].to_f / 100.0
      z = xyz_hash[:z].to_f / 100.0

      # Convert normalized XYZ to Linear sRGB values using sRGB's own white, D65 (no chromatic adaptation)
      # https://www.w3.org/TR/css-color-4/#color-conversion-code
      conversion_matrix = ::Matrix[
        [3.2409699419045213, -1.5373831775700935, -0.4986107602930033],
        [-0.9692436362808798, 1.8759675015077206, 0.04155505740717561],
        [0.05563007969699361, -0.20397695888897657, 1.0569715142428786]
      ]

      rgb_matrix = ::Matrix[[x, y, z]] * conversion_matrix

      rr = rgb_matrix[0, 0]
      gg = rgb_matrix[0, 1]
      bb = rgb_matrix[0, 2]

      RgbConverter.lrgb_to_rgb([rr, gg, bb])
    end

    # http://www.brucelindbloom.com/index.html?Eqn_RGB_to_XYZ.html
    def self.rgb_to_xyz(rgb_array)
      rr, gg, bb = RgbConverter.rgb_to_lrgb(rgb_array)

      # Convert using the RGB/XYZ matrix and sRGB's own white, D65 (no chromatic adaptation)
      # https://www.w3.org/TR/css-color-4/#color-conversion-code
      conversion_matrix = ::Matrix[
        [0.4123907992659595, 0.35758433938387796, 0.1804807884018343],
        [0.21263900587151036, 0.7151686787677559, 0.07219231536073371],
        [0.01933081871559185, 0.11919477979462599, 0.9505321522496606]
      ]

      xyz_matrix = ::Matrix[[rr, gg, bb]] * conversion_matrix

      x = xyz_matrix[0, 0]
      y = xyz_matrix[0, 1]
      z = xyz_matrix[0, 2]

      # Now, scale X, Y, Z so that Y for D65 white would be 100.
      x *= 100.0
      y *= 100.0
      z *= 100.0

      # Clamping XYZ values to prevent out-of-gamut issues and numerical errors and ensures these values stay within the valid and expected range.
      x = x.clamp(0.0..95.047)
      y = y.clamp(0.0..100.0)
      z = z.clamp(0.0..108.883)

      [x, y, z]
    end

    def self.d50_to_d65(xyz_array)
      x, y, z = xyz_array

      matrix = ::Matrix[
        [0.955473421488075, -0.02309845494876471, 0.06325924320057072],
        [-0.0283697093338637, 1.0099953980813041, 0.021041441191917323],
        [0.012314014864481998, -0.020507649298898964, 1.330365926242124]
      ]

      ::Matrix[[x, y, z]] * matrix
    end

    def self.d65_to_d50(xyz_array)
      x, y, z = xyz_array

      matrix = ::Matrix[
        [1.0479297925449969, 0.022946870601609652, -0.05019226628920524],
        [0.02962780877005599, 0.9904344267538799, -0.017073799063418826],
        [-0.009243040646204504, 0.015055191490298152, 0.7518742814281371]
      ]

      ::Matrix[[x, y, z]] * matrix
    end
  end
end
