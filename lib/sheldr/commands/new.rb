class New < Dry::CLI::Command
  attr_reader :name, :author, :email, :summary, :description, :homepage, :rubyversion, :aph, :sourcecode, :changelog

  desc "Creates a new CLI Application"

  argument :name, required: true, desc: "Name of the Application"
  option :author, default: "TODO: Author Name", desc: "Author of the Application"
  option :email, default: "TODO: Email", desc: "Email for the Application"
  option :summary, default: "TODO: Summary", desc: "Summary of the Application"
  option :desc, default: "TODO: Description", desc: "Description of the Application"
  option :homepage, default: "TODO: Homepage URI", desc: "Homepage URI of the Application"
  option :rubyversion, default: ">= 3.1.0", desc: "Ruby Version of the Application"
  option :aph, default: "https://rubygems.org", desc: "Allowed Push Host"
  option :sourcecode, default: "TODO: Sourcecode URI", desc: "Sourcecode URI of the Application"
  option :changelog, default: "TODO: Changelog URI", desc: "Changelog URI of the Application"

  example [
    "app # Creates a new CLI Application with the name 'app'"
  ]

  def call(name:, **options)
    # Set Variables
    @name = name
    @author = options.fetch(:author)
    @email = options.fetch(:email)
    @summary = options.fetch(:summary)
    @description = options.fetch(:desc)
    @homepage = options.fetch(:homepage)
    @rubyversion = options.fetch(:rubyversion)
    @aph = options.fetch(:aph)
    @sourcecode = options.fetch(:sourcecode)
    @changelog = options.fetch(:changelog)

    # Check for main Argument
    create_folder_structure
  end

  def create_folder_structure
    capitalized_name = name.capitalize
    # create project folder
    puts ("Creating the #{name} directory.")
    system_command("mkdir #{name}")
    Dir.chdir("#{name}")
    # create .github/
    puts ("Creating the .github directory.")
    system_command("mkdir .github")
    Dir.chdir(".github")
    # create .github/workflows
    puts ("Creating the .github/workflows directory.")
    system_command("mkdir workflows")
    Dir.chdir("workflows")
    # create .github/workflows/main.yml
    puts ("Creating the .github/workflows/main.yml file.")
    main_yml = File.new("main.yml", "w")
    main_yml.puts("name: Ruby

on:
  push:
    branches:
      - master

  pull_request:

jobs:
  build:
    runs-on: ubuntu-latest
    name: Ruby ${{ matrix.ruby }}
    strategy:
      matrix:
        ruby:
          - '3.4.2'

    steps:
      - uses: actions/checkout@v4
      - name: Set up Ruby
        uses: ruby/setup-ruby@v1
        with:
          ruby-version: ${{ matrix.ruby }}
          bundler-cache: true
      - name: Run the default task
        run: bundle exec rake
")
    Dir.chdir("..")
    Dir.chdir("..")
    # create exe/
    puts ("Creating the exe directory.")
    system_command("mkdir exe")
    Dir.chdir("exe")
    # create executible file
    puts ("Creating the exe/#{name} file.")
    exe_file = File.new("#{name}", "w")
    exe_file.puts("#!/usr/bin/env ruby

require_relative '../lib/#{name}.rb'
")
    Dir.chdir("..")
    # create lib/
    puts ("Creating the lib directory.")
    system_command("mkdir lib")
    Dir.chdir("lib")
    # create main ruby class file
    puts ("Creating the lib/#{name}.rb file.")
    main_ruby_file = File.new("#{name}.rb", "w")
    main_ruby_file.puts("require \"bundler/setup\"
require \"dry/cli\"
require_relative \"./#{name}/commands.rb\"
require_relative \"./#{name}/version.rb\"

Dry::CLI.new(#{capitalized_name}::CLI::Commands).call")
    # create project folder in lib/
    puts ("Creating the lib/#{name} directory.")
    system_command("mkdir #{name}")
    Dir.chdir("#{name}")
    # create version.rb
    puts ("Creating the lib/#{name}/version.rb file.")
    version_file = File.new("version.rb", "w")
    version_file.puts("
module #{capitalized_name}
  VERSION = \"0.1.0\"
end
")
    # create commands.rb
    puts ("Creating the lib/#{name}/commands.rb file.")
    commands_file = File.new("commands.rb", "w")
    commands_file.puts("# Import All Commands from the Commands Directory

Dir[File.expand_path('./commands/*.rb', File.dirname(__FILE__))].each do |file|
  require file
end

# Define Commands Module

module #{capitalized_name}
  module CLI
    module Commands
      extend Dry::CLI::Registry
    end
  end
end

# Register Commands

#{capitalized_name}::CLI::Commands.register \"version\", Version, aliases: [\"v\", \"-v\", \"--version\"]")
    # create commands/
    puts ("Creating the lib/#{name}/commands directory.")
    system_command("mkdir commands")
    Dir.chdir("commands")
    # create version command
    puts ("Creating the lib/#{name}/commands/version.rb file.")
    version_command_file = File.new("version.rb", "w")
    version_command_file.puts("class Version < Dry::CLI::Command
  desc \"Prints the current Version\"
  
  def call(*)
    puts #{capitalized_name}::VERSION
  end
end")
    Dir.chdir("..")
    Dir.chdir("..")
    Dir.chdir("..")
    # create tests folder
    puts ("Creating the tests directory.")
    system_command("mkdir tests")
    # create .gitignore
    puts ("Creating the .gitignore file.")
    gitignore_file = File.new(".gitignore", "w")
    gitignore_file.puts("*.gem
*.rbc
/.config
/coverage/
/InstalledFiles
Gemfile.lock
/pkg
/spec/reports/
/spec/examples.txt
/test/tmp/
/test/version_tmp/
/tmp/


/.bundle/
/vendor/bundle
/lib/bundler/man/
")
    # create CHANGELOD.md
    puts ("Creating the CHANGELOG.md file.")
    changelog_file = File.new("CHANGELOG.md", "w")
    # create CODE_OF_CONDUCT.md
    puts ("Creating the CODE_OF_CONDUCT.md file.")
    code_of_conduct_file = File.new("CODE_OF_CONDUCT.md", "w")
    code_of_conduct_file.puts("# Contributor Covenant Code of Conduct

## Our Pledge

We as members, contributors, and leaders pledge to make participation in our
community a harassment-free experience for everyone, regardless of age, body
size, visible or invisible disability, ethnicity, sex characteristics, gender
identity and expression, level of experience, education, socio-economic status,
nationality, personal appearance, race, caste, color, religion, or sexual
identity and orientation.

We pledge to act and interact in ways that contribute to an open, welcoming,
diverse, inclusive, and healthy community.

## Our Standards

Examples of behavior that contributes to a positive environment for our
community include:

* Demonstrating empathy and kindness toward other people
* Being respectful of differing opinions, viewpoints, and experiences
* Giving and gracefully accepting constructive feedback
* Accepting responsibility and apologizing to those affected by our mistakes,
  and learning from the experience
* Focusing on what is best not just for us as individuals, but for the overall
  community

Examples of unacceptable behavior include:

* The use of sexualized language or imagery, and sexual attention or advances of
  any kind
* Trolling, insulting or derogatory comments, and personal or political attacks
* Public or private harassment
* Publishing others' private information, such as a physical or email address,
  without their explicit permission
* Other conduct which could reasonably be considered inappropriate in a
  professional setting

## Enforcement Responsibilities

Community leaders are responsible for clarifying and enforcing our standards of
acceptable behavior and will take appropriate and fair corrective action in
response to any behavior that they deem inappropriate, threatening, offensive,
or harmful.

Community leaders have the right and responsibility to remove, edit, or reject
comments, commits, code, wiki edits, issues, and other contributions that are
not aligned to this Code of Conduct, and will communicate reasons for moderation
decisions when appropriate.

## Scope

This Code of Conduct applies within all community spaces, and also applies when
an individual is officially representing the community in public spaces.
Examples of representing our community include using an official email address,
posting via an official social media account, or acting as an appointed
representative at an online or offline event.

## Enforcement

Instances of abusive, harassing, or otherwise unacceptable behavior may be
reported to the community leaders responsible for enforcement at
[INSERT CONTACT METHOD].
All complaints will be reviewed and investigated promptly and fairly.

All community leaders are obligated to respect the privacy and security of the
reporter of any incident.

## Enforcement Guidelines

Community leaders will follow these Community Impact Guidelines in determining
the consequences for any action they deem in violation of this Code of Conduct:

### 1. Correction

**Community Impact**: Use of inappropriate language or other behavior deemed
unprofessional or unwelcome in the community.

**Consequence**: A private, written warning from community leaders, providing
clarity around the nature of the violation and an explanation of why the
behavior was inappropriate. A public apology may be requested.

### 2. Warning

**Community Impact**: A violation through a single incident or series of
actions.

**Consequence**: A warning with consequences for continued behavior. No
interaction with the people involved, including unsolicited interaction with
those enforcing the Code of Conduct, for a specified period of time. This
includes avoiding interactions in community spaces as well as external channels
like social media. Violating these terms may lead to a temporary or permanent
ban.

### 3. Temporary Ban

**Community Impact**: A serious violation of community standards, including
sustained inappropriate behavior.

**Consequence**: A temporary ban from any sort of interaction or public
communication with the community for a specified period of time. No public or
private interaction with the people involved, including unsolicited interaction
with those enforcing the Code of Conduct, is allowed during this period.
Violating these terms may lead to a permanent ban.

### 4. Permanent Ban

**Community Impact**: Demonstrating a pattern of violation of community
standards, including sustained inappropriate behavior, harassment of an
individual, or aggression toward or disparagement of classes of individuals.

**Consequence**: A permanent ban from any sort of public interaction within the
community.

## Attribution

This Code of Conduct is adapted from the [Contributor Covenant][homepage],
version 2.1, available at
[https://www.contributor-covenant.org/version/2/1/code_of_conduct.html][v2.1].

Community Impact Guidelines were inspired by
[Mozilla's code of conduct enforcement ladder][Mozilla CoC].

For answers to common questions about this code of conduct, see the FAQ at
[https://www.contributor-covenant.org/faq][FAQ]. Translations are available at
[https://www.contributor-covenant.org/translations][translations].

[homepage]: https://www.contributor-covenant.org
[v2.1]: https://www.contributor-covenant.org/version/2/1/code_of_conduct.html
[Mozilla CoC]: https://github.com/mozilla/diversity
[FAQ]: https://www.contributor-covenant.org/faq
[translations]: https://www.contributor-covenant.org/translations
")
    # create Gemfile
    puts ("Creating the Gemfile file.")
    gemfile_file = File.new("Gemfile", "w")
    gemfile_file.puts("source \"https://rubygems.org\"

gem \"dry-cli\"")
    # create LICENSE.txt
    puts ("Creating the LICENSE.txt file.")
    license_file = File.new("LICENSE.txt", "w")
    license_file.puts("Copyright [Current Year] #{author}

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.

2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

3. Neither the name of the copyright holder nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS “AS IS” AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.")
    # create Rakefile
    puts ("Creating the Rakefile file.")
    rakefile_file = File.new("Rakefile", "w")
    rakefile_file.puts("# frozen_string_literal: true

require \"bundler/gem_tasks\"")
    # create gemspec file
    puts ("Creating the #{name}.gemspec file.")
    gemspec_file = File.new("#{name}.gemspec", "w")
    gemspec_file.puts("# frozen_string_literal: true

require_relative \"lib/#{name}/version\"

Gem::Specification.new do |spec|
  spec.name = \"#{name}\"
  spec.version = #{capitalized_name}::VERSION
  spec.authors = [\"#{author}\"]
  spec.email = [\"#{email}\"]

  spec.summary = \"#{summary}\"
  spec.description = \"#{description}\"
  spec.homepage = \"#{homepage}\"
  spec.required_ruby_version = \"#{rubyversion}\"

  spec.metadata[\"allowed_push_host\"] = \"#{aph}\"

  spec.metadata[\"homepage_uri\"] = spec.homepage
  spec.metadata[\"source_code_uri\"] = \"#{sourcecode}\"
  spec.metadata[\"changelog_uri\"] = \"#{changelog}\"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines(\"\\x0\", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .github appveyor Gemfile])
    end
  end
  spec.bindir = \"exe\"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = [\"lib\"]

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency \"example-gem\", \"~> 1.0\"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
")
    # bundle install to create Gemfile.lock
    puts ("Bundle install command to generate Gemfile.lock file.")
    system_command("bundle install")
  end


  # Call a system command
  def system_command(syscmd)
    puts `#{syscmd}`
  end
end
