# frozen_string_literal: true

RSpec.shared_examples 'classic_colour_conversions' do
  # Define these in your spec via `let`:
  # - `converter`: The converter class (e.g., `ColorConverters::RgbConverter`)
  # - `colour_space`: Symbol (e.g., `:rgb`, `:oklab`)

  # should really never be passed except maybe for OK space conversions
  let(:rounding_margin) { 0.0 } unless method_defined?(:rounding_margin)

  # the expected_rgb values are all hard-coded here to keep them independent from the fixture file value

  describe 'and' do
    context 'converts black' do
      it 'from rgb to colour space' do
        check_rgb_converted_to_colour(colour_space, black, { r: 0.0, g: 0.0, b: 0.0 })
      end

      it 'from colour space to rgb' do
        check_colour_converted_to_rgb(colour_space, black, { r: 0.0, g: 0.0, b: 0.0 })
      end
    end

    context 'converts white' do
      it 'from rgb to colour space' do
        check_rgb_converted_to_colour(colour_space, white, { r: 255.0, g: 255.0, b: 255.0 })
      end

      it 'from colour space to rgb' do
        check_colour_converted_to_rgb(colour_space, white, { r: 255.0, g: 255.0, b: 255.0 })
      end
    end

    context 'converts black' do
      it 'from rgb to colour space' do
        check_rgb_converted_to_colour(colour_space, red, { r: 255.0, g: 0.0, b: 0.0 })
      end

      it 'from colour space to rgb' do
        check_colour_converted_to_rgb(colour_space, red, { r: 255.0, g: 0.0, b: 0.0 })
      end
    end

    context 'converts orange' do
      it 'from rgb to colour space' do
        check_rgb_converted_to_colour(colour_space, orange, { r: 255.0, g: 127.0, b: 0.0 })
      end

      it 'from colour space to rgb' do
        check_colour_converted_to_rgb(colour_space, orange, { r: 255.0, g: 127.0, b: 0.0 })
      end
    end

    context 'converts yellow' do
      it 'from rgb to colour space' do
        check_rgb_converted_to_colour(colour_space, yellow, { r: 255.0, g: 255.0, b: 0.0 })
      end

      it 'from colour space to rgb' do
        check_colour_converted_to_rgb(colour_space, yellow, { r: 255.0, g: 255.0, b: 0.0 })
      end
    end

    context 'converts green' do
      it 'from rgb to colour space' do
        check_rgb_converted_to_colour(colour_space, green, { r: 0.0, g: 255.0, b: 0.0 })
      end

      it 'from colour space to rgb' do
        check_colour_converted_to_rgb(colour_space, green, { r: 0.0, g: 255.0, b: 0.0 })
      end
    end

    context 'converts blue' do
      it 'from rgb to colour space' do
        check_rgb_converted_to_colour(colour_space, blue, { r: 0.0, g: 0.0, b: 255.0 })
      end

      it 'from colour space to rgb' do
        check_colour_converted_to_rgb(colour_space, blue, { r: 0.0, g: 0.0, b: 255.0 })
      end
    end

    context 'converts indigo' do
      it 'from rgb to colour space' do
        check_rgb_converted_to_colour(colour_space, indigo, { r: 75.0, g: 0.0, b: 130.0 })
      end

      it 'from colour space to rgb' do
        check_colour_converted_to_rgb(colour_space, indigo, { r: 75.0, g: 0.0, b: 130.0 })
      end
    end

    context 'converts violet' do
      it 'from rgb to colour space' do
        check_rgb_converted_to_colour(colour_space, violet, { r: 148.0, g: 0.0, b: 211.0 })
      end

      it 'from colour space to rgb' do
        check_colour_converted_to_rgb(colour_space, violet, { r: 148.0, g: 0.0, b: 211.0 })
      end
    end
  end
end
