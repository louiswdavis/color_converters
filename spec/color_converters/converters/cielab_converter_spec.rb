# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ColorConverters::CielabConverter do
  context 'methods' do
    it '.matches?' do
      expect(described_class.matches?(l: 74, a: 35, b: 37, space: :cie)).to be true
      expect(described_class.matches?(l: 74, a: 35, b: 37)).to be false
      expect(described_class.matches?(l: 74, a: 35, z: 37)).to be false
      expect(described_class.matches?('#ffffff')).to be false
    end

    it '.validate_input' do
      expect { described_class.new(l: 274, a: 35, b: 37, space: :cie) }.to raise_error(ColorConverters::InvalidColorError)
      expect { described_class.new(l: 74, a: 235, b: 37, space: :cie) }.to raise_error(ColorConverters::InvalidColorError)
      expect { described_class.new(l: 74, a: 35, b: 237, space: :cie) }.to raise_error(ColorConverters::InvalidColorError)
    end

    it '.input_to_rgba for strings' do
      expect(described_class.new(l: 45.03, a: 18.72, b: -57.86, space: :cie).rgba).to eq({ r: 51.00961713, g: 101.99063779, b: 203.98615483, a: 1.0 })
      expect(described_class.new(l: '45.03', a: '18.72', b: '-57.86', space: 'cie').rgba).to eq({ r: 51.00961713, g: 101.99063779, b: 203.98615483, a: 1.0 })
    end
  end

  context 'shared_examples for' do
    it_behaves_like 'classic_colour_conversions' do
      let(:converter) { described_class }
      let(:colour_space) { :cielab }

      let(:black)   { get_classic_colour_value('black', 'CIELab') }
      let(:white)   { get_classic_colour_value('white', 'CIELab') }

      let(:red)     { get_classic_colour_value('red', 'CIELab') }
      let(:orange)  { get_classic_colour_value('orange', 'CIELab') }
      let(:yellow)  { get_classic_colour_value('yellow', 'CIELab') }
      let(:green)   { get_classic_colour_value('green', 'CIELab') }
      let(:blue)    { get_classic_colour_value('blue', 'CIELab') }
      let(:indigo)  { get_classic_colour_value('indigo', 'CIELab') }
      let(:violet)  { get_classic_colour_value('violet', 'CIELab') }
    end

    it_behaves_like 'custom_colour_conversions' do
      let(:converter) { described_class }
      let(:colour_space) { :cielab }

      let(:passed_colours) { [0, 1, 2, 3, 4, 5].collect { |i| get_custom_colour_value(i, 'CIELab') } }
      let(:expected_rgbs) { [0, 1, 2, 3, 4, 5].collect { |i| get_custom_colour_value(i, 'RGB') } }
    end
  end

  context 'edge cases' do
    it '.input_to_rgba and exceeds the xyz bound, so is changed back to a different value' do
      cielab_1 = { l: 100.00, a: 70.637, b: -25.362 }
      cielab_2 = { l: 86.67, a: 28.98, b: -19.80 }
      xyz = { x: 80, y: 69, z: 104 }
      rgba = { r: 255, g: 199, b: 255, a: 1.0 }

      colour = described_class.new(**cielab_1, space: :cie)
      expect(colour.cielab).not_to eq cielab_1
      expect(colour.cielab).to eq cielab_2
      expect(colour.xyz.transform_values(&:round)).to eq xyz
      expect(colour.rgba.transform_values(&:round)).to eq rgba

      colour = described_class.new(**cielab_2, space: :cie)
      expect(colour.cielab).not_to eq cielab_1
      expect(colour.cielab).to eq({ l: 86.67, a: 28.98, b: -19.79 }) # rounding on b
      expect(colour.xyz.transform_values(&:round)).to eq xyz
      expect(colour.rgba.transform_values(&:round)).to eq rgba
    end
  end
end
