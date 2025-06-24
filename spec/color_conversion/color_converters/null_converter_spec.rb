# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ColorConversion::NullConverter do
  context 'methods' do
    it '.matches?' do
      expect(described_class.matches?('blue')).to be true
      expect(described_class.matches?(r: 51, g: 102, b: 204)).to be true
    end

    it '.input_to_rgba' do
      expect { described_class.new(c: 74, m: 58, y: 22, k: 3).rgba }.to raise_error(ColorConversion::InvalidColorError)
    end
  end
end
