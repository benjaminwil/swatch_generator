require 'chunky_png'
require 'zip'

# ChunkyPNG includes the 147 colours we already know and love from HTML. Right
# now, that's the only swatches that get generated.
colours = ChunkyPNG::Color::PREDEFINED_COLORS

# Defines the height and width (in pixels) of the swatch files we will generate.
height, width = 50, 50

# The folder and .zip archive where we'll discover our beautiful new swatches.
target_build_dir = [Dir.pwd, '/', 'swatches'].join
target_archive = [target_build_dir, '.zip'].join

# If the `target_build_dir` doesn't already exist, create it.
FileUtils.mkdir_p(target_build_dir)

# This loop creates a .png for each color, then encloses it in the .zip we're
# generating.
Zip::File.open(target_archive, Zip::File::CREATE) do |zip|
  colours.each do |name, value|
    colour = ChunkyPNG::Color.parse(name)
    swatch = ChunkyPNG::Image.new(width, height, colour)
    filename = [name.to_s, '.png'].join
    fullpath = [target_build_dir, '/', filename].join

    File.write(fullpath, swatch.to_datastream)

    zip.add(filename, fullpath)
  end
end
