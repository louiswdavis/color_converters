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

    it '.input_to_rgba for strings' do
      expect(described_class.new(x: 17.0157, y: 14.5662, z: 59.0415).rgba).to eq({ r: 51.04, g: 102.0, b: 204.0, a: 1.0 })
      expect(described_class.new(x: '17.0157', y: '14.5662', z: '59.0415').rgba).to eq({ r: 51.04, g: 102.0, b: 204.0, a: 1.0 })
    end

    it '.input_to_rgba and back' do
      xyz = { x: 23.94, y: 14.96, z: 56.87 }
      rgba = { r: 140.02, g: 75.98, b: 200.97, a: 1.0 }
      colour = described_class.new(**xyz)
      expect(colour.xyz).to eq xyz
      expect(colour.rgba).to eq rgba

      xyz = { x: 16.69, y: 14.84, z: 52.43 }
      rgba = { r: 64.05, g: 103.99, b: 192.99, a: 1.0 }
      colour = described_class.new(**xyz)
      expect(colour.xyz).to eq xyz
      expect(colour.rgba).to eq rgba

      xyz = { x: 95.04, y: 100.0, z: 108.88 }
      rgba = { r: 254.99, g: 255.0, b: 254.97, a: 1.0 }
      colour = described_class.new(**xyz)
      expect(colour.xyz).to eq xyz
      expect(colour.rgba).to eq rgba

      xyz = { x: 0.0, y: 0.0, z: 0.0 }
      rgba = { r: 0, g: 0, b: 0, a: 1.0 }
      colour = described_class.new(**xyz)
      expect(colour.xyz).to eq xyz
      expect(colour.rgba).to eq rgba
    end
  end

  context 'shared_examples for .input_to_rgba and back' do
    it_behaves_like 'classic_colour_conversions' do
      let(:converter) { described_class }
      let(:colour_space) { :xyz }

      let(:black)   { get_classic_colour_value('black', 'XYZ') }
      let(:white)   { get_classic_colour_value('white', 'XYZ') }

      let(:red)     { get_classic_colour_value('red', 'XYZ') }
      let(:orange)  { get_classic_colour_value('orange', 'XYZ') }
      let(:yellow)  { get_classic_colour_value('yellow', 'XYZ') }
      let(:green)   { get_classic_colour_value('green', 'XYZ') }
      let(:blue)    { get_classic_colour_value('blue', 'XYZ') }
      let(:indigo)  { get_classic_colour_value('indigo', 'XYZ') }
      let(:violet)  { get_classic_colour_value('violet', 'XYZ') }
    end
  end
end
