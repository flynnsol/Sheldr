class Version < Dry::CLI::Command
  desc "Prints the current Version"
  
  def call(*)
    puts Sheldr::VERSION
  end
end