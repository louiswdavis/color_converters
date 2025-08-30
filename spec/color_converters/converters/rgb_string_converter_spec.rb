# frozen_string_literal: true

RSpec.describe ColorConverters::RgbStringConverter do
  context 'methods' do
    it '.matches?' do
      expect(described_class.matches?('rgb(51, 102, 204)')).to be true
      expect(described_class.matches?('rgba(51, 102, 204, 0.2)')).to be true
      expect(described_class.matches?(r: 51, g: 102, b: 204)).to be false
    end

    it '.validate_input' do
      expect { described_class.new('rgb()') }.to raise_error(ColorConverters::InvalidColorError, 'Invalid color input: r must be present, g must be present, b must be present')
      expect { described_class.new('rgb(451, 102, 204)') }.to raise_error(ColorConverters::InvalidColorError, 'Invalid color input: r must be between 0.0 and 255.0')
      expect { described_class.new('rgb(151, 402, 204)') }.to raise_error(ColorConverters::InvalidColorError, 'Invalid color input: g must be between 0.0 and 255.0')
      expect { described_class.new('rgb(151, 102, 404)') }.to raise_error(ColorConverters::InvalidColorError, 'Invalid color input: b must be between 0.0 and 255.0')
      expect { described_class.new('rgb(151, 102, 204, 1.5)') }.to raise_error(ColorConverters::InvalidColorError, 'Invalid color input: a must be between 0.0 and 1.0') # TODO: permit alpha only for the correct string

      expect { described_class.new('rgba(foo)') }.to raise_error(ColorConverters::InvalidColorError, 'Invalid color input: r must be present, g must be present, b must be present, a must be present')
      expect { described_class.new('rgba(451, 102, 204, 0.5)') }.to raise_error(ColorConverters::InvalidColorError, 'Invalid color input: r must be between 0.0 and 255.0')
      expect { described_class.new('rgba(151, 402, 204, 0.5)') }.to raise_error(ColorConverters::InvalidColorError, 'Invalid color input: g must be between 0.0 and 255.0')
      expect { described_class.new('rgba(151, 102, 404, 0.5)') }.to raise_error(ColorConverters::InvalidColorError, 'Invalid color input: b must be between 0.0 and 255.0')
      expect { described_class.new('rgba(151, 102, 204, 1.5)') }.to raise_error(ColorConverters::InvalidColorError, 'Invalid color input: a must be between 0.0 and 1.0')
    end

    it '.input_to_rgba for strings' do
      expect(described_class.new('rgb(51, 102, 204)').rgba).to eq({ r: 51, g: 102, b: 204, a: 1.0 })
      expect(described_class.new('rgba(51, 102, 204, 0.5)').rgba).to eq({ r: 51, g: 102, b: 204, a: 0.5 })

      expect(described_class.new('rgb(51, 102, 204, 0.5)').rgba).to eq({ r: 51, g: 102, b: 204, a: 0.5 }) # TODO: permit alpha only for the correct string
    end

    it 'options' do
      colour_input = 'rgb(451, 102, 204)'

      expect { described_class.new(colour_input) }.to raise_error(ColorConverters::InvalidColorError)
      expect { described_class.new(colour_input, limit_override: true) }.not_to raise_error
      # expect { described_class.new(colour_input, limit_clamp: true) }.not_to raise_error

      expect(described_class.new(colour_input, limit_override: true).rgba).to eq({ r: 451.0, g: 102.0, b: 204.0, a: 1.0 })
      expect(described_class.new(colour_input, limit_override: true).rgb).to eq({ r: 451.0, g: 102.0, b: 204.0 })

      # expect(described_class.new(colour_input, limit_clamp: true).rgba).to eq({ r: 255.0, g: 234.1313178, b: 215.40997709, a: 1.0 })
      # expect(described_class.new(colour_input, limit_clamp: true).rgb).to eq({ l: 93.93, a: 4.11, b: 11.65 })
    end
  end
end
