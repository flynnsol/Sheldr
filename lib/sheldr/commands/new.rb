class New < Dry::CLI::Command
  desc "Creates a new CLI Application"

  argument :name, desc: "Name of Application"

  example [
    "app # Creates a new CLI Application with the name 'app'"
  ]

  def call(name: nil, **)
    if name.nil?
      puts `sheldr new --help`
    else
      puts "Creating the Application: "+name
    end
  end
end
