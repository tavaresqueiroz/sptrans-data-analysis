require 'rubygems'
require 'nokogiri'
require 'open-uri'

page = Nokogiri::HTML(open("http://www.prefeitura.sp.gov.br/cidade/secretarias/transportes/institucional/sptrans/acesso_a_informacao/index.php?p=228269"))
file = File.open("saida2.txt", 'a')

calendarios = page.css('.calendarios')

puts calendarios.children.length

calendarios.children.each { |calendario|
    file.write(calendario.css('table'))
}