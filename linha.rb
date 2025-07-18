# Represents a bus line with its number, name, and daily data
class Linha
  attr_accessor :numero, :nome, :dias
  
  def initialize(numero, nome)
    @numero = numero
    @nome = nome
    @dias = []
  end

  # Add daily data for this bus line
  # @param data [Date, nil] The date for this data point (nil for totals)
  # @param total [Numeric] The total value for this date
  def add_dia(data, total)
    @dias.push({ dia: data, total: total })
  end

  # Get total for a specific date
  # @param date [Date] The date to get total for
  # @return [Numeric, nil] The total for the date, or nil if not found
  def total_for_date(date)
    dia = @dias.find { |item| item[:dia] == date }
    dia ? dia[:total] : nil
  end

  # Get overall total (data without date)
  # @return [Numeric, nil] The overall total, or nil if not found
  def overall_total
    dia = @dias.find { |item| item[:dia].nil? }
    dia ? dia[:total] : nil
  end

  def to_s
    "Linha #{@numero}: #{@nome} (#{@dias.length} data points)"
  end
end