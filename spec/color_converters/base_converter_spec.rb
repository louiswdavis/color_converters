# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ColorConverters::BaseConverter do
  context 'methods' do
    it 'conversions to colour spaces' do
      colour = ColorConverters::Color.new(r: 51, g: 102, b: 204, a: 0.8)

      expect(colour.alpha).to eq 0.8
      expect(colour.rgb).to eq({ r: 51, g: 102, b: 204 })
      expect(colour.hex).to eq('#3366cc')
      expect(colour.hsl).to eq({ h: 220.0, s: 60, l: 50 })
      expect(colour.hsv).to eq({ h: 220.0, s: 75, v: 80 })
      expect(colour.hsb).to eq({ h: 220.0, s: 75, b: 80 })
      expect(colour.cmyk).to eq({ c: 75, m: 50, y: 0, k: 20 })
      expect(colour.xyz).to eq({ x: 17.01, y: 14.57, z: 59.04 })
      expect(colour.cielab).to eq({ l: 45.03, a: 18.72, b: -57.85 })
      expect(colour.cielch).to eq({ l: 45.03, c: 60.80, h: 287.93 })
      expect(colour.oklab).to eq({ l: 53.25, a: -0.02, b: -0.17 })
      expect(colour.oklch).to eq({ l: 53.25, c: 0.17, h: 262.29 })

      colour = ColorConverters::Color.new(r: 64, g: 104, b: 193)
      expect(colour.cmyk).to eq({ c: 66.84, m: 46.11, y: 0.0, k: 24.31 })

      colour = ColorConverters::Color.new(r: 1, g: 1, b: 1)
      expect(colour.name).to eq nil

      # xyz
      colour = ColorConverters::Color.new(r: 64, g: 104, b: 193)
      expect(colour.xyz).to eq({ x: 16.69, y: 14.84, z: 52.44 })

      # cie
      colour = ColorConverters::Color.new(r: 64, g: 104, b: 193)
      expect(colour.xyz).to eq({ x: 16.69, y: 14.84, z: 52.44 })
      expect(colour.cielab).to eq({ l: 45.41, a: 15.27, b: -50.87 })
      expect(colour.cielch).to eq({ l: 45.41, c: 53.11, h: 286.71 })

      colour = ColorConverters::Color.new(r: 140, g: 76, b: 201)
      expect(colour.cielab).to eq({ l: 45.58, a: 50.33, b: -54.90 })
      expect(colour.cielch).to eq({ l: 45.58, c: 74.48, h: 312.52 })

      colour = ColorConverters::Color.new(r: 255, g: 255, b: 255)
      expect(colour.cielab).to eq({ l: 100.0, a: 0.0, b: 0.0 })
      expect(colour.cielch).to eq({ l: 100.0, c: 0.0, h: 0.0 })

      colour = ColorConverters::Color.new(r: 0, g: 0, b: 0)
      expect(colour.cielab).to eq({ l: 0.0, a: 0.0, b: 0.0 })
      expect(colour.cielch).to eq({ l: 0.0, c: 0.0, h: 0.0 })

      colour = ColorConverters::Color.new(r: 255, g: 0, b: 197)
      expect(colour.cielab).to eq({ l: 57.36, a: 90.93, b: -32.79 })
      expect(colour.cielch).to eq({ l: 57.36, c: 96.66, h: 340.17 })

      # testing the episilon for LCH conversion fallback
      colour = ColorConverters::Color.new(h: 255, s: 0, l: 50)
      expect(colour.cielab).to eq({ l: 53.39, a: 0.0, b: 0.0 })
      expect(colour.cielch).to eq({ l: 53.39, c: 0.0, h: 0.0 })

      colour = ColorConverters::Color.new(h: 255, s: 1, l: 50)
      expect(colour.cielab).to eq({ l: 53.01, a: 0.75, b: -1.3 })
      expect(colour.cielch).to eq({ l: 53.01, c: 1.5, h: 300.03 })

      # ok
      colour = ColorConverters::Color.new(r: 64, g: 104, b: 193)
      expect(colour.xyz).to eq({ x: 16.69, y: 14.84, z: 52.44 })
      expect(colour.oklab).to eq({ l: 53.46, a: -0.02, b: -0.15 })
      expect(colour.oklch).to eq({ l: 53.46, c: 0.15, h: 263.93 })

      colour = ColorConverters::Color.new(r: 140, g: 76, b: 201)
      expect(colour.oklab).to eq({ l: 55.26, a: 0.11, b: -0.16 })
      expect(colour.oklch).to eq({ l: 55.26, c: 0.19, h: 304.5 })

      colour = ColorConverters::Color.new(r: 255, g: 255, b: 255)
      expect(colour.oklab).to eq({ l: 100.0, a: 0.0, b: 0.0 })
      expect(colour.oklch).to eq({ l: 100.0, c: 0.0, h: 0.0 })

      colour = ColorConverters::Color.new(r: 0, g: 0, b: 0)
      expect(colour.oklab).to eq({ l: 0.0, a: 0.0, b: 0.0 })
      expect(colour.oklch).to eq({ l: 0.0, c: 0.0, h: 0.0 })

      colour = ColorConverters::Color.new(r: 255, g: 0, b: 197)
      expect(colour.oklab).to eq({ l: 67.12, a: 0.27, b: -0.09 })
      expect(colour.oklch).to eq({ l: 67.12, c: 0.29, h: 342.2 })
    end

    it 'conversions (white point)' do
      colour = ColorConverters::Color.new(r: 255, g: 255, b: 255, a: 0.8)

      expect(colour.alpha).to eq 0.8
      expect(colour.name).to eq 'white'
      expect(colour.rgb).to eq({ r: 255.0, g: 255.0, b: 255.0 })
      expect(colour.hex).to eq('#ffffff')
      expect(colour.hsl).to eq({ h: 0.0, s: 0.0, l: 100.0 })
      expect(colour.hsv).to eq({ h: 0.0, s: 0.0, v: 100.0 })
      expect(colour.hsb).to eq({ h: 0.0, s: 0.0, b: 100.0 })
      expect(colour.cmyk).to eq({ c: 0.0, m: 0.0, y: 0.0, k: 0.0 })
      expect(colour.xyz).to eq({ x: 95.05, y: 100.0, z: 108.91 })
      expect(colour.cielab).to eq({ l: 100.0, a: 0.0, b: 0.0 })
      expect(colour.cielch).to eq({ l: 100.0, c: 0.0, h: 0.0 })
      expect(colour.oklab).to eq({ l: 100.0, a: 0.0, b: 0.0 })
      expect(colour.oklch).to eq({ l: 100.0, c: 0.0, h: 0.0 })
    end

    it 'conversions (black point)' do
      colour = ColorConverters::Color.new(r: 0, g: 0, b: 0, a: 0.3)

      expect(colour.alpha).to eq 0.3
      expect(colour.name).to eq 'black'
      expect(colour.rgb).to eq({ r: 0.0, g: 0.0, b: 0.0 })
      expect(colour.hex).to eq('#000000')
      expect(colour.hsl).to eq({ h: 0.0, s: 0.0, l: 0.0 })
      expect(colour.hsv).to eq({ h: 0.0, s: 0.0, v: 0.0 })
      expect(colour.hsb).to eq({ h: 0.0, s: 0.0, b: 0.0 })
      expect(colour.cmyk).to eq({ c: 0.0, m: 0.0, y: 0.0, k: 100.0 })
      expect(colour.xyz).to eq({ x: 0.0, y: 0.0, z: 0.0 })
      expect(colour.cielab).to eq({ l: 0.0, a: 0.0, b: 0.0 })
      expect(colour.cielch).to eq({ l: 0.0, c: 0.0, h: 0.0 })
      expect(colour.oklab).to eq({ l: 0.0, a: 0.0, b: 0.0 })
      expect(colour.oklch).to eq({ l: 0.0, c: 0.0, h: 0.0 })
    end

    it 'conversions (red point)' do
      colour = ColorConverters::Color.new(r: 255, g: 0, b: 0, a: 1.0)

      expect(colour.alpha).to eq 1.0
      expect(colour.name).to eq 'red'
      expect(colour.rgb).to eq({ r: 255.0, g: 0.0, b: 0.0 })
      expect(colour.hex).to eq('#ff0000')
      expect(colour.hsl).to eq({ h: 0.0, s: 100.0, l: 50.0 })
      expect(colour.hsv).to eq({ h: 0.0, s: 100.0, v: 100.0 })
      expect(colour.hsb).to eq({ h: 0.0, s: 100.0, b: 100.0 })
      expect(colour.cmyk).to eq({ c: 0.0, m: 100.0, y: 100.0, k: 0.0 })
      expect(colour.xyz).to eq({ x: 41.24, y: 21.26, z: 1.93 })
      expect(colour.cielab).to eq({ l: 53.24, a: 80.09, b: 67.2 })
      expect(colour.cielch).to eq({ l: 53.24, c: 104.55, h: 40.0 })
      expect(colour.oklab).to eq({ l: 62.8, a: 0.22, b: 0.13 })
      expect(colour.oklch).to eq({ l: 62.8, c: 0.26, h: 29.23 })
    end

    it 'conversions (green point)' do
      colour = ColorConverters::Color.new(r: 0, g: 255, b: 0, a: 1.0)

      expect(colour.alpha).to eq 1.0
      expect(colour.name).to eq 'lime'
      expect(colour.rgb).to eq({ r: 0.0, g: 255.0, b: 0.0 })
      expect(colour.hex).to eq('#00ff00')
      expect(colour.hsl).to eq({ h: 120.0, s: 100.0, l: 50.0 })
      expect(colour.hsv).to eq({ h: 120.0, s: 100.0, v: 100.0 })
      expect(colour.hsb).to eq({ h: 120.0, s: 100.0, b: 100.0 })
      expect(colour.cmyk).to eq({ c: 100.0, m: 0.0, y: 100.0, k: 0.0 })
      expect(colour.xyz).to eq({ x: 35.76, y: 71.52, z: 11.92 })
      expect(colour.cielab).to eq({ l: 87.74, a: -86.18, b: 83.19 })
      expect(colour.cielch).to eq({ l: 87.74, c: 119.78, h: 136.01 })
      expect(colour.oklab).to eq({ l: 86.64, a: -0.23, b: 0.18 })
      expect(colour.oklch).to eq({ l: 86.64, c: 0.29, h: 142.5 })
    end

    it 'conversions (blue point)' do
      colour = ColorConverters::Color.new(r: 0, g: 0, b: 255, a: 1)

      expect(colour.alpha).to eq 1.0
      expect(colour.name).to eq 'blue'
      expect(colour.rgb).to eq({ r: 0.0, g: 0.0, b: 255.0 })
      expect(colour.hex).to eq('#0000ff')
      expect(colour.hsl).to eq({ h: 240.0, s: 100.0, l: 50.0 })
      expect(colour.hsv).to eq({ h: 240.0, s: 100.0, v: 100.0 })
      expect(colour.hsb).to eq({ h: 240.0, s: 100.0, b: 100.0 })
      expect(colour.cmyk).to eq({ c: 100.0, m: 100.0, y: 0.0, k: 0.0 })
      expect(colour.xyz).to eq({ x: 18.05, y: 7.22, z: 95.05 })
      expect(colour.cielab).to eq({ l: 32.3, a: 79.2, b: -107.86 })
      expect(colour.cielch).to eq({ l: 32.3, c: 133.81, h: 306.29 })
      expect(colour.oklab).to eq({ l: 45.2, a: -0.03, b: -0.31 })
      expect(colour.oklch).to eq({ l: 45.2, c: 0.31, h: 264.05 })
    end
  end
end
