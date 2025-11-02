# Cronos App Requirements Document

## 1. Introduction/Overview

### Description
Cronos is an iOS app to manage deadlines. With Cronos, the user can have an overview of which deadlines are coming up, with the amount of time left represented visually through an innovative reversed progress bar system. It offers widgets for easy glance on the homescreen and sends notifications to the user whenever a deadline is approaching.

### The Problem
In day to day activities, be them work, school, personal, or any other life area, there are always important dates that we need to keep in the back of our heads. It can be a deadline for renewing some document. It can be the date you need to deliver some school work. It can be the last day to fill your taxes forms. Usually, these activities are not something you need to do right now, but something you'll need to do soon. Creating reminders or calendar events for those dates can help a bit, but there's a risk of forgetting about that deadline only to be reminded about it the day before. What's missing is a visual, at-a-glance way to see the temporal proximity of upcoming deadlines and their relative importance.

### Target Audiences/Users
There isn't a specific target audience for this app. Its users can be students that need to track school activities, employees that need to track deadlines for projects, a person who wants to be more organized with their dates, or virtually anyone who manages time-sensitive commitments.

---

## 2. Objectives and Goals

### Success Criteria
Cronos aims to be a utility app where users can solve the issues described previously by tracking, categorizing, and visualizing upcoming deadlines with an intuitive reversed progress bar interface. It should allow the user to use it for any purpose they want, in any area of their life.

### Key Outcomes

**Launch Metrics:**
- Have the app released in the App Store
- Have at least 10 users in the first week

**User Engagement:**
- Users check the app or widget at least 3 times per week
- Average of 5+ active deadlines per user

**User Retention:**
- 60% of users still active after 30 days
- Users create at least one new deadline per week

**User Satisfaction:**
- Average App Store rating of 4.5+ stars
- Less than 5% negative feedback related to core functionality

---

## 3. Functional Requirements

### What the App Must Do
- Allow the creation of deadlines with title, description, due date, and category assignment
- Allow the creation of categories with custom colors
- Allow assigning a deadline to a category
- Allow marking deadlines as complete before their due date
- Archive expired deadlines automatically and allow viewing them in a separate view
- Allow the color theme to be changed
- Allow deadlines to be filtered by text search and grouped by category
- Allow the change of language and date format
- Display deadlines with reversed progress bars that visually represent temporal proximity
- Send notifications based on configurable schedules (global, category-specific, or deadline-specific)
- Provide home screen widgets showing upcoming deadlines

### User Stories
- As a user, I want to create categories so I can categorize and visually differentiate deadlines
- As a user, I want to create deadlines so I can track how close to today they are
- As a user, I want to see deadlines represented by reversed progress bars so I can quickly understand which ones are most imminent
- As a user, I want to mark a deadline as complete so I can indicate I've finished it before the due date
- As a user, I want expired deadlines to be automatically archived so my main view stays clean
- As a user, I want to view recently expired deadlines so I can review what I've completed or missed
- As a user, I want to change the app language in-app so I can easily configure it to my likings
- As a user, I want to change the app color theme so I can customize the app to my taste
- As a user, I want to filter the deadlines by text so I can search for a deadline between all categories
- As a user, I want to visualize deadlines for all categories sorted by how much time until then so I can have an overview of what's coming up
- As a user, I want to group my deadlines by category so I can better separate different concerns
- As a user, I want to define the category priority order so I can organize the categories in a way that makes more sense to me
- As a user, I want to define a general notification schedule so I can get notified whenever a deadline is coming up
- As a user, I want to define a category-specific notification schedule so I can apply the same schedule to a group
- As a user, I want to define a specific deadline notification schedule so I can customize a single deadline if I need

### Core Workflows

#### 1. Setting Up Categories and Organization
**Purpose:** Establish the organizational structure for deadlines

**Main Steps:**
1. User navigates to category management
2. User creates a new category with a name
3. User selects a color for the category
4. User saves the category
5. User can reorder categories by dragging or setting priority
6. User can edit or delete existing categories

**Variations:**
- User assigns default notification schedule to category during creation
- User modifies category color or name later

#### 2. Managing Deadlines
**Purpose:** Create, edit, and maintain deadline items

**Main Steps:**
1. User taps "Add Deadline" button
2. User enters deadline title (required)
3. User enters description (optional)
4. User selects due date and optionally time
5. User assigns deadline to a category
6. User optionally configures custom notification schedule
7. User saves deadline
8. Deadline appears in main list with reversed progress bar visualization

**Variations:**
- User edits existing deadline details
- User marks deadline as complete before due date (moves to archive)
- User deletes a deadline
- Deadline automatically archives when due date passes

#### 3. Viewing and Monitoring Deadlines
**Purpose:** Get an at-a-glance overview of upcoming commitments

