# frozen_string_literal: true

require 'spec_helper'

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
  end
end
