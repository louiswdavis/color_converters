# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ColorConverters::HslConverter do
  context 'methods' do
    it '.matches?' do
      expect(described_class.matches?(h: 225, s: 73, l: 57)).to be true
      expect(described_class.matches?(h: 225, s: 73, l: 57, a: 0.5)).to be true
      expect(described_class.matches?(h: 225, s: 73, v: 57)).to be false
      expect(described_class.matches?('#ffffff')).to be false
    end

    it '.validate_input' do
      expect { described_class.new(h: 374, s: 35, l: 37) }.to raise_error(ColorConverters::InvalidColorError)
      expect { described_class.new(h: 74, s: 135, l: 37) }.to raise_error(ColorConverters::InvalidColorError)
      expect { described_class.new(h: 74, s: 35, l: 137) }.to raise_error(ColorConverters::InvalidColorError)
    end

    it '.input_to_rgba for strings' do
      expect(described_class.new(h: 220.0, s: 60, l: 50).rgba).to eq({ r: 51.0, g: 102.0, b: 204.0, a: 1.0 })
      expect(described_class.new(h: '220.0', s: '60', l: '50').rgba).to eq({ r: 51.0, g: 102.0, b: 204.0, a: 1.0 })
    end
  end

  context 'shared_examples for' do
    it_behaves_like 'classic_colour_conversions' do
      let(:converter) { described_class }
      let(:colour_space) { :hsl }

      let(:black)   { get_classic_colour_value('black', 'HSL') }
      let(:white)   { get_classic_colour_value('white', 'HSL') }

      let(:red)     { get_classic_colour_value('red', 'HSL') }
      let(:orange)  { get_classic_colour_value('orange', 'HSL') }
      let(:yellow)  { get_classic_colour_value('yellow', 'HSL') }
      let(:green)   { get_classic_colour_value('green', 'HSL') }
      let(:blue)    { get_classic_colour_value('blue', 'HSL') }
      let(:indigo)  { get_classic_colour_value('indigo', 'HSL') }
      let(:violet)  { get_classic_colour_value('violet', 'HSL') }
    end
  end
end
