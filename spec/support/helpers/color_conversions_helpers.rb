# frozen_string_literal: true

module ColorConversionsHelper
  # check that when the known RGB value is converted to the colour space using the Converter, that it matches the fixtured value (that is assumed to be correct)
  def check_rgb_converted_to_colour(colour_space, passed_colour, expected_rgb, rounding_margin = 0.0)
    if [:name, :hex].include?(colour_space)
      converted_colour = ColorConverters::Color.new(expected_rgb).send(colour_space)
      expect(converted_colour).to eq passed_colour
    else
      converted_colour = ColorConverters::Color.new(**expected_rgb).send(colour_space)

      if rounding_margin > 0
        converted_colour.each { |k, v| expect(v).to be_within(rounding_margin).of(passed_colour[k]) }
      else
        expect(converted_colour).to eq passed_colour.except(:space)
      end
    end
  end

  # check that when the fixtured colour space value (that is assumed to be correct) is converted to RGB, that it matches the known RGB value (with 0dp)
  def check_colour_converted_to_rgb(colour_space, passed_colour, expected_rgb, rounding_margin = 0.0)
    if [:name, :hex].include?(colour_space)
      converted_rgb = ColorConverters::Color.new(passed_colour).rgb
    else
      converted_rgb = ColorConverters::Color.new(**passed_colour).rgb
    end

    if rounding_margin > 0
      converted_rgb.transform_values { |v| v.round.to_f }.each { |k, v| expect(v).to be_within(rounding_margin).of(expected_rgb[k].round.to_f) }
    else
      expect(converted_rgb.transform_values { |v| v.round.to_f }).to eq(expected_rgb.transform_values { |v| v.round.to_f })
    end
  end
end

RSpec.configure do |config|
  config.include ColorConversionsHelper
end
