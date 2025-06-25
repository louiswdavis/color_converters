# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ColorConverters::NameConverter do
  context 'methods' do
    it '.matches?' do
      expect(described_class.matches?('blue')).to be true
      expect(described_class.matches?('RoyalBlue')).to be true
      expect(described_class.matches?('royalblue')).to be true
      expect(described_class.matches?('#ffffff')).to be false
    end

    # it '.validate_input' do
    #   expect { described_class.new(l: 74, a: 35, b: 37) }.to raise_error(ColorConverters::InvalidColorError)
    #   expect { described_class.new(l: 74, a: 35, b: 37) }.to raise_error(ColorConverters::InvalidColorError)
    #   expect { described_class.new(l: 74, a: 35, b: 37) }.to raise_error(ColorConverters::InvalidColorError)
    # end

    it '.input_to_rgba' do
      expect(described_class.new('blue').rgba).to eq({ r: 0, g: 0, b: 255, a: 1.0 })
      expect { described_class.new('bluee') }.to raise_error(ColorConverters::InvalidColorError)
    end
  end
end
