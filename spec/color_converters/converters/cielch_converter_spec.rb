# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ColorConverters::CielchConverter do
  context 'methods' do
    it '.matches?' do
      expect(described_class.matches?(l: 74, c: 35, h: 37, space: :cie)).to be true
      expect(described_class.matches?(l: 74, c: 35, h: 37)).to be false
      expect(described_class.matches?(l: 74, c: 35, z: 37)).to be false
      expect(described_class.matches?('#ffffff')).to be false
    end

    it '.validate_input' do
      expect { described_class.new(l: 174, c: 35, h: 37, space: :cie) }.to raise_error(ColorConverters::InvalidColorError)
      expect { described_class.new(l: 74, c: 235, h: 37, space: :cie) }.to raise_error(ColorConverters::InvalidColorError)
      expect { described_class.new(l: 74, c: 35, h: 437, space: :cie) }.to raise_error(ColorConverters::InvalidColorError)
    end

    it '.input_to_rgba for strings' do
      expect(described_class.new(l: 45.03, c: 60.80, h: 287.92, space: :cie).rgba).to eq({ r: 50.99193921, g: 101.99706275, b: 203.9694083, a: 1.0 })
      expect(described_class.new(l: '45.03', c: '60.80', h: '287.92', space: 'cie').rgba).to eq({ r: 50.99193921, g: 101.99706275, b: 203.9694083, a: 1.0 })
    end

    it '.input_to_rgba and back' do
      cielch = { l: 73.53, c: 33.59, h: 36.34, space: :cie }
      rgba = { r: 239.07, g: 161.17, b: 145.60, a: 1.0 }
      colour = described_class.new(**cielch)
      expect(colour.cielch).to eq({ l: 73.53, c: 33.6, h: 36.35 }) # rounding on h
      expect(colour.rgba).to eq rgba

      cielch = { l: 44.65, c: 6.92, h: 41.51, space: :cie }
      rgba = { r: 117.47, g: 102.46, b: 98.19, a: 1.0 }
      colour = described_class.new(**cielch)
      expect(colour.cielch).to eq({ l: 44.65, c: 6.93, h: 41.58 }) # rounding on h
      expect(colour.rgba).to eq rgba

      cielch = { l: 45.02, c: 60.79, h: 287.93, space: :cie }
      rgba = { r: 51.04, g: 101.97, b: 203.92, a: 1.0 }
      colour = described_class.new(**cielch)
      expect(colour.cielch).to eq({ l: 45.02, c: 60.78, h: 287.93 })
      expect(colour.rgba).to eq rgba
    end

    it '.input_to_rgba and exceeds the xyz bound, so is changed back to a different value' do
      cielch_1 = { l: 100.00, c: 70.637, h: 25.362, space: :cie }
      cielch_2 = { l: 85.55, c: 20.64, h: 22.63, space: :cie }
      xyz = { x: 72, y: 67, z: 64 }
      rgba = { r: 255, g: 201, b: 200, a: 1.0 }

      colour = described_class.new(**cielch_1)
      expect(colour.cielch).not_to eq cielch_1
      expect(colour.cielch).to eq({ l: 85.55, c: 20.64, h: 22.60 }) # rounding on h (is cielch_2)
      expect(colour.xyz.transform_values(&:round)).to eq xyz
      expect(colour.rgba.transform_values(&:round)).to eq rgba

      colour = described_class.new(**cielch_2)
      expect(colour.cielch).not_to eq cielch_1
      expect(colour.cielch).to eq({ l: 85.55, c: 20.64, h: 22.66 }) # rounding on h
      expect(colour.xyz.transform_values(&:round)).to eq xyz
      expect(colour.rgba.transform_values(&:round)).to eq rgba
    end
  end

  context 'shared_examples for .input_to_rgba and back' do
    it_behaves_like 'classic_colour_conversions' do
      let(:converter) { described_class }
      let(:colour_space) { :cielch }

      let(:black)   { get_classic_colour_value('black', 'CIELCh').merge({ space: 'cie' }) }
      let(:white)   { get_classic_colour_value('white', 'CIELCh').merge({ space: 'cie' }) }

      let(:red)     { get_classic_colour_value('red', 'CIELCh').merge({ space: 'cie' }) }
      let(:orange)  { get_classic_colour_value('orange', 'CIELCh').merge({ space: 'cie' }) }
      let(:yellow)  { get_classic_colour_value('yellow', 'CIELCh').merge({ space: 'cie' }) }
      let(:green)   { get_classic_colour_value('green', 'CIELCh').merge({ space: 'cie' }) }
      let(:blue)    { get_classic_colour_value('blue', 'CIELCh').merge({ space: 'cie' }) }
      let(:indigo)  { get_classic_colour_value('indigo', 'CIELCh').merge({ space: 'cie' }) }
      let(:violet)  { get_classic_colour_value('violet', 'CIELCh').merge({ space: 'cie' }) }
    end
  end
end
