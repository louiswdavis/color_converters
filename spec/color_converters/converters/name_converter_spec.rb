# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ColorConverters::NameConverter do
  context 'methods' do
    it '.matches?' do
      expect(described_class.matches?('blue')).to be true
      expect(described_class.matches?('RoyalBlue')).to be true
      expect(described_class.matches?('royalblue')).to be true
      expect(described_class.matches?('#ffffff')).to be false
    end

    it '.validate_input' do
      expect { described_class.new('bluee') }.to raise_error(ColorConverters::InvalidColorError)
    end

    it '.input_to_rgba' do
      expect(described_class.new('blue').rgba).to eq({ r: 0, g: 0, b: 255, a: 1.0 })
    end

    it '.rgb_to_name' do
      expect(described_class.rgb_to_name([255, 255, 255])).to eq 'white'
      expect(described_class.rgb_to_name([0, 255, 255])).to eq 'cyan'
      expect(described_class.rgb_to_name([255, 0, 255])).to eq 'fuchsia'
      expect(described_class.rgb_to_name([255, 255, 0])).to eq 'yellow'
      expect(described_class.rgb_to_name([0, 0, 0])).to eq 'black'
      expect(described_class.rgb_to_name([176, 196, 222])).to eq 'lightsteelblue'

      # sometimes the RGB values when converted to Hex values align with a/the named colour
      expect(described_class.rgb_to_name([0.1, 0.1, 0.1])).to eq 'black'
      expect(described_class.rgb_to_name([175.8, 196.4, 222.1])).to eq nil
    end
  end

  context 'shared_examples for .input_to_rgba and back' do
    it_behaves_like 'classic_colour_conversions' do
      let(:converter) { described_class }
      let(:colour_space) { :name }

      let(:black)   { get_classic_colour_value('black', 'Name') }
      let(:white)   { get_classic_colour_value('white', 'Name') }

      let(:red)     { get_classic_colour_value('red', 'Name') }
      let(:orange)  { get_classic_colour_value('orange', 'Name') }
      let(:yellow)  { get_classic_colour_value('yellow', 'Name') }
      let(:green)   { get_classic_colour_value('green', 'Name') }
      let(:blue)    { get_classic_colour_value('blue', 'Name') }
      let(:indigo)  { get_classic_colour_value('indigo', 'Name') }
      let(:violet)  { get_classic_colour_value('violet', 'Name') }
    end
  end
end
