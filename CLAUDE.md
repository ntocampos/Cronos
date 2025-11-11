# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**Cronos** is an iOS deadline management app built with SwiftUI and SwiftData. The app features an innovative "reversed progress bar" visualization system where deadline bars grow wider as they become more imminent, providing at-a-glance temporal awareness.

**Key Characteristics:**
- Pure SwiftUI + SwiftData architecture (no ViewModels)
- Local-first data persistence (no cloud sync in v1)
- Feature-based modular structure
- Target: iOS 16+ (iPadOS universal)

## Development Commands

### Building and Running
```bash
# Build the project
xcodebuild -project Cronos.xcodeproj -scheme Cronos -configuration Debug build

# Run tests
xcodebuild test -project Cronos.xcodeproj -scheme Cronos -destination 'platform=iOS Simulator,name=iPhone 15'

# Run UI tests
xcodebuild test -project Cronos.xcodeproj -scheme Cronos -destination 'platform=iOS Simulator,name=iPhone 15' -only-testing:CronosUITests

# Run specific test
xcodebuild test -project Cronos.xcodeproj -scheme Cronos -destination 'platform=iOS Simulator,name=iPhone 15' -only-testing:CronosTests/TestClassName/testMethodName
```

### Code Formatting
The project uses `swift-format` with pre-commit hooks:
```bash
# Format all Swift files
swift-format format --in-place --recursive Cronos/

# Format specific file
swift-format format --in-place path/to/file.swift

# Install pre-commit hooks
pre-commit install
```

Pre-commit hooks automatically format Swift files on commit. If you encounter formatting issues, run `swift-format` manually before committing.

## Architecture Overview

### Data Flow Pattern
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

### Core Architectural Decisions

**1. View-Centric Data Access**
- No service layer or ViewModels (yet)
- Views query data directly using `@Query` property wrapper
- Data mutations through `@Environment(\.modelContext)`
- Exception: Tests reference `DeadlineGroupingService` (not yet implemented)

**2. Modal Form Pattern**
- Add/Edit operations use SwiftUI sheets with `.sheet(item:)` bindings
- Forms manage local state with `@State` properties
- Parent views handle sheet presentation and data persistence

**3. Callback-Based List Actions**
- List views accept closures for edit/delete: `onEdit: (Deadline) -> Void`
- Separates presentation (list) from business logic (parent view)

**4. Reversed Progress Bar Visualization**
The app's signature feature—bar width is inversely proportional to days remaining:
- Located in `DeadlineBarView.swift`
- Uses `GeometryReader` for responsive layout
- Formula: wider bars = closer deadlines (more visual weight)
- Positioned right-to-left via `Spacer()` + right alignment

### Key Directory Structure

```
Cronos/
├── Models/              # SwiftData @Model entities
│   ├── Deadline.swift   # Core entity with computed display properties
│   ├── Category.swift   # One-to-many relationship with Deadlines
│   └── Extensions/
│       └── Category+Colors.swift  # HEX ↔ Color conversion
├── Features/            # Feature-based organization
│   ├── Dashboard/       # Main deadline list (DashboardView)
│   ├── Deadlines/       # Deadline CRUD operations
│   ├── Categories/      # Category management
│   ├── Settings/        # App settings and data management
│   └── Groups/          # Empty (grouping feature WIP)
├── Services/            # Empty (prepared for future service layer)
├── Shared/Extensions/   # Common utilities
│   ├── Color.swift      # HEX string ↔ Color conversion
│   └── Preview.swift    # ModelContainer preview helpers
└── Docs/
    ├── APP_REQUIREMENTS.md         # Complete product requirements
    └── PREVIEW_HELPERS_GUIDE.md    # Preview usage patterns
```

## SwiftData Integration

### Schema Definition
Located in `CronosApp.swift:14-16`:
```swift
let schema = Schema([
  Deadline.self,
  Category.self,
])
```

### Data Models

**Deadline** (`Models/Deadline.swift`)
- Primary entity with computed properties for UI: `isPast`, `daysUntil`, `daysUntilText`
- Optional relationship to Category (nullified on category deletion)
- Includes display logic in model layer (not in views)

**Category** (`Models/Category.swift`)
```swift
@Relationship(deleteRule: .nullify, inverse: \Deadline.category)
var deadlines: [Deadline]
```
- Color stored as HEX string (`colorHex`) for persistence
- Use `Category+Colors.swift` extension for Color conversion
- One-to-many relationship with Deadlines

### Color Persistence Pattern
Categories store colors as HEX strings, not RGB:
```swift
// Getting color
let color = category.color  // Computed property in Category+Colors.swift

// Setting color
category.setColor(.blue)    // Converts to HEX and updates colorHex
```

10 predefined colors available in `Category.DefaultColors` enum.

## SwiftUI Preview Patterns

**Always use preview helpers from `Shared/Extensions/Preview.swift`:**

```swift
// Standard preview with rich sample data (4 categories, 8 deadlines)
#Preview {
    YourView()
        .modelContainer(.preview)
}

// Empty container for custom data setup
#Preview {
    YourView()
        .modelContainer(.emptyPreview)
}

// Custom sample data
#Preview {
    let container = ModelContainer.emptyPreview
    SampleData.addSampleCategories(to: container.mainContext)
    // Add your custom data...

    return YourView()
        .modelContainer(container)
}
```

See `Docs/PREVIEW_HELPERS_GUIDE.md` for complete documentation.

## Important Implementation Notes

### Current State of Features

**Implemented:**
- Deadline CRUD with reversed progress bars
- Category management with custom colors
- Dashboard list view with swipe actions
- Settings (notifications toggle, data deletion, app info)
- SwiftData persistence

