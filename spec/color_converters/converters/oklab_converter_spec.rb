# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ColorConverters::OklabConverter do
  context 'methods' do
    it '.matches?' do
      expect(described_class.matches?(l: 74, a: 0.0, b: 0.0, space: 'ok')).to be true
      expect(described_class.matches?(l: 74, a: 0.0, b: 0.0)).to be false
      expect(described_class.matches?(l: 74, a: 0.0, z: 0.0)).to be false
      expect(described_class.matches?('#ffffff')).to be false
    end

    it '.validate_input' do
      expect { described_class.new(l: 274, a: 0.2, b: -0.1, space: :ok) }.to raise_error(ColorConverters::InvalidColorError)
      expect { described_class.new(l: 74, a: 1.2, b: -0.1, space: :ok) }.to raise_error(ColorConverters::InvalidColorError)
      expect { described_class.new(l: 74, a: 0.2, b: -1.1, space: :ok) }.to raise_error(ColorConverters::InvalidColorError)
    end

    it '.input_to_rgba' do
      expect(described_class.new(l: 33.673, a: 0.2, b: -0.1, space: :ok).rgba).to eq({ r: 5.29, g: 0.0, b: 4.28, a: 1.0 })
      expect(described_class.new(l: '33.673', a: '0.2', b: '-0.1', space: 'ok').rgba).to eq({ r: 5.29, g: 0.0, b: 4.28, a: 1.0 })
    end

    it '.input_to_rgba and back' do
      oklab = { l: 100.0, a: 0.0, b: 0.0 }
      rgba = { r: 255, g: 255, b: 255, a: 1.0 }
      color = described_class.new(**oklab, space: 'ok')
      expect(color.oklab).to eq oklab
      expect(color.rgba).to eq rgba

      oklab = { l: 0.0, a: 0.0, b: 0.0 }
      rgba = { r: 0, g: 0, b: 0, a: 1.0 }
      color = described_class.new(**oklab, space: 'ok')
      expect(color.oklab).to eq oklab
      expect(color.rgba).to eq rgba

      oklab = { l: 63.53, a: 0.24, b: 0.11 }
      rgba = { r: 254.99, g: 155.04, b: 115.85, a: 1.0 }
      color = described_class.new(**oklab, space: 'ok')
      expect(color.oklab).to eq oklab
      expect(color.rgba).to eq rgba

      oklab = { l: 44.65, a: 0.21, b: -0.5 }
      rgba = { r: 59.80, g: 105.74, b: 174.77, a: 1.0 }
      color = described_class.new(**oklab, space: 'ok')
      expect(color.oklab).to eq oklab
      expect(color.rgba).to eq rgba

      oklab = { l: 96.78, a: -0.076, b: -0.123 }
      rgba = { r: 59.80, g: 105.74, b: 174.77, a: 1.0 }
      color = described_class.new(**oklab, space: 'ok')
      expect(color.oklab).to eq oklab
      expect(color.rgba).to eq rgba

      oklab = { l: 45.02, a: 36.11, b: -44.37 }
      rgba = { r: 126.01, g: 86.75, b: 181.19, a: 1.0 }
      color = described_class.new(**oklab, space: 'ok')
      expect(color.oklab).to eq oklab
      expect(color.rgba).to eq rgba
    end

    it '.input_to_rgba and exceeds the xyz bound, so is changed back to a different value' do
      oklab_1 = { l: 100.00, a: 0.37, b: -0.362 }
      oklab_2 = { l: 21.86, a: 0.08, b: -0.08 }
      xyz = { x: 2, y: 1, z: 4 }
      rgba = { r: 44, g: 0, b: 59, a: 1.0 }

      color = described_class.new(**oklab_1, space: 'ok')
      expect(color.oklab).not_to eq oklab_1
      expect(color.oklab).to eq oklab_2
      expect(color.xyz.transform_values(&:round)).to eq xyz
      expect(color.rgba.transform_values(&:round)).to eq rgba

      color = described_class.new(**oklab_2, space: 'ok')
      expect(color.oklab).not_to eq oklab_1
      expect(color.oklab).to eq oklab_2
      expect(color.xyz.transform_values(&:round)).to eq xyz
      expect(color.rgba.transform_values(&:round)).to eq rgba
    end
  end
end
