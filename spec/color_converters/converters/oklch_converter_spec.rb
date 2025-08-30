# frozen_string_literal: true

RSpec.describe ColorConverters::OklchConverter do
  context 'methods' do
    it '.matches?' do
      expect(described_class.matches?(l: 0.74, c: 35, h: 37, space: 'ok')).to be true
      expect(described_class.matches?(l: 0.74, c: 35, h: 37)).to be false
      expect(described_class.matches?(l: 0.74, c: 35, z: 37, space: 'ok')).to be false
      expect(described_class.matches?('#ffffff')).to be false
    end

    it '.validate_input' do
      expect { described_class.new(l: 174, c: 35, h: 37, space: :ok) }.to raise_error(ColorConverters::InvalidColorError, 'Invalid color input: l must be between 0.0 and 100.0')
      expect { described_class.new(l: 74, c: 635, h: 37, space: :ok) }.to raise_error(ColorConverters::InvalidColorError, 'Invalid color input: c must be between 0.0 and 500.0')
      expect { described_class.new(l: 74, c: 35, h: 437, space: :ok) }.to raise_error(ColorConverters::InvalidColorError, 'Invalid color input: h must be between 0.0 and 360.0')
    end

    it '.input_to_rgba for strings' do
      expect(described_class.new(l: 53, c: 0.17, h: 260, space: :ok).rgba).to eq({ r: 40.88007918, g: 102.47077623, b: 203.95430287, a: 1.0 })
      expect(described_class.new(l: '53', c: '0.17', h: '260', space: 'ok').rgba).to eq({ r: 40.88007918, g: 102.47077623, b: 203.95430287, a: 1.0 })
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

  # TODO: improve the converter as these can be off anywhere from 1 unit to 10 units
  context 'shared_examples for' do
    it_behaves_like 'classic_colour_conversions' do
      let(:converter) { described_class }
      let(:colour_space) { :oklch }

      let(:black)   { get_classic_colour_value('black', 'OKLCh') }
      let(:white)   { get_classic_colour_value('white', 'OKLCh') }

      let(:red)     { get_classic_colour_value('red', 'OKLCh') }
      let(:orange)  { get_classic_colour_value('orange', 'OKLCh') }
      let(:yellow)  { get_classic_colour_value('yellow', 'OKLCh') }
      let(:green)   { get_classic_colour_value('green', 'OKLCh') }
      let(:blue)    { get_classic_colour_value('blue', 'OKLCh') }
      let(:indigo)  { get_classic_colour_value('indigo', 'OKLCh') }
      let(:violet)  { get_classic_colour_value('violet', 'OKLCh') }
    end

    it_behaves_like 'custom_colour_conversions' do
      let(:converter) { described_class }
      let(:colour_space) { :oklch }

      let(:passed_colours) { [0, 1, 2, 3, 4, 5].collect { |i| get_custom_colour_value(i, 'OKLCh') } }
      let(:expected_rgbs) { [0, 1, 2, 3, 4, 5].collect { |i| get_custom_colour_value(i, 'RGB') } }
    end
  end

  # this spec is to act more as a reminder of this edge case than to check any portion of the conversion process
  # it is unclear whether it's a bounding issue of the colour space, or an issue with the conversion process
  context 'edge cases' do
    it 'where conversions from colour space to rgb are not correctly converted back to the colour space with the same value' do
      oklch_1 = { l: 90.0, c: 70.63, h: 25.36 }
      oklch_2 = { l: 62.8, c: 0.26, h: 29.23 }

      colour = described_class.new(**oklch_1, space: :ok)
      expect(colour.oklch).not_to eq oklch_1
      expect(colour.oklch).to eq oklch_2

      colour = described_class.new(**oklch_2, space: :ok)
      expect(colour.oklch).not_to eq oklch_1
      expect(colour.oklch).to eq oklch_2
    end
  end
end
