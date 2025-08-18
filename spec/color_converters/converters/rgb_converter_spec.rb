# frozen_string_literal: true

require 'spec_helper'
# require_relative '../../support/shared_examples/classic_color_shared_examples'

RSpec.describe ColorConverters::RgbConverter do
  context 'methods' do
    it '.matches?' do
      expect(described_class.matches?(r: 51, g: 102, b: 204)).to be true
      expect(described_class.matches?(r: 51, g: 102, b: 204, a: 0.5)).to be true
      expect(described_class.matches?(h: 225, s: 73, v: 57)).to be false
      expect(described_class.matches?('#ffffff')).to be false
    end

    it '.validate_input' do
      expect { described_class.new(r: 274, g: 35, b: 37) }.to raise_error(ColorConverters::InvalidColorError)
      expect { described_class.new(r: 74, g: -35, b: 37) }.to raise_error(ColorConverters::InvalidColorError)
      expect { described_class.new(r: 74, g: 35, b: 337) }.to raise_error(ColorConverters::InvalidColorError)
    end

    it '.input_to_rgba for strings' do
      expect(described_class.new(r: 51, g: 102, b: 204).rgba).to eq({ r: 51.0, g: 102.0, b: 204.0, a: 1.0 })
      expect(described_class.new(r: '51', g: '102', b: '204').rgba).to eq({ r: 51.0, g: 102.0, b: 204.0, a: 1.0 })
    end
  end

  context 'shared_examples for .input_to_rgba and back' do
    it_behaves_like 'classic_color_conversions' do
      let(:converter) { described_class }
      let(:color_space) { :rgb }

      let(:black)   { get_classic_color_value('black', 'RGB') }
      let(:white)   { get_classic_color_value('white', 'RGB') }

      let(:red)     { get_classic_color_value('red', 'RGB') }
      let(:orange)  { get_classic_color_value('orange', 'RGB') }
      let(:yellow)  { get_classic_color_value('yellow', 'RGB') }
      let(:green)   { get_classic_color_value('green', 'RGB') }
      let(:blue)    { get_classic_color_value('blue', 'RGB') }
      let(:indigo)  { get_classic_color_value('indigo', 'RGB') }
      let(:violet)  { get_classic_color_value('violet', 'RGB') }
    end

    it_behaves_like 'custom_color_conversions' do
      let(:converter) { described_class }
      let(:color_space) { :rgb }

      let(:sample_colors) do
        [
          { r: 51.0, g: 102.0, b: 204.0 }
        ]
      end

      let(:passed_colors) do
        [
          { r: 51.0, g: 102.0, b: 204.0 }
        ]
      end
    end
  end
end
