#!/usr/bin/env ruby

$LOAD_PATH << '.'

require 'optparse'
require 'config'
require 'simple_logger'

# Command Line Interface for SPTrans Data Analysis
class CLI
  def initialize
    @options = {}
    @logger = SimpleLogger.instance
  end

  def run(args)
    parse_options(args)
    
    if @options[:help]
      show_help
      return
    end

    if @options[:version]
      show_version
      return
    end

    setup_logger
    
    case @options[:command]
    when 'download'
      download_only
    when 'process'
      process_only
    when 'analyze'
      full_analysis
    else
      full_analysis
    end
  end

  private

  def parse_options(args)
    parser = OptionParser.new do |opts|
      opts.banner = 'Usage: sptrans_analysis [options] [command]'
      
      opts.separator ''
      opts.separator 'Commands:'
      opts.separator '  download    Download files only'
      opts.separator '  process     Process downloaded files only'
      opts.separator '  analyze     Full analysis (download + process) [default]'
      opts.separator ''
      opts.separator 'Options:'
      
      opts.on('-c', '--config FILE', 'Configuration file path') do |config|
        @options[:config] = config
      end
      
      opts.on('-v', '--verbose', 'Enable verbose logging') do
        @options[:verbose] = true
      end
      
      opts.on('-q', '--quiet', 'Suppress output') do
        @options[:quiet] = true
      end
      
      opts.on('-h', '--help', 'Show this help message') do
        @options[:help] = true
      end
      
      opts.on('--version', 'Show version information') do
        @options[:version] = true
      end
    end
    
    parser.parse!(args)
    @options[:command] = args.first
  end

  def show_help
    puts <<~HELP
      SPTrans Data Analysis Tool
      
      This tool downloads and processes SPTrans bus data from the São Paulo
      government website, generating consolidated monthly reports.
      
      Usage:
        ruby cli.rb [options] [command]
      
      Commands:
        download    Download XLS files from government website
        process     Process downloaded files and generate reports
        analyze     Full analysis (download + process) [default]
      
      Options:
        -c, --config FILE    Use custom configuration file
        -v, --verbose        Enable verbose logging
        -q, --quiet          Suppress output
        -h, --help           Show this help message
        --version            Show version information
      
      Examples:
        ruby cli.rb                    # Run full analysis
        ruby cli.rb download           # Download files only
        ruby cli.rb -v process         # Process with verbose output
        ruby cli.rb -c custom.yml      # Use custom configuration
      
      Configuration:
        Copy config.sample.yml to config.yml and modify as needed.
        The tool will use default values if no config file is found.
    HELP
  end

  def show_version
    puts 'SPTrans Data Analysis Tool v1.0.0'
    puts 'A Ruby application for processing São Paulo bus transportation data'
  end

  def setup_logger
    if @options[:verbose]
      @logger.set_level('DEBUG')
    elsif @options[:quiet]
      @logger.set_level('ERROR')
    else
      @logger.set_level(Config.logging_level)
    end
  end

  def download_only
    @logger.info('Starting download-only mode...')
    require 'download'
    Download.get_files
    @logger.info('Download completed!')
  end

  def process_only
    @logger.info('Starting process-only mode...')
    require 'main'
    # Load the process_data method from main.rb
    load 'main.rb'
    @logger.info('Processing completed!')
  end

  def full_analysis
    @logger.info('Starting full analysis...')
    require 'main'
    # Load and run the full main.rb
    load 'main.rb'
    @logger.info('Full analysis completed!')
  end
end

# Run CLI if this file is executed directly
if __FILE__ == $0
  cli = CLI.new
  cli.run(ARGV)
end