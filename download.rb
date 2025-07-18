require 'rubygems'
require 'nokogiri'
require 'uri'
require 'net/http'
require 'net/https'
require 'config'
require 'simple_logger'

# Module for downloading XLS files from São Paulo government website
module Download
  def self.get_files
    logger = SimpleLogger.instance
    create_main_folder
    
    begin
      logger.info("Starting file download from government website...")
      page = fetch_page(Config.data_url)
      download_files_from_page(page, logger)
      logger.info("File download completed successfully")
    rescue StandardError => e
      logger.error("Error downloading files: #{e.message}")
      logger.error("Please check your internet connection and try again.")
    end
  end

  private

  def self.create_main_folder
    folder_path = File.join(Dir.pwd, Config.download_directory)
    Dir.mkdir(folder_path, Config.file_permissions) unless File.directory?(folder_path)
  end

  def self.fetch_page(url)
    uri = URI(url)
    response = Net::HTTP.get_response(uri)
    
    unless response.code == '200'
      raise "Failed to fetch page: HTTP #{response.code}"
    end
    
    Nokogiri::HTML(response.body)
  end

  def self.download_files_from_page(page, logger)
    calendarios = page.css('.calendarios')
    logger.info("Found #{calendarios.length} calendar sections")

    calendarios.children.each do |calendario|
      process_calendar(calendario, logger)
    end
  end

  def self.process_calendar(calendario, logger)
    caption = calendario.css('caption')
    return if caption.text.strip.empty?

    month_name = caption.text.strip
    folder_path = create_month_folder(month_name)
    logger.info("Processing month: #{month_name}")

    tbody = calendario.css('table tbody')
    file_count = 0
    
    tbody.css('td').each do |td|
      if download_file_from_cell(td, folder_path, logger)
        file_count += 1
      end
    end
    
    logger.info("Downloaded #{file_count} files for #{month_name}")
  end

  def self.create_month_folder(month_name)
    folder_path = File.join(Dir.pwd, Config.download_directory, month_name)
    Dir.mkdir(folder_path, Config.file_permissions) unless File.directory?(folder_path)
    folder_path
  end

  def self.download_file_from_cell(cell, folder_path, logger)
    anchor = cell.css('a')
    return false if anchor.nil? || anchor[0].nil?

    href = anchor[0]['href']
    return false if href.nil? || href.empty?

    file_name = href.split('/').last
    file_path = File.join(folder_path, file_name)
    
    if File.exist?(file_path)
      logger.debug("File already exists: #{file_name}")
      return false
    end

    download_file(href, file_path)
    logger.info("Downloaded: #{file_name}")
    true
  rescue StandardError => e
    logger.error("Error downloading #{file_name}: #{e.message}")
    false
  end

  def self.download_file(url, file_path)
    uri = URI(url)
    
    Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https') do |http|
      request = Net::HTTP::Get.new(uri.request_uri)
      
      http.request(request) do |response|
        if response.code == '200'
          File.open(file_path, 'wb') do |file|
            response.read_body do |chunk|
              file.write(chunk)
            end
          end
        else
          raise "HTTP #{response.code}: #{response.message}"
        end
      end
    end
  end
end