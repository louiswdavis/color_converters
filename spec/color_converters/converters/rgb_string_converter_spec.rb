# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ColorConverters::RgbStringConverter do
  context 'methods' do
    it '.matches?' do
      expect(described_class.matches?('rgb(51, 102, 204)')).to be true
      expect(described_class.matches?('rgba(51, 102, 204, 0.2)')).to be true
      expect(described_class.matches?(r: 51, g: 102, b: 204)).to be false
    end

    # it '.validate_input' do
    #   expect { described_class.new(l: 74, a: 35, b: 37) }.to raise_error(ColorConverters::InvalidColorError)
    #   expect { described_class.new(l: 74, a: 35, b: 37) }.to raise_error(ColorConverters::InvalidColorError)
    #   expect { described_class.new(l: 74, a: 35, b: 37) }.to raise_error(ColorConverters::InvalidColorError)
    # end

    it '.input_to_rgba' do
      expect(described_class.new('rgb(51, 102, 204)').rgba).to eq({ r: 51, g: 102, b: 204, a: 1.0 })
      expect(described_class.new('rgba(51, 102, 204, 0.5)').rgba).to eq({ r: 51, g: 102, b: 204, a: 0.5 })

      expect { described_class.new('rgb(51, 102)').rgba }.to raise_error(ColorConverters::InvalidColorError)
      expect { described_class.new('rgba(foo)').rgba }.to raise_error(ColorConverters::InvalidColorError)
    end
  end
end
