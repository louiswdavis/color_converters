# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ColorConverter::CmykConverter do
  context 'methods' do
    it '.matches?' do
      expect(described_class.matches?(c: 87, m: 69, y: 13, k: 1)).to be true
      expect(described_class.matches?(h: 225, s: 73, v: 57)).to be false
      expect(described_class.matches?('#ffffff')).to be false
    end

    it '.validate_input' do
      expect { described_class.new(c: 187, m: 69, y: 13, k: 41) }.to raise_error(ColorConverter::InvalidColorError)
      expect { described_class.new(c: 87, m: -69, y: 13, k: 41) }.to raise_error(ColorConverter::InvalidColorError)
      expect { described_class.new(c: 87, m: 69, y: 213, k: 41) }.to raise_error(ColorConverter::InvalidColorError)
      expect { described_class.new(c: 87, m: 69, y: 13, k: 141) }.to raise_error(ColorConverter::InvalidColorError)
    end

    it '.input_to_rgba' do
      expect(described_class.new(c: 75, m: 50, y: 0, k: 20).rgba).to eq({ r: 51, g: 102, b: 204, a: 1.0 })
      expect(described_class.new(c: '75', m: '50', y: '0', k: '20').rgba).to eq({ r: 51, g: 102, b: 204, a: 1.0 })

      expect(described_class.new(c: 74, m: 58, y: 22, k: 3).rgba).to eq({ r: 64.31, g: 103.89, b: 192.93, a: 1.0 })
      expect(described_class.new(c: '74', m: '58', y: '22', k: '3').rgba).to eq({ r: 64.31, g: 103.89, b: 192.93, a: 1.0 })
    end
  end
end
