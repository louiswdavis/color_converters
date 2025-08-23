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
      expect { described_class.new(l: 274, a: 0.2, b: -0.1, space: :ok) }.to raise_error(ColorConverters::InvalidColorError, 'Invalid color input: l must be between 0.0 and 100.0')
      expect { described_class.new(l: 74, a: 11.2, b: -0.1, space: :ok) }.to raise_error(ColorConverters::InvalidColorError, 'Invalid color input: a must be between -0.5 and 0.5')
      expect { described_class.new(l: 74, a: 0.2, b: -11.1, space: :ok) }.to raise_error(ColorConverters::InvalidColorError, 'Invalid color input: b must be between -0.5 and 0.5')
    end

    it '.input_to_rgba for strings' do
      expect(described_class.new(l: 53, a: -0.02, b: -0.17, space: :ok).rgba).to eq({ r: 52.28190213, g: 100.18295421, b: 205.1047036, a: 1.0 })
      expect(described_class.new(l: '53', a: '-0.02', b: '-0.17', space: :ok).rgba).to eq({ r: 52.28190213, g: 100.18295421, b: 205.1047036, a: 1.0 })
    end

    it 'options' do
      colour_input = { l: 174, c: 35, h: 37, space: :cie }

      expect { described_class.new(**colour_input) }.to raise_error(ColorConverters::InvalidColorError)
      expect { described_class.new(**colour_input, limit_override: true) }.not_to raise_error(ColorConverters::InvalidColorError)
      expect { described_class.new(**colour_input, limit_clamp: true) }.not_to raise_error(ColorConverters::InvalidColorError)

      expect(described_class.new(**colour_input, limit_override: true).rgba).to eq({ r: 255.0, g: 255.0, b: 255.0, a: 1.0 })
      expect(described_class.new(**colour_input, limit_override: true).cielab).to eq({ l: 100.0, a: 0.0, b: 0.0 })

      expect(described_class.new(**colour_input, limit_clamp: true).rgba).to eq({ r: 255.0, g: 234.1313178, b: 215.40997709, a: 1.0 })
      expect(described_class.new(**colour_input, limit_clamp: true).cielab).to eq({ l: 93.93, a: 4.11, b: 11.65 })
    end
  end

  context 'shared_examples for' do
    it_behaves_like 'classic_colour_conversions' do
      let(:converter) { described_class }
      let(:colour_space) { :oklab }

      let(:black)   { get_classic_colour_value('black', 'OKLab') }
      let(:white)   { get_classic_colour_value('white', 'OKLab') }

      let(:red)     { get_classic_colour_value('red', 'OKLab') }
      let(:orange)  { get_classic_colour_value('orange', 'OKLab') }
      let(:yellow)  { get_classic_colour_value('yellow', 'OKLab') }
      let(:green)   { get_classic_colour_value('green', 'OKLab') }
      let(:blue)    { get_classic_colour_value('blue', 'OKLab') }
      let(:indigo)  { get_classic_colour_value('indigo', 'OKLab') }
      let(:violet)  { get_classic_colour_value('violet', 'OKLab') }
    end

    it_behaves_like 'custom_colour_conversions' do
      let(:converter) { described_class }
      let(:colour_space) { :oklab }

      let(:passed_colours) { [0, 1, 2, 3, 4, 5].collect { |i| get_custom_colour_value(i, 'OKLab') } }
      let(:expected_rgbs) { [0, 1, 2, 3, 4, 5].collect { |i| get_custom_colour_value(i, 'RGB') } }
    end
  end

  # this spec is to act more as a reminder of this edge case than to check any portion of the conversion process
  # it is unclear whether it's a bounding issue of the colour space, or an issue with the conversion process
  context 'edge cases' do
    it 'where conversions from colour space to rgb are not correctly converted back to the colour space with the same value' do
      oklab_1 = { l: 30.00, a: -0.28, b: -0.22 }
      oklab_2 = { l: 36.69, a: -0.02, b: -0.19 }

      colour = described_class.new(**oklab_1, space: :ok)
      expect(colour.oklab).not_to eq oklab_1
      expect(colour.oklab).to eq oklab_2

      colour = described_class.new(**oklab_2, space: :ok)
      expect(colour.oklab).not_to eq oklab_1
      expect(colour.oklab).to eq oklab_2
    end
  end
end
