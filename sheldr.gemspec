# frozen_string_literal: true

require_relative "lib/sheldr/version"

Gem::Specification.new do |spec|
  spec.name = "sheldr"
  spec.version = Sheldr::VERSION
  spec.authors = ["Flynn Sol"]
  spec.email = ["flynn@flynnsol.com"]

  spec.summary = "Ruby CLI Building Tool"
  spec.description = "Sheldr is a CLI tool built in Ruby that is designed to assist in creating CLI tools/projects."
  spec.homepage = "https://github.com/flynnsol/Sheldr"
  spec.required_ruby_version = ">= 3.1.0"

  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/flynnsol/Sheldr"
  spec.metadata["changelog_uri"] = "https://github.com/flynnsol/Sheldr/blob/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .github appveyor Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
