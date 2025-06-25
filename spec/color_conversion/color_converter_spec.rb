# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ColorConversion::ColorConverter do
  context 'methods' do
    it 'conversions' do
      color = ColorConversion::Color.new(r: 51, g: 102, b: 204, a: 0.8)

      expect(color.alpha).to eq 0.8
      expect(color.rgb).to eq({ r: 51, g: 102, b: 204 })
      expect(color.hex).to eq('#3366cc')
      expect(color.hsl).to eq({ h: 220.0, s: 60, l: 50 })
      expect(color.hsv).to eq({ h: 220.0, s: 75, v: 80 })
      expect(color.hsb).to eq({ h: 220.0, s: 75, b: 80 })
      expect(color.cmyk).to eq({ c: 75, m: 50, y: 0, k: 20 })
      expect(color.xyz).to eq({ x: 17.01, y: 14.56, z: 59.03 })
      expect(color.cielab).to eq({ l: 45.03, a: 18.71, b: -57.85 })
      expect(color.oklch).to eq({ l: 45.03, c: 60.80, h: 287.92 })

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

      # cielab
      color = ColorConversion::Color.new(r: 64, g: 104, b: 193)
      expect(color.xyz).to eq({ x: 16.69, y: 14.84, z: 52.43 })
      expect(color.cielab).to eq({ l: 45.41, a: 15.26, b: -50.87 })

      color = ColorConversion::Color.new(r: 140, g: 76, b: 201)
      expect(color.cielab).to eq({ l: 45.58, a: 50.33, b: -54.89 })

      color = ColorConversion::Color.new(r: 255, g: 255, b: 255)
      expect(color.cielab).to eq({ l: 100.0, a: 0.0, b: 0.0 })

      color = ColorConversion::Color.new(r: 0, g: 0, b: 0)
      expect(color.cielab).to eq({ l: 0.0, a: 0.0, b: 0.0 })

      color = ColorConversion::Color.new(r: 255, g: 0, b: 197)
      expect(color.cielab).to eq({ l: 57.36, a: 90.93, b: -32.78 })
    end
  end
end
