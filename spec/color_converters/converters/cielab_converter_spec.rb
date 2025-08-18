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
      expect(described_class.new(l: 45.03, a: 18.72, b: -57.86, space: :cie).rgba).to eq({ r: 51.01, g: 101.99, b: 203.99, a: 1.0 })
      expect(described_class.new(l: '45.03', a: '18.72', b: '-57.86', space: 'cie').rgba).to eq({ r: 51.01, g: 101.99, b: 203.99, a: 1.0 })
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

  context 'shared_examples for .input_to_rgba and back' do
    it_behaves_like 'classic_color_conversions' do
      let(:converter) { described_class }
      let(:color_space) { :cielab }

      let(:black)   { get_classic_color_value('black', 'CIELab').merge({ space: 'cie' }) }
      let(:white)   { get_classic_color_value('white', 'CIELab').merge({ space: 'cie' }) }

      let(:red)     { get_classic_color_value('red', 'CIELab').merge({ space: 'cie' }) }
      let(:orange)  { get_classic_color_value('orange', 'CIELab').merge({ space: 'cie' }) }
      let(:yellow)  { get_classic_color_value('yellow', 'CIELab').merge({ space: 'cie' }) }
      let(:green)   { get_classic_color_value('green', 'CIELab').merge({ space: 'cie' }) }
      let(:blue)    { get_classic_color_value('blue', 'CIELab').merge({ space: 'cie' }) }
      let(:indigo)  { get_classic_color_value('indigo', 'CIELab').merge({ space: 'cie' }) }
      let(:violet)  { get_classic_color_value('violet', 'CIELab').merge({ space: 'cie' }) }
    end
  end
end
