# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ColorConverters::XyzConverter do
  context 'methods' do
    it '.matches?' do
      expect(described_class.matches?(x: 24, y: 15, z: 57)).to be true
      expect(described_class.matches?(x: 24, y: 15, b: 57)).to be false
      expect(described_class.matches?(x: 24, y: 15, z: 32, b: 57)).to be false
      expect(described_class.matches?('#ffffff')).to be false
    end

    it '.validate_input' do
      expect { described_class.new(x: 174, y: 35, z: 37) }.to raise_error(ColorConverters::InvalidColorError)
      expect { described_class.new(x: 74, y: 135, z: 37) }.to raise_error(ColorConverters::InvalidColorError)
      expect { described_class.new(x: 74, y: 35, z: 137) }.to raise_error(ColorConverters::InvalidColorError)
    end

    it '.input_to_rgba' do
      expect(described_class.new(x: 17.01, y: 14.56, z: 59.03).rgba).to eq({ r: 51.01, g: 101.98, b: 203.98, a: 1.0 })
      expect(described_class.new(x: '17.01', y: '14.56', z: '59.03').rgba).to eq({ r: 51.01, g: 101.98, b: 203.98, a: 1.0 })

      expect(described_class.new(x: 24, y: 15, z: 57).rgba).to eq({ r: 140.19, g: 76.1, b: 201.18, a: 1.0 })
      expect(described_class.new(x: '24', y: '15', z: '57').rgba).to eq({ r: 140.19, g: 76.1, b: 201.18, a: 1.0 })
    end

    it '.input_to_rgba and back' do
      xyz = { x: 23.94, y: 14.96, z: 56.87 }
      rgba = { r: 140.02, g: 75.98, b: 200.97, a: 1.0 }
      color = described_class.new(**xyz)
      expect(color.xyz).to eq xyz
      expect(color.rgba).to eq rgba

      xyz = { x: 16.69, y: 14.84, z: 52.43 }
      rgba = { r: 64.05, g: 103.99, b: 192.99, a: 1.0 }
      color = described_class.new(**xyz)
      expect(color.xyz).to eq xyz
      expect(color.rgba).to eq rgba

      xyz = { x: 95.04, y: 100.0, z: 108.88 }
      rgba = { r: 254.99, g: 255.0, b: 254.97, a: 1.0 }
      color = described_class.new(**xyz)
      expect(color.xyz).to eq xyz
      expect(color.rgba).to eq rgba

      xyz = { x: 0.0, y: 0.0, z: 0.0 }
      rgba = { r: 0, g: 0, b: 0, a: 1.0 }
      color = described_class.new(**xyz)
      expect(color.xyz).to eq xyz
      expect(color.rgba).to eq rgba
    end
  end
end
