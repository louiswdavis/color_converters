# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ColorConverters::HexConverter do
  context 'methods' do
    it '.matches?' do
      expect(described_class.matches?('#FFFFFF')).to be true
      expect(described_class.matches?('#FFF')).to be true
      expect(described_class.matches?('#ffffff')).to be true
      expect(described_class.matches?('#asdf')).to be false
      expect(described_class.matches?(c: 87, m: 69, y: 13, k: 1)).to be false
      expect(described_class.matches?(h: 225, s: 73, v: 57)).to be false
    end

    # it '.validate_input' do
    #   expect { described_class.new(l: 74, a: 35, b: 37) }.to raise_error(ColorConverters::InvalidColorError)
    #   expect { described_class.new(l: 74, a: 35, b: 37) }.to raise_error(ColorConverters::InvalidColorError)
    #   expect { described_class.new(l: 74, a: 35, b: 37) }.to raise_error(ColorConverters::InvalidColorError)
    # end

    it '.input_to_rgba for strings' do
      expect(described_class.new('#3366cc').rgba).to eq({ r: 51, g: 102, b: 204, a: 1.0 })
      expect(described_class.new('#36c').rgba).to eq({ r: 51, g: 102, b: 204, a: 1.0 })
    end
  end

  context 'shared_examples for' do
    it_behaves_like 'classic_colour_conversions' do
      let(:converter) { described_class }
      let(:colour_space) { :hex }

      let(:black)   { get_classic_colour_value('black', 'Hex') }
      let(:white)   { get_classic_colour_value('white', 'Hex') }

      let(:red)     { get_classic_colour_value('red', 'Hex') }
      let(:orange)  { get_classic_colour_value('orange', 'Hex') }
      let(:yellow)  { get_classic_colour_value('yellow', 'Hex') }
      let(:green)   { get_classic_colour_value('green', 'Hex') }
      let(:blue)    { get_classic_colour_value('blue', 'Hex') }
      let(:indigo)  { get_classic_colour_value('indigo', 'Hex') }
      let(:violet)  { get_classic_colour_value('violet', 'Hex') }
    end
  end
end
