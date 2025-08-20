# frozen_string_literal: true

RSpec.shared_examples 'custom_colour_conversions' do
  # Define these in your spec via `let`:
  # - `converter`: The converter class (e.g., `ColorConverters::RgbConverter`)
  # - `colour_space`: Symbol (e.g., `:rgb`, `:oklab`)

  # should really never be passed except maybe for OK space conversions
  let(:rounding_margin) { 0.0 } unless method_defined?(:rounding_margin)

  describe 'and' do
    it 'converts from rgb to colour space' do
      passed_colours.each_with_index do |passed_colour, index|
        check_rgb_converted_to_colour(colour_space, passed_colour, expected_rgbs[index], rounding_margin)
      end
    end

    it 'converts from colour space to rgb' do
      passed_colours.each_with_index do |passed_colour, index|
        check_colour_converted_to_rgb(colour_space, passed_colour, expected_rgbs[index], rounding_margin)
      end
    end
  end
end
