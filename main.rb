require 'spreadsheet'

workbook = Spreadsheet.open (File.join(Dir.pwd, "files", "Passag-20170101.xls"))
worksheet = workbook.worksheets[0]

file = File.open("saida.txt", 'a')

#http://www.prefeitura.sp.gov.br/cidade/secretarias/transportes/institucional/sptrans/acesso_a_informacao/index.php?p=228269

worksheet.each do |row|
	break if row[0].nil?
	file.write("#{row[4]} \t\t\t\t\ #{row[18]}\n") if row[3] == "SAMBAIBA"
end