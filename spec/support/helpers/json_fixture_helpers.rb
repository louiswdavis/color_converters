require 'json'

module JsonFixtureHelpers
  def get_classic_color_value(color_name, format_name)
    # Get the path relative to the current working directory
    color_data = JSON.parse(File.read(File.join(Dir.pwd, 'spec', 'fixtures', 'classic_colors', "#{color_name}.json")))

    # Convert string values to appropriate hash formats where applicable
    convert_value_to_hash(format_name, color_data[color_name][format_name])
  rescue JSON::ParserError => e
    raise "Failed to parse JSON fixture for #{color_name}: #{e.message}"
  rescue Errno::ENOENT => e
    raise "Fixture file not found for #{color_name}: #{e.message}"
  rescue KeyError => e
    raise "Format '#{format_name}' not found for color '#{color_name}'"
  end

  private

  def convert_value_to_hash(format_name, value)
    case format_name
    when 'RGB', 'RGB Percent'
      values = value.split(', ').map(&:to_i)
      { r: values[0], g: values[1], b: values[2] }
    when 'CMY'
      values = value.split(', ').map(&:to_f)
      { c: values[0], m: values[1], y: values[2] }
    when 'CMYK'
      values = value.split(', ').map(&:to_f)
      { c: values[0], m: values[1], y: values[2], k: values[3] }
    when 'HSL'
      values = value.split(', ').map(&:to_i)
      { h: values[0], s: values[1], l: values[2] }
    when 'HSV'
      values = value.split(', ').map(&:to_i)
      { h: values[0], s: values[1], v: values[3] }
    when 'XYZ'
      values = value.split(', ').map(&:to_f)
      { x: values[0], y: values[1], z: values[2] }
    when 'YIQ'
      values = value.split(', ').map(&:to_f)
      { y: values[0], i: values[1], q: values[2] }
    when 'RYB'
      values = value.split(', ').map(&:to_i)
      { r: values[0], y: values[1], b: values[2] }
    when 'CIELab'
      values = value.split(', ').map(&:to_f)
      { l: values[0], a: values[1], b: values[2] }
    when 'CIELCh'
      values = value.split(', ').map(&:to_f)
      { l: values[0], c: values[1], h: values[2] }
    when 'Yxy'
      values = value.split(', ').map(&:to_f)
      { y: values[0], x: values[1], y2: values[2] }
    when 'YUV'
      values = value.split(', ').map(&:to_f)
      { y: values[0], u: values[1], v: values[2] }
    when 'Hunter-Lab'
      values = value.split(', ').map(&:to_f)
      { l: values[0], a: values[1], b: values[2] }
    else
      # Return the original value for formats that don't need conversion
      value
    end
  end
end

RSpec.configure do |config|
  config.include JsonFixtureHelpers
end
