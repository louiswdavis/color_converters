# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ColorConversion::RgbConverter do
  context 'methods' do
    it '.matches?' do
      expect(described_class.matches?(r: 51, g: 102, b: 204)).to be true
      expect(described_class.matches?(r: 51, g: 102, b: 204, a: 0.5)).to be true
      expect(described_class.matches?(h: 225, s: 73, v: 57)).to be false
      expect(described_class.matches?('#ffffff')).to be false
    end

    it '.input_to_rgba' do
      expect(described_class.new(r: 51, g: 102, b: 204).rgba).to eq({ r: 51, g: 102, b: 204, a: 1.0 })
      expect(described_class.new(r: 51, g: 102, b: 204, a: 0.5).rgba).to eq({ r: 51, g: 102, b: 204, a: 0.5 })
      expect(described_class.new(r: '51', g: '102', b: '204', a: '0.5').rgba).to eq({ r: 51, g: 102, b: 204, a: 0.5 })
    end
  end
end
