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

### Command Line Interface

The application provides a command-line interface for easy usage:

```bash
# Full analysis (download and process)
ruby cli.rb

# Download files only
ruby cli.rb download

# Process existing files only
ruby cli.rb process

# Verbose output
ruby cli.rb -v

# Use custom configuration
ruby cli.rb -c custom_config.yml

# Show help
ruby cli.rb --help
```

### Programmatic Usage

You can also use the library programmatically:

```ruby
require_relative 'examples/usage_example'
# See examples/usage_example.rb for detailed examples
```

### Configuration

1. Copy the sample configuration:
   ```bash
   cp config.sample.yml config.yml
   ```

2. Edit `config.yml` to match your needs:
   - Change `company_filter` to process different companies
   - Adjust directory paths
   - Configure logging levels
   - Modify column mappings if needed

### Traditional Usage

The application will automatically:
1. Download XLS files from the São Paulo government website
2. Create a `months/` directory structure
3. Process the data for the configured company (default: SAMBAIBA)
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

The application supports extensive configuration through YAML files:

### Default Configuration

The application includes sensible defaults and will work without a configuration file.

### Custom Configuration

1. **Copy the sample configuration**:
   ```bash
   cp config.sample.yml config.yml
   ```

2. **Edit configuration options**:
   - **Company Filter**: Change which bus company to process
   - **Directories**: Customize download and output directories
   - **Logging**: Configure logging levels and output
   - **Data Source**: Modify the URL if needed
   - **File Permissions**: Set directory permissions

### Configuration Options

```yaml
# Company to filter data by
company_filter: "SAMBAIBA"

# Directory paths
output_directory: "months/result"
download_directory: "months"

# Logging settings
logging:
  enabled: true
  level: "INFO"  # DEBUG, INFO, WARN, ERROR

# Advanced settings
file_permissions: "0755"
date_format: "%d-%m-%Y"
```

See `config.sample.yml` for a complete configuration example.

## Dependencies

- `nokogiri` (~> 1.15) - HTML/XML parsing for web scraping
- `spreadsheet` (~> 1.3) - Excel file reading and writing

### Development Dependencies

- `pry-byebug` (~> 3.10) - Debugging support
- `rubocop` (~> 1.50) - Code style linting
- `minitest` (~> 5.18) - Unit testing framework

## Known Issues

- Application depends on the São Paulo government website structure
- Limited error handling for network failures
- Hard-coded configuration values
- No comprehensive test coverage

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Run tests and quality checks: `rake quality`
5. Submit a pull request

See [CONTRIBUTING.md](CONTRIBUTING.md) for detailed contribution guidelines.

## Project Structure

```
.
├── main.rb              # Main application entry point
├── cli.rb               # Command-line interface
├── download.rb          # Web scraping and file download module
├── linha.rb             # Bus line data model
├── mes.rb               # Monthly data model
├── config.rb            # Configuration management
├── simple_logger.rb     # Logging utilities
├── Gemfile              # Ruby dependencies
├── Gemfile.lock         # Locked dependency versions
├── Rakefile             # Build and development tasks
├── .rubocop.yml         # Code style configuration
├── config.sample.yml    # Sample configuration file
├── test/                # Unit tests
├── examples/            # Usage examples
├── docs/                # Documentation
├── .github/workflows/   # CI/CD configuration
└── .vscode/             # VS Code configuration
```

## Data Flow

1. **Download Phase**: Scrapes the government website for XLS file links
2. **Processing Phase**: Reads each XLS file and extracts relevant data
3. **Filtering Phase**: Filters data by company name and date
4. **Consolidation Phase**: Combines data by month and bus line
5. **Export Phase**: Generates new XLS files with processed data
6. **Logging Phase**: Records activities and errors for monitoring

## License

This project is open source. Please check with the repository owner for specific licensing terms.

## Contact

For questions or support, please open an issue in the GitHub repository.