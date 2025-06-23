require 'spec_helper'

describe XyzConverter do
  describe '.matches?' do
    it 'should match args with xyz hash' do
      expect(XyzConverter.matches?(x: 24, y: 15, z: 57)).to be true
    end

    it 'should not match args without xyz hash' do
      expect(XyzConverter.matches?(x: 24, y: 15, b: 57)).to be false
    end

    it 'should not match a string' do
      expect(XyzConverter.matches?('#ffffff')).to be false
    end
  end

  describe '.rgba' do
    it 'should convert xyz to rgba' do
      conv = XyzConverter.new(x: 24, y: 15, z: 57)
      rgba = { r: 140, g: 76, b: 201, a: 1.0 }
      expect(conv.rgba).to eq rgba
    end

    it 'should convert xyz strings to rgba' do
      conv = XyzConverter.new(x: '24', y: '15', z: '57')
      rgba = { r: 140, g: 76, b: 201, a: 1.0 }
      expect(conv.rgba).to eq rgba
    end

    it 'should convert xyz to rgba and back' do
      xyz = { x: 23.94, y: 14.96, z: 56.87 }
      rgba = { r: 140, g: 76, b: 201, a: 1.0 }
      conv = XyzConverter.new(**xyz)
      expect(conv.xyz).to eq xyz
      expect(conv.rgba).to eq rgba

      xyz = { x: 16.69, y: 14.84, z: 52.43 }
      rgba = { r: 64, g: 104, b: 193, a: 1.0 }
      conv = XyzConverter.new(**xyz)
      expect(conv.xyz).to eq xyz
      expect(conv.rgba).to eq rgba

      xyz = { x: 95.05, y: 100.0, z: 108.88 }
      rgba = { r: 255, g: 255, b: 255, a: 1.0 }
      conv = XyzConverter.new(**xyz)
      expect(conv.xyz).to eq xyz
      expect(conv.rgba).to eq rgba

      xyz = { x: 0.0, y: 0.0, z: 0.0 }
      rgba = { r: 0, g: 0, b: 0, a: 1.0 }
      conv = XyzConverter.new(**xyz)
      expect(conv.xyz).to eq xyz
      expect(conv.rgba).to eq rgba
    end

    it 'can convert multiple xyzs to the same rgba, but inversely only one xyz' do
      xyz_1 = { x: 64.69, y: 14.84, z: 52.43 }
      xyz_2 = { x: 51.32, y: 25.30, z: 54.99 }

      rgba = { r: 255, g: 0, b: 197, a: 1.0 }

      conv_1 = XyzConverter.new(**xyz_1)
      conv_2 = XyzConverter.new(**xyz_2)

      expect(conv_1.rgba).to eq rgba
      expect(conv_2.rgba).to eq rgba

      expect(conv_1.xyz).to eq xyz_2
      expect(conv_2.xyz).to eq xyz_2
    end
  end
end
