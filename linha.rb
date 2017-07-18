class Linha
    attr_accessor :numero, :nome, :dias
    
    def initialize numero, nome
        @numero = numero
        @nome = nome
        @dias = Array.new
    end

    def add_dia data, total
        @dias.push({ :dia => data, :total => total })
    end
end