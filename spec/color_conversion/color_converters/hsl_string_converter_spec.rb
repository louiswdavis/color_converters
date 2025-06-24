# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ColorConversion::HslStringConverter do
  context 'methods' do
    it '.matches?' do
      expect(described_class.matches?('hsl(225, 73%, 57%)')).to be true
      expect(described_class.matches?('hsla(225, 73%, 57%, 0.5)')).to be true
      expect(described_class.matches?(h: 225, s: 73, l: 57)).to be false
    end

    it '.input_to_rgba' do
      expect(described_class.new('hsl(225, 73%, 57%)').rgba).to eq({ r: 65.31, g: 105.33, b: 225.39, a: 1.0 })
      expect(described_class.new('hsla(225, 73%, 57%, 0.5)').rgba).to eq({ r: 65.31, g: 105.33, b: 225.39, a: 0.5 })
    end
  end
end
