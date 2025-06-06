
require "bundler/setup"
require "dry/cli"
require_relative "./sheldr/commands.rb"
require_relative "./sheldr/version.rb"

Dry::CLI.new(Sheldr::CLI::Commands).call