# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ColorConversion::ColorConverter do
  context 'methods' do
    it 'conversions' do
      color = ColorConversion::Color.new(r: 51, g: 102, b: 204, a: 0.8)

      expect(color.alpha).to eq 0.8
      expect(color.rgb).to eq({ r: 51, g: 102, b: 204 })
      expect(color.hex).to eq('#3366cc')
      expect(color.hsl).to eq({ h: 220, s: 60, l: 50 })
      expect(color.hsv).to eq({ h: 220, s: 75, v: 80 })
      expect(color.hsb).to eq({ h: 220, s: 75, b: 80 })
      expect(color.cmyk).to eq({ c: 75, m: 50, y: 0, k: 20 })

      color = ColorConversion::Color.new(r: 64, g: 104, b: 193)
      expect(color.cmyk).to eq({ c: 66.84, m: 46.11, y: 0.0, k: 24.31 })

      # xyz
      color = ColorConversion::Color.new(r: 64, g: 104, b: 193)
      expect(color.xyz).to eq({ x: 16.69, y: 14.84, z: 52.43 })

      color = ColorConversion::Color.new(r: 255, g: 255, b: 255)
      expect(color.xyz).to eq({ x: 95.05, y: 100.0, z: 108.88 })

      color = ColorConversion::Color.new(r: 0, g: 0, b: 0)
      expect(color.xyz).to eq({ x: 0.0, y: 0.0, z: 0.0 })
      expect(color.name).to eq 'black'

      color = ColorConversion::Color.new(r: 1, g: 1, b: 1)
      expect(color.name).to eq nil
    end
  end
end
