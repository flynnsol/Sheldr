
# Import All Commands from the Commands Directory

Dir[File.expand_path('./commands/*.rb', File.dirname(__FILE__))].each do |file|
  require file
end

# Define Commands Module

module Sheldr
  module CLI
    module Commands
      extend Dry::CLI::Registry
    end
  end
end

# Register Commands

Sheldr::CLI::Commands.register "version", Version, aliases: ["v", "-v", "--version"]
Sheldr::CLI::Commands.register "new", New
Sheldr::CLI::Commands.register "add", Add