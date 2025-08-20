# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ColorConverters::NullConverter do
  context 'methods' do
    it '.matches?' do
      expect(described_class.matches?('blue')).to be true
      expect(described_class.matches?(r: 51, g: 102, b: 204)).to be true
    end

    it '.validate_input' do
      expect { described_class.new(l: 74, a: 35, b: 37) }.to raise_error(ColorConverters::InvalidColorError)
    end
  end
end
