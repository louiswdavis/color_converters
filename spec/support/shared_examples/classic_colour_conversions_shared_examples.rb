RSpec.shared_examples 'classic_colour_conversions' do
  # Define these in your spec via `let`:
  # - `converter`: The converter class (e.g., `ColorConverters::RgbConverter`)
  # - `colour_space`: Symbol (e.g., `:rgb`, `:oklab`)

  describe 'two-way conversions' do
    it 'converts black and back' do
      passed_colour = black
      expected_rgb = { r: 0.0, g: 0.0, b: 0.0 }

      check_rgb_converted_to_colour(colour_space, passed_colour, expected_rgb)
      check_colour_converted_to_rgb(colour_space, passed_colour, expected_rgb)
    end

    it 'converts white and back' do
      passed_colour = white
      expected_rgb = { r: 255.0, g: 255.0, b: 255.0 }

      check_rgb_converted_to_colour(colour_space, passed_colour, expected_rgb)
      check_colour_converted_to_rgb(colour_space, passed_colour, expected_rgb)
    end

    it 'converts red and back' do
      passed_colour = red
      expected_rgb = { r: 255.0, g: 0.0, b: 0.0 }

      check_rgb_converted_to_colour(colour_space, passed_colour, expected_rgb)
      check_colour_converted_to_rgb(colour_space, passed_colour, expected_rgb)
    end

    it 'converts orange and back' do
      passed_colour = orange
      expected_rgb = { r: 255.0, g: 127.0, b: 0.0 }

      check_rgb_converted_to_colour(colour_space, passed_colour, expected_rgb)
      check_colour_converted_to_rgb(colour_space, passed_colour, expected_rgb)
    end

    it 'converts yellow and back' do
      passed_colour = yellow
      expected_rgb = { r: 255.0, g: 255.0, b: 0.0 }

      check_rgb_converted_to_colour(colour_space, passed_colour, expected_rgb)
      check_colour_converted_to_rgb(colour_space, passed_colour, expected_rgb)
    end

    it 'converts green and back' do
      passed_colour = green
      expected_rgb = { r: 0.0, g: 255.0, b: 0.0 }

      check_rgb_converted_to_colour(colour_space, passed_colour, expected_rgb)
      check_colour_converted_to_rgb(colour_space, passed_colour, expected_rgb)
    end

    it 'converts blue and back' do
      passed_colour = blue
      expected_rgb = { r: 0.0, g: 0.0, b: 255.0 }

      check_rgb_converted_to_colour(colour_space, passed_colour, expected_rgb)
      check_colour_converted_to_rgb(colour_space, passed_colour, expected_rgb)
    end

    it 'converts indigo and back' do
      passed_colour = indigo
      expected_rgb = { r: 75.0, g: 0.0, b: 130.0 }

      check_rgb_converted_to_colour(colour_space, passed_colour, expected_rgb)
      check_colour_converted_to_rgb(colour_space, passed_colour, expected_rgb)
    end

    it 'converts violet and back' do
      passed_colour = violet
      expected_rgb = { r: 148.0, g: 0.0, b: 211.0 }

      check_rgb_converted_to_colour(colour_space, passed_colour, expected_rgb)
      check_colour_converted_to_rgb(colour_space, passed_colour, expected_rgb)
    end
  end
end

RSpec.shared_examples 'custom_colour_conversions' do
  # Define these in your spec via `let`:
  # - `converter`: The converter class (e.g., `ColorConverters::RgbConverter`)
  # - `colour_space`: Symbol (e.g., `:rgb`, `:oklab`)

  # describe 'two-way conversions' do
  #   it 'converts the passed colour and back' do
  #     passed_colours.each_with_index do |passed_colour, index|
  #       expected_rgb = sample_colours[index]
  #       passed_rgb = ColorConverters::Color.new(**passed_colour).rgb

  #       ColorConverters::Color.new(**expected_rgb).send(colour_space).each { |key, value| expect(passed_colour[key]).to be_within(rounding_margin).of value }
  #       passed_rgb.each { |key, value| expect(expected_rgb[key]).to be_within(rounding_margin).of value }
  #     end
  #   end
  # end
end
