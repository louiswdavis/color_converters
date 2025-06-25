# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ColorConverter::Color do
  context 'methods' do
    it '.initialize' do
      expect(described_class.new(r: 51, g: 102, b: 204).rgb).not_to eq nil

      expect(described_class.new(r: 51, g: 102, b: 204).rgb).to eq({ r: 51, g: 102, b: 204 })
      expect(described_class.new(r: 51, g: 102, b: 204, a: 0.5).rgb).to eq({ r: 51, g: 102, b: 204 })
      expect(described_class.new(r: 51, g: 102, b: 204, a: 0.5).alpha).to eq(0.5)

      expect(described_class.new(h: 225, s: 73, l: 57).rgb).to eq({ r: 65.31, g: 105.33, b: 225.39 })
      expect(described_class.new(h: 225, s: 73, l: 57, a: 0.5).rgb).to eq({ r: 65.31, g: 105.33, b: 225.39 })
      expect(described_class.new(r: 51, g: 102, b: 204, a: 0.4).alpha).to eq(0.4)

      expect(described_class.new(h: 220, s: 75, v: 80).rgb).to eq({ r: 51, g: 102, b: 204 })
      expect(described_class.new(h: 220, s: 75, b: 80).rgb).to eq({ r: 51, g: 102, b: 204 })
      expect(described_class.new(c: 74, m: 58, y: 22, k: 3).rgb).to eq({ r: 64.31, g: 103.89, b: 192.93 })
      expect(described_class.new(x: 45, y: 23, z: 64).rgb).to eq({ r: 229.27, g: 40.72, b: 211.48 })

      expect(described_class.new('#3366cc').rgb).to eq({ r: 51, g: 102, b: 204 })
      expect(described_class.new('#3366CC').rgb).to eq({ r: 51, g: 102, b: 204 })
      expect(described_class.new('#36C').rgb).to eq({ r: 51, g: 102, b: 204 })

      expect(described_class.new('rgb(51, 102, 204)').rgb).to eq({ r: 51, g: 102, b: 204 })
      expect(described_class.new('rgba(51, 102, 204, 0.2)').rgb).to eq({ r: 51, g: 102, b: 204 })
      expect(described_class.new(r: 51, g: 102, b: 204, a: 0.7).alpha).to eq 0.7

      expect(described_class.new('hsl(225, 73%, 57%)').rgb).to eq({ r: 65.31, g: 105.33, b: 225.39 })
      expect(described_class.new('hsla(225, 73%, 57%, 0.5)').rgb).to eq({ r: 65.31, g: 105.33, b: 225.39 })
      expect(described_class.new(r: 51, g: 102, b: 204, a: 0.0).alpha).to eq 0.0

      expect(described_class.new('royalblue').rgb).to eq({ r: 65, g: 105, b: 225 })
      expect(described_class.new('RoyalBlue').rgb).to eq({ r: 65, g: 105, b: 225 })
    end

    it '.==' do
      # should be equal when same color
      color_1 = described_class.new('#3366cc')
      color_2 = described_class.new('#3366cc')
      expect(color_1).to eq(color_2)

      # should be equal when logically same color
      color_1 = described_class.new('#3366cc')
      color_2 = described_class.new(r: 51, g: 102, b: 204)
      expect(color_1).to eq(color_2)

      # should be equal when same color and alpha
      color_1 = described_class.new(r: 51, g: 102, b: 204, a: 0.2)
      color_2 = described_class.new('rgba(51, 102, 204, 0.2)')
      expect(color_1).to eq(color_2)

      # should not be equal when same color but not same alpha
      color_1 = described_class.new(r: 51, g: 102, b: 204, a: 0.2)
      color_2 = described_class.new(r: 51, g: 102, b: 204, a: 0.2)
      expect(color_1).to eq(color_2)
    end
  end
end
