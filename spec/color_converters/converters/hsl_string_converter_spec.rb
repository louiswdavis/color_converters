# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ColorConverters::HslStringConverter do
  context 'methods' do
    it '.matches?' do
      expect(described_class.matches?('hsl(225, 73%, 57%)')).to be true
      expect(described_class.matches?('hsla(225, 73%, 57%, 0.5)')).to be true
      expect(described_class.matches?('hsl(225, 73%, 57%, 0.5)')).to be true
      expect(described_class.matches?('hsla(225, 73%, 57%)')).to be true
      expect(described_class.matches?(h: 225, s: 73, l: 57)).to be false
    end

    it '.validate_input' do
      expect { described_class.new('hsl()') }.to raise_error(ColorConverters::InvalidColorError, 'Invalid color input: h must be present, s must be present, l must be present')
      expect { described_class.new('hsl(425, 73%, 57%)') }.to raise_error(ColorConverters::InvalidColorError, 'Invalid color input: h must be between 0.0 and 360.0')
      expect { described_class.new('hsl(25, 173%, 57%)') }.to raise_error(ColorConverters::InvalidColorError, 'Invalid color input: s must be between 0.0 and 100.0')
      expect { described_class.new('hsl(25, 73%, 157%)') }.to raise_error(ColorConverters::InvalidColorError, 'Invalid color input: l must be between 0.0 and 100.0')
      expect { described_class.new('hsl(25, 73%, 57%, 1.5)') }.to raise_error(ColorConverters::InvalidColorError, 'Invalid color input: a must be between 0.0 and 1.0') # TODO: permit alpha only for the correct string

      expect { described_class.new('hsla(foo)') }.to raise_error(ColorConverters::InvalidColorError, 'Invalid color input: h must be present, s must be present, l must be present, a must be present')
      expect { described_class.new('hsla(425, 73%, 57%, 0.5)') }.to raise_error(ColorConverters::InvalidColorError, 'Invalid color input: h must be between 0.0 and 360.0')
      expect { described_class.new('hsla(25, 173%, 57%, 0.5)') }.to raise_error(ColorConverters::InvalidColorError, 'Invalid color input: s must be between 0.0 and 100.0')
      expect { described_class.new('hsla(25, 73%, 157%, 0.5)') }.to raise_error(ColorConverters::InvalidColorError, 'Invalid color input: l must be between 0.0 and 100.0')
      expect { described_class.new('hsla(225, 73%, 57%, 1.5)') }.to raise_error(ColorConverters::InvalidColorError, 'Invalid color input: a must be between 0.0 and 1.0')
    end

    it '.input_to_rgba for strings' do
      expect(described_class.new('hsl(225, 73%, 57%)').rgba).to eq({ r: 65.3055, g: 105.32775, b: 225.3945, a: 1.0 })
      expect(described_class.new('hsla(225, 73%, 57%, 0.5)').rgba).to eq({ r: 65.3055, g: 105.32775, b: 225.3945, a: 0.5 })

      expect(described_class.new('hsl(225, 73%, 57%, 0.5)').rgba).to eq({ r: 65.3055, g: 105.32775, b: 225.3945, a: 0.5 }) # TODO: permit alpha only for the correct string
    end
  end
end
