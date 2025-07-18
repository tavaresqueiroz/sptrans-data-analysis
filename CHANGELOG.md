# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- Comprehensive README with installation and usage instructions
- Configuration management system with external config file support
- Structured logging system with configurable levels
- Command-line interface (CLI) with multiple operation modes
- Unit tests for core classes (Linha, Mes)
- RuboCop configuration for code style consistency
- Rakefile with common development tasks
- GitHub Actions CI/CD workflow
- Sample configuration file (config.sample.yml)
- Enhanced .gitignore for development artifacts

### Changed
- Updated Gemfile with proper version constraints and grouped dependencies
- Replaced deprecated `open-uri` with proper `Net::HTTP` usage
- Improved file permissions from 0777 to 0755 for security
- Enhanced model classes with better methods and documentation
- Modernized Ruby code style and practices
- Added English comments and documentation throughout

### Fixed
- SSL/TLS support for HTTPS downloads
- Comprehensive error handling with meaningful messages
- Input validation and sanitization
- Network failure handling

### Security
- Fixed overly permissive file permissions
- Added SSL verification for downloads
- Improved input sanitization

## [1.0.0] - 2017-07-10

### Added
- Initial release
- Basic XLS file downloading from São Paulo government website
- Data processing for SAMBAIBA bus company
- Monthly report generation
- Basic Excel file parsing and output