# frozen_string_literal: true

RSpec.describe ColorConverters::RgbConverter do
  context 'methods' do
    it '.matches?' do
      expect(described_class.matches?(r: 51, g: 102, b: 204)).to be true
      expect(described_class.matches?(r: 51, g: 102, b: 204, a: 0.5)).to be true
      expect(described_class.matches?(h: 225, s: 73, v: 57)).to be false
      expect(described_class.matches?('#ffffff')).to be false
    end

    it '.validate_input' do
      expect { described_class.new(r: 274, g: 35, b: 37) }.to raise_error(ColorConverters::InvalidColorError, 'Invalid color input: r must be between 0.0 and 255.0')
      expect { described_class.new(r: 74, g: -35, b: 37) }.to raise_error(ColorConverters::InvalidColorError, 'Invalid color input: g must be between 0.0 and 255.0')
      expect { described_class.new(r: 74, g: 35, b: 337) }.to raise_error(ColorConverters::InvalidColorError, 'Invalid color input: b must be between 0.0 and 255.0')
      expect { described_class.new(r: 74, g: 35, b: 137, a: 5.0) }.to raise_error(ColorConverters::InvalidColorError, 'Invalid color input: a must be between 0.0 and 1.0')
    end

    it '.input_to_rgba for strings' do
      expect(described_class.new(r: 51, g: 102, b: 204).rgba).to eq({ r: 51.0, g: 102.0, b: 204.0, a: 1.0 })
      expect(described_class.new(r: '51', g: '102', b: '204').rgba).to eq({ r: 51.0, g: 102.0, b: 204.0, a: 1.0 })
    end

    it 'options' do
      colour_input = { r: 274, g: 35, b: 37 }

      expect { described_class.new(colour_input) }.to raise_error(ColorConverters::InvalidColorError)
      expect { described_class.new(colour_input, limit_override: true) }.not_to raise_error
      # expect { described_class.new(colour_input, limit_clamp: true) }.not_to raise_error

      expect(described_class.new(colour_input, limit_override: true).rgba).to eq({ r: 274.0, g: 35.0, b: 37.0, a: 1.0 })
      expect(described_class.new(colour_input, limit_override: true).rgb).to eq({ r: 274, g: 35, b: 37 })

      # expect(described_class.new(colour_input, limit_clamp: true).rgba).to eq({ r: 255.0, g: 234.1313178, b: 215.40997709, a: 1.0 })
      # expect(described_class.new(colour_input, limit_clamp: true).rgb).to eq({ l: 93.93, a: 4.11, b: 11.65 })
    end
  end

  context 'shared_examples for' do
    it_behaves_like 'classic_colour_conversions' do
      let(:converter) { described_class }
      let(:colour_space) { :rgb }

      let(:black)   { get_classic_colour_value('black', 'RGB') }
      let(:white)   { get_classic_colour_value('white', 'RGB') }

      let(:red)     { get_classic_colour_value('red', 'RGB') }
      let(:orange)  { get_classic_colour_value('orange', 'RGB') }
      let(:yellow)  { get_classic_colour_value('yellow', 'RGB') }
      let(:green)   { get_classic_colour_value('green', 'RGB') }
      let(:blue)    { get_classic_colour_value('blue', 'RGB') }
      let(:indigo)  { get_classic_colour_value('indigo', 'RGB') }
      let(:violet)  { get_classic_colour_value('violet', 'RGB') }
    end

    it_behaves_like 'custom_colour_conversions' do
      let(:converter) { described_class }
      let(:colour_space) { :rgb }

      let(:passed_colours) { [{ r: 51.0, g: 102.0, b: 204.0 }] }
      let(:expected_rgbs) { [{ r: 51.0, g: 102.0, b: 204.0 }] }
    end
  end
end
