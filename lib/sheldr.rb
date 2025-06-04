require "bundler/setup"
require "dry/cli"
require_relative "./sheldr/version.rb"

Dir[File.expand_path('./sheldr/commands/*.rb', File.dirname(__FILE__))].each do |file|
  require file
end

Dry::CLI.new(Sheldr::CLI::Commands).call