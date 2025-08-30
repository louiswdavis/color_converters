# frozen_string_literal: true

RSpec.describe ColorConverters::HslConverter do
  context 'methods' do
    it '.matches?' do
      expect(described_class.matches?(h: 225, s: 73, l: 57)).to be true
      expect(described_class.matches?(h: 225, s: 73, l: 57, a: 0.5)).to be true
      expect(described_class.matches?(h: 225, s: 73, v: 57)).to be false
      expect(described_class.matches?('#ffffff')).to be false
    end

    it '.validate_input' do
      expect { described_class.new(h: 374, s: 35, l: 37) }.to raise_error(ColorConverters::InvalidColorError, 'Invalid color input: h must be between 0.0 and 360.0')
      expect { described_class.new(h: 74, s: 135, l: 37) }.to raise_error(ColorConverters::InvalidColorError, 'Invalid color input: s must be between 0.0 and 100.0')
      expect { described_class.new(h: 74, s: 35, l: 137) }.to raise_error(ColorConverters::InvalidColorError, 'Invalid color input: l must be between 0.0 and 100.0')
      expect { described_class.new(h: 74, s: 35, l: 37, a: 5.0) }.to raise_error(ColorConverters::InvalidColorError, 'Invalid color input: a must be between 0.0 and 1.0')
    end

    it '.input_to_rgba for strings' do
      expect(described_class.new(h: 220.0, s: 60, l: 50).rgba).to eq({ r: 51.0, g: 102.0, b: 204.0, a: 1.0 })
      expect(described_class.new(h: '220.0', s: '60', l: '50').rgba).to eq({ r: 51.0, g: 102.0, b: 204.0, a: 1.0 })
    end

    it 'options' do
      colour_input = { h: 374, s: 35, l: 37 }

      expect { described_class.new(colour_input) }.to raise_error(ColorConverters::InvalidColorError)
      expect { described_class.new(colour_input, limit_override: true) }.not_to raise_error
      # expect { described_class.new(colour_input, limit_clamp: true) }.not_to raise_error

      expect(described_class.new(colour_input, limit_override: true).rgba).to eq({ r: 127.3725, g: 76.738, b: 61.3275, a: 1.0 })
      expect(described_class.new(colour_input, limit_override: true).hsl).to eq({ h: 14.0, s: 35.0, l: 37.0 })

      # expect(described_class.new(colour_input, limit_clamp: true).rgba).to eq({ r: 255.0, g: 234.1313178, b: 215.40997709, a: 1.0 })
      # expect(described_class.new(colour_input, limit_clamp: true).hsl).to eq({ l: 93.93, a: 4.11, b: 11.65 })
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
