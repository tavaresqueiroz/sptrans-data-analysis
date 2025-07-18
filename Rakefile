require 'rake'
require 'rake/testtask'

# Define test task
Rake::TestTask.new(:test) do |t|
  t.libs << 'test'
  t.test_files = FileList['test/*_test.rb']
  t.verbose = true
end

# Define RuboCop task
begin
  require 'rubocop/rake_task'
  RuboCop::RakeTask.new(:rubocop) do |task|
    task.options = ['--display-cop-names']
  end
rescue LoadError
  puts "RuboCop not available. Install it with: gem install rubocop"
end

# Define main application task
desc 'Run the main SPTrans data analysis application'
task :run do
  ruby 'main.rb'
end

# Define setup task
desc 'Set up the development environment'
task :setup do
  puts 'Setting up development environment...'
  puts 'Installing dependencies...'
  system 'bundle install'
  
  puts 'Creating sample configuration...'
  unless File.exist?('config.yml')
    system 'cp config.sample.yml config.yml'
    puts 'Created config.yml from sample. Please review and modify as needed.'
  end
  
  puts 'Setup complete!'
end

# Define clean task
desc 'Clean up generated files'
task :clean do
  puts 'Cleaning up generated files...'
  FileUtils.rm_rf('months') if Dir.exist?('months')
  puts 'Cleanup complete!'
end

# Define default task
task default: [:test, :rubocop]

# Define quality task
desc 'Run all quality checks'
task quality: [:test, :rubocop]