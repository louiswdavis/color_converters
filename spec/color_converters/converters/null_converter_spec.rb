# frozen_string_literal: true

RSpec.describe ColorConverters::NullConverter do
  context 'methods' do
    it '.matches?' do
      expect(described_class.matches?('blue')).to be true
      expect(described_class.matches?(r: 51, g: 102, b: 204)).to be true
    end

    it '.validate_input' do
      expect { described_class.new(l: 74, a: 35, b: 37) }.to raise_error(ColorConverters::InvalidColorError, 'Invalid color input: did not recognise colour input')
    end

    it 'options' do
      colour_input = { l: 74, a: 35, b: 37 }

      # still need to return an error for this converter type as it's the major fallback
      expect { described_class.new(colour_input) }.to raise_error(ColorConverters::InvalidColorError)
      expect { described_class.new(colour_input, limit_override: true) }.to raise_error(ColorConverters::InvalidColorError)
      # expect { described_class.new(colour_input, limit_clamp: true) }.not_to raise_error
    end
  end
end
