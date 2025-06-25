# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ColorConverter::HslConverter do
  context 'methods' do
    it '.matches?' do
      expect(described_class.matches?(h: 225, s: 73, l: 57)).to be true
      expect(described_class.matches?(h: 225, s: 73, l: 57, a: 0.5)).to be true
      expect(described_class.matches?(h: 225, s: 73, v: 57)).to be false
      expect(described_class.matches?('#ffffff')).to be false
    end

    it '.validate_input' do
      expect { described_class.new(h: 374, s: 35, l: 37) }.to raise_error(ColorConverter::InvalidColorError)
      expect { described_class.new(h: 74, s: 135, l: 37) }.to raise_error(ColorConverter::InvalidColorError)
      expect { described_class.new(h: 74, s: 35, l: 137) }.to raise_error(ColorConverter::InvalidColorError)
    end

    it '.input_to_rgba' do
      expect(described_class.new(h: 220.0, s: 60, l: 50).rgba).to eq({ r: 51.0, g: 102.0, b: 204.0, a: 1.0 })
      expect(described_class.new(h: '220.0', s: '60', l: '50').rgba).to eq({ r: 51.0, g: 102.0, b: 204.0, a: 1.0 })

      expect(described_class.new(h: 225, s: 73, l: 57).rgba).to eq({ r: 65.31, g: 105.33, b: 225.39, a: 1.0 })
      expect(described_class.new(h: 225, s: 73, l: 57, a: 0.5).rgba).to eq({ r: 65.31, g: 105.33, b: 225.39, a: 0.5 })

      expect(described_class.new(h: '225', s: '73%', l: '57%', a: '0.5').rgba).to eq({ r: 65.31, g: 105.33, b: 225.39, a: 0.5 })
      expect(described_class.new(h: '225', s: '0%', l: '20%', a: '0.5').rgba).to eq({ r: 51.0, g: 51.0, b: 51.0, a: 0.5 })
    end
  end
end