**Main Steps:**
1. User opens app to main dashboard
2. System displays all active deadlines sorted by time remaining (closest first)
3. Each deadline shows reversed progress bar (wider = more imminent)
4. Bar color corresponds to deadline's category
5. User can scroll through list to see all deadlines

**Variations:**
- User switches to grouped view to see deadlines organized by category
- User searches/filters deadlines by text
- User taps a deadline to view full details
- User views archived deadlines in separate "Recently Expired" section
- User checks home screen widget for quick glance

**Visual Representation Details:**
- Reversed progress bar grows from right to left
- Bar width is inversely proportional to days remaining
- Imminent deadlines have the widest bars (most visual weight)
- Distant deadlines have narrow bars (less visual prominence)
- Bar color matches the deadline's category color

#### 4. Configuring Notifications
**Purpose:** Set up alerts to be reminded of approaching deadlines

**Main Steps:**
1. User navigates to notification settings
2. User configures global default notification schedule (e.g., "7 days before, 3 days before, 1 day before")
3. User optionally overrides notification schedule for specific categories
4. User optionally overrides notification schedule for individual deadlines
5. System requests notification permissions if not already granted
6. System schedules all notifications based on hierarchy: deadline-specific > category-specific > global default

**Variations:**
- User modifies existing notification schedules
- User disables notifications for specific categories or deadlines
- User adjusts notification delivery times (e.g., always at 9 AM)

#### 5. App Customization
**Purpose:** Personalize the app appearance and localization

**Main Steps:**
1. User navigates to settings
2. User selects preferred color theme (Light/Dark/System)
3. User selects preferred language
4. User selects preferred date format
5. Changes take effect immediately

---

## 4. Non-Functional Requirements

### Performance Expectations
- App should launch in under 2 seconds on supported devices
- Deadline list should render instantly even with 100+ deadlines
- Widget should update within 5 seconds of data change in the app
- Notifications should fire within 1 minute of scheduled time
- Smooth 60fps scrolling and animations throughout the app
- Search/filter results should appear within 500ms of user input

### Security Requirements
- No network transmission of user data (all data remains local)
- Comply with iOS privacy guidelines for notifications and widget data
- Follow Apple's data privacy best practices
- No collection of analytics or personal information without explicit user consent

### Usability Standards
- Follow Apple Human Interface Guidelines and Liquid Glass design principles
- Support Dynamic Type (font scaling) for accessibility
- Intuitive gestures throughout the app:
  - Swipe to delete deadlines
  - Long-press for quick actions
  - Pull to refresh
- Clear visual hierarchy emphasizing deadline urgency through bar width
- Provide onboarding flow for first-time users explaining the reversed progress bar concept
- Maintain consistency in category colors across all views and widgets
- Ensure all interactive elements have sufficient touch targets (minimum 44x44 points)

### Compatibility
- The app should be compatible with iOS and iPadOS devices of all sizes
- The app should be compatible with iOS and iPadOS version 26 at minimum
- Support both portrait and landscape orientations on iPad
- Support for iPhone SE (small screen) through iPhone Pro Max (large screen)
- Optimize layouts for iPad multitasking (Split View, Slide Over)

---

## 5. User Interface/Experience

### Key Screens or Flows

**1. Home/Dashboard**
- Main list view of all active deadlines
- Each deadline displays: title, reversed progress bar (colored by category), and days/time remaining
- Sorted by temporal proximity (most imminent first)
- Quick actions: add new deadline, search, switch to grouped view
- Pull to refresh

**2. Grouped Category View**
- Deadlines organized by category sections
- User-defined category order
- Same reversed progress bar visualization within each category
- Ability to collapse/expand categories

**3. Add/Edit Deadline Screen**
- Form with fields: title (required), description (optional), due date/time, category selection
- Option to set custom notification schedule
- Clear save/cancel actions
- Date picker for deadline selection

**4. Deadline Detail View**
- Full information about a deadline
- Options to: edit, mark as complete, delete
- Visual representation of notification schedule
- Category badge with color

**5. Category Management**
- List of all categories with color indicators
- Add new category button
- Edit category (name, color, default notification schedule)
- Reorder categories via drag and drop
- Delete category (with warning if it contains deadlines)

**6. Settings Screen**
- Color theme selection (Light/Dark/System)
- Language selection
- Date format selection
- Global notification schedule configuration
- About/Help section

**7. Archive/Recently Expired View**
- List of deadlines that have passed or been marked complete
- Option to restore or permanently delete
- Organized by expiration date

**8. Home Screen Widgets**
- Small widget: Next 1-3 upcoming deadlines with mini reversed progress bars
- Medium widget: Next 5-7 deadlines
- Large widget: Comprehensive view with category grouping

