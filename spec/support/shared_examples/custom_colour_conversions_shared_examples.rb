# frozen_string_literal: true

RSpec.shared_examples 'custom_colour_conversions' do
  # Define these in your spec via `let`:
  # - `converter`: The converter class (e.g., `ColorConverters::RgbConverter`)
  # - `colour_space`: Symbol (e.g., `:rgb`, `:oklab`)

  describe 'two-way conversions' do
    it 'converts colours from colour space to rgb' do
      passed_colours.each_with_index do |passed_colour, index|
        expected_rgb = sample_colours[index]
        passed_rgb = ColorConverters::Color.new(**passed_colour).rgb

        ColorConverters::Color.new(**expected_rgb).send(colour_space).each { |key, value| expect(passed_colour[key]).to be_within(rounding_margin).of value }
        passed_rgb.each { |key, value| expect(expected_rgb[key]).to be_within(rounding_margin).of value }
      end
    end

    it 'converts rgb to colours in colour space' do
      passed_colours.each_with_index do |passed_colour, index|
        expected_rgb = sample_colours[index]
        passed_rgb = ColorConverters::Color.new(**passed_colour).rgb

        ColorConverters::Color.new(**expected_rgb).send(colour_space).each { |key, value| expect(passed_colour[key]).to be_within(rounding_margin).of value }
        passed_rgb.each { |key, value| expect(expected_rgb[key]).to be_within(rounding_margin).of value }
      end
    end
  end
end
