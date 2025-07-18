# Contributing to SPTrans Data Analysis

We welcome contributions to the SPTrans Data Analysis project! This document provides guidelines for contributing to the project.

## Getting Started

### Prerequisites
- Ruby 3.0 or higher
- Bundler for dependency management
- Git for version control

### Setting up the Development Environment

1. Fork the repository
2. Clone your fork:
   ```bash
   git clone https://github.com/yourusername/sptrans-data-analysis.git
   cd sptrans-data-analysis
   ```

3. Set up the development environment:
   ```bash
   rake setup
   ```

4. Run tests to ensure everything is working:
   ```bash
   rake test
   ```

## Development Workflow

### Making Changes

1. Create a feature branch:
   ```bash
   git checkout -b feature/your-feature-name
   ```

2. Make your changes following the coding standards (see below)

3. Run tests and quality checks:
   ```bash
   rake quality
   ```

4. Commit your changes with a clear message:
   ```bash
   git commit -m "Add feature: description of your change"
   ```

5. Push your branch:
   ```bash
   git push origin feature/your-feature-name
   ```

6. Create a pull request

### Coding Standards

- Follow the Ruby style guide
- Use RuboCop for code linting: `bundle exec rubocop`
- Write tests for new functionality
- Document public methods and classes
- Keep methods small and focused
- Use meaningful variable and method names

### Testing

- Write unit tests for new classes and methods
- Run the full test suite: `rake test`
- Ensure all tests pass before submitting a pull request
- Add integration tests for complex features

### Code Quality

- Run RuboCop: `bundle exec rubocop`
- Fix any style violations
- Ensure code coverage is maintained
- Follow the existing code patterns

## Types of Contributions

### Bug Reports
- Use the GitHub issue tracker
- Include steps to reproduce the bug
- Provide system information (Ruby version, OS, etc.)
- Include relevant error messages

### Feature Requests
- Use the GitHub issue tracker
- Clearly describe the feature and its benefits
- Provide use cases and examples

### Code Contributions
- Bug fixes
- New features
- Performance improvements
- Documentation improvements
- Test coverage improvements

## Pull Request Process

1. Ensure your code follows the project's coding standards
2. Update documentation if needed
3. Add tests for new functionality
4. Ensure all tests pass
5. Update the CHANGELOG.md with your changes
6. Submit a pull request with a clear description

### Pull Request Guidelines

- Use a clear and descriptive title
- Provide a detailed description of changes
- Reference related issues
- Include screenshots for UI changes
- Be responsive to feedback

## Code of Conduct

- Be respectful and inclusive
- Focus on constructive feedback
- Help maintain a positive environment
- Follow the project's code of conduct

## Getting Help

- Check the README for basic information
- Review existing issues and pull requests
- Ask questions in GitHub discussions
- Contact maintainers for complex issues

## Recognition

Contributors will be acknowledged in the project's README and release notes.

Thank you for contributing to SPTrans Data Analysis!