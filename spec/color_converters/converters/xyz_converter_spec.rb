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
      expect(described_class.new(x: 17.0157, y: 14.5662, z: 59.0415).rgba).to eq({ r: 51.03548592, g: 101.99999871, b: 203.99678845, a: 1.0 })
      expect(described_class.new(x: '17.0157', y: '14.5662', z: '59.0415').rgba).to eq({ r: 51.03548592, g: 101.99999871, b: 203.99678845, a: 1.0 })
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

    it_behaves_like 'custom_colour_conversions' do
      let(:converter) { described_class }
      let(:colour_space) { :xyz }

      let(:passed_colours) { [0, 1, 2, 3, 4, 5].collect { |i| get_custom_colour_value(i, 'XYZ') } }
      let(:expected_rgbs) { [0, 1, 2, 3, 4, 5].collect { |i| get_custom_colour_value(i, 'RGB') } }
    end
  end
end
