require "rseed"
require "colorize"

namespace :rseed do
  desc "Seed an Excel file using the RooAdapter and a converter"
  task :excel => :environment do
    converter = ENV["converter"] || ENV["CONVERTER"]
    converter_options = ENV["converter_options"] || ENV["CONVERTER_OPTIONS"]
    file = ENV["file"] || ENV["FILE"]
    if file && converter
      options = {converter: converter}
      options[:converter_options] = converter_options if converter_options
      Rseed::from_excel file, options
    else
      puts "You must specify file=<file> and converter=<converter>".red
    end
  end
end
