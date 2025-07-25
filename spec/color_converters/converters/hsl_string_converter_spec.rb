# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ColorConverters::HslStringConverter do
  context 'methods' do
    it '.matches?' do
      expect(described_class.matches?('hsl(225, 73%, 57%)')).to be true
      expect(described_class.matches?('hsla(225, 73%, 57%, 0.5)')).to be true
      expect(described_class.matches?(h: 225, s: 73, l: 57)).to be false
    end

    # it '.validate_input' do
    #   expect { described_class.new(l: 74, a: 35, b: 37) }.to raise_error(ColorConverters::InvalidColorError)
    #   expect { described_class.new(l: 74, a: 35, b: 37) }.to raise_error(ColorConverters::InvalidColorError)
    #   expect { described_class.new(l: 74, a: 35, b: 37) }.to raise_error(ColorConverters::InvalidColorError)
    # end

    it '.input_to_rgba' do
      expect(described_class.new('hsl(225, 73%, 57%)').rgba).to eq({ r: 65.31, g: 105.33, b: 225.39, a: 1.0 })
      expect(described_class.new('hsla(225, 73%, 57%, 0.5)').rgba).to eq({ r: 65.31, g: 105.33, b: 225.39, a: 0.5 })

      expect { described_class.new('hsl(51, 102)').rgba }.to raise_error(ColorConverters::InvalidColorError)
      expect { described_class.new('hsla(foo)').rgba }.to raise_error(ColorConverters::InvalidColorError)
    end
  end
end
