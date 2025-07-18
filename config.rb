require 'yaml'

# Configuration management for SPTrans Data Analysis
class Config
  DEFAULT_CONFIG = {
    'company_filter' => 'SAMBAIBA',
    'output_directory' => 'months/result',
    'download_directory' => 'months',
    'file_permissions' => '0755',
    'data_url' => 'http://www.prefeitura.sp.gov.br/cidade/secretarias/transportes/institucional/sptrans/acesso_a_informacao/index.php?p=188767',
    'date_format' => '%d-%m-%Y',
    'logging' => {
      'enabled' => true,
      'level' => 'INFO'
    }
  }.freeze

  def self.load(config_file = 'config.yml')
    config = DEFAULT_CONFIG.dup
    
    if File.exist?(config_file)
      file_config = YAML.load_file(config_file)
      config.merge!(file_config) if file_config.is_a?(Hash)
    end
    
    config
  end

  def self.get(key)
    @config ||= load
    @config[key]
  end

  def self.company_filter
    get('company_filter')
  end

  def self.output_directory
    get('output_directory')
  end

  def self.download_directory
    get('download_directory')
  end

  def self.file_permissions
    get('file_permissions').to_i(8)
  end

  def self.data_url
    get('data_url')
  end

  def self.date_format
    get('date_format')
  end

  def self.logging_enabled?
    get('logging')['enabled']
  end

  def self.logging_level
    get('logging')['level']
  end
end