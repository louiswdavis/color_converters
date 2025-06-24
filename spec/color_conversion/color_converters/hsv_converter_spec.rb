# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ColorConversion::HsvConverter do
  context 'methods' do
    it '.matches?' do
      expect(described_class.matches?(h: 225, s: 73, v: 57)).to be true
      expect(described_class.matches?(h: 225, s: 73, b: 57)).to be true
      expect(described_class.matches?(h: 225, s: 73, l: 57)).to be false
      expect(described_class.matches?('#ffffff')).to be false
    end

    it '.input_to_rgba' do
      expect(described_class.new(h: 220, s: 75, v: 80).rgba).to eq({ r: 51.0, g: 102.0, b: 204.0, a: 1.0 })
      expect(described_class.new(h: 220, s: 75, b: 80).rgba).to eq({ r: 51.0, g: 102.0, b: 204.0, a: 1.0 })
    end
  end
end
