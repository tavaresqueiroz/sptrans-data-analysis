$LOAD_PATH << '.'

require 'spreadsheet'
require 'date'
require 'download'
require 'linha'
require 'mes'
require 'config'
require 'simple_logger'

# Initialize logger
logger = SimpleLogger.instance
logger.set_level(Config.logging_level) if Config.logging_enabled?

# Download files
logger.info("Starting SPTrans data analysis...")
Download.get_files

logger.info("Processing files...")

FULL_PATH_MONTHS = File.join(Dir.pwd, Config.download_directory)

# Read XLS lines and filter by company
def read_xls_lines(workbook, data, linhas)
  worksheet = workbook.worksheets[0]
  
  worksheet.each do |row|
    break if row[0].nil?
    
    # Configure column indices based on data type
    empresa_col = data == "total" ? 2 : 3
    nome_col = data == "total" ? 3 : 4
    qtd_col = data == "total" ? 17 : 18

    # Filter by company name
    next unless row[empresa_col] == Config.company_filter

    numero, nome = row[nome_col].split(' - ')
    next if numero.nil? || nome.nil?
    
    total = row[qtd_col].respond_to?("value") ? row[qtd_col].value : row[qtd_col]

    # Find or create linha
    linha = linhas.find { |l| l.numero == numero }
    linha ||= Linha.new(numero, nome)

    # Add daily data
    date_value = data == "total" ? nil : Date.parse(data)
    linha.add_dia(date_value, total)

    # Update or add linha to collection
    index = linhas.index { |x| x.numero == linha.numero }
    if index.nil?
      linhas.push(linha)
    else
      linhas[index] = linha
    end
  end
  
  linhas
end

# Write consolidated Excel file
def write_new_xls(mes_atual, path, data)
  return if data.nil?
  
  newbook = Spreadsheet::Workbook.new
  sheet = newbook.create_worksheet

  # Generate valid days for the month
  days = []
  (1..31).each do |d|
    days.push(d) if Date.valid_date?(data.year, data.month, d)
  end

  # Create header row
  sheet.row(0).push("Número", "Nome")
  days.each do |d|
    date_obj = Date.new(data.year, data.month, d)
    sheet.row(0).push(date_obj.strftime(Config.date_format))
  end
  sheet.row(0).push("Total")

  # Add linha data
  mes_atual.linhas.each_with_index do |linha, index|
    row_index = index + 1
    sheet.row(row_index).push(linha.numero, linha.nome)
    
    # Add daily data
    days.each do |d|
      target_date = Date.new(data.year, data.month, d)
      dia = linha.dias.find { |item| item[:dia] == target_date }
      sheet.row(row_index).push(dia ? dia[:total] : 0)
    end
    
    # Add total
    total_dia = linha.dias.find { |item| item[:dia].nil? }
    sheet.row(row_index).push(total_dia ? total_dia[:total] : 0)
  end

  # Ensure output directory exists
  Dir.mkdir(path, Config.file_permissions) unless File.directory?(path)

  # Write file
  output_file = File.join(path, "#{mes_atual.nome}.xls")
  newbook.write(output_file)
  
  logger.info("Generated report: #{output_file}")
end

# Extract date from filename
def get_data_string(filename)
  parts = filename.split("-")
  return "total" if parts.length < 2
  
  date_part = parts[1]&.split(".")&.first
  date_part || "total"
end

# Main processing function
def process_data(logger)
  Dir.foreach(FULL_PATH_MONTHS) do |month|
    next if month == '.' || month == '..'

    logger.info("Processing month: #{month}")
    subfolder = File.join(FULL_PATH_MONTHS, month)
    
    next if Dir[File.join(subfolder, "*")].empty?

    linhas = []
    parsed_data = nil
    
    Dir.foreach(subfolder) do |xls_file|
      next if xls_file == '.' || xls_file == '..' || xls_file == "#{month}.xls"
      
      logger.info("Processing file: #{xls_file}")
      
      data = get_data_string(xls_file)
      if parsed_data.nil? && data != "total"
        parsed_data = Date.strptime(data, "%Y%m%d")
      end
      
      begin
        workbook = Spreadsheet.open(File.join(subfolder, xls_file))
        linhas = read_xls_lines(workbook, data, linhas)
      rescue => e
        logger.error("Error processing file #{xls_file}: #{e.message}")
        next
      end
    end

    next if linhas.empty?
    
    mes_atual = Mes.new(month, linhas)
    output_path = File.join(FULL_PATH_MONTHS, Config.output_directory)
    
    write_new_xls(mes_atual, output_path, parsed_data)
  end
end

# Main execution
begin
  process_data(logger)
  logger.info("Processing completed successfully!")
rescue => exception
  logger.error("Application error: #{exception.message}")
  logger.error(exception.backtrace.join("\n"))
end