
module Sheldr
  module CLI
    module Commands
      extend Dry::CLI::Registry

      class Version < Dry::CLI::Command
        def call(*)
          puts Sheldr::VERSION
        end
      end

      register "v", Version
      register "version", Version
    end
  end
end