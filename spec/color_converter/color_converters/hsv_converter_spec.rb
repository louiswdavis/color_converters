# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ColorConverter::HsvConverter do
  context 'methods' do
    it '.matches?' do
      expect(described_class.matches?(h: 225, s: 73, v: 57)).to be true
      expect(described_class.matches?(h: 225, s: 73, b: 57)).to be true
      expect(described_class.matches?(h: 225, s: 73, l: 57)).to be false
      expect(described_class.matches?('#ffffff')).to be false
    end

    it '.validate_input' do
      expect { described_class.new(h: -74, s: 135, v: 37) }.to raise_error(ColorConverter::InvalidColorError)
      expect { described_class.new(h: 74, s: -235, v: 37) }.to raise_error(ColorConverter::InvalidColorError)
      expect { described_class.new(h: 74, s: 35, v: -237) }.to raise_error(ColorConverter::InvalidColorError)
      expect { described_class.new(h: 474, s: 35, b: 117) }.to raise_error(ColorConverter::InvalidColorError)
      expect { described_class.new(h: 74, s: 435, b: 117) }.to raise_error(ColorConverter::InvalidColorError)
      expect { described_class.new(h: 74, s: 115, b: 437) }.to raise_error(ColorConverter::InvalidColorError)
    end

    it '.input_to_rgba' do
      expect(described_class.new(h: 220.0, s: 75, v: 80).rgba).to eq({ r: 51.0, g: 102.0, b: 204.0, a: 1.0 })
      expect(described_class.new(h: 220.0, s: 75, b: 80).rgba).to eq({ r: 51.0, g: 102.0, b: 204.0, a: 1.0 })

      expect(described_class.new(h: 220.0, s: 75, v: 80).rgba).to eq({ r: 51.0, g: 102.0, b: 204.0, a: 1.0 })
      expect(described_class.new(h: 220.0, s: 75, b: 80).rgba).to eq({ r: 51.0, g: 102.0, b: 204.0, a: 1.0 })
    end
  end
end
