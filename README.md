# SPTrans Data Analysis

A Ruby application for downloading and analyzing SPTrans (São Paulo public transportation) data from the São Paulo government website.

## Overview

This application downloads Excel files containing bus line data from the São Paulo municipal government website, processes the data to extract information about specific bus companies (currently configured for "SAMBAIBA"), and generates consolidated monthly reports.

## Features

- **Automated Data Download**: Downloads XLS files from the São Paulo government transparency portal
- **Data Processing**: Filters and processes bus line data by company and date
- **Report Generation**: Creates consolidated monthly Excel reports with daily breakdowns
- **Date-based Analysis**: Organizes data by month and generates summaries

## Requirements

- Ruby 3.0 or higher
- Bundler for dependency management
- Internet connection for downloading data files

## Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/tavaresqueiroz/sptrans-data-analysis.git
   cd sptrans-data-analysis
   ```

2. Install dependencies:
   ```bash
   bundle install
   ```

3. Run the application:
   ```bash
   ruby main.rb
   ```

## Usage

The application will automatically:
1. Download XLS files from the São Paulo government website
2. Create a `months/` directory structure
3. Process the data for the configured company (SAMBAIBA)
4. Generate consolidated reports in `months/result/`

### Output Structure

```
months/
├── [Month Name]/
│   ├── [downloaded XLS files]
│   └── ...
└── result/
    └── [Month Name].xls
```

## Configuration

The application currently uses hard-coded configurations:
- **Company Filter**: "SAMBAIBA" (configurable in `main.rb`)
- **Data Source**: São Paulo government transparency portal
- **Output Directory**: `months/result/`

## Dependencies

- `nokogiri` - HTML/XML parsing for web scraping
- `spreadsheet` - Excel file reading and writing
- `pry-byebug` - Debugging support

## Project Structure

```
.
├── main.rb          # Main application entry point
├── download.rb      # Web scraping and file download module
├── linha.rb         # Bus line data model
├── mes.rb           # Monthly data model
├── Gemfile          # Ruby dependencies
├── Gemfile.lock     # Locked dependency versions
└── .vscode/         # VS Code configuration
```

## Data Flow

1. **Download Phase**: Scrapes the government website for XLS file links
2. **Processing Phase**: Reads each XLS file and extracts relevant data
3. **Filtering Phase**: Filters data by company name and date
4. **Consolidation Phase**: Combines data by month and bus line
5. **Export Phase**: Generates new XLS files with processed data

## Development

### Running in Development Mode

```bash
# Install development dependencies
bundle install

# Run the application
ruby main.rb
```

### Debugging

The application includes `pry-byebug` for debugging. You can add breakpoints using:
```ruby
binding.pry
```

## Known Issues

- Application depends on the São Paulo government website structure
- Limited error handling for network failures
- Hard-coded configuration values
- No comprehensive test coverage

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request

## License

This project is open source. Please check with the repository owner for specific licensing terms.

## Contact

For questions or support, please open an issue in the GitHub repository.