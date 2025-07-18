require 'minitest/autorun'
require_relative '../mes'
require_relative '../linha'

# Test cases for Mes class
class MesTest < Minitest::Test
  def setup
    @mes = Mes.new('Janeiro 2023')
  end

  def test_initialization
    assert_equal 'Janeiro 2023', @mes.nome
    assert_empty @mes.linhas
  end

  def test_initialization_with_linhas
    linha1 = Linha.new('001', 'Linha 1')
    linha2 = Linha.new('002', 'Linha 2')
    mes = Mes.new('Fevereiro 2023', [linha1, linha2])
    
    assert_equal 2, mes.linhas.length
    assert_equal linha1, mes.linhas.first
    assert_equal linha2, mes.linhas.last
  end

  def test_add_linha
    linha = Linha.new('001', 'Linha Teste')
    @mes.add_linha(linha)
    
    assert_equal 1, @mes.linhas.length
    assert_equal linha, @mes.linhas.first
  end

  def test_find_linha
    linha1 = Linha.new('001', 'Linha 1')
    linha2 = Linha.new('002', 'Linha 2')
    @mes.add_linha(linha1)
    @mes.add_linha(linha2)
    
    assert_equal linha1, @mes.find_linha('001')
    assert_equal linha2, @mes.find_linha('002')
    assert_nil @mes.find_linha('003')
  end

  def test_total_linhas
    assert_equal 0, @mes.total_linhas
    
    @mes.add_linha(Linha.new('001', 'Linha 1'))
    assert_equal 1, @mes.total_linhas
    
    @mes.add_linha(Linha.new('002', 'Linha 2'))
    assert_equal 2, @mes.total_linhas
  end

  def test_to_s
    expected = 'Mes Janeiro 2023: 0 linhas'
    assert_equal expected, @mes.to_s
    
    @mes.add_linha(Linha.new('001', 'Linha 1'))
    expected = 'Mes Janeiro 2023: 1 linhas'
    assert_equal expected, @mes.to_s
  end
end