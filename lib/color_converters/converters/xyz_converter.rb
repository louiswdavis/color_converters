# frozen_string_literal: true

module ColorConverters
  class XyzConverter < BaseConverter
    def self.matches?(colour_input)
      return false unless colour_input.is_a?(Hash)

      colour_input.keys - [:x, :y, :z] == []
    end

    def self.bounds
      { x: [0.0, 100.0], y: [0.0, 100.0], z: [0.0, 110.0] }
    end

    def self.d65
      { x: 95.047, y: 100.0, z: 108.883 }
    end

    private

    # def clamp_input(colour_input)
    #   colour_input.each { |key, value| colour_input[key] = value.clamp(*XyzConverter.bounds[key]) }
    # end

    def validate_input(colour_input)
      XyzConverter.bounds.collect do |key, range|
        "#{key} must be between #{range[0]} and #{range[1]}" unless colour_input[key].to_f.between?(*range)
      end.compact
    end

    def input_to_rgba(colour_input)
      r, g, b = XyzConverter.xyz_to_rgb(colour_input)

      [r, g, b, 1.0]
    end

    def self.xyz_to_rgb(xyz_hash)
      # [0, 100]
      x = xyz_hash[:x].to_d
      y = xyz_hash[:y].to_d
      z = xyz_hash[:z].to_d

      # Convert XYZ (typically with Y=100 for white) to normalized XYZ (Y=1 for white).
      # The transformation matrix expects X, Y, Z values in the 0-1 range.
      x /= 100.0.to_d
      y /= 100.0.to_d
      z /= 100.0.to_d

      # Convert normalized XYZ to Linear sRGB values using sRGB's own white, D65 (no chromatic adaptation)
      # https://www.w3.org/TR/css-color-4/#color-conversion-code
      conversion_matrix = ::Matrix[
        [BigDecimal('3.2409699419045213'), BigDecimal('-1.5373831775700935'), BigDecimal('-0.4986107602930033')],
        [BigDecimal('-0.9692436362808798'), BigDecimal('1.8759675015077206'), BigDecimal('0.04155505740717561')],
        [BigDecimal('0.05563007969699361'), BigDecimal('-0.20397695888897657'), BigDecimal('1.0569715142428786')]
      ]

      rr, gg, bb = (conversion_matrix * ::Matrix.column_vector([x, y, z])).to_a.flatten

      # [0, 1]
      RgbConverter.lrgb_to_rgb([rr, gg, bb])
    end

    # http://www.brucelindbloom.com/index.html?Eqn_RGB_to_XYZ.html
    def self.rgb_to_xyz(rgb_array_frac)
      rr, gg, bb = RgbConverter.rgb_to_lrgb(rgb_array_frac)

      # Convert using the RGB/XYZ matrix and sRGB's own white, D65 (no chromatic adaptation)
      # https://www.w3.org/TR/css-color-4/#color-conversion-code
      conversion_matrix = ::Matrix[
        [BigDecimal('0.4123907992659595'), BigDecimal('0.35758433938387796'), BigDecimal('0.1804807884018343')],
        [BigDecimal('0.21263900587151036'), BigDecimal('0.7151686787677559'), BigDecimal('0.07219231536073371')],
        [BigDecimal('0.01933081871559185'), BigDecimal('0.11919477979462599'), BigDecimal('0.9505321522496606')]
      ]

      x, y, z = (conversion_matrix * ::Matrix.column_vector([rr, gg, bb])).to_a.flatten

      # Now, scale X, Y, Z so that Y for D65 white would be 100.
      x *= 100.0
      y *= 100.0
      z *= 100.0

      # Clamping XYZ values to prevent out-of-gamut issues and numerical errors and ensures these values stay within the valid and expected range.
      # x = x.clamp(0.0..95.047)
      # y = y.clamp(0.0..100.0)
      # z = z.clamp(0.0..108.883)

      [x, y, z]
    end

    def self.d50_to_d65(xyz_array)
      x, y, z = xyz_array

      conversion_matrix = ::Matrix[
        [BigDecimal('0.955473421488075'), BigDecimal('-0.02309845494876471'), BigDecimal('0.06325924320057072')],
        [BigDecimal('-0.0283697093338637'), BigDecimal('1.0099953980813041'), BigDecimal('0.021041441191917323')],
        [BigDecimal('0.012314014864481998'), BigDecimal('-0.020507649298898964'), BigDecimal('1.330365926242124')]
      ]

      (conversion_matrix * ::Matrix.column_vector([x, y, z])).to_a.flatten
    end

    def self.d65_to_d50(xyz_array)
      x, y, z = xyz_array

      conversion_matrix = ::Matrix[
        [BigDecimal('1.0479297925449969'), BigDecimal('0.022946870601609652'), BigDecimal('-0.05019226628920524')],
        [BigDecimal('0.02962780877005599'), BigDecimal('0.9904344267538799'), BigDecimal('-0.017073799063418826')],
        [BigDecimal('-0.009243040646204504'), BigDecimal('0.015055191490298152'), BigDecimal('0.7518742814281371')]
      ]

      (conversion_matrix * ::Matrix.column_vector([x, y, z])).to_a.flatten
    end
  end
end
