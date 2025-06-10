class Add < Dry::CLI::Command
  attr_reader :name, :description

  desc "Creates a new command for your CLI Application"

  argument :name, required: true, desc: "Name of the Command"
  option :desc, default: "Description", desc: "Description of the Command"
  option :alises, default: nil, desc: "Alises for the Command"

  example [
    "command # Creates a new command for the CLI Application with the name 'command'"
  ]

  def call(name: nil, **options)
    @name = name
    @description = options.fetch(:desc)
    # Format Aliases
    alias_input = options.fetch(:aliases)
    alias_split = alias_input.split(" ")
    alias_final = ""
    loop_count = 0
    for alias_name in alias_split do
      alias_final = "\"" + alias_name + "\""
      loop_count++
      if loop_count != alias_split.length()
        alias_final = alias_final + ", "
      end
    end
    @alises = options.fetch(:aliases)

    create_command
  end

  def create_command
    capitalized_name = name.capitalize
    current_dir = Dir.pwd
    name_array = current_dir.split("/")
    app_name = name_array[name_array.length() - 1]
    capitalized_app_name = app_name.capitalize

    # create command file
    puts "Creating #{name}.rb command file."
    Dir.chdir("lib")
    Dir.chdir("#{app_name}")
    Dir.chdir("commands")
    command_file = File.new("#{name}.rb", "w")
    command_file.puts("class #{capitalized_name} < Dry::CLI::Command
  desc \"#{description}\"
  
  def call(*)
    puts \"This is the new command #{name}.\"
  end
end")
    Dir.chdir("..")
    # register command in commands.rb
    puts "Registering the new #{name} command."
    commands_file = File.new("commands.rb", "a")
    if alises.nil?
      commands_file.puts("#{capitalized_app_name}::CLI::Commands.register \"#{name}\", #{capitalized_name}")
    else
      commands_file.puts("#{capitalized_app_name}::CLI::Commands.register \"#{name}\", #{capitalized_name}, aliases: [#{aliases}]")
    end
  end

  # Call a system command
  def system_command(syscmd)
    puts `#{syscmd}`
  end
end