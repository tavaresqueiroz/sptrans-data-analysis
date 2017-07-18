$LOAD_PATH << '.'

require 'spreadsheet'
require 'download'
require 'linha'
require 'mes'

Download.get_files

puts "Processando arquivos:"

FULL_PATH_MONTHS = File.join(Dir.pwd, Download::MAIN_FOLDER)

def read_xls_lines workbook, data, linhas
	
	worksheet = workbook.worksheets[0]
	
	worksheet.each do |row|

		break if row[0].nil?
		
		empresa = 3
		nome = 4
		qtd = 18
		if data == "total"
			empresa = 2
			nome = 3
			qtd = 17
		end

		next unless row[empresa] == "SAMBAIBA"

		numero, nome = row[nome].split(' - ')
		total = row[qtd].respond_to?("value") ? row[qtd].value : row[qtd]

		linha = linhas.find { |l| l.numero == numero }

		linha = linha || Linha.new(numero, nome)

		linha.add_dia (Date.parse(data) unless data == "total"), total

		index = linhas.index { |x| x.numero == linha.numero}
		if index.nil?
			linhas.push linha
		else
			linhas[index] = linha
		end
	end
	linhas
end

def write_new_xls mes_atual, path, data

	newbook = Spreadsheet::Workbook.new
	sheet = newbook.create_worksheet

	days = Array.new 
	(1..31).each { |d| 
		if Date.valid_date?(data.year, data.month, d)
			days.push d
		end
	}

	sheet.row(0).push("")
	sheet.row(0).push("")

	days.each { |d|
		i = Date.new(data.year, data.month, d)
		sheet.row(0).push(i.strftime('%d-%m-%Y'))
	}
	sheet.row(0).push("Total")

	increase = 1
	mes_atual.linhas.each_with_index { |linha,index|
		sheet.row(index + increase).push(linha.numero)
		sheet.row(index + increase).push(linha.nome)
	}

	mes_atual.linhas.each_with_index { |linha,index|
		days.each { |d|
			dia = linha.dias.find { |item|
				(item[:dia] <=> Date.new(data.year, data.month, d)) == 0
			}
			unless dia.nil?
				sheet.row(index + increase).push(dia[:total]) 
			else
				sheet.row(index + increase).push(0)
			end
		}

		dia = linha.dias.find { |item|
			item[:dia].nil?
		}
		sheet.row(index + increase).push(dia[:total]) unless dia.nil?
	}

	unless File.directory?(path)
		Dir.mkdir(path, 0777)
	end

	newbook.write(File.join(path, mes_atual.nome + ".xls"))
end

def get_data_string str
	tmp = str.split("-")[1] unless str.split("-")[1].nil?
	unless tmp.nil?
			tmp.split(".")[0]
	else
		"total"
	end
end

def init
	Dir.foreach(FULL_PATH_MONTHS) do |month|
		next if month == '.' || month == '..'

		puts "#{month}"

		subfolder = File.join(FULL_PATH_MONTHS, month)

		next if Dir[File.join(subfolder, "*")].empty?

		linhas = Array.new
		parsed_data = nil
		Dir.foreach(subfolder) do |xls|
			next if xls == '.' || xls == '..' || month + ".xls" == xls
			
			puts "* " + xls

			data = get_data_string(xls)
			if parsed_data.nil?
				parsed_data = Date.strptime(data, "%Y%m%d") unless data == "total"
			end
			
			workbook = Spreadsheet.open(File.join(FULL_PATH_MONTHS, month, xls))
			
			linhas = read_xls_lines workbook, data, linhas
		end

		mes_atual = Mes.new month, linhas

		write_new_xls mes_atual, File.join(FULL_PATH_MONTHS, "result"), parsed_data
	end
end

begin
	init
rescue => exception
	puts exception
end

puts "**Terminado**"