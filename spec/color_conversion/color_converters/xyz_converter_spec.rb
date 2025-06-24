# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ColorConversion::XyzConverter do
  context 'methods' do
    it '.matches?' do
      expect(described_class.matches?(x: 24, y: 15, z: 57)).to be true
      expect(described_class.matches?(x: 24, y: 15, b: 57)).to be false
      expect(described_class.matches?(x: 24, y: 15, z: 32, b: 57)).to be false
      expect(described_class.matches?('#ffffff')).to be false
    end

    it '.input_to_rgba' do
      expect(described_class.new(x: 24, y: 15, z: 57).rgba).to eq({ r: 140.18, g: 76.1, b: 201.2, a: 1.0 })
      expect(described_class.new(x: '24', y: '15', z: '57').rgba).to eq({ r: 140.18, g: 76.1, b: 201.2, a: 1.0 })
    end

    it '.input_to_rgba and back' do
      xyz = { x: 23.94, y: 14.96, z: 56.87 }
      rgba = { r: 140.01, g: 75.98, b: 200.99, a: 1.0 }
      conv = described_class.new(**xyz)
      expect(conv.xyz).to eq xyz
      expect(conv.rgba).to eq rgba

      xyz = { x: 16.69, y: 14.84, z: 52.43 }
      rgba = { r: 64.04, g: 103.99, b: 193.01, a: 1.0 }
      conv = described_class.new(**xyz)
      expect(conv.xyz).to eq xyz
      expect(conv.rgba).to eq rgba

      xyz = { x: 95.05, y: 100.0, z: 108.88 }
      rgba = { r: 255, g: 255, b: 255, a: 1.0 }
      conv = described_class.new(**xyz)
      expect(conv.xyz).to eq xyz
      expect(conv.rgba).to eq rgba

      xyz = { x: 0.0, y: 0.0, z: 0.0 }
      rgba = { r: 0, g: 0, b: 0, a: 1.0 }
      conv = described_class.new(**xyz)
      expect(conv.xyz).to eq xyz
      expect(conv.rgba).to eq rgba
    end
  end
end
