require 'minitest/autorun'

# Load all test files
test_files = Dir[File.join(__dir__, '*_test.rb')]
test_files.each { |file| require file }