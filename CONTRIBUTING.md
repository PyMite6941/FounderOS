# Contributing to FounderOS

Thank you for considering contributing! Please read the following guidelines to help make the process smooth and enjoyable.

## Development Setup
1. **Fork the repository** on GitHub
2. **Clone your fork** locally: `git clone https://github.com/your-username/FounderOS.git`
3. **Create a branch**: `git checkout -b feature/amazing-feature`
4. **Make your changes** following the existing code styles and patterns
5. **Test your changes**:
   - Backend: `cd backend && python -m pytest`
   - Ensure all existing tests pass
6. **Commit your changes**: `git commit -m 'feat: add some amazing feature'`
7. **Push to your branch**: `git push origin feature/amazing-feature`
8. **Open a Pull PR** against the main repository

## Code Styles

### Python (Backend)
- Follow [PEP 8](https://pep8.org/) style guidelines
- Use type hints where appropriate
- Run `ruff check` for linting
- Tests should be in `backend/tests/` and follow pytest conventions

### iOS (SwiftUI)
- Follow [Apple's Swift style guide](https://swift.org/documentation/api-design-guidelines/)
- Use the design system from `appleUI/FoundersOS/Utilities/Constants.swift`
- SwiftData models should follow the `StartupIdea` / `StartupAnalysis` patterns

### Android (Jetpack Compose)
- Follow [Android Kotlin coding conventions](https://developer.android.com/kotlin/style)
- **Use lowercase `true`/`false`** — do not use `True`/`False` (capitalized), which are invalid Kotlin
- Use the constants from `androidUI/app/src/main/java/com/founderos/androidui/constants/`
- Keep API clients consistent with `POST /v1/analyze`

### Web (HTML/JS)
- Follow standard HTML5 and CSS best practices
- Use Tailwind CSS utility classes
- Maintain light/dark mode support with `prefers-color-scheme`
- Add animations using CSS keyframes

## Adding New Features

### Backend
1. Add new endpoint in `backend/app/main.py`
2. Add Pydantic model for request/response
3. Add test in `backend/tests/`
4. Update `backend/README.md` with new route

### iOS
1. Add SwiftUI views in `appleUI/FoundersOS/Views/`
2. Add ViewModels in `appleUI/FoundersOS/ViewModels/`
3. Add models in `appleUI/FoundersOS/Models/`
4. Update `AppConstants` if needed

### Android
1. Add data model in `androidUI/app/src/main/java/com/founderos/androidui/data/`
2. Add API service in `androidUI/app/src/main/java/com/founderos/androidui/network/`
3. Add constants in `androidUI/app/src/main/java/com/founderos/androidui/constants/`
4. **Use lowercase `true`/`false`** — avoid `True`/`False` which cause compilation errors
5. Update `AppConstants` if needed

### Web
1. Update `web/index.html` with new UI elements
2. Add JavaScript functionality
3. Ensure light/dark mode support
4. Add appropriate CSS classes

## Pull Request Guidelines

- **Title**: Use `feat:`, `fix:`, `docs:`, `style:`, `refactor:`, `test:`, or `chore:` prefixes
- **Description**: Describe what changed and why
- **Tests**: Add or update tests for new functionality
- **Documentation**: Update README.md and relevant docs
- **Style**: Follow existing code styles and patterns
- **Commit messages**: Use present tense ("Add feature" not "Added feature")

## Reporting Issues

Use the [GitHub Issues](https://github.com/PyMite6941/FounderOS/issues) tracker to report bugs, request features, or ask questions. Include:
- Clear title describing the issue
- Steps to reproduce (for bugs)
- Expected vs. actual behavior
- Environment (OS, browser, device)
- Any relevant screenshots

## License

By contributing, you agree that your contributions will be under the [MIT License](LICENSE).