**In Progress (deadline-grouping branch):**
- Deadline grouping by category/timeframe
- Tests exist (`DeadlineGroupingServiceTests.swift`) but service not implemented
- Recent commit `d62c9c7` undid previous grouping implementation

**Not Yet Implemented (see APP_REQUIREMENTS.md):**
- Notifications scheduling (framework referenced, not implemented)
- Archive/Recently Expired view
- Widgets (WidgetKit)
- Search/filter
- Completion marking
- Recurring deadlines
- Localization
- Theme customization

### Data Relationships
```swift
Category (one) ←→ (many) Deadline
   ↓ deleteRule: .nullify
When category is deleted, deadline.category becomes nil
```

### Naming Conventions
- **Views:** Suffix with "View" (DashboardView, DeadlineBarView)
- **Forms:** Suffix with "FormView" (DeadlineFormView, CategoryFormView)
- **Models:** No suffix (Deadline, Category)
- **Extensions:** Use "+" notation (Category+Colors, Color+Hex)

### State Management Pattern
```swift
// Query data (reactive)
@Query(sort: \Deadline.date) private var deadlines: [Deadline]

// Environment access for persistence
@Environment(\.modelContext) private var modelContext

// Local form state
@State private var title: String = ""
@State private var selectedDate = Date()

// Presentation state
@State private var showingAddSheet = false
@State private var editingDeadline: Deadline?
```

## Testing

### Framework
Uses **Swift Testing** (not XCTest) with `@Suite` and `@Test` macros.

### Running Tests
```bash
# All tests
xcodebuild test -project Cronos.xcodeproj -scheme Cronos -destination 'platform=iOS Simulator,name=iPhone 15'

# Specific test class
xcodebuild test -project Cronos.xcodeproj -scheme Cronos -destination 'platform=iOS Simulator,name=iPhone 15' -only-testing:CronosTests/DeadlineGroupingServiceTests
```

### Test Data
Use `SampleData` helpers from `Preview.swift`:
```swift
let container = ModelContainer.emptyPreview
SampleData.addSampleData(to: container.mainContext)
// Now have 4 categories and 8 deadlines for testing
```

## Product Requirements

Full requirements are in `Cronos/Docs/APP_REQUIREMENTS.md`. Key constraints:

**Design Framework:** Liquid Glass (Apple's software design framework)
- Clean, minimal interface focused on the reversed progress bar visualization
- Visual emphasis on temporal urgency through bar width (not color)
- Consistent category colors throughout the app

**Accessibility Requirements:**
- Full VoiceOver support
- Dynamic Type support (font scaling)
- Color contrast meeting WCAG AA standards
- Progress bar width conveys urgency (not just color)
- Haptic feedback for key interactions

**Performance Expectations:**
- App launch under 2 seconds
- Instant list rendering (even with 100+ deadlines)
- 60fps scrolling and animations
- Search results within 500ms

## Key Files Reference

When working on specific features, start with these files:

**Data Layer:**
- `CronosApp.swift:13` - ModelContainer and schema setup
- `Models/Deadline.swift` - Deadline entity with display logic
- `Models/Category.swift` - Category entity with relationships

**Main UI:**
- `ContentView.swift` - TabView root navigation
- `Features/Dashboard/DashboardView.swift` - Main deadline list with queries
- `Features/Deadlines/DeadlineBarView.swift` - Progress bar visualization
- `Features/Deadlines/DeadlineFormView.swift` - Add/Edit deadline workflow

**Utilities:**
- `Shared/Extensions/Color.swift` - HEX ↔ Color conversion
- `Shared/Extensions/Preview.swift` - Preview helpers and sample data
- `Models/Extensions/Category+Colors.swift` - Category color utilities

## Common Patterns

### Adding a New Feature View

1. Create view file in appropriate `Features/` subdirectory
2. Use `@Query` for data access if needed
3. Add preview using `.modelContainer(.preview)`
4. If adding to navigation, update `ContentView.swift` TabView
5. Format code: `swift-format format --in-place path/to/file.swift`

### Modifying Data Models

1. Update model file (`Deadline.swift` or `Category.swift`)
2. Consider migration strategy (SwiftData handles simple changes automatically)
3. Update preview sample data in `Preview.swift` if needed
4. Verify all views using the model still compile

### Working with Categories and Colors

```swift
// Always use Category+Colors extension methods
let category = Category(name: "Work", colorHex: Category.DefaultColors.blue)

// Get SwiftUI Color
let color = category.color  // Computed property

// Update color
category.setColor(.red)  // Updates colorHex string

// Never directly set colorHex without using setColor()
```

## Current Branch Context

**Branch:** `deadline-grouping`
**Status:** Working on deadline grouping feature (previously undone)

Recent commits show grouping functionality was implemented then reverted. Tests for `DeadlineGroupingService` exist but service is not implemented in main code. This suggests the feature is being re-explored with a different approach.

When implementing grouping:
- Reference `CronosTests/DeadlineGroupingServiceTests.swift` for expected behavior
- Grouping modes: All (no grouping), Category, Timeframe
- Service should return grouped and sorted deadlines

## Additional Resources

- **APP_REQUIREMENTS.md** - Complete product vision, user stories, technical constraints
- **PREVIEW_HELPERS_GUIDE.md** - Detailed preview helper documentation
- **Swift Testing Documentation** - https://developer.apple.com/documentation/testing
- **SwiftData Documentation** - https://developer.apple.com/documentation/swiftdata

# Agent tips

## Plan

- Ask about open questions if any.
- Offer to save the plan in a markdown file if it's long so we can reference it later.

## Implementation

- Always use modern Swift/SwiftUI/SwiftData patterns as of Nov 2025.
- Use context7 if necessary to access documentations.
