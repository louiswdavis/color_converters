# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ColorConverters::OklchConverter do
  context 'methods' do
    it '.matches?' do
      expect(described_class.matches?(l: 74, c: 35, h: 37, space: 'ok')).to be true
      expect(described_class.matches?(l: 74, c: 35, h: 37)).to be false
      expect(described_class.matches?(l: 74, c: 35, z: 37)).to be false
      expect(described_class.matches?('#ffffff')).to be false
    end

    it '.validate_input' do
      expect { described_class.new(l: 174, c: 35, h: 37, space: :ok) }.to raise_error(ColorConverters::InvalidColorError)
      expect { described_class.new(l: 74, c: -135, h: 37, space: :ok) }.to raise_error(ColorConverters::InvalidColorError)
      expect { described_class.new(l: 74, c: 35, h: 437, space: :ok) }.to raise_error(ColorConverters::InvalidColorError)
    end

    it '.input_to_rgba' do
      expect(described_class.new(l: 45.03, c: 60.80, h: 287.92, space: :ok).rgba).to eq({ r: 50.99, g: 102.0, b: 203.99, a: 1.0 })
      expect(described_class.new(l: '45.03', c: '60.80', h: '287.92', space: 'ok').rgba).to eq({ r: 50.99, g: 102.0, b: 203.99, a: 1.0 })

      expect(described_class.new(l: 33.673, c: 15.512, h: 47.284, space: :ok).rgba).to eq({ r: 101.25, g: 72.70, b: 61.67, a: 1.0 })
      expect(described_class.new(l: '33.673', c: '15.512', h: '47.284', space: 'ok').rgba).to eq({ r: 101.25, g: 72.70, b: 61.67, a: 1.0 })
    end

    it '.input_to_rgba and back' do
      oklch = { l: 73.53, c: 33.54, h: 36.31 }
      rgba = { r: 238.99, g: 161.19, b: 145.69, a: 1.0 }
      color = described_class.new(**oklch)
      expect(color.oklch).to eq oklch
      expect(color.rgba).to eq rgba

      oklch = { l: 44.65, c: 6.91, h: 41.47 }
      rgba = { r: 117.45, g: 102.46, b: 98.22, a: 1.0 }
      color = described_class.new(**oklch)
      expect(color.oklch).to eq oklch
      expect(color.rgba).to eq rgba

      oklch = { l: 100.0, c: 0.0, h: 0.0 }
      rgba = { r: 255, g: 255, b: 255, a: 1.0 }
      color = described_class.new(**oklch)
      expect(color.oklch).to eq oklch
      expect(color.rgba).to eq rgba

      oklch = { l: 0.0, c: 0.0, h: 0.0 }
      rgba = { r: 0, g: 0, b: 0, a: 1.0 }
      color = described_class.new(**oklch)
      expect(color.oklch).to eq oklch
      expect(color.rgba).to eq rgba

      oklch = { l: 45.02, c: 60.80, h: 287.92 }
      rgba = { r: 50.95, g: 101.97, b: 203.96, a: 1.0 }
      color = described_class.new(**oklch)
      expect(color.oklch).to eq oklch
      expect(color.rgba).to eq rgba
    end

    it '.input_to_rgba and exceeds the xyz bound, so is changed back to a different value' do
      oklch_1 = { l: 100.00, c: 70.637, h: 25.362 }
      oklch_2 = { l: 85.55, c: 20.64, h: 22.57 }
      xyz = { x: 72, y: 67, z: 64 }
      rgba = { r: 255, g: 201, b: 200, a: 1.0 }

      color = described_class.new(**oklch_1)
      expect(color.oklch).not_to eq oklch_1
      expect(color.oklch).to eq oklch_2
      expect(color.xyz.transform_values(&:round)).to eq xyz
      expect(color.rgba.transform_values(&:round)).to eq rgba

      color = described_class.new(**oklch_2)
      expect(color.oklch).not_to eq oklch_1
      expect(color.oklch).to eq oklch_2
      expect(color.xyz.transform_values(&:round)).to eq xyz
      expect(color.rgba.transform_values(&:round)).to eq rgba
    end
  end
end
