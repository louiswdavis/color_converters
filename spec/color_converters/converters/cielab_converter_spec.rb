# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ColorConverters::CielabConverter do
  context 'methods' do
    it '.matches?' do
      expect(described_class.matches?(l: 74, a: 35, b: 37, space: 'cie')).to be true
      expect(described_class.matches?(l: 74, a: 35, b: 37)).to be false
      expect(described_class.matches?(l: 74, a: 35, z: 37)).to be false
      expect(described_class.matches?('#ffffff')).to be false
    end

    it '.validate_input' do
      expect { described_class.new(l: 274, a: 35, b: 37, space: :cie) }.to raise_error(ColorConverters::InvalidColorError)
      expect { described_class.new(l: 74, a: 235, b: 37, space: :cie) }.to raise_error(ColorConverters::InvalidColorError)
      expect { described_class.new(l: 74, a: 35, b: 237, space: :cie) }.to raise_error(ColorConverters::InvalidColorError)
    end

    it '.input_to_rgba' do
      expect(described_class.new(l: 33.673, a: 15.512, b: -47.284, space: :cie).rgba).to eq({ r: 36.70, g: 75.53, b: 154.83, a: 1.0 })
      expect(described_class.new(l: '33.673', a: '15.512', b: '-47.284', space: 'cie').rgba).to eq({ r: 36.70, g: 75.53, b: 154.83, a: 1.0 })
    end

    it '.input_to_rgba and back' do
      cielab = { l: 73.53, a: 33.54, b: 36.33 }
      rgba = { r: 255.00, g: 155.03, b: 115.80, a: 1.0 }
      color = described_class.new(**cielab, space: 'cie')
      expect(color.cielab).to eq cielab
      expect(color.rgba).to eq rgba

      cielab = { l: 44.65, a: 6.92, b: -41.48 }
      rgba = { r: 59.90, g: 105.73, b: 174.72, a: 1.0 }
      color = described_class.new(**cielab, space: 'cie')
      expect(color.cielab).to eq({ l: 44.65, a: 6.92, b: -41.47 }) # rounding on b
      expect(color.rgba).to eq rgba

      cielab = { l: 100.0, a: 0.0, b: 0.0 }
      rgba = { r: 255, g: 255, b: 254.97, a: 1.0 }
      color = described_class.new(**cielab, space: 'cie')
      expect(color.cielab).to eq({ l: 100.0, a: -0.01, b: 0.01 }) # rounding
      expect(color.rgba).to eq rgba

      cielab = { l: 0.0, a: 0.0, b: 0.0 }
      rgba = { r: 0, g: 0, b: 0, a: 1.0 }
      color = described_class.new(**cielab, space: 'cie')
      expect(color.cielab).to eq cielab
      expect(color.rgba).to eq rgba

      cielab = { l: 45.02, a: 36.11, b: -44.37 }
      rgba = { r: 126.02, g: 86.75, b: 181.17, a: 1.0 }
      color = described_class.new(**cielab, space: 'cie')
      expect(color.cielab).to eq({ l: 45.02, a: 36.11, b: -44.36 }) # rounding on b
      expect(color.rgba).to eq rgba
    end

    it '.input_to_rgba and exceeds the xyz bound, so is changed back to a different value' do
      cielab_1 = { l: 100.00, a: 70.637, b: -25.362 }
      cielab_2 = { l: 86.67, a: 28.98, b: -19.80 }
      xyz = { x: 80, y: 69, z: 104 }
      rgba = { r: 255, g: 199, b: 255, a: 1.0 }

      color = described_class.new(**cielab_1, space: 'cie')
      expect(color.cielab).not_to eq cielab_1
      expect(color.cielab).to eq cielab_2
      expect(color.xyz.transform_values(&:round)).to eq xyz
      expect(color.rgba.transform_values(&:round)).to eq rgba

      color = described_class.new(**cielab_2, space: 'cie')
      expect(color.cielab).not_to eq cielab_1
      expect(color.cielab).to eq({ l: 86.67, a: 28.98, b: -19.79 }) # rounding on b
      expect(color.xyz.transform_values(&:round)).to eq xyz
      expect(color.rgba.transform_values(&:round)).to eq rgba
    end
  end
end
