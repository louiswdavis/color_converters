# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ColorConversion::CmykConverter do
  context 'methods' do
    it '.matches?' do
      expect(described_class.matches?(c: 87, m: 69, y: 13, k: 1)).to be true
      expect(described_class.matches?(h: 225, s: 73, v: 57)).to be false
      expect(described_class.matches?('#ffffff')).to be false
    end

    it '.input_to_rgba' do
      expect(described_class.new(c: 74, m: 58, y: 22, k: 3).rgba).to eq({ r: 64.31, g: 103.89, b: 192.93, a: 1.0 })
      expect(described_class.new(c: '74', m: '58', y: '22', k: '3').rgba).to eq({ r: 64.31, g: 103.89, b: 192.93, a: 1.0 })
    end
  end
end
