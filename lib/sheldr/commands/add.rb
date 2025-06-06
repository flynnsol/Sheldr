class Add < Dry::CLI::Command
  attr_reader :name

  desc "Creates a new command for your CLI Application"

  argument :name, desc: "Name of command"

  example [
    "command # Creates a new command for the CLI Application with the name 'command'"
  ]

  def call(name: nil, **)
    @name = name
    if name.nil?
      puts "No valid arguments - See info about the new command below"
      system_command("sheldr add --help")
    else
      create_command
    end
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
  desc \"TODO: Description\"
  
  def call(*)
    puts \"This is the new command #{name}.\"
  end
end")
    Dir.chdir("..")
    # register command in commands.rb
    puts "Registering the new #{name} command."
    commands_file = File.new("commands.rb", "a")
    commands_file.puts("#{capitalized_app_name}::CLI::Commands.register \"#{name}\", #{capitalized_name}")
  end

  # Call a system command
  def system_command(syscmd)
    puts `#{syscmd}`
  end
end