# frozen_string_literal: true

RSpec.describe ColorConverters::HsvConverter do
  context 'methods' do
    it '.matches?' do
      expect(described_class.matches?(h: 225, s: 73, v: 57)).to be true
      expect(described_class.matches?(h: 225, s: 73, b: 57)).to be true
      expect(described_class.matches?(h: 225, s: 73, l: 57)).to be false
      expect(described_class.matches?('#ffffff')).to be false
    end

    it '.validate_input' do
      expect { described_class.new(h: -74, s: 125, v: 37) }.to raise_error(ColorConverters::InvalidColorError, 'Invalid color input: h must be between 0.0 and 360.0')
      expect { described_class.new(h: 74, s: -235, v: 37) }.to raise_error(ColorConverters::InvalidColorError, 'Invalid color input: s must be between -128.0 and 127.0')
      expect { described_class.new(h: 74, s: 35, v: -237) }.to raise_error(ColorConverters::InvalidColorError, 'Invalid color input: v must be between -128.0 and 127.0')
      expect { described_class.new(h: 474, s: 35, b: 117) }.to raise_error(ColorConverters::InvalidColorError, 'Invalid color input: h must be between 0.0 and 360.0')
      expect { described_class.new(h: 74, s: 435, b: 117) }.to raise_error(ColorConverters::InvalidColorError, 'Invalid color input: s must be between -128.0 and 127.0')
      expect { described_class.new(h: 74, s: 115, b: 437) }.to raise_error(ColorConverters::InvalidColorError, 'Invalid color input: b must be between -128.0 and 127.0')
    end

    it '.input_to_rgba for strings' do
      expect(described_class.new(h: 220, s: 75, v: 80).rgba).to eq({ r: 51.0, g: 102.0, b: 204.0, a: 1.0 })
      expect(described_class.new(h: '220', s: '75', v: '80').rgba).to eq({ r: 51.0, g: 102.0, b: 204.0, a: 1.0 })
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
      let(:colour_space) { :hsv }

      let(:black)   { get_classic_colour_value('black', 'HSV') }
      let(:white)   { get_classic_colour_value('white', 'HSV') }

      let(:red)     { get_classic_colour_value('red', 'HSV') }
      let(:orange)  { get_classic_colour_value('orange', 'HSV') }
      let(:yellow)  { get_classic_colour_value('yellow', 'HSV') }
      let(:green)   { get_classic_colour_value('green', 'HSV') }
      let(:blue)    { get_classic_colour_value('blue', 'HSV') }
      let(:indigo)  { get_classic_colour_value('indigo', 'HSV') }
      let(:violet)  { get_classic_colour_value('violet', 'HSV') }
    end
  end
end
