#!/usr/bin/env ruby

# Example script showing how to use the SPTrans Data Analysis library programmatically

$LOAD_PATH << '.'

require 'date'
require 'config'
require 'simple_logger'
require 'download'
require 'linha'
require 'mes'

# Initialize with custom configuration
puts "SPTrans Data Analysis - Programmatic Example"
puts "=" * 50

# Setup logger
logger = SimpleLogger.instance
logger.set_level('INFO')

# Display configuration
puts "Configuration:"
puts "  Company Filter: #{Config.company_filter}"
puts "  Download Directory: #{Config.download_directory}"
puts "  Output Directory: #{Config.output_directory}"
puts "  Data URL: #{Config.data_url}"
puts

# Example 1: Create a bus line manually
puts "Example 1: Creating a bus line manually"
linha = Linha.new('001', 'Terminal Exemplo - Centro')
linha.add_dia(Date.new(2023, 1, 15), 150)
linha.add_dia(Date.new(2023, 1, 16), 200)
linha.add_dia(nil, 350) # Total

puts "  Created: #{linha}"
puts "  Total for 2023-01-15: #{linha.total_for_date(Date.new(2023, 1, 15))}"
puts "  Overall total: #{linha.overall_total}"
puts

# Example 2: Create a month with multiple lines
puts "Example 2: Creating a month with multiple lines"
mes = Mes.new('Janeiro 2023')
mes.add_linha(linha)

linha2 = Linha.new('002', 'Linha Exemplo 2')
linha2.add_dia(Date.new(2023, 1, 15), 100)
linha2.add_dia(Date.new(2023, 1, 16), 120)
mes.add_linha(linha2)

puts "  Created: #{mes}"
puts "  Total lines: #{mes.total_linhas}"
puts "  Found line 001: #{mes.find_linha('001')&.nome}"
puts

# Example 3: Configuration examples
puts "Example 3: Working with configuration"
puts "  Current logging level: #{Config.logging_level}"
puts "  Logging enabled: #{Config.logging_enabled?}"
puts "  File permissions: #{Config.file_permissions.to_s(8)}"
puts

# Example 4: Download simulation (commented out to avoid actual download)
puts "Example 4: Download simulation"
puts "  To download files, uncomment the following line:"
puts "  # Download.get_files"
puts

puts "Example completed successfully!"
puts "Run 'ruby cli.rb --help' for CLI usage information"