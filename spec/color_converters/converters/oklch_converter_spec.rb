# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ColorConverters::OklchConverter do
  context 'methods' do
    it '.matches?' do
      expect(described_class.matches?(l: 0.74, c: 35, h: 37, space: 'ok')).to be true
      expect(described_class.matches?(l: 0.74, c: 35, h: 37)).to be false
      expect(described_class.matches?(l: 0.74, c: 35, z: 37, space: 'ok')).to be false
      expect(described_class.matches?('#ffffff')).to be false
    end

    it '.validate_input' do
      expect { described_class.new(l: 174, c: 35, h: 37, space: :ok) }.to raise_error(ColorConverters::InvalidColorError)
      expect { described_class.new(l: 74, c: -135, h: 37, space: :ok) }.to raise_error(ColorConverters::InvalidColorError)
      expect { described_class.new(l: 74, c: 35, h: 437, space: :ok) }.to raise_error(ColorConverters::InvalidColorError)
    end

    it '.input_to_rgba for strings' do
      expect(described_class.new(l: 53, c: 0.17, h: 260, space: :ok).rgba).to eq({ r: 40.88007918, g: 102.47077623, b: 203.95430287, a: 1.0 })
      expect(described_class.new(l: '53', c: '0.17', h: '260', space: 'ok').rgba).to eq({ r: 40.88007918, g: 102.47077623, b: 203.95430287, a: 1.0 })
    end
  end

  # TODO: improve the converter as these can be off anywhere from 1 unit to 10 units
  context 'shared_examples for' do
    it_behaves_like 'classic_colour_conversions' do
      let(:converter) { described_class }
      let(:colour_space) { :oklch }

      let(:black)   { get_classic_colour_value('black', 'OKLCh') }
      let(:white)   { get_classic_colour_value('white', 'OKLCh') }

      let(:red)     { get_classic_colour_value('red', 'OKLCh') }
      let(:orange)  { get_classic_colour_value('orange', 'OKLCh') }
      let(:yellow)  { get_classic_colour_value('yellow', 'OKLCh') }
      let(:green)   { get_classic_colour_value('green', 'OKLCh') }
      let(:blue)    { get_classic_colour_value('blue', 'OKLCh') }
      let(:indigo)  { get_classic_colour_value('indigo', 'OKLCh') }
      let(:violet)  { get_classic_colour_value('violet', 'OKLCh') }
    end

    it_behaves_like 'custom_colour_conversions' do
      let(:converter) { described_class }
      let(:colour_space) { :oklch }
      let(:rounding_margin) { 5.0 }

      let(:passed_colours) { [0, 1, 2, 3, 4, 5].collect { |i| get_custom_colour_value(i, 'OKLCh') } }
      let(:expected_rgbs) { [0, 1, 2, 3, 4, 5].collect { |i| get_custom_colour_value(i, 'RGB') } }
    end
  end

  context 'edge cases' do
    it 'where conversions from rgb to colour space exceeds the xyz bound, so is changed back to a different value' do
      oklch_1 = { l: 100, c: 70.637, h: 25.362 }
      oklch_2 = { l: 85.55, c: 20.64, h: 22.57 }
      xyz = { x: 72, y: 67, z: 64 }
      rgba = { r: 255, g: 201, b: 200, a: 1.0 }

      colour = described_class.new(**oklch_1)
      expect(colour.oklch).not_to eq oklch_1
      expect(colour.oklch).to eq oklch_2
      expect(colour.xyz.transform_values(&:round)).to eq xyz
      expect(colour.rgba.transform_values(&:round)).to eq rgba

      colour = described_class.new(**oklch_2)
      expect(colour.oklch).not_to eq oklch_1
      expect(colour.oklch).to eq oklch_2
      expect(colour.xyz.transform_values(&:round)).to eq xyz
      expect(colour.rgba.transform_values(&:round)).to eq rgba
    end
  end
end
