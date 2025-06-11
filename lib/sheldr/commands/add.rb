class Add < Dry::CLI::Command
  attr_reader :name, :description, :aliases, :args, :options

  desc "Creates a new command for your CLI Application"

  argument :name, required: true, desc: "Name of the Command"
  option :desc, default: "Description", desc: "Description of the Command"
  option :aliases, default: "", desc: "Alises for the Command"
  option :args, default: "", desc: "Arguments for the Command"
  option :options, default: "", desc: "Options for the Command"

  example [
    "command # Creates a new command for the CLI Application with the name 'command'"
  ]

  def call(name:, **options)
    @name = name
    @description = options.fetch(:desc)
    # Format Aliases
    alias_input = options.fetch(:aliases)
    alias_final = ""
    if !alias_input.nil?
      alias_split = alias_input.split(", ")
      for alias_name in alias_split do
        alias_final = alias_final + "\"" + alias_name + "\""
        alias_final = alias_final + ", "
      end
      alias_final = alias_final[0...-2]
    end
    # Set Aliases
    @aliases = alias_final
    # Format Arguments
    args_input = options.fetch(:args)
    args_final = ""
    if !args_input.nil?
      args_split = args_input.split("]")
      for arg in args_split do
        clean_args = arg.delete_prefix("[")
        clean_arg = clean_args.split(", ")
        arg_name = nil
        arg_required = nil
        arg_description = nil
        # Check Name
        if !clean_arg[0].nil?
          arg_name = clean_arg[0]
          # Required
          if !clean_arg[2].nil?
            # if required is there set it and description
            arg_required = clean_arg[1]
            arg_description = clean_arg[2]
          elsif clean_arg[2].nil? && !clean_arg[1].nil?
            # if description is there just set description
            arg_description = clean_arg
          end
        end
        if !arg_description.nil?
          if !arg_required.nil?
            args_final = args_final + "argument :#{arg_name}, required: #{arg_required}, desc: \"#{arg_description}\""
          else
            args_final = args_final + "argument :#{arg_name}, desc: \"#{arg_description}\""
          end
        end
      end
      # Set Arguments
      @args = args_final
    end

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

  #{args}
  
  def call(*)
    puts \"This is the new command #{name}.\"
  end
end")
    Dir.chdir("..")
    # register command in commands.rb
    puts "Registering the new #{name} command."
    commands_file = File.new("commands.rb", "a")
    if aliases.nil?
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