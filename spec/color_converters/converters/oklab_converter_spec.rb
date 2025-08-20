# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ColorConverters::OklabConverter do
  context 'methods' do
    it '.matches?' do
      expect(described_class.matches?(l: 74, a: 0.0, b: 0.0, space: :ok)).to be true
      expect(described_class.matches?(l: 74, a: 0.0, b: 0.0)).to be false
      expect(described_class.matches?(l: 74, a: 0.0, z: 0.0)).to be false
      expect(described_class.matches?('#ffffff')).to be false
    end

    it '.validate_input' do
      expect { described_class.new(l: 274, a: 0.2, b: -0.1, space: :ok) }.to raise_error(ColorConverters::InvalidColorError)
      expect { described_class.new(l: 74, a: 1.2, b: -0.1, space: :ok) }.to raise_error(ColorConverters::InvalidColorError)
      expect { described_class.new(l: 74, a: 0.2, b: -1.1, space: :ok) }.to raise_error(ColorConverters::InvalidColorError)
    end

    it '.input_to_rgba for strings' do
      expect(described_class.new(l: 53, a: -0.02, b: -0.17, space: :ok).rgba).to eq({ r: 52.28190213, g: 100.18295421, b: 205.1047036, a: 1.0 })
      expect(described_class.new(l: '53', a: '-0.02', b: '-0.17', space: :ok).rgba).to eq({ r: 52.28190213, g: 100.18295421, b: 205.1047036, a: 1.0 })
    end

    xit '.input_to_rgba and exceeds the xyz bound, so is changed back to a different value' do
      oklab_1 = { l: 100.00, a: 0.37, b: -0.362 }
      oklab_2 = { l: 21.86, a: 0.08, b: -0.08 }
      xyz = { x: 2, y: 1, z: 4 }
      rgba = { r: 44, g: 0, b: 59, a: 1.0 }

      colour = described_class.new(**oklab_1, space: :ok)
      expect(colour.oklab).not_to eq oklab_1
      expect(colour.oklab).to eq oklab_2
      expect(colour.xyz.transform_values(&:round)).to eq xyz
      expect(colour.rgba.transform_values(&:round)).to eq rgba

      colour = described_class.new(**oklab_2, space: :ok)
      expect(colour.oklab).not_to eq oklab_1
      expect(colour.oklab).to eq oklab_2
      expect(colour.xyz.transform_values(&:round)).to eq xyz
      expect(colour.rgba.transform_values(&:round)).to eq rgba
    end
  end

  context 'shared_examples for .input_to_rgba and back' do
    it_behaves_like 'classic_colour_conversions' do
      let(:converter) { described_class }
      let(:colour_space) { :oklab }

      let(:black)   { get_classic_colour_value('black', 'OKLab').merge({ space: 'ok' }) }
      let(:white)   { get_classic_colour_value('white', 'OKLab').merge({ space: 'ok' }) }

      let(:red)     { get_classic_colour_value('red', 'OKLab').merge({ space: 'ok' }) }
      let(:orange)  { get_classic_colour_value('orange', 'OKLab').merge({ space: 'ok' }) }
      let(:yellow)  { get_classic_colour_value('yellow', 'OKLab').merge({ space: 'ok' }) }
      let(:green)   { get_classic_colour_value('green', 'OKLab').merge({ space: 'ok' }) }
      let(:blue)    { get_classic_colour_value('blue', 'OKLab').merge({ space: 'ok' }) }
      let(:indigo)  { get_classic_colour_value('indigo', 'OKLab').merge({ space: 'ok' }) }
      let(:violet)  { get_classic_colour_value('violet', 'OKLab').merge({ space: 'ok' }) }
    end
  end
end
