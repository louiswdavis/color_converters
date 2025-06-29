# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ColorConverters::BaseConverter do
  context 'methods' do
    it 'conversions' do
      color = ColorConverters::Color.new(r: 51, g: 102, b: 204, a: 0.8)

      expect(color.alpha).to eq 0.8
      expect(color.rgb).to eq({ r: 51, g: 102, b: 204 })
      expect(color.hex).to eq('#3366cc')
      expect(color.hsl).to eq({ h: 220.0, s: 60, l: 50 })
      expect(color.hsv).to eq({ h: 220.0, s: 75, v: 80 })
      expect(color.hsb).to eq({ h: 220.0, s: 75, b: 80 })
      expect(color.cmyk).to eq({ c: 75, m: 50, y: 0, k: 20 })
      expect(color.xyz).to eq({ x: 17.01, y: 14.56, z: 59.03 })
      expect(color.cielab).to eq({ l: 45.03, a: 18.71, b: -57.85 })
      expect(color.cielch).to eq({ l: 45.03, c: 60.80, h: 287.92 })
      expect(color.oklab).to eq({ l: 53.25, a: -0.02, b: -1.02 })
      expect(color.oklch).to eq({ l: 53.25, c: 1.02, h: 268.74 })

      color = ColorConverters::Color.new(r: 64, g: 104, b: 193)
      expect(color.cmyk).to eq({ c: 66.84, m: 46.11, y: 0.0, k: 24.31 })

      # xyz
      color = ColorConverters::Color.new(r: 64, g: 104, b: 193)
      expect(color.xyz).to eq({ x: 16.69, y: 14.84, z: 52.43 })

      color = ColorConverters::Color.new(r: 255, g: 255, b: 255)
      expect(color.xyz).to eq({ x: 95.05, y: 100.0, z: 108.88 })

      color = ColorConverters::Color.new(r: 0, g: 0, b: 0)
      expect(color.xyz).to eq({ x: 0.0, y: 0.0, z: 0.0 })
      expect(color.name).to eq 'black'

      color = ColorConverters::Color.new(r: 1, g: 1, b: 1)
      expect(color.name).to eq nil

      # cie
      color = ColorConverters::Color.new(r: 64, g: 104, b: 193)
      expect(color.xyz).to eq({ x: 16.69, y: 14.84, z: 52.43 })
      expect(color.cielab).to eq({ l: 45.41, a: 15.26, b: -50.87 })
      expect(color.cielch).to eq({ l: 45.41, c: 53.11, h: 286.7 })

      color = ColorConverters::Color.new(r: 140, g: 76, b: 201)
      expect(color.cielab).to eq({ l: 45.58, a: 50.33, b: -54.89 })
      expect(color.cielch).to eq({ l: 45.58, c: 74.47, h: 312.52 })

      color = ColorConverters::Color.new(r: 255, g: 255, b: 255)
      expect(color.cielab).to eq({ l: 100.0, a: 0.0, b: 0.0 })
      expect(color.cielch).to eq({ l: 100.0, c: 0.0, h: 0.0 })

      color = ColorConverters::Color.new(r: 0, g: 0, b: 0)
      expect(color.cielab).to eq({ l: 0.0, a: 0.0, b: 0.0 })
      expect(color.cielch).to eq({ l: 0.0, c: 0.0, h: 0.0 })

      color = ColorConverters::Color.new(r: 255, g: 0, b: 197)
      expect(color.cielab).to eq({ l: 57.36, a: 90.93, b: -32.78 })
      expect(color.cielch).to eq({ l: 57.36, c: 96.66, h: 340.17 })

      # ok
      color = ColorConverters::Color.new(r: 64, g: 104, b: 193)
      expect(color.xyz).to eq({ x: 16.69, y: 14.84, z: 52.43 })
      expect(color.oklab).to eq({ l: 53.46, a: -0.02, b: -1.0 })
      expect(color.oklch).to eq({ l: 53.46, c: 1.0, h: 269.11 })

      color = ColorConverters::Color.new(r: 140, g: 76, b: 201)
      expect(color.oklab).to eq({ l: 55.26, a: 0.11, b: -1.02 })
      expect(color.oklch).to eq({ l: 55.26, c: 1.02, h: 275.99 })

      color = ColorConverters::Color.new(r: 255, g: 255, b: 255)
      expect(color.oklab).to eq({ l: 100.0, a: 0.0, b: -1.57 })
      expect(color.oklch).to eq({ l: 100.0, c: 1.57, h: 270.0 })

      color = ColorConverters::Color.new(r: 0, g: 0, b: 0)
      expect(color.oklab).to eq({ l: 0.0, a: 0.0, b: 0.0 })
      expect(color.oklch).to eq({ l: 0.0, c: 0.0, h: 0.0 })

      color = ColorConverters::Color.new(r: 255, g: 0, b: 197)
      expect(color.oklab).to eq({ l: 67.12, a: 0.27, b: -1.1 })
      expect(color.oklch).to eq({ l: 67.12, c: 1.14, h: 284.0 })
    end
  end
end
