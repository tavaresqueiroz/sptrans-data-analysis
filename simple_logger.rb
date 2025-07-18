require 'logger'

# Simple logging utility for SPTrans Data Analysis
class SimpleLogger
  LEVELS = {
    'DEBUG' => Logger::DEBUG,
    'INFO' => Logger::INFO,
    'WARN' => Logger::WARN,
    'ERROR' => Logger::ERROR,
    'FATAL' => Logger::FATAL
  }.freeze

  def self.instance
    @instance ||= new
  end

  def initialize
    @logger = Logger.new(STDOUT)
    @logger.level = LEVELS['INFO']
    @logger.formatter = proc do |severity, datetime, progname, msg|
      "[#{datetime.strftime('%Y-%m-%d %H:%M:%S')}] #{severity}: #{msg}\n"
    end
  end

  def set_level(level)
    @logger.level = LEVELS[level.upcase] || Logger::INFO
  end

  def debug(message)
    @logger.debug(message)
  end

  def info(message)
    @logger.info(message)
  end

  def warn(message)
    @logger.warn(message)
  end

  def error(message)
    @logger.error(message)
  end

  def fatal(message)
    @logger.fatal(message)
  end
end