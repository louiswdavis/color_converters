# frozen_string_literal: true

RSpec.describe ColorConverters::XyzConverter do
  context 'methods' do
    it '.matches?' do
      expect(described_class.matches?(x: 24, y: 15, z: 57)).to be true
      expect(described_class.matches?(x: 24, y: 15, b: 57)).to be false
      expect(described_class.matches?(x: 24, y: 15, z: 32, b: 57)).to be false
      expect(described_class.matches?('#ffffff')).to be false
    end

    it '.validate_input' do
      expect { described_class.new(x: 174, y: 35, z: 37) }.to raise_error(ColorConverters::InvalidColorError, 'Invalid color input: x must be between 0.0 and 100.0')
      expect { described_class.new(x: 74, y: 135, z: 37) }.to raise_error(ColorConverters::InvalidColorError, 'Invalid color input: y must be between 0.0 and 100.0')
      expect { described_class.new(x: 74, y: 35, z: 137) }.to raise_error(ColorConverters::InvalidColorError, 'Invalid color input: z must be between 0.0 and 110.0')
    end

    it '.input_to_rgba for strings' do
      expect(described_class.new(x: 17.0157, y: 14.5662, z: 59.0415).rgba).to eq({ r: 51.03548592, g: 101.99999871, b: 203.99678845, a: 1.0 })
      expect(described_class.new(x: '17.0157', y: '14.5662', z: '59.0415').rgba).to eq({ r: 51.03548592, g: 101.99999871, b: 203.99678845, a: 1.0 })
    end

    it 'options' do
      colour_input = { x: 174, y: 135, z: 137 }

      expect { described_class.new(colour_input) }.to raise_error(ColorConverters::InvalidColorError)
      expect { described_class.new(colour_input, limit_override: true) }.not_to raise_error
      # expect { described_class.new(colour_input, limit_clamp: true) }.not_to raise_error

      expect(described_class.new(colour_input, limit_override: true).rgba).to eq({ r: 255.0, g: 243.80279203, b: 255.0, a: 1.0 })
      expect(described_class.new(colour_input, limit_override: true).xyz).to eq({ x: 91.58, y: 93.06, z: 107.75 })

      # expect(described_class.new(colour_input, limit_clamp: true).rgba).to eq({ r: 255.0, g: 234.1313178, b: 215.40997709, a: 1.0 })
      # expect(described_class.new(colour_input, limit_clamp: true).xyz).to eq({ l: 93.93, a: 4.11, b: 11.65 })
    end
  end

  context 'shared_examples for' do
    it_behaves_like 'classic_colour_conversions' do
      let(:converter) { described_class }
      let(:colour_space) { :xyz }

      let(:black)   { get_classic_colour_value('black', 'XYZ') }
      let(:white)   { get_classic_colour_value('white', 'XYZ') }

      let(:red)     { get_classic_colour_value('red', 'XYZ') }
      let(:orange)  { get_classic_colour_value('orange', 'XYZ') }
      let(:yellow)  { get_classic_colour_value('yellow', 'XYZ') }
      let(:green)   { get_classic_colour_value('green', 'XYZ') }
      let(:blue)    { get_classic_colour_value('blue', 'XYZ') }
      let(:indigo)  { get_classic_colour_value('indigo', 'XYZ') }
      let(:violet)  { get_classic_colour_value('violet', 'XYZ') }
    end

    it_behaves_like 'custom_colour_conversions' do
      let(:converter) { described_class }
      let(:colour_space) { :xyz }

      let(:passed_colours) { [0, 1, 2, 3, 4, 5].collect { |i| get_custom_colour_value(i, 'XYZ') } }
      let(:expected_rgbs) { [0, 1, 2, 3, 4, 5].collect { |i| get_custom_colour_value(i, 'RGB') } }
    end
  end
end
