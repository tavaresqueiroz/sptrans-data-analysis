require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'net/http'

module Download

    MAIN_FOLDER = "months"
    FULL_URL = "http://www.prefeitura.sp.gov.br/cidade/secretarias/transportes/institucional/sptrans/acesso_a_informacao/index.php?p=188767"

    def Download.get_files

        unless File.directory?(File.join(Dir.pwd, MAIN_FOLDER))
            Dir.mkdir(File.join(Dir.pwd, MAIN_FOLDER), 0777)
        end

        page = Nokogiri::HTML(open(FULL_URL))
        
        calendarios = page.css('.calendarios')

        puts "Download dos arquivos:\n"

        calendarios.children.each { |calendario|
            
            caption = calendario.css('caption')
            next if caption.text.strip.empty?

            folder_path = File.join(Dir.pwd, MAIN_FOLDER, caption.text.strip)
            
            unless File.directory?(folder_path)
                Dir.mkdir(folder_path, 0777)
            end

            puts caption.text.strip

            tbody = calendario.css('table').css('tbody')
            tbody.css('td').each { |td|
                anchor = td.css('a')
                next if anchor.nil?
                next if anchor[0].nil?
                href = anchor[0]['href']
                
                file_name = href.split('/').last
                
                uri = URI(href)
                
                begin
                    Net::HTTP.start(uri.host) do |http|
                        unless File.exist?(File.join(folder_path, file_name))
                            xls = File.open(File.join(folder_path, file_name), "wb")
                            begin
                                http.request_get(uri.path) do |resp|
                                    resp.read_body do |segment|
                                        xls.write(segment)
                                    end
                                end
                            ensure
                                xls.close()
                            end
                        end
                    end
                    puts "* " + file_name
                rescue StandardError => e
                    puts e
                end
            }
        }
        puts "\n\n"
    end
end