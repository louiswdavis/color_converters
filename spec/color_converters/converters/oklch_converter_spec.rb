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

    it '.input_to_rgba' do
      expect(described_class.new(l: 53, c: 0.17, h: 260, space: :ok).rgba).to eq({ r: 51.0, g: 102.0, b: 203.95, a: 1.0 })
      expect(described_class.new(l: '53', c: '0.17', h: '260', space: 'ok').rgba).to eq({ r: 51.0, g: 102.0, b: 203.95, a: 1.0 })
    end

    xit '.input_to_rgba and exceeds the xyz bound, so is changed back to a different value' do
      oklch_1 = { l: 1.00, c: 70.637, h: 25.362 }
      oklch_2 = { l: 0.8555, c: 20.64, h: 22.57 }
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

  context 'shared_examples for .input_to_rgba and back' do
    it_behaves_like 'classic_colour_conversions' do
      let(:converter) { described_class }
      let(:colour_space) { :oklch }

      let(:black)   { get_classic_colour_value('black', 'OKLCh').merge({ space: 'ok' }) }
      let(:white)   { get_classic_colour_value('white', 'OKLCh').merge({ space: 'ok' }) }

      let(:red)     { get_classic_colour_value('red', 'OKLCh').merge({ space: 'ok' }) }
      let(:orange)  { get_classic_colour_value('orange', 'OKLCh').merge({ space: 'ok' }) }
      let(:yellow)  { get_classic_colour_value('yellow', 'OKLCh').merge({ space: 'ok' }) }
      let(:green)   { get_classic_colour_value('green', 'OKLCh').merge({ space: 'ok' }) }
      let(:blue)    { get_classic_colour_value('blue', 'OKLCh').merge({ space: 'ok' }) }
      let(:indigo)  { get_classic_colour_value('indigo', 'OKLCh').merge({ space: 'ok' }) }
      let(:violet)  { get_classic_colour_value('violet', 'OKLCh').merge({ space: 'ok' }) }
    end
  end
end
