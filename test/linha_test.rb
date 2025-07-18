require 'minitest/autorun'
require 'date'
require_relative '../linha'

# Test cases for Linha class
class LinhaTest < Minitest::Test
  def setup
    @linha = Linha.new('001', 'Linha Teste')
  end

  def test_initialization
    assert_equal '001', @linha.numero
    assert_equal 'Linha Teste', @linha.nome
    assert_empty @linha.dias
  end

  def test_add_dia
    date = Date.new(2023, 1, 15)
    @linha.add_dia(date, 100)
    
    assert_equal 1, @linha.dias.length
    assert_equal date, @linha.dias.first[:dia]
    assert_equal 100, @linha.dias.first[:total]
  end

  def test_total_for_date
    date = Date.new(2023, 1, 15)
    @linha.add_dia(date, 150)
    
    assert_equal 150, @linha.total_for_date(date)
    assert_nil @linha.total_for_date(Date.new(2023, 1, 16))
  end

  def test_overall_total
    @linha.add_dia(nil, 500)
    assert_equal 500, @linha.overall_total
    
    @linha.add_dia(Date.new(2023, 1, 15), 100)
    assert_equal 500, @linha.overall_total
  end

  def test_to_s
    expected = 'Linha 001: Linha Teste (0 data points)'
    assert_equal expected, @linha.to_s
    
    @linha.add_dia(Date.new(2023, 1, 15), 100)
    expected = 'Linha 001: Linha Teste (1 data points)'
    assert_equal expected, @linha.to_s
  end
end