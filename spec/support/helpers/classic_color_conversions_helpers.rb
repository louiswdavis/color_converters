module ClassicColorConversionsHelper
  # check that when the known RGB value is converted to the color space using the Converter, that it matches the fixtured value (that is assumed to be correct)
  def check_rgb_converted_to_color(color_space, fixture_color, expected_rgb)
    if [:name, :hex].include?(color_space)
      converted_color = ColorConverters::Color.new(expected_rgb).send(color_space)
      expect(converted_color).to eq fixture_color
    else
      converted_color = ColorConverters::Color.new(**expected_rgb).send(color_space)
      expect(converted_color).to eq fixture_color.except(:space)
    end
  end

  # check that when the fixtured color space value (that is assumed to be correct) is converted to RGB, that it matches the known RGB value (with 0dp)
  def check_color_converted_to_rgb(color_space, fixture_color, expected_rgb)
    if [:name, :hex].include?(color_space)
      converted_rgb = ColorConverters::Color.new(fixture_color).rgb
    else
      converted_rgb = ColorConverters::Color.new(**fixture_color).rgb
    end

    expect(converted_rgb.transform_values(&:round)).to eq expected_rgb
  end
end

RSpec.configure do |config|
  config.include ClassicColorConversionsHelper
end
