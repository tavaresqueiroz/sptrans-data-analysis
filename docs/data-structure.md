# Data Structure Documentation

This document describes the data structures used in the SPTrans Data Analysis application.

## Excel File Structure

The application processes Excel files downloaded from the São Paulo government website. These files contain bus line data with the following structure:

### Input File Columns

| Column | Description | Type |
|--------|-------------|------|
| 0 | Row identifier | String |
| 1-2 | Additional identifiers | String |
| 3 | Company name (empresa) | String |
| 4 | Line number and name (numero - nome) | String |
| 5-17 | Various data fields | Mixed |
| 18 | Quantity/Total (qtd) | Numeric |

### Special File Types

**Total Files**: Files with "total" in the name use a different column structure:
- Column 2: Company name
- Column 3: Line number and name
- Column 17: Quantity/Total

## Internal Data Models

### Linha (Bus Line)

Represents a single bus line with its associated data.

```ruby
class Linha
  attr_accessor :numero, :nome, :dias
  
  # numero: String - Bus line number (e.g., "001")
  # nome: String - Bus line name (e.g., "Terminal Exemplo")
  # dias: Array - Collection of daily data records
end
```

#### Daily Data Structure
```ruby
{
  dia: Date,     # Date object or nil for totals
  total: Numeric # Total value for this date
}
```

### Mes (Month)

Represents a month's worth of bus line data.

```ruby
class Mes
  attr_accessor :nome, :linhas
  
  # nome: String - Month name (e.g., "Janeiro 2023")
  # linhas: Array<Linha> - Collection of bus lines
end
```

## Output File Structure

The application generates consolidated Excel files with the following structure:

### Output Columns

| Column | Description | Type |
|--------|-------------|------|
| A | Line number | String |
| B | Line name | String |
| C-? | Daily totals (one per day) | Numeric |
| Last | Monthly total | Numeric |

### File Organization

```
months/
├── [Month Name]/          # Downloaded files
│   ├── arquivo-20230101.xls
│   ├── arquivo-20230102.xls
│   └── ...
└── result/                # Generated reports
    ├── Janeiro 2023.xls
    ├── Fevereiro 2023.xls
    └── ...
```

## Configuration Structure

The application uses a YAML configuration file with the following structure:

```yaml
# Company filter
company_filter: "SAMBAIBA"

# Directory configuration
output_directory: "months/result"
download_directory: "months"

# File permissions (octal)
file_permissions: "0755"

# Data source URL
data_url: "http://..."

# Date formatting
date_format: "%d-%m-%Y"

# Logging configuration
logging:
  enabled: true
  level: "INFO"

# Excel processing configuration
excel:
  columns:
    empresa: 3
    nome: 4
    qtd: 18
    total_empresa: 2
    total_nome: 3
    total_qtd: 17
```

## Processing Flow

1. **Download Phase**: Files are downloaded and organized by month
2. **Parse Phase**: Each Excel file is parsed and filtered
3. **Aggregate Phase**: Data is aggregated by line and date
4. **Output Phase**: Consolidated Excel files are generated

## Error Handling

The application handles various error conditions:

- Network failures during download
- Malformed Excel files
- Missing data fields
- Invalid date formats
- File permission issues

## Performance Considerations

- Files are processed sequentially
- Memory usage scales with the number of bus lines
- Large months may require significant processing time
- Network speed affects download performance