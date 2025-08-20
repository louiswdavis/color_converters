# frozen_string_literal: true

module ClassicColorConversionsHelper
  # check that when the known RGB value is converted to the colour space using the Converter, that it matches the fixtured value (that is assumed to be correct)
  def check_rgb_converted_to_colour(colour_space, fixture_colour, expected_rgb)
    if [:name, :hex].include?(colour_space)
      converted_colour = ColorConverters::Color.new(expected_rgb).send(colour_space)
      expect(converted_colour).to eq fixture_colour
    else
      converted_colour = ColorConverters::Color.new(**expected_rgb).send(colour_space)
      expect(converted_colour).to eq fixture_colour.except(:space)
    end
  end

  # check that when the fixtured colour space value (that is assumed to be correct) is converted to RGB, that it matches the known RGB value (with 0dp)
  def check_colour_converted_to_rgb(colour_space, fixture_colour, expected_rgb)
    if [:name, :hex].include?(colour_space)
      converted_rgb = ColorConverters::Color.new(fixture_colour).rgb
    else
      converted_rgb = ColorConverters::Color.new(**fixture_colour).rgb
    end

    expect(converted_rgb.transform_values { |v| v.round.to_f }).to eq expected_rgb
  end
end

RSpec.configure do |config|
  config.include ClassicColorConversionsHelper
end
