# frozen_string_literal: true

require 'spec_helper'

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
      colour_input = { l: 174, c: 35, h: 37, space: :cie }

      expect { described_class.new(**colour_input) }.to raise_error(ColorConverters::InvalidColorError)
      expect { described_class.new(**colour_input, limit_override: true) }.not_to raise_error(ColorConverters::InvalidColorError)
      expect { described_class.new(**colour_input, limit_clamp: true) }.not_to raise_error(ColorConverters::InvalidColorError)

      expect(described_class.new(**colour_input, limit_override: true).rgba).to eq({ r: 255.0, g: 255.0, b: 255.0, a: 1.0 })
      expect(described_class.new(**colour_input, limit_override: true).cielab).to eq({ l: 100.0, a: 0.0, b: 0.0 })

      expect(described_class.new(**colour_input, limit_clamp: true).rgba).to eq({ r: 255.0, g: 234.1313178, b: 215.40997709, a: 1.0 })
      expect(described_class.new(**colour_input, limit_clamp: true).cielab).to eq({ l: 93.93, a: 4.11, b: 11.65 })
    end
  end
end
