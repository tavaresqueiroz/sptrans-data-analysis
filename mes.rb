# Represents a month's worth of bus line data
class Mes
  attr_accessor :linhas, :nome

  def initialize(nome, linhas = [])
    @nome = nome
    @linhas = linhas || []
  end

  # Add a bus line to this month
  # @param linha [Linha] The bus line to add
  def add_linha(linha)
    @linhas << linha
  end

  # Find a bus line by number
  # @param numero [String] The bus line number
  # @return [Linha, nil] The bus line if found, nil otherwise
  def find_linha(numero)
    @linhas.find { |linha| linha.numero == numero }
  end

  # Get total number of bus lines
  # @return [Integer] The number of bus lines
  def total_linhas
    @linhas.length
  end

  def to_s
    "Mes #{@nome}: #{total_linhas} linhas"
  end
end