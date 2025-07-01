# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ColorConverters::CielchConverter do
  context 'methods' do
    it '.matches?' do
      expect(described_class.matches?(l: 74, c: 35, h: 37, space: 'cie')).to be true
      expect(described_class.matches?(l: 74, c: 35, h: 37)).to be false
      expect(described_class.matches?(l: 74, c: 35, z: 37)).to be false
      expect(described_class.matches?('#ffffff')).to be false
    end

    it '.validate_input' do
      expect { described_class.new(l: 174, c: 35, h: 37, space: :cie) }.to raise_error(ColorConverters::InvalidColorError)
      expect { described_class.new(l: 74, c: 135, h: 37, space: :cie) }.to raise_error(ColorConverters::InvalidColorError)
      expect { described_class.new(l: 74, c: 35, h: 437, space: :cie) }.to raise_error(ColorConverters::InvalidColorError)
    end

    it '.input_to_rgba' do
      expect(described_class.new(l: 45.03, c: 60.80, h: 287.92, space: :cie).rgba).to eq({ r: 50.99, g: 102.0, b: 203.97, a: 1.0 })
      expect(described_class.new(l: '45.03', c: '60.80', h: '287.92', space: 'cie').rgba).to eq({ r: 50.99, g: 102.0, b: 203.97, a: 1.0 })

      expect(described_class.new(l: 33.673, c: 15.512, h: 47.284, space: :cie).rgba).to eq({ r: 101.26, g: 72.70, b: 61.66, a: 1.0 })
      expect(described_class.new(l: '33.673', c: '15.512', h: '47.284', space: 'cie').rgba).to eq({ r: 101.26, g: 72.70, b: 61.66, a: 1.0 })
    end

    it '.input_to_rgba and back' do
      cielch = { l: 73.53, c: 33.59, h: 36.34 }
      rgba = { r: 239.07, g: 161.17, b: 145.60, a: 1.0 }
      color = described_class.new(**cielch)
      expect(color.cielch).to eq({ l: 73.53, c: 33.59, h: 36.35 }) # rounding on h
      expect(color.rgba).to eq rgba

      cielch = { l: 44.65, c: 6.92, h: 41.51 }
      rgba = { r: 117.47, g: 102.46, b: 98.19, a: 1.0 }
      color = described_class.new(**cielch)
      expect(color.cielch).to eq({ l: 44.65, c: 6.93, h: 41.58 }) # rounding on h
      expect(color.rgba).to eq rgba

      cielch = { l: 100.0, c: 0.0, h: 0.0 }
      rgba = { r: 255, g: 255, b: 254.97, a: 1.0 }
      color = described_class.new(**cielch)
      expect(color.cielch).to eq({ l: 100.0, c: 0.02, h: 110.18 }) # slight rounding somewhere in reverse conversions
      expect(color.rgba).to eq rgba

      cielch = { l: 0.0, c: 0.0, h: 0.0 }
      rgba = { r: 0, g: 0, b: 0, a: 1.0 }
      color = described_class.new(**cielch)
      expect(color.cielch).to eq cielch
      expect(color.rgba).to eq rgba

      cielch = { l: 45.02, c: 60.79, h: 287.93 }
      rgba = { r: 51.04, g: 101.97, b: 203.92, a: 1.0 }
      color = described_class.new(**cielch)
      expect(color.cielch).to eq({ l: 45.02, c: 60.78, h: 287.93 })
      expect(color.rgba).to eq rgba
    end

    it '.input_to_rgba and exceeds the xyz bound, so is changed back to a different value' do
      cielch_1 = { l: 100.00, c: 70.637, h: 25.362 }
      cielch_2 = { l: 85.55, c: 20.64, h: 22.63 }
      xyz = { x: 72, y: 67, z: 64 }
      rgba = { r: 255, g: 201, b: 200, a: 1.0 }

      color = described_class.new(**cielch_1)
      expect(color.cielch).not_to eq cielch_1
      expect(color.cielch).to eq({ l: 85.55, c: 20.64, h: 22.60 }) # rounding on h (is cielch_2)
      expect(color.xyz.transform_values(&:round)).to eq xyz
      expect(color.rgba.transform_values(&:round)).to eq rgba

      color = described_class.new(**cielch_2)
      expect(color.cielch).not_to eq cielch_1
      expect(color.cielch).to eq({ l: 85.55, c: 20.64, h: 22.67 }) # rounding on h
      expect(color.xyz.transform_values(&:round)).to eq xyz
      expect(color.rgba.transform_values(&:round)).to eq rgba
    end
  end
end
