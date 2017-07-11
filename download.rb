require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'net/http'

module Download

    FULL_URL = "http://www.prefeitura.sp.gov.br/cidade/secretarias/transportes/institucional/sptrans/acesso_a_informacao/index.php?p=228269"

    def Download.get_files

        page = Nokogiri::HTML(open(FULL_URL))
        
        calendarios = page.css('.calendarios')

        puts "Download dos arquivos:\n"

        calendarios.children.each { |calendario|
            
            caption = calendario.css('caption')
            next if caption.text.strip.empty?

            folder_path = File.join(Dir.pwd, 'months', caption.text.strip)
            
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
            }
        }
        puts "\n\n"
    end
end