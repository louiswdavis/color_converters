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
  rescue KeyError
    raise "Format '#{format_name}' not found for color '#{color_name}'"
  end

  private

  def convert_value_to_hash(format_name, value)
    values = value.split(', ').map(&:to_f)

    case format_name
    when 'RGB', 'RGB Percent'
      { r: values[0], g: values[1], b: values[2] }
    when 'CMY'
      { c: values[0], m: values[1], y: values[2] }
    when 'CMYK'
      { c: values[0], m: values[1], y: values[2], k: values[3] }
    when 'HSL'
      { h: values[0], s: values[1], l: values[2] }
    when 'HSV'
      { h: values[0], s: values[1], v: values[2] }
    when 'XYZ'
      { x: values[0], y: values[1], z: values[2] }
    when 'YIQ'
      { y: values[0], i: values[1], q: values[2] }
    when 'RYB'
      { r: values[0], y: values[1], b: values[2] }
    when 'CIELab'
      { l: values[0], a: values[1], b: values[2] }
    when 'CIELCh'
      { l: values[0], c: values[1], h: values[2] }
    when 'OKLab'
      { l: values[0], a: values[1], b: values[2] }
    when 'OKLCh'
      { l: values[0], c: values[1], h: values[2] }
    when 'Yxy'
      { y: values[0], x: values[1], y2: values[2] }
    when 'YUV'
      { y: values[0], u: values[1], v: values[2] }
    when 'Hunter-Lab'
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
