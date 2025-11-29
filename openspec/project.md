# Project Context

## Purpose
Cronos is an iOS deadline management app featuring an innovative "reversed progress bar" visualization system. Deadline bars grow wider as they become more imminent, providing at-a-glance temporal awareness. The app is local-first with no cloud sync in v1, targeting iOS 17+ (iPadOS universal).

## Tech Stack
- **Language:** Swift 5.9+
- **UI Framework:** SwiftUI (iOS 17+)
- **Data Persistence:** SwiftData
- **Design System:** Liquid Glass (Apple's software design framework)
- **Code Formatting:** swift-format with pre-commit hooks
- **Testing:** Swift Testing framework (@Suite, @Test macros)
- **Build System:** Xcode / xcodebuild

## Project Conventions

### Code Style
- Use `swift-format` for all code formatting (pre-commit hooks enforce this)
- **Naming Conventions:**
  - Views: Suffix with "View" (e.g., `DashboardView`, `DeadlineBarView`)
  - Forms: Suffix with "FormView" (e.g., `DeadlineFormView`, `CategoryFormView`)
  - Models: No suffix (e.g., `Deadline`, `Category`)
  - Extensions: Use "+" notation (e.g., `Category+Colors`, `Color+Hex`)
- Colors stored as HEX strings for persistence, converted via extensions
- Use computed properties in models for display logic (e.g., `isPast`, `daysUntil`)

### Architecture Patterns
- **View-Centric Data Access:** Views query data directly using `@Query`
- **@Observable Coordinator Pattern:** `DeadlineCoordinator` manages actions and sheet state, injected via environment
- **Modal Form Pattern:** Add/Edit operations use SwiftUI sheets with `.sheet(item:)` bindings
- **Feature-Based Organization:** Code organized by feature in `Features/` directory

**Data Flow:**
```
CronosApp (ModelContainer setup)
    ↓
ContentView (TabView root)
    ↓
Feature Views (@Query for data)
    ↓
Form Views (mutations via modelContext)
    ↓
SwiftData (automatic persistence)
```

### Testing Strategy
- Use **Swift Testing** framework (not XCTest)
- Use `@Suite` and `@Test` macros
- Test data via `SampleData` helpers from `Preview.swift`
- Use `ModelContainer.emptyPreview` for isolated test containers

### Git Workflow
- Main branch: `main`
- Feature branches for new development
- Pre-commit hooks run swift-format automatically
- Commit messages should be descriptive of changes

## Domain Context
- **Reversed Progress Bar:** The app's signature feature—bar width is inversely proportional to days remaining. Wider bars = closer deadlines = more visual weight. This is the core UX innovation.
- **Categories:** Deadlines can be assigned to categories with custom colors (10 predefined colors available)
- **Relationship:** Category (one) ←→ (many) Deadline with `.nullify` delete rule

## Important Constraints
- **iOS 17+ minimum deployment target** (for SwiftData and @Observable)
- **Accessibility Requirements:**
  - Full VoiceOver support
  - Dynamic Type support
  - WCAG AA color contrast
  - Progress bar width (not just color) conveys urgency
  - Haptic feedback for key interactions
- **Performance Expectations:**
  - App launch under 2 seconds
  - Instant list rendering (100+ deadlines)
  - 60fps scrolling and animations
  - Search results within 500ms

## External Dependencies
- No external package dependencies (pure Apple frameworks)
- No cloud services or APIs in v1
- Local-only data persistence via SwiftData
