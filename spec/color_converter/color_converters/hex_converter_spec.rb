# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ColorConverter::HexConverter do
  context 'methods' do
    it '.matches?' do
      expect(described_class.matches?('#FFFFFF')).to be true
      expect(described_class.matches?('#FFF')).to be true
      expect(described_class.matches?('#ffffff')).to be true
      expect(described_class.matches?('#asdf')).to be false
      expect(described_class.matches?(c: 87, m: 69, y: 13, k: 1)).to be false
      expect(described_class.matches?(h: 225, s: 73, v: 57)).to be false
    end

    # it '.validate_input' do
    #   expect { described_class.new(l: 74, a: 35, b: 37) }.to raise_error(ColorConverter::InvalidColorError)
    #   expect { described_class.new(l: 74, a: 35, b: 37) }.to raise_error(ColorConverter::InvalidColorError)
    #   expect { described_class.new(l: 74, a: 35, b: 37) }.to raise_error(ColorConverter::InvalidColorError)
    # end

    it '.input_to_rgba' do
      expect(described_class.new('#3366cc').rgba).to eq({ r: 51, g: 102, b: 204, a: 1.0 })
      expect(described_class.new('#36c').rgba).to eq({ r: 51, g: 102, b: 204, a: 1.0 })
    end
  end
end
