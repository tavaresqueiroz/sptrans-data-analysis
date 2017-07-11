$LOAD_PATH << '.'

require 'spreadsheet'
require 'download'

#Download.get_files

MAIN_FOLDER = 'months'

puts "Processando arquivos:"

def process_xls(workbook, sheet)
	
	worksheet = workbook.worksheets[0]
	
	index = 0;
	worksheet.each do |row|
		break if row[0].nil?
		next unless row[3] == "SAMBAIBA"
		
		column = sheet.row(index).column(0) 
		

		sheet.row(index).push(row[4]) unless row[4].nil? && sheet.row(index) == row[4]
		sheet.row(index).push(row[18]) unless row[18].nil?

		index += 1
	end

	return true
end

Dir.foreach(File.join(Dir.pwd, MAIN_FOLDER)) do |month|
	next if month == '.' || month == '..'
	
	puts month

	newbook = Spreadsheet::Workbook.new
	sheet = newbook.create_worksheet

	subfolder = File.join(Dir.pwd, MAIN_FOLDER, month)

	can_write = false

	Dir.foreach(subfolder) do |xls|
		next if xls == '.' || xls == '..' || month + ".xls" == xls
		
		puts "* " + xls

		workbook = Spreadsheet.open(File.join(Dir.pwd, MAIN_FOLDER, month, xls))
		can_write = process_xls(workbook, sheet)
	end

	newbook.write(File.join(subfolder, month + ".xls")) if can_write

end