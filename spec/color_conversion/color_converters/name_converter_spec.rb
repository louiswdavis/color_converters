# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ColorConversion::NameConverter do
  context 'methods' do
    it '.matches?' do
      expect(described_class.matches?('blue')).to be true
      expect(described_class.matches?('RoyalBlue')).to be true
      expect(described_class.matches?('royalblue')).to be true
      expect(described_class.matches?('#ffffff')).to be false
    end

    it '.input_to_rgba' do
      expect(described_class.new('blue').rgba).to eq({ r: 0, g: 0, b: 255, a: 1.0 })
      expect { described_class.new('bluee').rgba }.to raise_error(ColorConversion::InvalidColorError)
    end
  end
end