### Design Principles or Constraints
- Embrace Liquid Glass design framework for modern, elegant aesthetics
- Clean, minimal interface focused on clarity and the unique progress bar visualization
- Visual emphasis on temporal urgency through bar width (not color)
- Consistent use of category colors throughout the app (bars, badges, headers)
- Support for both Light and Dark mode with appropriate contrast
- Gesture-based interactions for power users (swipe, long-press) while maintaining discoverability
- Avoid clutter—show only essential information on main screens
- Use animation purposefully to guide attention and provide feedback

### Accessibility Requirements
- Full VoiceOver support for all interactive elements with descriptive labels
- Dynamic Type support allowing text scaling from minimum to maximum accessibility sizes
- Sufficient color contrast ratios meeting WCAG AA standards (minimum 4.5:1 for normal text)
- Alternative to color-only information: progress bar width conveys urgency, not just color
- Haptic feedback for key interactions (marking complete, deleting, saving)
- Reduce Motion support for users with motion sensitivity
- Clear focus indicators for keyboard navigation (iPad with keyboard)
- Support for Bold Text system setting

---

## 6. Technical Constraints

### Technology Stack
- **Language:** Swift
- **UI Framework:** SwiftUI
- **Data Persistence:** SwiftData
- **Design Framework:** Liquid Glass (Apple's software design framework)
- **Widget Framework:** WidgetKit
- **Notifications:** UserNotifications framework

### Integration Requirements
- WidgetKit for home screen widgets with data sharing via App Group
- UserNotifications framework for local notification scheduling
- No external API or service integrations required

### Data Storage and Management
- All app data stored locally on device using SwiftData
- No cloud sync or backup (out of scope for version 1)
- Data model:
  - **Deadline:** id, title, description, dueDate, categoryId, completionStatus, customNotificationSchedule, createdAt
  - **Category:** id, name, color, priorityOrder, defaultNotificationSchedule, createdAt
- Implement data migration strategy for future versions

### Permissions Required
- **User Notifications:** Required for deadline reminders
- **Background App Refresh:** May be needed to ensure timely notification scheduling (to be confirmed during development)

### Storage Requirements
- Minimal storage footprint
- Typical user with 50 deadlines and 10 categories: estimated <1 MB of data
- No media attachments or large file storage

---

## 7. Assumptions and Dependencies

### What You're Assuming to be True
- Users will grant notification permissions to get full value from the app
- Users understand the concept of categories for organizational purposes
- The reversed progress bar concept will be intuitive to users after brief onboarding
- Local-only storage is sufficient for the target use case (no cloud backup needed for v1)
- Users have iOS/iPadOS 16 or later installed on their devices
- Users manage a reasonable number of deadlines (under 200 active at once)
- SwiftData provides adequate performance for the expected data volume

### External Factors the Project Depends On
- Apple App Store review and approval process
- iOS notification system reliability and timely delivery
- SwiftData stability and performance in production
- Liquid Glass design framework availability and documentation
- No breaking changes in SwiftUI/SwiftData APIs in future iOS updates
- Continued support for WidgetKit in future iOS versions
- Device hardware capable of running iOS 16+ (processor, memory)

---

## 8. Out of Scope

### What the App Explicitly Won't Do

**Version 1 Exclusions:**
- Cloud sync or data backup between devices
- User authentication or sign in/up flow
- Collaboration or sharing deadlines with other users
- Integration with external calendar apps (Calendar, Google Calendar, etc.)
- Integration with task management apps (Todoist, Things, Reminders, etc.)
- Recurring deadlines (e.g., monthly bill payments)
- Sub-tasks or checklist items within deadlines
- File attachments or photo attachments to deadlines
- Rich text formatting in descriptions
- Priority levels separate from temporal proximity
- Time tracking or pomodoro features
- Analytics or statistics about completed deadlines
- Export functionality (CSV, PDF, etc.)
- Import from other apps or services
- Siri shortcuts or voice commands
- Apple Watch companion app
- macOS version
- Android version
- Web version
- Premium or paid tier features
- In-app purchases
- Advertisements

**Philosophical Exclusions:**
- The app will not attempt to be a full task manager or to-do list
- The app will not include features that complicate the core "deadline awareness" purpose
- The app will not include social features or gamification elements

---

## Appendix: Open Questions and Future Considerations

### Questions to Resolve During Development
1. Exact notification permission timing—request on first launch or when user creates first deadline?
2. Confirm whether background app refresh is needed for notification reliability
3. Determine exact date/time format options to support (ISO, US, EU, etc.)
4. Widget refresh frequency and data freshness strategy
5. Default notification schedule timing (what makes sense as global default?)

### Future Version Considerations (Not Committed)
- iCloud sync for cross-device support
- User accounts for cloud backup
- Apple Watch complications
- Siri integration ("Hey Siri, show my deadlines")
- Shortcuts app support
- macOS companion app
- Team/shared deadlines
- Import from calendar or reminders
- Recurring deadline support

---

## Document Version History
- v1.0 - Initial draft
- v2.0 - Complete requirements with all sections filled, incorporating user feedback and clarifications
