RSpec.shared_examples 'classic_color_conversions' do
  # Define these in your spec via `let`:
  # - `converter`: The converter class (e.g., `ColorConverters::RgbConverter`)
  # - `color_space`: Symbol (e.g., `:rgb`, `:oklab`)

  describe 'two-way conversions' do
    it 'converts black and back' do
      passed_color = black
      expected_rgb = { r: 0.0, g: 0.0, b: 0.0 }

      check_rgb_converted_to_color(color_space, passed_color, expected_rgb)
      check_color_converted_to_rgb(color_space, passed_color, expected_rgb)
    end

    it 'converts white and back' do
      passed_color = white
      expected_rgb = { r: 255.0, g: 255.0, b: 255.0 }

      check_rgb_converted_to_color(color_space, passed_color, expected_rgb)
      check_color_converted_to_rgb(color_space, passed_color, expected_rgb)
    end

    it 'converts red and back' do
      passed_color = red
      expected_rgb = { r: 255.0, g: 0.0, b: 0.0 }

      check_rgb_converted_to_color(color_space, passed_color, expected_rgb)
      check_color_converted_to_rgb(color_space, passed_color, expected_rgb)
    end

    it 'converts orange and back' do
      passed_color = orange
      expected_rgb = { r: 255.0, g: 127.0, b: 0.0 }

      check_rgb_converted_to_color(color_space, passed_color, expected_rgb)
      check_color_converted_to_rgb(color_space, passed_color, expected_rgb)
    end

    it 'converts yellow and back' do
      passed_color = yellow
      expected_rgb = { r: 255.0, g: 255.0, b: 0.0 }

      check_rgb_converted_to_color(color_space, passed_color, expected_rgb)
      check_color_converted_to_rgb(color_space, passed_color, expected_rgb)
    end

    it 'converts green and back' do
      passed_color = green
      expected_rgb = { r: 0.0, g: 255.0, b: 0.0 }

      check_rgb_converted_to_color(color_space, passed_color, expected_rgb)
      check_color_converted_to_rgb(color_space, passed_color, expected_rgb)
    end

    it 'converts blue and back' do
      passed_color = blue
      expected_rgb = { r: 0.0, g: 0.0, b: 255.0 }

      check_rgb_converted_to_color(color_space, passed_color, expected_rgb)
      check_color_converted_to_rgb(color_space, passed_color, expected_rgb)
    end

    it 'converts indigo and back' do
      passed_color = indigo
      expected_rgb = { r: 75.0, g: 0.0, b: 130.0 }

      check_rgb_converted_to_color(color_space, passed_color, expected_rgb)
      check_color_converted_to_rgb(color_space, passed_color, expected_rgb)
    end

    it 'converts violet and back' do
      passed_color = violet
      expected_rgb = { r: 148.0, g: 0.0, b: 211.0 }

      check_rgb_converted_to_color(color_space, passed_color, expected_rgb)
      check_color_converted_to_rgb(color_space, passed_color, expected_rgb)
    end
  end
end

RSpec.shared_examples 'custom_color_conversions' do
  # Define these in your spec via `let`:
  # - `converter`: The converter class (e.g., `ColorConverters::RgbConverter`)
  # - `color_space`: Symbol (e.g., `:rgb`, `:oklab`)

  # describe 'two-way conversions' do
  #   it 'converts the passed color and back' do
  #     passed_colors.each_with_index do |passed_color, index|
  #       expected_rgb = sample_colors[index]
  #       passed_rgb = ColorConverters::Color.new(**passed_color).rgb

  #       ColorConverters::Color.new(**expected_rgb).send(color_space).each { |key, value| expect(passed_color[key]).to be_within(rounding_margin).of value }
  #       passed_rgb.each { |key, value| expect(expected_rgb[key]).to be_within(rounding_margin).of value }
  #     end
  #   end
  # end
end
