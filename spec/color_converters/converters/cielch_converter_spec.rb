# frozen_string_literal: true

RSpec.describe ColorConverters::CielchConverter do
  context 'methods' do
    it '.matches?' do
      expect(described_class.matches?(l: 74, c: 35, h: 37, space: :cie)).to be true
      expect(described_class.matches?(l: 74, c: 35, h: 37)).to be false
      expect(described_class.matches?(l: 74, c: 35, z: 37)).to be false
      expect(described_class.matches?('#ffffff')).to be false
    end

    it '.validate_input' do
      expect { described_class.new(l: 174, c: 35, h: 37, space: :cie) }.to raise_error(ColorConverters::InvalidColorError, 'Invalid color input: l must be between 0.0 and 100.0')
      expect { described_class.new(l: 74, c: 235, h: 37, space: :cie) }.to raise_error(ColorConverters::InvalidColorError, 'Invalid color input: c must be between 0.0 and 150.0')
      expect { described_class.new(l: 74, c: 35, h: 437, space: :cie) }.to raise_error(ColorConverters::InvalidColorError, 'Invalid color input: h must be between 0.0 and 360.0')
    end

    it '.input_to_rgba for strings' do
      expect(described_class.new(l: 45.03, c: 60.80, h: 287.92, space: :cie).rgba).to eq({ r: 50.99193921, g: 101.99706275, b: 203.9694083, a: 1.0 })
      expect(described_class.new(l: '45.03', c: '60.80', h: '287.92', space: 'cie').rgba).to eq({ r: 50.99193921, g: 101.99706275, b: 203.9694083, a: 1.0 })
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
      let(:colour_space) { :cielch }

      let(:black)   { get_classic_colour_value('black', 'CIELCh') }
      let(:white)   { get_classic_colour_value('white', 'CIELCh') }

      let(:red)     { get_classic_colour_value('red', 'CIELCh') }
      let(:orange)  { get_classic_colour_value('orange', 'CIELCh') }
      let(:yellow)  { get_classic_colour_value('yellow', 'CIELCh') }
      let(:green)   { get_classic_colour_value('green', 'CIELCh') }
      let(:blue)    { get_classic_colour_value('blue', 'CIELCh') }
      let(:indigo)  { get_classic_colour_value('indigo', 'CIELCh') }
      let(:violet)  { get_classic_colour_value('violet', 'CIELCh') }
    end

    it_behaves_like 'custom_colour_conversions' do
      let(:converter) { described_class }
      let(:colour_space) { :cielch }

      let(:passed_colours) { [0, 1, 2, 3, 4, 5].collect { |i| get_custom_colour_value(i, 'CIELCh') } }
      let(:expected_rgbs) { [0, 1, 2, 3, 4, 5].collect { |i| get_custom_colour_value(i, 'RGB') } }
    end
  end

  context 'edge cases' do
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
end
