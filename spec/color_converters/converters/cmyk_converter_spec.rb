# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ColorConverters::CmykConverter do
  context 'methods' do
    it '.matches?' do
      expect(described_class.matches?(c: 87, m: 69, y: 13, k: 1)).to be true
      expect(described_class.matches?(h: 225, s: 73, v: 57)).to be false
      expect(described_class.matches?('#ffffff')).to be false
    end

    it '.validate_input' do
      expect { described_class.new(c: 187, m: 69, y: 13, k: 41) }.to raise_error(ColorConverters::InvalidColorError, 'Invalid color input: c must be between 0.0 and 100.0')
      expect { described_class.new(c: 87, m: -69, y: 13, k: 41) }.to raise_error(ColorConverters::InvalidColorError, 'Invalid color input: m must be between 0.0 and 100.0')
      expect { described_class.new(c: 87, m: 69, y: 213, k: 41) }.to raise_error(ColorConverters::InvalidColorError, 'Invalid color input: y must be between 0.0 and 100.0')
      expect { described_class.new(c: 87, m: 69, y: 13, k: 141) }.to raise_error(ColorConverters::InvalidColorError, 'Invalid color input: k must be between 0.0 and 100.0')
    end

    it '.input_to_rgba for strings' do
      expect(described_class.new(c: 75, m: 50, y: 0, k: 20).rgba).to eq({ r: 51.0, g: 102.0, b: 204.0, a: 1.0 })
      expect(described_class.new(c: '75', m: '50', y: '0', k: '20').rgba).to eq({ r: 51.0, g: 102.0, b: 204.0, a: 1.0 })
    end
  end

  context 'shared_examples for' do
    it_behaves_like 'classic_colour_conversions' do
      let(:converter) { described_class }
      let(:colour_space) { :cmyk }

      let(:black)   { get_classic_colour_value('black', 'CMYK') }
      let(:white)   { get_classic_colour_value('white', 'CMYK') }

      let(:red)     { get_classic_colour_value('red', 'CMYK') }
      let(:orange)  { get_classic_colour_value('orange', 'CMYK') }
      let(:yellow)  { get_classic_colour_value('yellow', 'CMYK') }
      let(:green)   { get_classic_colour_value('green', 'CMYK') }
      let(:blue)    { get_classic_colour_value('blue', 'CMYK') }
      let(:indigo)  { get_classic_colour_value('indigo', 'CMYK') }
      let(:violet)  { get_classic_colour_value('violet', 'CMYK') }
    end
  end
end
