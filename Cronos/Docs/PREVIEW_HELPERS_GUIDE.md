# Preview Helpers Usage Guide

This document explains how to use the new preview helpers in the Cronos app for cleaner, more maintainable SwiftUI previews.

## Quick Reference

### For views that need rich sample data:
```swift
#Preview {
    YourView()
        .modelContainer(.preview)
}
```

### For views that need empty containers:
```swift  
#Preview {
    YourView()
        .modelContainer(.emptyPreview)
}
```

### For custom sample data:
```swift
#Preview {
    let container = ModelContainer.emptyPreview
    SampleData.addSampleCategories(to: container.mainContext)
    // Add custom data...
    
    return YourView()
        .modelContainer(container)
}
```

## Available Preview Helpers

### ModelContainer Extensions

- **`.preview`**: Creates a container with comprehensive sample data (categories, deadlines, etc.)
- **`.emptyPreview`**: Creates an empty in-memory container for custom data setup

### SampleData Methods

- **`addSampleData(to:)`**: Adds full sample data set (8 deadlines across 4 categories)
- **`addSampleCategories(to:)`**: Adds only sample categories (6 categories with different colors)

## Benefits

1. **Consistency**: All previews use the same sample data
2. **Maintainability**: Update sample data in one place
3. **Performance**: Memory-only containers for fast previews
4. **Simplicity**: One-liner for most common cases
5. **Flexibility**: Easy custom data setup when needed

## Before and After Examples

### Before (Old Approach)
```swift
#Preview {
    let container = try! ModelContainer(
        for: Deadline.self, Category.self,
        configurations: ModelConfiguration(isStoredInMemoryOnly: true)
    )
    
    let workCategory = Category(name: "Work", colorHex: Category.DefaultColors.blue)
    let personalCategory = Category(name: "Personal", colorHex: Category.DefaultColors.green)
    container.mainContext.insert(workCategory)
    container.mainContext.insert(personalCategory)
    
    let deadline = Deadline(title: "Task", notes: "", date: Date(), category: workCategory)
    container.mainContext.insert(deadline)
    
    return YourView()
        .modelContainer(container)
}
```

### After (New Approach)
```swift
#Preview {
    YourView()
        .modelContainer(.preview)
}
```

## Sample Data Overview

The `.preview` container includes:

### Categories (4):
- Work (Blue)
- Personal (Green)  
- Study (Orange)
- Urgent (Red)

### Deadlines (8):
- Various due dates from overdue to 3+ weeks out
- Different priorities and categories
- Mix of short and long titles/notes

This provides comprehensive test coverage for UI components.